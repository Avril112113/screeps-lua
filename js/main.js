//*

const ASYNC_COMPILATION = false;  // This should reflect `WASM_ASYNC_COMPILATION` in `build.bat`
const MEMORY_HALT_THRESHOLD = 4;  // Remaining in MB
const BUCKET_CPU_REQUIREMENT = 400;
const LOOP_CPU_REQUIREMENT = 100;

// Future NOTE: For some dumb reason, console.log() doesn't work in `.then()` or `.catch()`, add items to a list and later log them.

if (Game.cpu.bucket < BUCKET_CPU_REQUIREMENT) {
	// throw new Error("Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)");
	console.log("<span style='color:#FF6F6B;'>Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)</span>");
	return;
}

let LuaModule;
let WASMBinary;
let LuaFiles;

let lua = null;
let luaSetupLogs = [];
let luaExploded = null;
function setupLuaModule(lua) {
	LuaFiles.write(lua.FS);

	global.Lua = {
		_wasm: lua,
		eval: lua.cwrap("eval", null, ["string"]),
	}

	let result = lua._init();
	if (result != 0) {
		throw new Error("Failed to initialise Lua script.");
	}

	luaSetupLogs.push("Lua module is set up.");
}
function loadWASM() {
	console.log("Loading Lua module.");

	if (!ASYNC_COMPILATION) {
		lua = new LuaModule({
			wasmBinary: WASMBinary,
			print: function(msg) {
				console.log(msg);
			},
			printErr: function(msg) {
				console.log("<span style='color:#FF6F6B;'>" + msg + "</span>");
			},
		});
		setupLuaModule(lua);
	} else {
		LuaModule({
			wasmBinary: WASMBinary,
			print: function(msg) {
				console.log(msg);
			},
			printErr: function(msg) {
				console.log("<span style='color:#FF6F6B;'>" + msg + "</span>");
			},
		}).then(_lua => {
			setupLuaModule(_lua);
			lua = _lua;
		}).catch(e => {
			luaExploded = e;
		});
	}
}

global._luaJS = {
	Object: Object,
	Array: Array,
	JSON: JSON,
}

global.bodyCost = function(body) {
	let cost = 0;
	body.forEach(part => {
		cost += BODYPART_COST[part];
	});
	return cost;
}


let firstTick = true;
module.exports.loop = function() {
	if (luaSetupLogs.length > 0) {
		luaSetupLogs.forEach(value => console.log(value));
		luaSetupLogs.length = 0;
	}
	if (luaExploded != null && luaExploded != true) {
		let t = luaExploded;
		luaExploded = true;
		console.log("Something exploded loading the Lua module, execution paused...");
		throw t;
	}
	// The below error was making debugging impossible, as all error messages was lost due to broken `console.log`. (Horrible work-around...)
	// "An object was thrown from supplied code within isolated-vm, but that object was not an instance of Error."
	if (firstTick) {
		firstTick = false;
		try {
			LuaModule = require("lua_module");
			WASMBinary = require("lua");
			LuaFiles = require("lua_files");
			loadWASM();
		} catch (e) {
			luaExploded = e;
		}
	}
	if (Game.cpu.tickLimit < LOOP_CPU_REQUIREMENT) {
		console.log("<span style='color:#FF6F6B;'>Not enough cpu to run loop. (tickLimit requirement " + Game.cpu.tickLimit + "/" + LOOP_CPU_REQUIREMENT + " not satisfied)</span>");
		return;
	}
	if (Game.time % 10 == 0) {
		let stats = Game.cpu.getHeapStatistics();
		if (stats.total_available_size <= 1028*1028*MEMORY_HALT_THRESHOLD) {
			console.log("<span style='color:#FF6F6B;'>Restarting due to up-coming memory issue... (memory leak?)</span>");
			Game.cpu.halt();
		}
	}
	
	if (lua != null) {
		try {
			lua._loop();
		} catch (e) {
			// Oh no...
			console.log("<span style='color:#FF6F6B;'>" + e.stack + "</span>");
			lua = null;
			loadWASM();
		}
	} else if (luaExploded != true) {
		console.log("Waiting on Lua module to be ready!");
	}
}

// Ignore this function, just figuring out methods
function _() {
}

//*/
