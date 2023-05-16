--- Main script table, for now this only contains `loop()`.
---@class Script
--- Called every tick.
---@field loop fun()
Script = nil

---@type Game
Game = nil

---@type table
Memory = {
	---@type table|{_move:table|{dest:table|{x:number, y:number, room:string},time:number,path:string,room:string}}
	creeps = nil
}

-- Screeps provided JS library.
---@type table
LoDash = nil

--- Custom methods supplied from JS
---@type table<string|number, any>
JS = nil

--- Access to JS Globals
---@type table<string|number, any>
JSGlobal = nil

---@type lightuserdata
---@diagnostic disable-next-line: lowercase-global
null = nil
