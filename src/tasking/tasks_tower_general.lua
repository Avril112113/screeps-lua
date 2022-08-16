local DISTANCE_WEIGHT = 1/20
local PRINT_PRIORITY = true


local function getTowerEnemy(tower)
	local enemies = LowDash:sortBy(tower.room:find(103), function(enemy)
		return tower.pos:getRangeTo(enemy)
	end)
	return enemies[1]
end
local function getTowerHeal(tower)
	local creeps = LowDash:filter(tower.room:find(102), function(creep)
		return creep.hits < creep.hitsMax
	end)
	creeps = LowDash:sortBy(creeps, function(creep)
		return tower.pos:getRangeTo(creep)
	end)
	return creeps[1]
end
local function getTowerRepair(tower)
	local structures = LowDash:filter(tower.room:find(107), function(structure)
		return structure.hits ~= nil and structure.hits < structure.hitsMax and (structure.structureType ~= "road" or structure.hits < 4000)
	end)
	structures = LowDash:sortBy(structures, function(structure)
		return tower.pos:getRangeTo(structure)
	end)
	return structures[1]
end


local tasks = {
	defend = {
		update = function(tower)
			local enemy = getTowerEnemy(tower)
			tower:attack(enemy)
			return true  -- Re-evaluate every time
		end,
		shouldStart = function(tower)
			return tower.store["energy"] >= 10 and getTowerEnemy(tower) ~= nil
		end,
		getPriority = function(tower)
			local enemy = getTowerEnemy(tower)
			return 80 * (1 - enemy.hits / enemy.hitsMax) / math.max(tower.pos:getRangeTo(enemy)*DISTANCE_WEIGHT, 1)
		end,
	},
	heal = {
		update = function(tower)
			local creep = getTowerHeal(tower)
			tower:heal(creep)
			return true  -- Re-evaluate every time
		end,
		shouldStart = function(tower)
			return tower.store["energy"] >= 10 and getTowerHeal(tower) ~= nil
		end,
		getPriority = function(tower)
			local creep = getTowerHeal(tower)
			return 50 * (1 - creep.hits / creep.hitsMax) / math.max(tower.pos:getRangeTo(creep)*DISTANCE_WEIGHT, 1)
		end,
	},
	repair = {
		update = function(tower)
			local structure = getTowerRepair(tower)
			tower:repair(structure)
			return getTowerEnemy(tower) ~= nil or structure.hits >= structure.hitsMax
		end,
		shouldStart = function(tower)
			return tower.store["energy"] >= 10 and getTowerRepair(tower) ~= nil
		end,
		getPriority = function(tower)
			local structure = getTowerRepair(tower)
			return 65 * (1 - structure.hits / structure.hitsMax) / math.max(tower.pos:getRangeTo(structure)*DISTANCE_WEIGHT, 1)
		end,
	},
}


return function(tower)
	local currentTask = tasks[tower.memory.task]

	if currentTask == nil then
		local availableTasks = {}
		local sumWeight = 0
		for name, task in pairs(tasks) do
			if task.shouldStart(tower) then
				local priority = task.getPriority(tower)
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
					print(("- Task priorities for tower @ %.0f, %.0f -"):format(tower.pos.x, tower.pos.y))
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
				tower.memory.task = taskInfo[1]
				currentTask = taskInfo[2]
			else
				print_error("Weighted random returned nil!?")
				return
			end
		end
	end
	if currentTask == nil then
		-- print_warn("Tower " .. tostring(tower) .. " has no task to do!")
		return
	end
	if currentTask.update(tower) then
		tower.memory.task = nil
	end
end
