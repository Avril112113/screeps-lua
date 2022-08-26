#include "conversions.hpp"


int convert_to_lua(lua_State* L, emscripten::val value, bool throwaway) {
	if (value.isNull() || value.isUndefined()) {
		lua_pushnil(L);
		return 1;	
	} else if (value.isNumber()) {
		lua_pushnumber(L, value.as<lua_Number>());
		return 1;
	} else if (value.isTrue() || value.isFalse()) {
		lua_pushboolean(L, value.as<bool>());
		return 1;
	} else if (value.isString()) {
		lua_pushstring(L, value.as<std::string>().c_str());
		return 1;
	} else if (value.isArray()) {
		return lua_pushjsobject(L, value, throwaway);
	}
	std::string type = value.typeOf().as<std::string>();
	if (type == "object" || type == "function") {
		return lua_pushjsobject(L, value, throwaway);
	}
	std::cerr << "Failed to convert type " << type.c_str() << "\n";
	lua_pushnil(L);
	return 1;
}

emscripten::val convert_to_js(lua_State* L, int n) {
	// Stack: ..., any@n, ...
	if (lua_isnil(L, n)) {
		return emscripten::val::null();
	} else if (lua_isboolean(L, n)) {
		return emscripten::val(lua_toboolean(L, n));
	} else if (lua_isnumber(L, n)) {
		return emscripten::val(lua_tonumber(L, n));
	} else if (lua_isstring(L, n)) {
		return emscripten::val(lua_tostring(L, n));
	} else if (lua_istable(L, n)) {
		if (n < 0) {
			n = lua_gettop(L) + n + 1;
		}
		int startSize = lua_gettop(L);
		bool isArray = true;
		lua_pushnil(L);
		while (lua_next(L, n) != 0) {
			if (!lua_isnumber(L, -2)) {
				isArray = false;
				lua_pop(L, 1);
				break;
			}
			lua_pop(L, 1);
		}
		if (isArray) {
			emscripten::val array = emscripten::val::array();
			int len = luaL_len(L, n);
			for (int i=0; i<len; i++) {
				lua_rawgeti(L, n, i+1);
				array.call<void>("push", convert_to_js(L, -1));
				lua_pop(L, 1);
			}
			return array;
		} else {
			emscripten::val object = emscripten::val::object();
			lua_pushnil(L);
			while (lua_next(L, n) != 0) {
				object.set(convert_to_js(L, -2), convert_to_js(L, -1));
				lua_pop(L, 1);
			}
			int endSize = lua_gettop(L);
			if (startSize != endSize) {
				int moreItems = endSize-startSize;
				if (moreItems > 0){
					// TODO: Fix this
					//		 Test case: moveTo with opts, nested tables AND multiple creeps
					// std::cerr << "We have " << moreItems << " more items on the stack than when we started?! (popped extras)\n";
					lua_pop(L, endSize-startSize);
				} else {
					std::cerr << "We have " << -moreItems << " less items on the stack than when we started?! (state is fucked...)\n";
					dumpstack(L);
				}
			}
			return object;
		}
	} else if (lua_isuserdata(L, n)) {
		JSObject* object = JSObject::fromUserdata(L, n);
		return object->value;
	}
	else if (lua_isfunction(L, n) || lua_iscfunction(L, n)) {
		lua_State* co = lua_newthread(L);  // freed by Lua
		lua_pushvalue(L, n);
		lua_xmove(L, co, 1);
		emscripten::val statePtr = emscripten::val(reinterpret_cast<size_t>(co));
		emscripten::val cb = emscripten::val::take_ownership(wrapLuaFunction(statePtr.as_handle()));
		return cb;
	}
	lua_newthread(L);
	std::cerr << "Failed to convert type " << luaL_typename(L, n) << "\n";
	lua_pop(L, 1);
	return emscripten::val::null();
}
