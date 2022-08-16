/* TODO List (there is also "todo"s scattered around the code)
*/

#include "global.hpp"

#include "screeps.hpp"  // TODO: remove this, it's not really needed.

#include "main.hpp"
// Include other cpp files, since I can't be arsed to build them all separately
#include "forjs.cpp"
#include "jsobject.cpp"
#include "conversions.cpp"

static void dumpstack(lua_State* L) {
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

static void luascreeps_setup(lua_State* L) {
	// Provide all needed methods for working with the JS environment
	// This is ran once along with `luaL_openlibs`
	JSObject_new(L, emscripten::val::global("_luaJS"));
	lua_setglobal(L, "JS");
	JSObject_new(L, emscripten::val::global("global"));
	lua_setglobal(L, "Global");
}

static void luascreeps_setup_tick(lua_State* L) {
	// Setup values that only exist for a loop/tick
	JSObject_new(L, screeps::tick->Game);
	lua_setglobal(L, "Game");
	JSObject_new(L, screeps::tick->Memory);
	lua_setglobal(L, "Memory");
	JSObject_new(L, screeps::tick->PathFinder);
	lua_setglobal(L, "PathFinder");
	JSObject_new(L, screeps::tick->RawMemory);
	lua_setglobal(L, "RawMemory");
}

static void luascreeps_cleanup_tick(lua_State* L) {
	// Clean-up everything we need after a tick has finished
	lua_pushnil(L);
	lua_setglobal(L, "Game");
	lua_pushnil(L);
	lua_setglobal(L, "Memory");
	lua_pushnil(L);
	lua_setglobal(L, "PathFinder");
	lua_pushnil(L);
	lua_setglobal(L, "RawMemory");
	lua_gc(L, LUA_GCCOLLECT);
}


extern "C" {

lua_State* L;

const char* RUN_FILE = "/screeps/run.lua";
extern int init() {
	L = luaL_newstate();
	luaL_openlibs(L);
	luascreeps_setup(L);
	JSObject_new(L, emscripten::val::global("_"));
	lua_setglobal(L, "LowDash");
	int result;
	result = luaL_loadfile(L, RUN_FILE);
	if (result != 0) {
		std::cerr << "Failed to load `run.lua` " << lua_tostring(L, -1) << "'\n";
		lua_close(L);
		return result;
	}
	result = lua_pcall(L, 0, LUA_MULTRET, 0);
	if (result != 0) {
		std::cerr << "Error running `" << RUN_FILE << "`\n";
		std::cerr << lua_tostring(L, -1) << "\n";
		std::cout << "Stack size after pcall error: " << lua_gettop(L) << "\n";
		return result;
	}
	return 0;
}

extern int loop() {
	screeps::INIT();
	luascreeps_setup_tick(L);
	lua_getglobal(L, "Script");  // table(global.Script)
	lua_getfield(L, -1, "loop");  // table(global.Script), function(Script.loop)
	int result = lua_pcall(L, 0, LUA_MULTRET, 0);
	if (result != 0) {
		std::cerr << "Error running `Script.loop()`\n";
		std::cerr << lua_tostring(L, -1) << "\n";
	}
	luascreeps_cleanup_tick(L);
	lua_pop(L, lua_gettop(L));
	return result;
}

extern void eval(char* code) {
	luascreeps_setup_tick(L);
	int result;
	result = luaL_loadstring(L, code); // Stack: callable(code)
	if (result != 0) {
		std::cerr << "Failed to load eval code " << lua_tostring(L, -1) << "'\n";
		lua_close(L);
		return;
	}
	result = lua_pcall(L, 0, LUA_MULTRET, 0);
	if (result != 0) {
		std::cerr << "Error running `Script.loop()`\n";
		std::cerr << lua_tostring(L, -1) << "\n";
	}
	luascreeps_cleanup_tick(L);
	dumpstack(L);
	lua_pop(L, lua_gettop(L));
	return;
}

}
