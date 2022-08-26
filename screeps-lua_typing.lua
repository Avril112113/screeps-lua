-- screeps-lua
Script = {
	---@type fun()
	loop = nil,
}

-- Screeps
Game = {}

-- Screeps
Memory = {
	---@type table<string,table>
	creeps = nil,
}

-- Screeps provided JS library.
---@type table
LoDash = nil

-- Custom from JS
---@type table<string|number, any>
JS = nil

-- JS Globals
---@type table<string|number, any>
JSGlobal = nil
