-- From: https://github.com/kennyledet/Algorithm-Implementations/blob/master/Weighted_Random_Distribution/Lua/Yonaba/weighted_random.lua
-- items   : an array-list of values
-- weights : a map table holding the weight for each value in
--  in the `items` list.
-- returns : an iterator function
-- function math.expandingRandom(items, weights)
-- 	local list = {}
-- 	for _, item in ipairs(items) do
-- 		local n = weights[item] * 100
-- 		for i = 1, n do table.insert(list, item) end
-- 	end
-- 	return function()
-- 		return list[math.random(1, #list)]
-- 	end
-- end

-- From: https://github.com/kennyledet/Algorithm-Implementations/blob/master/Weighted_Random_Distribution/Lua/Yonaba/weighted_random.lua
-- items   : an array-list of values
-- weights : a map table holding the weight for each value in
--  in the `items` list.
-- returns : an iterator function
function math.inPlaceRandom(items, weights)
	local partial_sums, partial_sum = {}, 0
	for _, item in ipairs(items) do
		partial_sum = partial_sum + weights[item]
		table.insert(partial_sums, partial_sum)
	end
	return function()
		local n, s = math.random(), 0
		for i, si in ipairs(partial_sums) do
			s = s + si
			if si > n then return items[i] end
		end
	end
end
