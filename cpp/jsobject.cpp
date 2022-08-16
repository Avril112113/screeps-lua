#pragma once

#include "global.hpp"
#include "conversions.hpp"
#include "main.hpp"


static emscripten::val GLOBAL_OBJECT = emscripten::val::global("Object");

class JSObjectPairs {
public:
	static JSObjectPairs* fromUserdata(lua_State* L, int n) {
		// NOTE: we have NO safety, we don't check the userdata
		return *reinterpret_cast<JSObjectPairs**>(lua_touserdata(L, n));
	}
	static JSObjectPairs* fromUserdata(lua_State* L) {
		return fromUserdata(L, 1);
	}

private:
	emscripten::val _value;
	emscripten::val _keys;
	int _size;
	int _idx = 0;

public:
	JSObjectPairs(emscripten::val value, emscripten::val _keys) : _value(value), _keys(_keys) {
		_size = _keys["length"].as<int>();
	}

	~JSObjectPairs() {
	}

	std::string get_initial_key() {
		return _keys[0].as<std::string>();
	}

	static int __pairs_iter(lua_State* L) {
		JSObjectPairs* self = (*reinterpret_cast<JSObjectPairs**>(lua_touserdata(L, 1)));

		if (self->_idx >= self->_size) return 0;

		std::string key = self->_keys[self->_idx].as<std::string>();
		lua_pushstring(L, key.c_str());
		emscripten::val keyObject = self->_value[key];
		if (convert_to_lua(L, keyObject) == 0) {
			lua_pushnil(L);
		}

		self->_idx++;

		return 2;
	}
};
static int JSObjectPairs___gc(lua_State* L){
	delete JSObjectPairs::fromUserdata(L);
	return 0;
}
luaL_Reg JSObjectPairs_reg[] =
{
	{ "__gc", &JSObjectPairs___gc },
	{ NULL, NULL }
};

class JSObject {
public:
	static JSObject* fromUserdata(lua_State* L, int n) {
		// NOTE: we have NO safety, we don't check the userdata
		return *reinterpret_cast<JSObject**>(lua_touserdata(L, n));
	}
	static JSObject* fromUserdata(lua_State* L) {
		return fromUserdata(L, 1);
	}

	emscripten::val _value;

	JSObject(emscripten::val value) : _value(value) {
	}

	~JSObject() {
	}

	int _delete(lua_State* L, emscripten::val index) {
		// Stack: userdata<JSObject>, any(index)
		_value.delete_(index);
		return 0;
	}

	int __index(lua_State* L) {
		// Stack: userdata<JSObject>, any(index)
		if (lua_isstring(L, 2)) {
			const char* index = lua_tostring(L, 2);
			if (luaL_getmetafield(L, 1, index) > 0) {
				// Stack: userdata<JSObject>, any(index), callable
				return 1;
			}
		}
		emscripten::val index;
		if (_value.isArray() && lua_isnumber(L, 2)) {
			index = emscripten::val(lua_tonumber(L, 2) - 1);
		} else {
			index = convert_to_js(L, 2);
		}
		return convert_to_lua(L, _value[index]);
	}

	int __newindex(lua_State* L, emscripten::val index, emscripten::val value) {
		// Stack: userdata<JSObject>, any(index), any(value)
		_value.set(index, value);
		return 0;
	}

	int __pairs(lua_State* L) {
		// Stack: userdata<JSObject>
		emscripten::val _keys = GLOBAL_OBJECT.call<emscripten::val>("keys", _value);
		lua_pop(L, 1);  // Stack: 
		*reinterpret_cast<JSObjectPairs**>(lua_newuserdata(L, sizeof(JSObjectPairs*))) = new JSObjectPairs(_value, _keys);
		lua_pushcfunction(L, JSObjectPairs::__pairs_iter);  // Stack: userdata<JSObjectIter>, cfunction<JSObjectPairs::__pairs_iter>
		lua_rotate(L, 1, 1);  // Stack: cfunction<JSObjectPairs::__pairs_iter>, userdata<JSObjectIter>
		lua_pushstring(L, "");  // Stack: cfunction<JSObjectPairs::__pairs_iter>, userdata<JSObjectIter>, ""
		return 3;
	}

	int __tostring(lua_State* L) {
		// Stack: userdata<JSObject>
		std::stringstream nameBuilder;
		nameBuilder << "<JSObject '" << _value.typeOf().as<std::string>() << "' at " << std::hex << (void*)this << ">";
		const std::string& nameStr = nameBuilder.str();
		const char* name = nameStr.c_str();
		lua_pushstring(L, name);
		return 1;
	}

	int __call(lua_State* L) {
		// Stack: userdata<JSObject>(this), userdata<JSObject>(lua self), ...
		emscripten::EM_VAL parentHandle;
		int startIndex = 2;
		if (lua_isuserdata(L, 2)) {
			parentHandle = JSObject::fromUserdata(L, 2)->_value.as_handle();
			startIndex = 3;
		} else {
			parentHandle = emscripten::val::null().as_handle();
		}
		int nargs = lua_gettop(L)-(startIndex-1);
		emscripten::val array = emscripten::val::array();
		for (int i = 0; i < nargs; i++) {
			array.call<void>("push", convert_to_js(L, i+startIndex));
		}
		emscripten::val result = emscripten::val::take_ownership(varcall(_value.as_handle(), parentHandle, array.as_handle()));
		return convert_to_lua(L, result);
	}

	int __len(lua_State* L) {
		// Stack: userdata<JSObject>
		if (_value.isArray()) {
			lua_pushinteger(L, _value["length"].as<int>());
			return 1;
		}
		lua_pushinteger(L, GLOBAL_OBJECT.call<emscripten::val>("keys", _value)["length"].as<int>());
		return 1;
	}
};

static int JSObject___gc(lua_State* L){
	delete JSObject::fromUserdata(L);
	return 0;
}

static int JSObject___index(lua_State* L){
	return JSObject::fromUserdata(L)->__index(L);
}

static int JSObject___newindex(lua_State* L){
	return JSObject::fromUserdata(L)->__newindex(L, convert_to_js(L, 2), convert_to_js(L, 3));
}

static int JSObject___pairs(lua_State* L){
	return JSObject::fromUserdata(L)->__pairs(L);
}

static int JSObject___tostring(lua_State* L){
	return JSObject::fromUserdata(L)->__tostring(L);
}

static int JSObject___call(lua_State* L){
	return JSObject::fromUserdata(L)->__call(L);
}

static int JSObject___len(lua_State* L){
	return JSObject::fromUserdata(L)->__len(L);
}

static int JSObject__delete(lua_State* L) {
	return JSObject::fromUserdata(L)->_delete(L, convert_to_js(L, 2));
}

luaL_Reg JSObject_reg[] =
{
	{ "__index", &JSObject___index },
	{ "__newindex", &JSObject___newindex },
	{ "__pairs", &JSObject___pairs },
	{ "__tostring", &JSObject___tostring },
	{ "__call", &JSObject___call },
	{ "__len", &JSObject___len },
	{ "__gc", &JSObject___gc },
	{ "_delete", &JSObject__delete },
	{ NULL, NULL }
};

static int JSObject_new(lua_State* L, emscripten::val value) {
	*reinterpret_cast<JSObject**>(lua_newuserdata(L, sizeof(JSObject*))) = new JSObject(value);
	lua_newtable(L);
	luaL_setfuncs(L, JSObject_reg, 0);
	lua_setmetatable(L, -2);
	return 1;
}
