-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" alt="" src="./Screeps Documentation_files/deposit.png"/></p> <p>A rare resource deposit needed for producing commodities. Can be harvested by creeps with a <code>WORK</code> body part. Each harvest operation triggers a cooldown period, which becomes longer and longer over time.</p> <p>Learn more about deposits from <a href="https://docs.screeps.com/resources.html">this article</a>. </p> <table class="table gameplay-info"><tbody><tr><td><strong>Cooldown</strong></td><td><code>0.001 * totalHarvested ^ 1.2</code></td><td></td></tr><tr><td><strong>Decay</strong></td><td>50,000 ticks after appearing or last harvest operation</td></tr></tbody></table>
---@class Deposit
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>The amount of game ticks until the next harvest action is possible.</p>
---@field cooldown number
--- <p>The deposit type, one of the following constants:</p>
---@field depositType string
--- <p>A unique object identificator. You can use <a href="https://docs.screeps.com/api/#Game.getObjectById"><code>Game.getObjectById</code></a> method to retrieve an object instance by its <code>id</code>.</p>
---@field id string
--- <p>The cooldown of the last harvest operation on this deposit.</p>
---@field lastCooldown number
--- <p>The amount of game ticks when this deposit will disappear.</p>
---@field ticksToDecay number
local Deposit = {}
