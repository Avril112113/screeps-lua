---@diagnostic disable: lowercase-global

require "screeps.api"
require "screeps.logging"

Logging.registerContext("creep", function(creep)
	return ("creep=\"%s\""):format(creep and creep.name or "nil")
end)

Script = {}

require "main"

assert(Script.loop ~= nil, "Missing 'Script.loop' function.")
