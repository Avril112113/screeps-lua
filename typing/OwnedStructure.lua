-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>The base prototype for a structure that has an owner. Such structures can be found using <code>FIND_MY_STRUCTURES</code> and <code>FIND_HOSTILE_STRUCTURES</code> constants.</p>
---@class OwnedStructure
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>The current amount of hit points of the structure.</p>
---@field hits number
--- <p>The total amount of hit points of the structure.</p>
---@field hitsMax number
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>One of the <code>STRUCTURE_*</code> constants.</p>
---@field structureType string
--- <p>Whether this is your own structure.</p>
---@field my boolean
--- ![A](imgs/cpu_A.png) - Additional 0.2 CPU if OK is returned.
--- <p>Destroy this structure immediately.</p>
---@field destroy fun(self:OwnedStructure):(OK|ERR_NOT_OWNER|ERR_BUSY)
--- ![2](imgs/cpu_2.png) - Medium CPU cost.
--- <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun(self:OwnedStructure)
--- ![A](imgs/cpu_A.png) - Additional 0.2 CPU if OK is returned.
--- <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:OwnedStructure,enabled:boolean):(OK|ERR_NOT_OWNER|ERR_INVALID_ARGS)
---@field owner OwnedStructure.owner
local OwnedStructure = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class OwnedStructure.owner
local owner = {}
