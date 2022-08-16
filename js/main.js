//*

const MEMORY_HALT_THRESHOLD = 4;  // Remaining in MB
const BUCKET_CPU_REQUIREMENT = 400;
const LOOP_CPU_REQUIREMENT = 100;

// Future NOTE: For some dumb reason, console.log() doesn't work in `.then()` or `.catch()`, add items to a list and later log them.

if (Game.cpu.bucket < BUCKET_CPU_REQUIREMENT) {
	// throw new Error("Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)");
	console.log("<span style='color:#FF6F6B;'>Not enough cpu to initialise. (bucket requirement " + Game.cpu.bucket + "/" + BUCKET_CPU_REQUIREMENT + " not satisfied)</span>");
	return;
}

let LuaModule = require("lua_module");
let WASMBinary = require("lua");
let LuaFiles = require("lua_files");

let lua = null;
function loadWASM() {
	console.log("Loading WASM module.");

	lua = new LuaModule({
		wasmBinary: WASMBinary,
		print: function(msg) {
			console.log(msg);
		},
		printErr: function(msg) {
			console.log("<span style='color:#FF6F6B;'>" + msg + "</span>");
		},
	});

	LuaFiles.write(lua.FS);

	global.Lua = {
		_wasm: lua,
		eval: lua.cwrap("eval", null, ["string"]),
	}

	let result = lua._init();
	if (result != 0) {
		throw new Error("Failed to initialise Lua script.");
	}

	console.log("Initialised state.");
}
loadWASM();

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


module.exports.loop = function() {
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
	
	try {
		lua._loop();
	} catch (e) {
		// Oh no...
		console.log("<span style='color:#FF6F6B;'>" + e.stack + "</span>");
		lua = null;
		loadWASM();
	}
}

// Ignore this function, just figuring out methods
function _() {
}

//*/
