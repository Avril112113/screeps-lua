#pragma once

#include "global.hpp"

class JSObjectPairs {
public:
	static JSObjectPairs* fromUserdata(lua_State* L, int n);

private:
	emscripten::val _value;
	emscripten::val _keys;
	int _size;
	int _idx = 0;

public:
	JSObjectPairs(emscripten::val value);

	std::string get_initial_key();

	static int __gc(lua_State* L);

	static int __pairs_iter(lua_State* L);
};

int lua_pushjsobjectpairs(lua_State* L, emscripten::val value);

void jsobjectpairs_init_reg(lua_State* L);
