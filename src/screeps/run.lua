require "screeps.api"
require "screeps.extras"
require "screeps.logging"

math.nan = 0/0
math.inf = 3/0

function math.validNumber(n)
	return n ~= math.nan and n ~= math.inf and n ~= -math.nan and n ~= -math.inf
end

Logging.registerContext("creep", function(creep)
	return ("creep=\"%s\""):format(creep and creep.name or "nil")
end)

Script = {}

require "main"

assert(Script.loop ~= nil, "Missing 'Script.loop' function.")
