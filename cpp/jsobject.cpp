#include "jsobject.hpp"
#include "jsobjectpairs.hpp"
#include "conversions.hpp"
#include "main.hpp"


JSObject* JSObject::fromUserdata(lua_State* L, int n) {
	// NOTE: We have NO safety, we don't check the userdata is the correct one
	if (!lua_isuserdata(L, n)) {
		luaL_error(L, "Attempt to convert %s to userdata<JSObject>.", lua_typename(L, n));
	}
	return *reinterpret_cast<JSObject**>(lua_touserdata(L, n));
}

JSObject::JSObject(emscripten::val value, bool throwaway) {
	this->value = value;
	this->_throwaway = throwaway;
}

JSObject::~JSObject() {
	if (this->_throwaway) {
		this->flush_cache();
	}
}

int JSObject::lua_push(lua_State* L) {
	lua_pushlightuserdata(L, (void*)this);
	lua_gettable(L, LUA_REGISTRYINDEX);
	return 1;
}

void JSObject::flush_cache() {
	lua_State* L = get_global_state();
	if (cache.size() > 0) {
		for (auto pair : cache) {
			pair.second->flush_cache();
			lua_pushlightuserdata(L, (void*)pair.second);
			lua_pushnil(L);
			lua_settable(L, LUA_REGISTRYINDEX);
		}
		cache.empty();
	}
}

// This is no longer required as `nil` is now `undefined` instead of `null`
int JSObject::_delete(lua_State* L) {
	// Stack: userdata<JSObject>, index
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	emscripten::val index = convert_to_js(L, 2);
	jsobject->value.delete_(index);
	return 0;
}

int JSObject::__gc(lua_State* L) {
	// Stack: userdata<JSObject>
	delete JSObject::fromUserdata(L, 1);
	return 0;
}

int JSObject::__index(lua_State* L) {
	// Stack: userdata<JSObject>, index
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	emscripten::val index;
	if (lua_isnumber(L, 2) && jsobject->value.isArray()) {
		index = emscripten::val(lua_tonumber(L, 2) - 1);
	} else if (lua_isstring(L, 2)) {
		const char* strIndex = lua_tostring(L, 2);
		if (luaL_getmetafield(L, 1, strIndex) > 0) {
			// Stack: userdata<JSObject>, index, any
			return 1;
		} else {
			index = emscripten::val(lua_tostring(L, 2));
		}
	} else {
		index = convert_to_js(L, 2);
	}
	// return convert_to_lua(L, jsobject->value[index]);
	if (jsobject->cache.count(index) > 0) {
		return jsobject->cache[index]->lua_push(L);
	} else {
		convert_to_lua(L, jsobject->value[index], false);
		if (lua_isuserdata(L, -1)) {
			JSObject* value = JSObject::fromUserdata(L, -1);
			jsobject->cache[index] = value;
		}
		return 1;
	}
}

int JSObject::__newindex(lua_State* L) {
	// Stack: userdata<JSObject>, index, value
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	emscripten::val index = convert_to_js(L, 2);
	emscripten::val value = convert_to_js(L, 3);
	if (value.isUndefined()) {
		jsobject->value.delete_(index);
	} else {
		jsobject->value.set(index, value);
	}
	// NOTE: We don't cache anything here, when it's indexed it will be cached...
	return 0;
}

int JSObject::__len(lua_State* L) {
	// Stack: userdata<JSObject>
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	if (jsobject->value.isArray()) {
		return convert_to_lua(L, jsobject->value["length"], true);
	} else {
		return convert_to_lua(L, GLOBAL_OBJECT.call<emscripten::val>("keys", jsobject->value)["length"], true);
	}
}

int JSObject::__tostring(lua_State* L) {
	// Stack: userdata<JSObject>
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	emscripten::val repr;
	if (emscripten::val("toString").in(jsobject->value)) {
		repr = jsobject->value.call<emscripten::val>("toString");
	} else {
		repr = GLOBAL_JSON.call<emscripten::val>("stringify", jsobject->value);
		if (repr.isUndefined()) {
			repr = emscripten::val("<FAILED TO STRINGIFY>");
		}
	}
	return convert_to_lua(L, repr, true);
}

int JSObject::__pairs(lua_State* L) {
	// Stack: userdata<JSObject>, userdata<JSObject>, args...
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	lua_pushjsobjectpairs(L, jsobject->value);  // Stack: userdata<JSObjectIter>
	lua_pushcfunction(L, JSObjectPairs::__pairs_iter);  // Stack: userdata<JSObjectIter>, cfunction<JSObjectPairs::__pairs_iter>
	lua_rotate(L, 2, 1);  // Stack: cfunction<JSObjectPairs::__pairs_iter>, userdata<JSObjectIter>
	lua_pushstring(L, "");  // Stack: cfunction<JSObjectPairs::__pairs_iter>, userdata<JSObjectIter>, ""
	return 3;
}

int JSObject::__call(lua_State* L) {
	// Stack: userdata<JSObject>, userdata<JSObject>, args...
	JSObject* jsobject = JSObject::fromUserdata(L, 1);
	if (!lua_isuserdata(L, 2)) {
		luaL_error(L, "Missing call with `:` got '%s'", luaL_typename(L, 2));
		return 0;
	}
	JSObject* self = JSObject::fromUserdata(L, 2);
	emscripten::val args = emscripten::val::array();
	int nargs = lua_gettop(L)-2;
	for (int i = 0; i < nargs; i++) {
		args.call<void>("push", convert_to_js(L, 3+i));
	}
	emscripten::val result = emscripten::val::take_ownership(varcall(jsobject->value.as_handle(), self->value.as_handle(), args.as_handle()));
	return convert_to_lua(L, result, true);
}


luaL_Reg jsobject_reg[] =
{
	{ "_delete", &JSObject::_delete },
	{ "__gc", &JSObject::__gc },
	{ "__index", &JSObject::__index },
	{ "__newindex", &JSObject::__newindex },
	{ "__len", &JSObject::__len },
	{ "__tostring", &JSObject::__tostring },
	{ "__pairs", &JSObject::__pairs },
	{ "__call", &JSObject::__call },
	{ NULL, NULL }
};

int lua_pushjsobject(lua_State* L, emscripten::val value, bool throwaway) {
	JSObject* jsobject = *reinterpret_cast<JSObject**>(lua_newuserdata(L, sizeof(JSObject*))) = new JSObject(value, throwaway);
	lua_pushlightuserdata(L, (void*)&lua_pushjsobject);
    lua_gettable(L, LUA_REGISTRYINDEX);
	lua_setmetatable(L, -2);

	if (!throwaway) {
		lua_pushlightuserdata(L, (void*)jsobject);
		lua_pushvalue(L, -2);
		lua_settable(L, LUA_REGISTRYINDEX);
	}

	return 1;
}

void jsobject_init_reg(lua_State* L) {
	lua_pushlightuserdata(L, (void*)lua_pushjsobject);
	lua_newtable(L);
	lua_pushstring(L, "JSObject");
	lua_setfield(L, -2, "__name");
	luaL_setfuncs(L, jsobject_reg, 0);
	lua_settable(L, LUA_REGISTRYINDEX);
}
