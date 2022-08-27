-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>A mineral deposit. Can be harvested by creeps with a <code>WORK</code> body part using the extractor structure. Learn more about minerals from <a href="https://docs.screeps.com/resources.html">this article</a>.</p> <table class="table gameplay-info"><tbody><tr><td><strong>Regeneration amount</strong></td><td><code>DENSITY_LOW</code>: 15,000 <br/> <code>DENSITY_MODERATE</code>: 35,000<br/> <code>DENSITY_HIGH</code>: 70,000 <br/> <code>DENSITY_ULTRA</code>: 100,000</td></tr><tr><td><strong>Regeneration time</strong></td><td>50,000 ticks</td></tr><tr><td><strong>Density change probability</strong></td><td><code>DENSITY_LOW</code>: 100% chance <br/> <code>DENSITY_MODERATE</code>: 5% chance<br/> <code>DENSITY_HIGH</code>: 5% chance <br/> <code>DENSITY_ULTRA</code>: 100% chance</td></tr></tbody></table>
---@class Mineral
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>The density that this mineral deposit will be refilled to once <code>ticksToRegeneration</code> reaches 0. This is one of the <code>DENSITY_*</code> constants.</p>
---@field density number
--- <p>The remaining amount of resources.</p>
---@field mineralAmount number
--- <p>The resource type, one of the <code>RESOURCE_*</code> constants.</p>
---@field mineralType string
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>The remaining time after which the deposit will be refilled.</p>
---@field ticksToRegeneration number
local Mineral = {}
