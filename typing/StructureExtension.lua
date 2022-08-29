-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/spawn.png"/></p> <p>Contains energy which can be spent on spawning bigger creeps. Extensions can be placed anywhere in the room, any spawns will be able to use them regardless of distance.</p> <table class="table gameplay-info"><tbody><tr><td colspan="2"><strong>Controller level</strong></td></tr><tr><td>1</td><td>—</td></tr><tr><td>2</td><td>5 extensions (50 capacity)</td></tr><tr><td>3</td><td>10 extensions (50 capacity)</td></tr><tr><td>4</td><td>20 extensions (50 capacity)</td></tr><tr><td>5</td><td>30 extensions (50 capacity)</td></tr><tr><td>6</td><td>40 extensions (50 capacity)</td></tr><tr><td>7</td><td>50 extensions (100 capacity)</td></tr><tr><td>8</td><td>60 extensions (200 capacity)</td></tr><tr><td><strong>Cost</strong></td><td>3,000</td></tr><tr><td><strong>Hits</strong></td><td>1,000</td></tr></tbody></table>
---@class StructureExtension
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
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Store.getCapacity"><code>.store.getCapacity(RESOURCE_ENERGY)</code></a>.</p> <p>The total amount of energy the extension can contain.</p>
---@field energyCapacity number
--- <p>A <a href="https://docs.screeps.com/api/#Store"><code>Store</code></a> object that contains cargo of this structure.</p>
---@field store Store
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureExtension.destroy"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">destroy</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Destroy this structure immediately.</p>
---@field destroy fun(self:StructureExtension)
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureExtension.isActive"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">isActive</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--2" title="This method has medium CPU cost."></div></h2> <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun(self:StructureExtension)
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureExtension.notifyWhenAttacked"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">notifyWhenAttacked</span><span class="api-property__args">(enabled)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:StructureExtension,enabled:boolean)
---@field owner StructureExtension.owner
local StructureExtension = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class StructureExtension.owner
local owner = {}
