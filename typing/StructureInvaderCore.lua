-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/invaderCore.png"/></p> <p>This NPC structure is a control center of NPC Strongholds, and also rules all invaders in the sector. It spawns NPC defenders of the stronghold, refill towers, repairs structures. While it's alive, it will spawn invaders in all rooms in the same sector. It also contains some valuable resources inside, which you can loot from its ruin if you destroy the structure.</p> <p>An Invader Core has two lifetime stages: deploy stage and active stage. When it appears in a random room in the sector, it has <code>ticksToDeploy</code> property,public ramparts around it, and doesn't perform any actions. While in this stage it's invulnerable to attacks (has <code>EFFECT_INVULNERABILITY</code> enabled). When the <code>ticksToDeploy</code> timer is over, it spawns structures around it and startsspawning creeps, becomes vulnerable, and receives <code>EFFECT_COLLAPSE_TIMER</code> which will remove the stronghold when this timer is over.  </p> <p>An active Invader Core spawns level-0 Invader Cores in neutral neighbor rooms inside the sector. These lesser Invader Cores are spawnednear the room controller and don't perform any activity except reserving/attacking the controller. One Invader Core can spawn up to 42 lesser Coresduring its lifetime. </p> <table class="table gameplay-info"><tbody><tr><td><strong>Hits</strong></td><td>100,000</td></tr><tr><td><strong>Deploy time</strong></td><td>5,000 ticks</td></tr><tr><td><strong>Active time</strong></td><td>75,000 ticks with 10% random variation</td></tr><tr><td><strong>Lesser cores spawn interval</strong></td><td><b>Stronghold level 1</b>: 4000 ticks<br/><b>Stronghold level 2</b>: 3500 ticks<br/><b>Stronghold level 3</b>: 3000 ticks<br/><b>Stronghold level 4</b>: 2500 ticks<br/><b>Stronghold level 5</b>: 2000 ticks<br/></td></tr></tbody></table>
---@class StructureInvaderCore
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
--- <p>The level of the stronghold. The amount and quality of the loot depends on the level.</p>
---@field level number
--- <p>Shows the timer for a ot yet deployed stronghold, undefined otherwise. </p>
---@field ticksToDeploy number
--- <p>If the core is in process of spawning a new creep, this object will contain a <a href="https://docs.screeps.com/api/#StructureSpawn-Spawning"><code>StructureSpawn.Spawning</code></a> object, or null otherwise.</p>
---@field spawning StructureSpawn.Spawning
--- <p>Destroy this structure immediately.</p>
---@field destroy fun()
--- <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun()
--- <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>enabled</code></td><td>boolean</td><td><p>Whether to enable notification or disable.</p></td></tr></tbody></table>
---@field notifyWhenAttacked fun(enabled:any)
---@field owner StructureInvaderCore.owner
local StructureInvaderCore = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class StructureInvaderCore.owner
local owner = {}
