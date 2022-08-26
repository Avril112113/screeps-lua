#include "jsobjectpairs.hpp"
#include "conversions.hpp"


JSObjectPairs* JSObjectPairs::fromUserdata(lua_State* L, int n) {
	// NOTE: we have NO safety, we don't check the userdata
	return *reinterpret_cast<JSObjectPairs**>(lua_touserdata(L, n));
}

JSObjectPairs::JSObjectPairs(emscripten::val value) : _value(value) {
	_keys = GLOBAL_OBJECT.call<emscripten::val>("keys", value);
	_size = _keys["length"].as<int>();
}


std::string JSObjectPairs::get_initial_key() {
	return _keys[0].as<std::string>();
}

int JSObjectPairs::__pairs_iter(lua_State* L) {
	// Stack: userdata<JSObjectPairs>, 
	JSObjectPairs* jsobjectpairs = JSObjectPairs::fromUserdata(L, 1);

	if (jsobjectpairs->_idx >= jsobjectpairs->_size) return 0;

	std::string key = jsobjectpairs->_keys[jsobjectpairs->_idx].as<std::string>();
	lua_pushstring(L, key.c_str());
	emscripten::val keyObject = jsobjectpairs->_value[key];
	if (convert_to_lua(L, keyObject, true) == 0) {
		lua_pushnil(L);
	}

	jsobjectpairs->_idx++;

	return 2;
}

int JSObjectPairs::__gc(lua_State* L){
	// Stack: userdata<JSObjectPairs>
	delete JSObjectPairs::fromUserdata(L, 1);
	return 0;
}

luaL_Reg JSObjectPairs_reg[] =
{
	{ "__gc", &JSObjectPairs::__gc },
	{ NULL, NULL }
};

int lua_pushjsobjectpairs(lua_State* L, emscripten::val value) {
	*reinterpret_cast<JSObjectPairs**>(lua_newuserdata(L, sizeof(JSObjectPairs*))) = new JSObjectPairs(value);
	lua_pushlightuserdata(L, (void*)&lua_pushjsobjectpairs);
    lua_gettable(L, LUA_REGISTRYINDEX);
	lua_setmetatable(L, -2);
	return 1;
}

void jsobjectpairs_init_reg(lua_State* L) {
	lua_pushlightuserdata(L, (void*)lua_pushjsobjectpairs);
	lua_newtable(L);
	lua_pushstring(L, "JSObjectPairs");
	lua_setfield(L, -2, "__name");
	luaL_setfuncs(L, JSObjectPairs_reg, 0);
	lua_settable(L, LUA_REGISTRYINDEX);
}
