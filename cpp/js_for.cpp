#include "global.hpp"
#include "conversions.hpp"
#include "utils.hpp"

extern "C" emscripten::EM_VAL callWrappedLuaFunction(emscripten::EM_VAL statePtrHandle, emscripten::EM_VAL argsHandle) {
	emscripten::val statePtr = emscripten::val::take_ownership(statePtrHandle);
	emscripten::val args = emscripten::val::take_ownership(argsHandle);
	
	lua_State* L = reinterpret_cast<lua_State*>(statePtr.as<size_t>());
	// Stack: callable
	lua_pushvalue(L, 1);  // Copy the function, since lua_call consumes and this might be called many times
	// Stack: callable, callable
	int length = args["length"].as<int>();
	for (int i = 0; i < length; i++) {
		convert_to_lua(L, args[i], true);
	}
	int result = screepslua_pcall(L, length, LUA_MULTRET);
	if (result != 0) {
		std::cerr << "Error running JS wrapped lua function.\n";
		std::cerr << lua_tostring(L, -1) << "\n";
		lua_settop(L, 1);
		return emscripten::val::undefined().as_handle();
	}
	int nargs = lua_gettop(L)-1;
	if (nargs >= 2) {
		emscripten::val array = emscripten::val::array();
		for (int i = 0; i < nargs; i++)
		{
			array.call<void>("push", convert_to_js(L, i+2));
		}
		emscripten::EM_VAL handle = array.as_handle();
		emscripten::internal::_emval_incref(handle);
		lua_settop(L, 1);  // Just to be sure.
		return handle;
	} else if (nargs == 1) {
		emscripten::val value = convert_to_js(L, 2);
		emscripten::EM_VAL handle = value.as_handle();
		emscripten::internal::_emval_incref(handle);
		lua_settop(L, 1);  // Just to be sure.
		return handle;
	}
	lua_settop(L, 1);  // Just to be sure.
	return emscripten::val::undefined().as_handle();
}
