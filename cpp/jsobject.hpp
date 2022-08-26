#pragma once

#include "global.hpp"


class JSObject {
public:
	static JSObject* fromUserdata(lua_State* L, int n);

	std::map<emscripten::val, JSObject*> cache;

	emscripten::val value;
	bool _throwaway;

	JSObject(emscripten::val value, bool throwaway);
	~JSObject();

	int lua_push(lua_State* L);

	void flush_cache();

	static int _delete(lua_State* L);
	static int __gc(lua_State* L);
	static int __index(lua_State* L);
	static int __newindex(lua_State* L);
	static int __len(lua_State* L);
	static int __tostring(lua_State* L);
	static int __pairs(lua_State* L);
	static int __call(lua_State* L);
};

int lua_pushjsobject(lua_State* L, emscripten::val value, bool throwaway);

void jsobject_init_reg(lua_State* L);
