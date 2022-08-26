const WASM_LOAD_ASYNC = false;  // This should `true` only when the WASM was built with "async compilation"
const MIN_CPU_LOOP = 500;  // This only applied for the tick during loading, `.loop()` will be delayed
const MAX_TICKS_TO_LOAD = 3;


global.LuaLib = {
	test: function(f, ...args) {
		return f.apply(undefined, args);
	},
};


let LuaModule;
let LuaWASM;
let LuaFiles;


function _error(...args) {
	console.log("<span style='color:#FF6F6B;'>" + args.join(" ") + "</span>");
}


// Used when `console.log()` can be broken and not actually output anything.
// Primarily when any `Promise`s are involved or `LuaModule` throws any errors.
let log = [];
let logErrors = [];
let halt = false;

function _logException(e, msg) {
	if (msg != undefined) {
		logErrors.push(msg);
	}
	if (e.stack != undefined) {
		logErrors.push(e.stack);
	} else {
		logErrors.push(e);
	}
}

class Lua {
	constructor() {
		this.module = null;
		this.startedLoading = -1;
		this.loadedAt = -1;
		this.initialised = false;
		this.running = false;
	}

	loadSync() {
		console.log("Loading Lua module sync.");
		this.startedLoading = Game.time;
		try {
			this.module = new LuaModule({
				wasmBinary: LuaWASM,
				print: console.log,
				printErr: _error,
			});
		} catch (e) {
			_logException(e);
			this.startedLoading = -1;
			return;
		}
		LuaFiles.write(lua.module.FS);
		this.loadedAt = Game.time;
		this.setupGlobal();
		console.log("Loaded Lua module sync.");
	}

	loadAsync() {
		log.push("Loading Lua module async.");
		this.startedLoading = Game.time;
		LuaModule({
			wasmBinary: LuaWASM,
			print: function(msg) {
				console.log(msg);
			},
			printErr: function(msg) {
				console.log("<span style='color:#FF6F6B;'>" + msg + "</span>");
			},
		}).then(module => {
			this.module = module;
			try {
				LuaFiles.write(lua.module.FS);
			} catch (e) {
				_logException(e, "Failed to write files:");
				return;
			}
			this.loadedAt = Game.time;
			this.setupGlobal();
			log.push("Loaded Lua module async.");
		}).catch(e => {
			this.startedLoading = -1;
			logErrors.push(e);
		});
	}

	load() {
		return WASM_LOAD_ASYNC? this.loadAsync() : this.loadSync();
	}

	setupGlobal() {
		global.Lua = {
			_lua: this,
			eval: this.module.cwrap("eval", null, ["string"]),
		}
		// TODO: Have a special global in Lua that will get put into `global` for the console
	}
}


let lua = new Lua();

let lastHeapStats;
let losingMemoryStreak = 0;
let midTick = false;
module.exports.loop = function() {
	if (log.length > 0) {
		log.forEach(msg => console.log(msg));
		log.length = 0;
	}
	if (logErrors.length > 0) {
		logErrors.forEach(msg => _error(msg));
		logErrors.length = 0;
	}
	if (halt) {
		Game.cpu.halt();
	}
	if (LuaModule === null || LuaWASM === null || LuaFiles === null) {
		_error("Failed to `require()` a file (probably WASM) see above.");
		halt = true;
		return;
	} else if (LuaModule === undefined || LuaWASM === undefined || LuaFiles === undefined) {
		LuaModule = null;
		LuaWASM = null;
		LuaFiles = null;
		try {
			LuaModule = require("lua_module");
			LuaWASM = require("lua_wasm");
			LuaFiles = require("lua_files");
		} catch (e) {
			_logException(e);
		}
	}
	if (lua.module == null && lua.startedLoading < 0) {
		// Not currently trying to load
		try {
			lua.load();
		} catch (e) {
			_logException(e, "Caught error trying to load lua module:");
			return;
		}
	}
	if (lua.module != null && lua.loadedAt >= 0) {
		if (!lua.initialised) {
			try {
				let status = lua.module._init();
				if (status != 0) {
					logErrors.push("Failed to initialise lua module: " + status);
					return;
				}
				lua.initialised = true;
			} catch (e) {
				_logException(e, "Caught error in _init()");
				return;
			}
		}
		if (lua.initialised && !lua.running) {
			if (Game.cpu.tickLimit >= MIN_CPU_LOOP) {
				lua.running = true;
			} else {
				logErrors.push("Waiting for CPU tick limit to reach >=" + MIN_CPU_LOOP + " before we start running `Script.loop()`");
				return;
			}
		}
		if (midTick) {
			// For some reason we didn't finish last time (probably "timed out")
			_error("Execution didn't finish last tick (timed out?) reloading Lua to be safe.")
			try {
				lua.module._reload();
			} catch (e) {
				_logException(e, "Caught error in _reload()")
				return;
			}
		}
		if (lua.initialised && lua.running) {
			midTick = true;
			try {
				lua.module._loop();
			} catch (e) {
				_logException(e, "Caught error in _loop()")
				return;
			} finally {
				midTick = false;
				let stats = Game.cpu.getHeapStatistics();
				if (lastHeapStats != undefined) {
					// Game.cpu.getHeapStatistics().heap_size_limit - Game.cpu.getHeapStatistics().used_heap_size
					if (stats.used_heap_size > lastHeapStats.used_heap_size) {
						losingMemoryStreak++;
					} else {
						losingMemoryStreak = 0;
					}
				}
				if (losingMemoryStreak > 10) {
					logErrors.push(`WARNING: Memory leak, lost heap space for ${losingMemoryStreak} ticks. (${Math.ceil(stats.used_heap_size/1024/1024)}/${Math.ceil(stats.heap_size_limit/1024/1024)} MB)`);
				}
				lastHeapStats = stats;
			}
		}
	} else if (lua.module == null && lua.startedLoading >= 0 && Game.time - lua.startedLoading >= MAX_TICKS_TO_LOAD) {
		// Took too long to load. Something explode?
		logErrors.push("Failed to load within " + MAX_TICKS_TO_LOAD + " ticks, restarting.");
		halt = true;
		return;
	} else if (lua.module != null && lua.loadedAt < 0) {
		// Failed to load lua module (Probably `Lua.load()` failed)
		logErrors.push("Failed to tick because Lua module isn't loaded? See above.");
		halt = true;
		return;
	}
}
