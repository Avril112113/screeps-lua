#pragma once

#include "global.hpp"


static int JSObject_new(lua_State* L, emscripten::val value);

static void dumpstack(lua_State* L);
