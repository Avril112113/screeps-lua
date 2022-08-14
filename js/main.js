//*

const STARTUP_ATTEMPT_COUNT = 4;
const BUCKET_CPU_REQUIREMENT = 500*STARTUP_ATTEMPT_COUNT;
const LOOP_CPU_REQUIREMENT = 20;

if (Memory.startup === undefined || Memory.startup == 0) {
	if (Game.cpu.bucket < BUCKET_CPU_REQUIREMENT) {
		// throw new Error("Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)");
		console.log("<span style='color:#FF6F6B;'>Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)</span>");
		return;
	} else {
		Memory.startup = STARTUP_ATTEMPT_COUNT;
	}
} else {
	Memory.startup -= 1;
}

let LuaModule = require("lua_module");
let WASMBinary = require("lua");

let lua = new LuaModule({
	wasmBinary: WASMBinary,
	print: function(msg) {
		console.log(msg);
	},
	printErr: function(msg) {
		console.log("<span style='color:#FF6F6B;'>" + msg + "</span>");
	},
});
let hasInitialised = false;

global._luaJS = {
	Object: Object,
	Array: Array,
	JSON: JSON,
}

global.Lua = {
	_wasm: lua,
	eval: lua.cwrap("eval", null, ["string"]),
}

module.exports.loop = function() {
	if (Game.cpu.tickLimit < LOOP_CPU_REQUIREMENT) {
		console.log("<span style='color:#FF6F6B;'>Not enough cpu to run loop. (tickLimit requirement " + Game.cpu.tickLimit + "/" + LOOP_CPU_REQUIREMENT + " not satisfied)</span>");
		return;
	}
	if (!hasInitialised) {
		// We initialise on the 2nd tick because we spent a lot of time already loading the WASM
		let result = lua._init();
		if (result != 0) {
			throw new Error("Failed to initialise Lua script.");
		} else {
			console.log("Loaded ScreepsLua.");
		}
		hasInitialised = true;
	}
	lua._loop();
}

// Ignore this function, just figuring out methods
function t() {
	// Chicken?
	Source().room.lookForAtArea()
}

//*/
