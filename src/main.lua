local jobs = require "jobs"


function Script.loop()
	for spawnName, spawn in pairs(Game.spawns) do
		local result = spawn:spawnCreep({WORK, CARRY, MOVE}, ("Creep %.0f"):format(Game.time))
		if result ~= 0 and result ~= -6 and result ~= -4 then
			print("SPAWN " .. spawnName .. " ERROR: " .. result)
		end
		spawn.room.visual:text(tostring(#spawn.room:find(102)), spawn.pos)
	end

	for _, creep in pairs(Game.creeps) do
		Logging.setContext("creep", creep)
		xpcall(jobs.collector, function(...) print_error(debug.traceback(...)) end, creep)
	end
	Logging.setContext("creep", nil)

	if Game.time % 10 then
		for name, memory in pairs(Memory.creeps) do
			if Game.creeps[name] == nil then
				Memory.creeps:_delete(name)
			end
		end
	end
end
