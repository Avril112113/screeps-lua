-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/rampart.png"/></p> <p>Blocks movement of hostile creeps, and defends your creeps and structures on the same tile. Can be used as a controllable gate.</p> <table class="table gameplay-info"><tbody><tr><td colspan="2"><strong>Controller level</strong></td></tr><tr><td>1</td><td>—</td></tr><tr><td>2</td><td>300,000 max hits</td></tr><tr><td>3</td><td>1,000,000 max hits</td></tr><tr><td>4</td><td>3,000,000 max hits</td></tr><tr><td>5</td><td>10,000,000 max hits</td></tr><tr><td>6</td><td>30,000,000 max hits</td></tr><tr><td>7</td><td>100,000,000 max hits</td></tr><tr><td>8</td><td>300,000,000 max hits</td></tr><tr><td><strong>Cost</strong></td><td>1</td></tr><tr><td><strong>Hits when constructed</strong></td><td>1</td></tr><tr><td><strong>Decay</strong></td><td>Loses 300 hits every 100 ticks</td></tr></tbody></table>
---@class StructureRampart
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
--- <p>If false (default), only your creeps can step on the same square. If true, any hostile creeps can pass through.</p>
---@field isPublic boolean
--- <p>The amount of game ticks when this rampart will lose some hit points.</p>
---@field ticksToDecay number
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureRampart.destroy"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">destroy</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Destroy this structure immediately.</p>
---@field destroy fun(self:StructureRampart)
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureRampart.isActive"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">isActive</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--2" title="This method has medium CPU cost."></div></h2> <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun(self:StructureRampart)
--- <h2 class="api-property api-property--method api-property--inherited" id="StructureRampart.notifyWhenAttacked"><div class="api-property__inherited">Inherited from <a href="https://docs.screeps.com/api/#Structure">Structure</a></div><span class="api-property__name">notifyWhenAttacked</span><span class="api-property__args">(enabled)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:StructureRampart,enabled:boolean)
--- <h2 class="api-property api-property--method" id="StructureRampart.setPublic"><span class="api-property__name">setPublic</span><span class="api-property__args">(isPublic)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Make this rampart public to allow other players' creeps to pass through.</p>
---@field setPublic fun(self:StructureRampart,isPublic:boolean)
---@field owner StructureRampart.owner
local StructureRampart = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class StructureRampart.owner
local owner = {}
