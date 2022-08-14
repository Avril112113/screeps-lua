// From https://github.com/screepers/cppreeps/blob/master/include/cppreeps.hpp

#pragma once

#include <algorithm>
#include <cstdio>
#include <map>
#include <memory>
#include <vector>
#include <utility>

#include <emscripten.h>
#include <emscripten/val.h>
#include <emscripten/bind.h>


#define LOG_HEAD "[cppreeps]: "

namespace utils {
    
    using val = emscripten::val;
    
    using array_native  = std::vector<val>;
    using object_native = std::map<std::string, val>;
    
    
    const static val gGlobal = val::global();           // Global JS scope
    const static val gObject = val::global("Object");   // Global JS Object
    
    
    /// @returns val of global object by its name
    inline val get_global(char const* name) {
        return val::global(name); }
    
    /// @returns val of global object by its name
    inline val get_global(std::string const& name) {
        return val::global(name.c_str()); }
    
    /// @returns val of global constant by its name
    template <class T>
    inline val gCONST(T&& name) {
        return val::global(std::forward<T>(name)); }
    
    
    /// Parses given val, @returns std::vector<val>
    array_native js_array_to_vector(val const& arr) {
        int size = arr["length"].as<int>();
        
        array_native res; res.reserve(size);
        for(int i = 0; i < size; ++i)
            res.emplace_back(arr[i]);

        return res;
    }
    
    /// Parses given val, @returns std::map<std::string, val>
    object_native js_object_to_map(val const& obj) {
        val keys = gObject.call<val>("keys", obj);
        int size = keys["length"].as<int>();
        
        object_native res;
        for(int i = 0; i < size; ++i) {
            auto key = keys[i].as<std::string>();
            res.emplace_hint(res.end(), key, obj[key]);
        }
        
        return res;
    }
}

namespace screeps {
    
    using namespace utils;
    
    struct tick_t {
        val Game        = get_global("Game");
        val Memory      = get_global("Memory");
        val RawMemory   = get_global("RawMemory");
        val PathFinder  = get_global("PathFinder");
        
        //  tick_t() { std::printf(LOG_HEAD "TICK{%d} CONSTRUCTED\n", Game["time"].as<int>()); }
        // ~tick_t() { std::printf(LOG_HEAD "TICK{%d} DESTROYED\n",   Game["time"].as<int>()); }
    };
    
    static std::unique_ptr<tick_t> tick;
    
    /// Performs recaching of global game objects,
    /// resets previous tick data reference counters, releases objects for GC
    void INIT() { tick.reset(new tick_t{}); }
}

#undef LOG_HEAD
