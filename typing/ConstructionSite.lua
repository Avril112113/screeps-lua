-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>A site of a structure which is currently under construction. A construction site can be created using the 'Construct' button at the left of the game field or the <a href="https://docs.screeps.com/api/#Room.createConstructionSite"><code>Room.createConstructionSite</code></a> method.</p> <p>To build a structure on the construction site, give a worker creep some amount of energy and perform <a href="https://docs.screeps.com/api/#Creep.build"><code>Creep.build</code></a> action.</p> <p>You can remove enemy construction sites by moving a creep on it.</p>
---@class ConstructionSite
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>Whether this is your own construction site.</p>
---@field my boolean
--- <p>The current construction progress.</p>
---@field progress number
--- <p>The total construction progress needed for the structure to be built.</p>
---@field progressTotal number
--- <p>One of the <code>STRUCTURE_*</code> constants.</p>
---@field structureType string
--- <p>Remove the construction site.</p>
---@field remove fun()
---@field owner ConstructionSite.owner
local ConstructionSite = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class ConstructionSite.owner
local owner = {}
