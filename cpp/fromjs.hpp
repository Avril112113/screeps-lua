#pragma once

#include "global.hpp"


extern "C" {
	extern emscripten::EM_VAL varcall(emscripten::EM_VAL f, emscripten::EM_VAL thisObj, emscripten::EM_VAL args);
	extern emscripten::EM_VAL wrapLuaFunction(emscripten::EM_VAL statePtrHandle);
}
