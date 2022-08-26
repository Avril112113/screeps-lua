#include "main.hpp"
#include "utils.hpp"
#include "conversions.hpp"
#include "jsobject.hpp"
#include "jsobjectpairs.hpp"


std::map<const char*, JSObject*> jsglobals;
static void screepslua_setjsglobal(lua_State* L, const char* jsName, const char* luaName, bool cleanup=false) {
	if (convert_to_lua(L, emscripten::val::global(jsName), !cleanup) > 0) {
		if (cleanup) {
			jsglobals[jsName] = JSObject::fromUserdata(L, -1);
		}
		lua_setglobal(L, luaName);
	} else {
		std::cerr << "Failed to set global `" << luaName << "`\n";
	}
}


static void screepslua_init(lua_State* L) {
	jsobject_init_reg(L);
	jsobjectpairs_init_reg(L);

	lua_newtable(L);
	lua_setglobal(L, "Script");

	screepslua_setjsglobal(L, "_", "LoDash");
	screepslua_setjsglobal(L, "LuaLib", "JS");
	screepslua_setjsglobal(L, "global", "JSGlobal");
}

static void screepslua_tick_setup(lua_State* L) {
	screepslua_setjsglobal(L, "Game", "Game", true);
	screepslua_setjsglobal(L, "Memory", "Memory", true);
}

static void screepslua_tick_free(lua_State* L) {
	for (auto it = jsglobals.begin(); it != jsglobals.end(); it++)
	{
		it->second->flush_cache();
		lua_pushlightuserdata(L, (void*)it->second);
		lua_pushnil(L);
		lua_settable(L, LUA_REGISTRYINDEX);
		lua_pushnil(L);
		lua_setglobal(L, it->first);
	}
	jsglobals.empty();
}


lua_State* GlobalState;
lua_State* get_global_state() {
	return GlobalState;
}


extern "C" int init() {
	// Create and setup the lua state
	GlobalState = luaL_newstate();
	luaL_openlibs(GlobalState);
	screepslua_init(GlobalState);
	// Run the `/screeps/run.lua` file
	int status;
	status = luaL_loadfile(GlobalState, RUN_FILE);
	if (status != 0) {
		std::cerr << "Failed to load `" RUN_FILE "` " << lua_tostring(GlobalState, -1) << "'\n";
		lua_close(GlobalState);
		return status;
	}
	status = screepslua_pcall(GlobalState, 0, LUA_MULTRET);
	if (status != 0) {
		std::cerr << "Error running `" RUN_FILE "`\n";
		std::cerr << lua_tostring(GlobalState, -1) << "\n";
		return status;
	}
	leak_check();
	return status;
}

extern "C" int reload() {
	if (!(GlobalState == nullptr)) {
		lua_close(GlobalState);
	}
	return init();
}



extern "C" int loop() {
	screepslua_tick_setup(GlobalState);
	lua_getglobal(GlobalState, "Script");  // table(global.Script)
	lua_getfield(GlobalState, -1, "loop");  // table(global.Script), function(Script.loop)
	int status = screepslua_pcall(GlobalState, 0, LUA_MULTRET);
	if (status != 0) {
		std::cerr << "Error running `Script.loop()`\n";
		std::cerr << lua_tostring(GlobalState, -1) << "\n";
		return status;
	}
	screepslua_tick_free(GlobalState);
	lua_gc(GlobalState, LUA_GCCOLLECT);
	leak_check();
	lua_pop(GlobalState, lua_gettop(GlobalState));
	return status;
}

extern "C" int eval(char* code) {
	screepslua_tick_setup(GlobalState);
	luaL_loadstring(GlobalState, code);
	int status = screepslua_pcall(GlobalState, 0, LUA_MULTRET);
	if (status != 0) {
		std::cerr << "Error running eval string\n";
		std::cerr << lua_tostring(GlobalState, -1) << "\n";
		return status;
	}
	screepslua_tick_free(GlobalState);
	lua_gc(GlobalState, LUA_GCCOLLECT);
	leak_check();
	return status;
}
