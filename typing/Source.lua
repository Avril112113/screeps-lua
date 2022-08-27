-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>An energy source object. Can be harvested by creeps with a <code>WORK</code> body part.</p> <table class="table gameplay-info"><tbody><tr><td><strong>Energy amount</strong></td><td>4000 in center rooms<br/>3000 in an owned or reserved room<br/>1500 in an unreserved room</td></tr><tr><td><strong>Energy regeneration</strong></td><td>Every 300 game ticks</td></tr></tbody></table>
---@class Source
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>The remaining amount of energy.</p>
---@field energy number
--- <p>The total amount of energy in the source.</p>
---@field energyCapacity number
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>The remaining time after which the source will be refilled.</p>
---@field ticksToRegeneration number
local Source = {}
