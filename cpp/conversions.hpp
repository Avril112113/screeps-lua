#pragma once

#include "global.hpp"
#include "utils.hpp"
#include "jsobject.hpp"


int convert_to_lua(lua_State* L, emscripten::val value, bool throwaway);

emscripten::val convert_to_js(lua_State* L, int n);
