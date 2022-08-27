-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/ruin.png"/></p> <p>A destroyed structure. This is a walkable object. </p> <table class="table gameplay-info"><tbody><tr><td><strong>Decay</strong></td><td>500 ticks except some special cases</td></tr></tbody></table>
---@class Ruin
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>The time when the structure has been destroyed. </p>
---@field destroyTime number
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>A <a href="https://docs.screeps.com/api/#Store"><code>Store</code></a> object that contains resources of this structure.</p>
---@field store Store
--- <p>An object containing basic data of the destroyed structure.</p>
---@field structure Structure|OwnedStructure
--- <p>The amount of game ticks before this ruin decays.</p>
---@field ticksToDecay number
local Ruin = {}
