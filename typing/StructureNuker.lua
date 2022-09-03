-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/nuke.png"/></p> <p>Launches a nuke to another room dealing huge damage to the landing area. Each launch has a cooldown and requires energy and ghodium resources. Launching creates a <a href="https://docs.screeps.com/api/#Nuke">Nuke</a> object at the target room position which is visible to any player until it is landed. Incoming nuke cannot be moved or cancelled. Nukes cannot be launched from or to novice rooms. Resources placed into a StructureNuker cannot be withdrawn.</p> <table class="table gameplay-info"><tbody><tr><td colspan="2"><strong>Controller level</strong></td></tr><tr><td>1-7</td><td>—</td></tr><tr><td>8</td><td>1 nuke</td></tr><tr><td><strong>Cost</strong></td><td>100,000</td></tr><tr><td><strong>Hits</strong></td><td>1,000</td></tr><tr><td><strong>Range</strong></td><td>10 rooms</td></tr><tr><td><strong>Launch cost</strong></td><td>300,000 energy<br/> 5,000 ghodium</td></tr><tr><td><strong>Launch cooldown</strong></td><td>100,000 ticks</td></tr><tr><td><strong>Landing time</strong></td><td>50,000 ticks</td></tr><tr><td><strong>Effect</strong></td><td>All creeps, construction sites and dropped resources in the room are removed immediately, even inside ramparts. Damage to structures:            <ul><li>10,000,000 hits at the landing position;</li><li>5,000,000 hits to all structures in 5x5 area.</li></ul><p>Note that you can stack multiple nukes from different rooms at the same target position to increase damage.</p><p>Nuke landing does not generate tombstones and ruins, and destroys all existing tombstones and ruins in the room</p><p>If the room is in safe mode, then the safe mode is cancelled immediately, and the safe mode cooldown is reset to 0.</p><p>The room controller is hit by triggering <code>upgradeBlocked</code> period, which means it is unavailable to activate safe mode again within the next 200 ticks.</p></td></tr></tbody></table>
---@class StructureNuker
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
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#StructureExtension.store"><code>.store[RESOURCE_ENERGY]</code></a>.</p>
---@field energy number
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Store.getCapacity"><code>.store.getCapacity(RESOURCE_ENERGY)</code></a>.</p>
---@field energyCapacity number
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#StructureExtension.store"><code>.store[RESOURCE_GHODIUM]</code></a>.</p>
---@field ghodium number
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Store.getCapacity"><code>.store.getCapacity(RESOURCE_GHODIUM)</code></a>.</p>
---@field ghodiumCapacity number
--- <p>The amount of game ticks until the next launch is possible.</p>
---@field cooldown number
--- <p>A <a href="https://docs.screeps.com/api/#Store"><code>Store</code></a> object that contains cargo of this structure.</p>
---@field store Store
--- <p>Destroy this structure immediately.</p>
---@field destroy fun(self:StructureNuker):(OK|ERR_NOT_OWNER|ERR_BUSY)
--- <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun(self:StructureNuker)
--- <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:StructureNuker,enabled:boolean):(OK|ERR_NOT_OWNER|ERR_INVALID_ARGS)
--- <p>Launch a nuke to the specified position.</p>
---@field launchNuke fun(self:StructureNuker,pos:RoomPosition):(OK|ERR_NOT_OWNER|ERR_NOT_ENOUGH_RESOURCES|ERR_INVALID_TARGET|ERR_NOT_IN_RANGE|ERR_INVALID_ARGS|ERR_TIRED|ERR_RCL_NOT_ENOUGH)
---@field owner StructureNuker.owner
local StructureNuker = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class StructureNuker.owner
local owner = {}
