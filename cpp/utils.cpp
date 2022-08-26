#include "utils.hpp"


void dumpstack(lua_State* L) {
	int top=lua_gettop(L);
	for (int i=1; i <= top; i++) {
		printf("%d\t%s\t", i, luaL_typename(L,i));
		switch (lua_type(L, i)) {
			case LUA_TNUMBER:
				printf("%g\n",lua_tonumber(L,i));
				break;
			case LUA_TSTRING:
				printf("%s\n",lua_tostring(L,i));
				break;
			case LUA_TBOOLEAN:
				printf("%s\n", (lua_toboolean(L, i) ? "true" : "false"));
				break;
			case LUA_TNIL:
				printf("%s\n", "nil");
				break;
			default:
				printf("%p\n",lua_topointer(L,i));
				break;
		}
	}
}

// From: https://github.com/sydlawrence/CorsixTH-HTML5-Port/blob/95d272e0ad27758fed7d231d8ab7f79aa4b0773f/source/CorsixTH/Src/main.cpp#L201
int screepslua_stacktrace(lua_State *L) {
    // err = tostring(err)
    lua_settop(L, 1);
    lua_getglobal(L, "tostring");
    lua_insert(L, 1);
    lua_call(L, 1, 1);

    // return debug.traceback(err, 2)
    lua_getglobal(L, "debug");
    lua_getfield(L, -1, "traceback");
    lua_pushvalue(L, 1);
    lua_pushinteger(L, 2);
    lua_call(L, 2, 1);

    return 1;
}

// From: https://stackoverflow.com/questions/30021904/lua-set-default-error-handler
int screepslua_pcall(lua_State* L, int nargs, int nret) {
	int hpos = lua_gettop(L) - nargs;
	lua_pushcfunction(L, screepslua_stacktrace);
	lua_insert(L, hpos);
	int ret = lua_pcall(L, nargs, nret, hpos);
	lua_remove(L, hpos);
	return ret;
}

void print_registry_size(lua_State* L, const char* prefix) {
	int top = lua_gettop(L);
	int size = 0;
	lua_pushnil(L);
	while (lua_next(L, LUA_REGISTRYINDEX) != 0) {
		size++;
		lua_pop(L, 1);
	}
	lua_settop(L, top);
	std::cout << prefix << " Registry length: " << size << "\n";
}
