require "screeps.api"
require "screeps.extras"
require "screeps.random"
require "screeps.logging"

math.nan = math.abs(0/0)
math.inf = 1/0

function math.validNumber(n)
	return math.abs(n) ~= math.nan and math.abs(n) ~= math.inf and n == n
end

Logging.registerContext("creep", function(creep)
	return ("creep=\"%s\""):format(creep and creep.name or "nil")
end)

Logging.registerContext("tower", function(tower)
	return ("tower=%.0f,%.0f"):format(tower and tower.pos.x or math.nan, tower and tower.pos.x or math.nan)
end)

Script = {}

require "main"

assert(Script.loop ~= nil, "Missing 'Script.loop' function.")
