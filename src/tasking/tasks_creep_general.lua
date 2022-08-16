local DISTANCE_WEIGHT = 1/10
local PRINT_PRIORITY = false


local function isSourceValid(source, creep)
	if source.energy <= 0 and source.ticksToRegeneration > 25 then
		return false
	end
	local pos = source.pos
	if math.abs(creep.pos.x - pos.x) <= 1 and math.abs(creep.pos.y - pos.y) <= 1 then
		return true
	end
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
	sources = sources:filter(function(source, index, array)
		return isSourceValid(source, creep)
	end)
	sources = LowDash:sortBy(sources, function(source)
		return creep.pos:getRangeTo(source)
	end)
	return sources[1]
end
local function findAvailableSourceGround(creep)
	local sources = creep.room:find(118):concat(creep.room:find(106))
	sources = sources:filter(function(source, index, array)
		return source.resourceType == "energy" and source.amount > 0
	end)
	sources = LowDash:sortBy(sources, function(source)
		return creep.pos:getRangeTo(source)
	end)
	return sources[1]
end

local function findBestSpawnOrExtension(creep)
	local structures = creep.room:find(108)
	structures = structures:filter(function(structure)
		local structureType = structure.structureType
		if structureType == "spawn" or structureType == "extension" then
			return (structure.store:getFreeCapacity("energy") or 0) > 0
		end
		return false
	end)
	structures = LowDash:sortBy(structures, function(structure)
		return creep.pos:getRangeTo(structure)
	end)
	return structures[1]
end

local function existsConstructionSite(creep)
	local sites = creep.room:find(111)
	return #sites > 0
end
local function findConstructionSite(creep)
	local sites = creep.room:find(111)
	sites = LowDash:sortBy(sites, function(source)
		return creep.pos:getRangeTo(source)
	end)
	return sites[1]
end

local function findRepairStructure(creep)
	local structures = creep.room:find(107)
	structures = structures:filter(function(structure)
		return structure.hits ~= structure.hitsMax
	end)
	structures = LowDash:sortBy(structures, function(structure)
		return structure.hits/structure.hitsMax * math.max(1 - creep.pos:getRangeTo(structure) * 1/25, 1)
	end)
	return structures[1]
end

local function getTowersRoom(creep)
	local towers = creep.room:find(108)
	towers = towers:filter(function(structure)
		return structure.structureType == "tower"
	end)
	towers = LowDash:sortBy(towers, function(structure)
		return creep.pos:getRangeTo(structure)
	end)
	return towers
end
local function findTowerTransfer(creep)
	return getTowersRoom(creep):filter(function(tower)
		return (tower.store:getFreeCapacity("energy") or 0) > 0
	end)[1]
end


local tasks = {
	collect = {
		update = function(creep)
			local source
			if creep.memory.targetSource ~= nil then
				source = Game:getObjectById(creep.memory.targetSource)
			end
			if source ~= nil and source.energy <= 0 and source.ticksToRegeneration > 25 then
				source = nil
			end
			if creep.memory.targetSource == nil then
				source = findAvailableSource(creep)
				if source ~= nil then
					creep.memory.targetSource = source.id
				end
			end
			if source == nil then
				if creep.memory.targetSource ~= nil then
					creep.memory:_delete("targetSource")
				end
				return true
			end
			local result = creep:harvest(source)
			if result == -9 or (result == -6 and not (math.abs(creep.pos.x - source.pos.x) <= 1 and math.abs(creep.pos.y - source.pos.y) <= 1)) then
				creep:moveTo(source, {visualizePathStyle={stroke="#ffff00"}})
			end
			if creep.store:getFreeCapacity("energy") == 0 then
				creep.memory:_delete("targetSource")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") == 0 and findAvailableSource(creep) ~= nil
		end,
		getPriority = function(creep)
			return 1 / math.max(creep.pos:getRangeTo(findAvailableSource(creep))*DISTANCE_WEIGHT, 1)
		end,
	},
	collectGround = {
		update = function(creep)
			local source
			if creep.memory.targetSource ~= nil then
				source = Game:getObjectById(creep.memory.targetSource)
			end
			if source ~= nil and source.energy <= 0 and source.ticksToRegeneration > 25 then
				source = nil
			end
			if creep.memory.targetSource == nil then
				source = findAvailableSourceGround(creep)
				if source ~= nil then
					creep.memory.targetSource = source.id
				end
			end
			if source == nil then
				if creep.memory.targetSource ~= nil then
					creep.memory:_delete("targetSource")
				end
				return true
			end
			local result = creep:pickup(source)
			if result == -9 or (result == -6 and not (math.abs(creep.pos.x - source.pos.x) <= 1 and math.abs(creep.pos.y - source.pos.y) <= 1)) then
				creep:moveTo(source, {visualizePathStyle={stroke="#ffff00"}})
			end
			if creep.store:getFreeCapacity("energy") == 0 or source.amount <= 0 then
				creep.memory:_delete("targetSource")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") == 0 and findAvailableSourceGround(creep) ~= nil
		end,
		getPriority = function(creep)
			return 3 / math.max(creep.pos:getRangeTo(findAvailableSourceGround(creep))*DISTANCE_WEIGHT, 1)
		end,
	},
	transferSpawn = {
		update = function(creep)
			local structure
			if creep.memory.targetStructure ~= nil then
				structure = Game:getObjectById(creep.memory.targetStructure)
			end
			if structure ~= nil and structure.store:getFreeCapacity("energy") <= 0 then
				structure = nil
			end
			if creep.memory.targetStructure == nil then
				structure = findBestSpawnOrExtension(creep)
				if structure ~= nil then
					creep.memory.targetStructure = structure.id
				end
			end
			if structure == nil then
				if creep.memory.targetStructure ~= nil then
					creep.memory:_delete("targetStructure")
				end
				return true
			end
			local result = creep:transfer(structure, "energy")
			if result == -9 then
				creep:moveTo(structure, {visualizePathStyle={stroke="#D84800"}})
			end
			if result == -8 or creep.store:getUsedCapacity("energy") == 0 then
				creep.memory:_delete("targetStructure")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") > 0 and findBestSpawnOrExtension(creep) ~= nil
		end,
		getPriority = function(creep)
			local creepCount = #creep.room:find(102)
			return (
					creepCount <= 4 and 25 or
					creepCount <= 8 and 10 or
					creepCount < 12 and 7 or
					3
				) / math.max(creep.pos:getRangeTo(findBestSpawnOrExtension(creep))*DISTANCE_WEIGHT, 1)
		end,
	},
	upgradeController = {
		update = function(creep)
			local controller = creep.room.controller
			if creep:upgradeController(controller) == -9 then
				creep:moveTo(controller, {visualizePathStyle={stroke="#ff44ff"}})
			end
			return creep.store:getUsedCapacity("energy") == 0
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") > 0
		end,
		getPriority = function(creep)
			local maxDowngradeTicks = CONTROLLER_TICKS_DOWNGRADE_BY_LEVEL[creep.room.controller.level]
			local downgradeTicks = creep.room.controller.ticksToDowngrade
			local downgradeTicksMissing = maxDowngradeTicks - maxDowngradeTicks
			return (3 + (downgradeTicksMissing > 1000 and (downgradeTicksMissing / maxDowngradeTicks) * 100 or 0))
					/ math.max(creep.pos:getRangeTo(creep.room.controller)*DISTANCE_WEIGHT, 1)
		end,
	},
	build = {
		update = function(creep)
			local constructionSite
			if creep.memory.targetConstructionSite ~= nil then
				constructionSite = Game:getObjectById(creep.memory.targetConstructionSite)
			end
			if creep.memory.targetConstructionSite == nil then
				constructionSite = findConstructionSite(creep)
				if constructionSite ~= nil then
					creep.memory.targetConstructionSite = constructionSite.id
				end
			end
			if constructionSite == nil then
				if creep.memory.targetConstructionSite ~= nil then
					creep.memory:_delete("targetConstructionSite")
				end
				return true
			end
			local result = creep:build(constructionSite)
			if result == -9 then
				creep:moveTo(constructionSite, {visualizePathStyle={stroke="#00FF00"}})
			end
			if creep.store:getUsedCapacity("energy") <= 0 or Game:getObjectById(creep.memory.targetConstructionSite) == nil then
				creep.memory:_delete("targetConstructionSite")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return creep.store:getUsedCapacity("energy") > 0 and existsConstructionSite(creep)
		end,
		getPriority = function(creep)
			local constructionSite = findConstructionSite(creep)
			return 5 / math.max((constructionSite and creep.pos:getRangeTo(constructionSite) or 0)*DISTANCE_WEIGHT, 1)
		end,
	},
	repair = {
		update = function(creep)
			local structure
			if creep.memory.targetRepairStructure ~= nil then
				structure = Game:getObjectById(creep.memory.targetRepairStructure)
			end
			if creep.memory.targetRepairStructure == nil then
				structure = findRepairStructure(creep)
				if structure ~= nil then
					creep.memory.targetRepairStructure = structure.id
				end
			end
			if structure == nil then
				if creep.memory.targetRepairStructure ~= nil then
					creep.memory:_delete("targetRepairStructure")
				end
				return true
			end
			local result = creep:repair(structure)
			if result == -9 then
				creep:moveTo(structure, {visualizePathStyle={stroke="#0008FF"}})
			end
			if creep.store:getUsedCapacity("energy") <= 0 or structure.hits == structure.hitsMax then
				creep.memory:_delete("targetRepairStructure")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return #getTowersRoom(creep) <= 0 and creep.store:getUsedCapacity("energy") > 0 and findRepairStructure(creep) ~= nil
		end,
		getPriority = function(creep)
			local structure = findRepairStructure(creep)
			return 15 * (1-structure.hits/structure.hitsMax) / math.max(creep.pos:getRangeTo(structure)*DISTANCE_WEIGHT, 1)
		end,
	},
	transferTower = {
		update = function(creep)
			local tower
			if creep.memory.targetTower ~= nil then
				tower = Game:getObjectById(creep.memory.targetTower)
			end
			if tower ~= nil and tower.store:getFreeCapacity("energy") <= 0 then
				tower = nil
			end
			if creep.memory.targetTower == nil then
				tower = findTowerTransfer(creep)
				if tower ~= nil then
					creep.memory.targetTower = tower.id
				end
			end
			if tower == nil then
				if creep.memory.targetTower ~= nil then
					creep.memory:_delete("targetTower")
				end
				return true
			end
			local result = creep:transfer(tower, "energy")
			if result == -9 then
				creep:moveTo(tower, {visualizePathStyle={stroke="#D84800"}})
			end
			if result == -8 or creep.store:getUsedCapacity("energy") == 0 then
				creep.memory:_delete("targetTower")
				return true
			end
			return false
		end,
		shouldStart = function(creep)
			return #getTowersRoom(creep) > 0 and creep.store:getUsedCapacity("energy") > 0 and findTowerTransfer(creep) ~= nil
		end,
		getPriority = function(creep)
			return 15 * math.max(creep.pos:getRangeTo(findTowerTransfer(creep))*DISTANCE_WEIGHT, 1)
		end,
	},
}

-- TODO: This isn't working, calling from JS breaks the WASM runtime
-- function Global.getPriority(task, creep)
-- 	return tasks[task].getPriority(creep)
-- end

return function(creep)
	local currentTask = tasks[creep.memory.task]

	if currentTask == nil then
		local availableTasks = {}
		local sumWeight = 0
		for name, task in pairs(tasks) do
			if task.shouldStart(creep) then
				local priority = task.getPriority(creep)
				if math.validNumber(priority) then
					sumWeight = sumWeight + priority
					table.insert(availableTasks, {name, task, priority})
				else
					print_warn("Got invalid number priority " .. tostring(priority) .. " from task " .. name)
				end
			end
		end
		if #availableTasks > 0 then
			local taskInfo
			if #availableTasks == 1 then
				taskInfo = availableTasks[1]
			else
				local weights = {}
				if PRINT_PRIORITY then
					print(("- Task priorities for creep @ %.0f, %.0f -"):format(creep.pos.x, creep.pos.y))
				end
				for _, v in ipairs(availableTasks) do
					local priorityPercent = v[3] / sumWeight
					weights[v] = priorityPercent
					if PRINT_PRIORITY then
						print(("%s : %.0f%% @ %.2f"):format(v[1], priorityPercent*100, v[3]))
					end
				end
				taskInfo = math.inPlaceRandom(availableTasks, weights)()
				if PRINT_PRIORITY then
					print(("Picked: %s"):format(taskInfo[1]))
				end
			end
			if taskInfo ~= nil then
				creep.memory.task = taskInfo[1]
				currentTask = taskInfo[2]
			else
				print_error("Weighted random returned nil!?")
				return
			end
		end
	end
	if currentTask == nil then
		-- print_warn("Creep " .. tostring(creep) .. " has no task to do!")
		return
	end
	if currentTask.update(creep) then
		creep.memory.task = nil
	end
end
