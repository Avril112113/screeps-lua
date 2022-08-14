---@diagnostic disable: lowercase-global

require "screeps.api"
require "screeps.logging"

-- Logging.registerContext("creep", function(creep)
-- 	return ("<Creep \"%s\">"):format(tostring(creep))
-- end)

Script = {}

require "main"

assert(Script.loop ~= nil, "Missing 'Script.loop' function.")
