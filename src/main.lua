local Tasking = require "tasking"


local function bodyCost(body)
	local cost = 0
	for _, part in ipairs(body) do
		cost = cost + Global.BODYPART_COST[part]
	end
	return cost
end


function Script.loop()
	for spawnName, spawn in pairs(Game.spawns) do
		local creepCount = #spawn.room:find(102)
		local body
		local maxCost = creepCount < 4 and spawn.room.energyAvailable or spawn.room.energyCapacityAvailable
		local workCount = 1
		local carryCount = 1
		local moveCount = 1
		body = {WORK, CARRY, MOVE}
		local cost = bodyCost(body)
		while true do
			local part
			if carryCount/2 >= moveCount then
				part = MOVE
				moveCount = moveCount + 1
			elseif workCount > carryCount or cost + Global.BODYPART_COST[WORK] > maxCost then
				part = CARRY
				carryCount = carryCount + 1
			else
				part = WORK
				workCount = workCount + 1
			end
			local partCost = Global.BODYPART_COST[part]
			if cost + partCost > maxCost then
				break
			end
			table.insert(body, part)
			cost = cost + partCost
			if #body >= Global.MAX_CREEP_SIZE then
				break
			end
		end
		table.sort(body)
		local result = spawn:spawnCreep(body, ("Creep %.0f"):format(Game.time))
		if result ~= 0 and result ~= -6 and result ~= -4 then
			print_error("SPAWN " .. spawnName .. " ERROR: " .. result)
		elseif result == 0 then
			print_info("Spawned  creep that cost " .. bodyCost(body) .. "/" .. maxCost .. "/" .. spawn.room.energyCapacityAvailable .. " with [" .. table.concat(body, ", ") .. "]")
		end
		if result ~= 0 and spawn.room.energyCapacityAvailable == spawn.room.energyAvailable then
			print_warn("At capacity of " .. spawn.room.energyCapacityAvailable .. " but no creep that cost " .. bodyCost(body) .. " with [" .. table.concat(body, ", ") .. "] spawned?")
		end
		spawn.room.visual:text(tostring(creepCount), spawn.pos)
	end

	for _, creep in pairs(Game.creeps) do
		Logging.setContext("creep", creep)
		xpcall(Tasking.tasks_creep_general, function(...) print_error(debug.traceback(...)) end, creep)
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
