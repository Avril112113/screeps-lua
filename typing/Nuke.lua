-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>A nuke landing position. This object cannot be removed or modified. You can find incoming nukes in the room using the <code>FIND_NUKES</code> constant.</p> <table class="table gameplay-info"><tbody><tr><td><strong>Landing time</strong></td><td>50,000 ticks</td></tr><tr><td><strong>Effect</strong></td><td>All creeps, construction sites and dropped resources in the room are removed immediately, even inside ramparts. Damage to structures:            <ul><li>10,000,000 hits at the landing position;</li><li>5,000,000 hits to all structures in 5x5 area.</li></ul><p>Note that you can stack multiple nukes from different rooms at the same target position to increase damage.</p><p>Nuke landing does not generate tombstones and ruins, and destroys all existing tombstones and ruins in the room</p><p>If the room is in safe mode, then the safe mode is cancelled immediately, and the safe mode cooldown is reset to 0.</p><p>The room controller is hit by triggering <code>upgradeBlocked</code> period, which means it is unavailable to activate safe mode again within the next 200 ticks.</p></td></tr></tbody></table>
---@class Nuke
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>The name of the room where this nuke has been launched from.</p>
---@field launchRoomName string
--- <p>The remaining landing time.</p>
---@field timeToLand number
local Nuke = {}
