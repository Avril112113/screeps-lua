-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>Power Creeps are immortal "heroes" that are tied to your account and can be respawned in any <code>PowerSpawn</code> after death.You can upgrade their abilities ("powers") up to your account Global Power Level (see <a href="https://docs.screeps.com/api/#Game.gpl"><code>Game.gpl</code></a>).</p> <br/> <table class="table gameplay-info"><tbody><tr><td><strong>Time to live</strong></td><td>5,000</td></tr><tr><td><strong>Hits</strong></td><td>1,000 per level</td></tr><tr><td><strong>Capacity</strong></td><td>100 per level</td></tr> </tbody></table> <p><a href="https://docs.screeps.com/power.html#Powers">Full list of available powers</a></p>
---@class PowerCreep
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Store.getCapacity"><code>Creep.store.getCapacity()</code></a>.</p>
---@field carryCapacity number
--- <p>The power creep's class, one of the <code>POWER_CLASS</code> constants.</p>
---@field className string
--- <p>A timestamp when this creep is marked to be permanently deleted from the account, or undefined otherwise.</p>
---@field deleteTime number
--- <p>The current amount of hit points of the creep.</p>
---@field hits number
--- <p>The maximum amount of hit points of the creep.</p>
---@field hitsMax number
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>The power creep's level.</p>
---@field level number
--- <p>A shorthand to <code>Memory.powerCreeps[creep.name]</code>. You can use it for quick access the creep’s specific memory data object. <a href="https://docs.screeps.com/global-objects.html#Memory-object">Learn more about memory</a></p>
---@field memory any
--- <p>Whether it is your creep or foe.</p>
---@field my boolean
--- <p>Power creep’s name. You can choose the name while creating a new power creep, and it cannot be changed later. This name is a hash key to access the creep via the <a href="https://docs.screeps.com/api/#Game.powerCreeps">Game.powerCreeps</a> object.</p>
---@field name string
--- <p>A <a href="https://docs.screeps.com/api/#Store"><code>Store</code></a> object that contains cargo of this creep.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>The name of the owner user.</p></td></tr></tbody></table>
---@field store Store
--- <p>The text message that the creep was saying at the last tick.</p>
---@field saying string
--- <p>The name of the shard where the power creep is spawned, or undefined.</p>
---@field shard string
--- <p>The timestamp when spawning or deleting this creep will become available. Undefined if the power creep is spawned in the world.</p>
---@field spawnCooldownTime number
--- <p>The remaining amount of game ticks after which the creep will die and become unspawned. Undefined if the creepis not spawned in the world. </p>
---@field ticksToLive number
--- <p>A static method to create new Power Creep instance in your account. It will be added in an unspawned state, use <a href="https://docs.screeps.com/api/#PowerCreep.spawn"><code>spawn</code></a> method to spawn it in the world.</p> <p>You need one free Power Level in your account to perform this action.</p>
---@field create fun(self:PowerCreep,name:string,className:string)
--- <p>Cancel the order given during the current game tick.</p>
---@field cancelOrder fun(self:PowerCreep,methodName:string)
--- <p>Delete the power creep permanently from your account. It should NOT be spawned in the world. The creep is not deletedimmediately, but a 24-hours delete timer is started instead (see <a href="https://docs.screeps.com/api/#PowerCreep.deleteTime"><code>deleteTime</code></a>). You can cancel deletion by calling <code>delete(true)</code>.</p>
---@field delete fun(self:PowerCreep,cancel:boolean?)
--- <p>Drop this resource on the ground.</p>
---@field drop fun(self:PowerCreep,resourceType:string,amount:any?)
--- <p>Enable powers usage in this room. The room controller should be at adjacent tile.</p>
---@field enableRoom fun(self:PowerCreep,controller:StructureController)
--- <p>Move the creep one square in the specified direction.  </p>
---@field move fun(self:PowerCreep,direction:Creep|number)
--- <p>Move the creep using the specified predefined path. </p>
---@field moveByPath fun(self:PowerCreep,path:any[]|string)
--- <p>Find the optimal path to the target within the same room and move to it. A shorthand to consequent calls of <a href="https://docs.screeps.com/api/#RoomPosition.findPathTo">pos.findPathTo()</a> and <a href="https://docs.screeps.com/api/#Creep.move">move()</a> methods. If the target is in another room, then the corresponding exit will be used as a target. </p>
---@field moveTo fun(self:PowerCreep,x:number,y:number,opts:any?)|fun(self:PowerCreep,target:table,opts:any?)
--- <p>Toggle auto notification when the creep is under attack. The notification will be sent to your account email. Turned on by default.</p>
---@field notifyWhenAttacked fun(self:PowerCreep,enabled:boolean)
--- <p>Pick up an item (a dropped piece of energy). The target has to be at adjacent square to the creep or at the same square.</p>
---@field pickup fun(self:PowerCreep,target:Resource)
--- <p>Rename the power creep. It must not be spawned in the world.</p>
---@field rename fun(self:PowerCreep,name:string)
--- <p>Instantly restore time to live to the maximum using a Power Spawn or a Power Bank nearby. It has to be at adjacent tile. </p>
---@field renew fun(self:PowerCreep,target:StructurePowerBank|StructurePowerSpawn)
--- <p>Display a visual speech balloon above the creep with the specified message. The message will be available for one tick. You can read the last message using the <code>saying</code> property. Any valid Unicode characters are allowed, including <a href="http://unicode.org/emoji/charts/emoji-style.txt" target="_blank">emoji</a>.</p>
---@field say fun(self:PowerCreep,message:string,public:any?)
--- <p>Spawn this power creep in the specified Power Spawn.</p>
---@field spawn fun(self:PowerCreep,powerSpawn:StructurePowerSpawn)
--- <p>Kill the power creep immediately. It will not be destroyed permanently, but will become unspawned,so that you can <a href="https://docs.screeps.com/api/#PowerCreep.spawn"><code>spawn</code></a> it again.</p>
---@field suicide fun(self:PowerCreep)
--- <p>Transfer resource from the creep to another object. The target has to be at adjacent square to the creep.</p>
---@field transfer fun(self:PowerCreep,target:Creep|Structure,resourceType:string,amount:any?)
--- <p>Upgrade the creep, adding a new power ability to it or increasing level of the existing power. You need one free Power Level in your account to perform this action. </p>
---@field upgrade fun(self:PowerCreep,power:number)
--- <p>Apply one the creep's powers on the specified target. You can only use powers in rooms either without a controller, or with a <a href="https://docs.screeps.com/api/#PowerCreep.enableRoom">power-enabled</a> controller.Only one power can be used during the same tick, each <code>usePower</code> call will override the previous one.If the target has the same effect of a lower or equal level, it is overridden. If the existing effect level is higher, an error is returned.</p> <p><a href="https://docs.screeps.com/power.html#Powers">Full list of available powers</a> </p>
---@field usePower fun(self:PowerCreep,power:number,target:RoomObject?)
--- <p>Withdraw resources from a structure or tombstone. The target has to be at adjacent square to the creep. Multiple creeps can withdraw from the same object in the same tick. Your creeps can withdraw resources from hostile structures/tombstones as well, in case if there is no hostile rampart on top of it.</p> <p>This method should not be used to transfer resources between creeps. To transfer between creeps, use the <a href="https://docs.screeps.com/api/#Creep.transfer"><code>transfer</code></a> method on the original creep.</p>
---@field withdraw fun(self:PowerCreep,target:Structure|Tombstone,resourceType:string,amount:any?)
---@field carry PowerCreep.carry
---@field owner PowerCreep.owner
---@field powers PowerCreep.powers
local PowerCreep = {}

--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon.</p></div> <p>An alias for <a href="https://docs.screeps.com/api/#Creep.store"><code>Creep.store</code></a>. </p>
---@class PowerCreep.carry
local carry = {}

--- <p>An object with the creep’s owner info containing the following properties:</p>
---@class PowerCreep.owner
local owner = {}

--- <p>Available powers, an object with power ID as a key, and the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>level</code></td><td>number</td><td><p>Current level of the power.</p></td></tr><tr><td><code>cooldown</code></td><td>number</td><td><p>Cooldown ticks remaining, or undefined if the power creep is not spawned in the world.</p></td></tr></tbody></table>
---@class PowerCreep.powers
local powers = {}