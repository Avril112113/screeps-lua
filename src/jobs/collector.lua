local function isSourceValid(source)
	if source.energy <= 0 then
		return false
	end
	local pos = source.pos
	local terrain = source.room:lookForAtArea("terrain", pos.y-1, pos.x-1, pos.y+1, pos.x+1, true)
	for _, tile in ipairs(terrain) do
		if tile.terrain ~= "wall" then
			if #source.room:lookForAt("creep", tile.x, tile.y) <= 0 then
				return true
			end
		end
	end
	return false
end
local function findAvailableSource(creep)
	local sources = creep.room:find(105)
	sources = LowDash:sortBy(sources, function(source)
		return creep.pos:getRangeTo(source)
	end)
	sources = sources:filter(function(source, index, array)
		return isSourceValid(source)
	end)
	return sources[1]
end


local tasks = {
	collect = {
		update = function(creep)
			local source
			if creep.memory.targetSource ~= nil then
				source = Game:getObjectById(creep.memory.targetSource)
			end
			if creep.memory.targetSource == nil then
				source = findAvailableSource(creep)
				if source ~= nil then
					creep.memory.targetSource = source.id
				end
			end
			if source == nil then
				-- print_warn("Failed to find available source...")
				return true
			end
			if creep:harvest(source) == -9 then
				creep:moveTo(source, {visualizePathStyle={stroke="#ffffff"}})
			end
			if creep.store:getFreeCapacity("energy") == 0 then
				creep.memory.targetSource = nil
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") == 0
		end,
	},
	transferSpawn = {
		update = function(creep)
			local spawn = Game.spawns["W9N1_0"]
			if creep:transfer(spawn, "energy") == -9 then
				creep:moveTo(spawn, {visualizePathStyle={stroke="#ffffff"}})
			end
			return creep.store:getUsedCapacity("energy") == 0
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") > 0
		end,
	},
	upgradeController = {
		update = function(creep)
			local controller = creep.room.controller
			if creep:upgradeController(controller) == -9 then
				creep:moveTo(controller, {visualizePathStyle={stroke="#ffffff"}})
			end
			return creep.store:getUsedCapacity("energy") == 0
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") > 0
		end,
	},
}


return function(creep)
	print("Hi!")

	local currentTask = tasks[creep.memory.task]

	if currentTask == nil then
		local availableTasks = {}
		for name, task in pairs(tasks) do
			if task.shouldStart(creep) then
				table.insert(availableTasks, {name, task})
			end
		end
		if #availableTasks > 0 then
			local taskPair = availableTasks[math.random(1, #availableTasks)]
			creep.memory.task = taskPair[1]
			currentTask = taskPair[2]
		end
	end
	if currentTask == nil then
		print("Creep " .. tostring(creep) .. " has no task to do!")
		return
	end
	if currentTask.update(creep) then
		creep.memory.task = nil
	end
end
