-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p> Contains powerful methods for pathfinding in the game world. This module is written in fast native C++ code and supports custom navigation costs and paths which span multiple rooms. </p>
---@class PathFinder
--- <p>Find an optimal path between <code>origin</code> and <code>goal</code>.</p>
---@field search fun(self:PathFinder,origin:RoomPosition,goal:table,opts:any?)
--- <div class="api-deprecated"><p>This method is deprecated and will be removed soon.</p></div> <p>Specify whether to use this new experimental pathfinder in game objects methods. This method should be invoked every tick. It affects the following methods behavior: <a href="https://docs.screeps.com/api/#Room.findPath"><code>Room.findPath</code></a>, <a href="https://docs.screeps.com/api/#RoomPosition.findPathTo"><code>RoomPosition.findPathTo</code></a>, <a href="https://docs.screeps.com/api/#RoomPosition.findClosestByPath"><code>RoomPosition.findClosestByPath</code></a>, <a href="https://docs.screeps.com/api/#Creep.moveTo"><code>Creep.moveTo</code></a>.</p>
---@field use fun(self:PathFinder,isEnabled:boolean)
---@field CostMatrix PathFinder.CostMatrix
local PathFinder = {}

--- <p>Container for custom navigation cost data. By default <code>PathFinder</code> will only consider terrain data (plain, swamp, wall) — if you need to route around obstacles such as buildings or creeps you must put them into a <code>CostMatrix</code>. Generally you will create your <code>CostMatrix</code> from within <code>roomCallback</code>. If a non-0 value is found in a room's CostMatrix then that value  will be used instead of the default terrain cost. You should avoid using large values in your  CostMatrix and terrain cost flags. For example, running <code>PathFinder.search</code> with  <code>{ plainCost: 1, swampCost: 5 }</code> is faster than running it with <code>{plainCost: 2, swampCost: 10 }</code>  even though your paths will be the same.</p>
---@class PathFinder.CostMatrix
--- <p>Set the cost of a position in this CostMatrix.</p>
---@field set fun(self:PathFinder.CostMatrix,x:number,y:number,cost:number)
--- <p>Get the cost of a position in this CostMatrix.</p>
---@field get fun(self:PathFinder.CostMatrix,x:number,y:number)
--- <p>Copy this CostMatrix into a new CostMatrix with the same data.</p>
---@field clone fun(self:PathFinder.CostMatrix)
--- <p>Returns a compact representation of this CostMatrix which can be stored via <code>JSON.stringify</code>.</p>
---@field serialize fun(self:PathFinder.CostMatrix)
--- <p>Static method which deserializes a new CostMatrix using the return value of <code>serialize</code>.</p>
---@field deserialize fun(self:PathFinder.CostMatrix,val:table)
local CostMatrix = {}
