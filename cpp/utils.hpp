#pragma once

#include "global.hpp"


void dumpstack(lua_State* L);


int screepslua_stacktrace(lua_State *L);
int screepslua_pcall(lua_State* L, int nargs, int nret);

const emscripten::val GLOBAL_OBJECT = emscripten::val::global("Object");
const emscripten::val GLOBAL_JSON = emscripten::val::global("JSON");

void print_registry_size(lua_State* L, const char* prefix);
