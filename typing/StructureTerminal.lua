-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/terminal.png"/></p> <p>Sends any resources to a Terminal in another room. The destination Terminal can belong to any player. Each transaction requires additional energy (regardless of the transfer resource type) that can be calculated using <a href="https://docs.screeps.com/api/#Game.market.calcTransactionCost"><code>Game.market.calcTransactionCost</code></a> method. For example, sending 1000 mineral units from W0N0 to W10N5 will consume 742 energy units. You can track your incoming and outgoing transactions using the <a href="https://docs.screeps.com/api/#Game.market"><code>Game.market</code></a> object. Only one Terminal per room is allowed that can be addressed by <a href="https://docs.screeps.com/api/#Room.terminal"><code>Room.terminal</code></a> property.</p> <p>Terminals are used in the <a href="https://docs.screeps.com/market.html">Market system</a>.</p> <table class="table gameplay-info"><tbody><tr><td colspan="2"><strong>Controller level</strong></td></tr><tr><td>1-5</td><td>—</td></tr><tr><td>6-8</td><td>1 terminal</td></tr><tr><td><strong>Cost</strong></td><td>100,000</td></tr><tr><td><strong>Hits</strong></td><td>3,000</td></tr><tr><td><strong>Capacity</strong></td><td>300,000</td></tr><tr><td><strong>Cooldown on send</strong></td><td>10 ticks</td></tr></tbody></table>
---@class StructureTerminal
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
--- <p>The remaining amount of ticks while this terminal cannot be used to make <a href="https://docs.screeps.com/api/#StructureTerminal.send"><code>StructureTerminal.send</code></a> or <a href="https://docs.screeps.com/api/#Game.market.deal"><code>Game.market.deal</code></a> calls.</p>
---@field cooldown number
--- <p>A <a href="https://docs.screeps.com/api/#Store"><code>Store</code></a> object that contains cargo of this structure.</p>
---@field store Store
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Store.getCapacity"><code>.store.getCapacity()</code></a>.</p>
---@field storeCapacity number
--- <p>Destroy this structure immediately.</p>
---@field destroy fun()
--- <p>Check whether this structure can be used. If room controller level is insufficient, then this method will return false, and the structure will be highlighted with red in the game.</p>
---@field isActive fun()
--- <p>Toggle auto notification when the structure is under attack. The notification will be sent to your account email. Turned on by default.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>enabled</code></td><td>boolean</td><td><p>Whether to enable notification or disable.</p></td></tr></tbody></table>
---@field notifyWhenAttacked fun(enabled:any)
--- <p>Sends resource to a Terminal in another room with the specified name.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>resourceType</code></td><td>string</td><td><p>One of the <code>RESOURCE_*</code> constants.</p></td></tr><tr><td><code>amount</code></td><td>number</td><td><p>The amount of resources to be sent.</p></td></tr><tr><td><code>destination</code></td><td>string</td><td><p>The name of the target room. You don't have to gain visibility in this room.</p></td></tr><tr><td><code>description</code><br/><em>optional</em></td><td>string</td><td><p>The description of the transaction. It is visible to the recipient. The maximum length is 100 characters.</p></td></tr></tbody></table>
---@field send fun(resourceType:any,amount:any,destination:any,description:any?)
---@field owner StructureTerminal.owner
local StructureTerminal = {}

--- <p>An object with the structure’s owner info containing the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@class StructureTerminal.owner
local owner = {}
