-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/portal.png"/></p> <p>A non-player structure. Instantly teleports your creeps to a distant room acting as a room exit tile. Portals appear randomly in the central room of each sector.</p> <p></p> <table class="table gameplay-info"><tbody><tr><td><strong>Stable time</strong></td><td>10 days</td></tr><tr><td><strong>Decay time</strong></td><td>30,000 ticks</td></tr></tbody></table>
---@class StructurePortal
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
--- <p>If this is an <strong>inter-room</strong> portal, then this property contains a <code>RoomPosition</code> object leading to the point in the destination room.</p> <p>If this is an <strong>inter-shard</strong> portal, then this property contains an object with <code>shard</code> and <code>room</code> string properties.Exact coordinates are undetermined, the creep will appear at any free spot in the destination room.</p>
---@field destination RoomPosition|table
--- <p>The amount of game ticks when the portal disappears, or undefined when the portal is stable.</p>
---@field ticksToDecay number
--- <p>Destroy this structure immediately.</p>
---@field destroy fun(self:StructurePortal)
--- <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun(self:StructurePortal)
--- <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:StructurePortal,enabled:boolean)
local StructurePortal = {}
