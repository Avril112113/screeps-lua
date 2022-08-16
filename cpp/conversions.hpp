#pragma once

#include "global.hpp"


static int convert_to_lua(lua_State* L, emscripten::val value);

static emscripten::val convert_to_js(lua_State* L, int n);