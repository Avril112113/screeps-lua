-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>A flag. Flags can be used to mark particular spots in a room. Flags are visible to their owners only. You cannot have more than 10,000 flags.</p>
---@class Flag
--- <p>Applied effects, an array of objects with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>effect</code></td><td>number</td><td><p>Effect ID of the applied effect. Can be either natural effect ID or Power ID.</p></td></tr><tr><td><code>level</code><br/><em>optional</em></td><td>number </td><td><p>Power level of the applied effect. Absent if the effect is not a Power effect.</p></td></tr><tr><td><code>ticksRemaining</code></td><td>number</td><td><p>How many ticks will the effect last.</p></td></tr></tbody></table>
---@field effects any[]
--- <p>An object representing the position of this object in the room.</p>
---@field pos RoomPosition
--- <p>The link to the Room object. May be undefined in case if an object is a flag or a construction site and is placed in a room that is not visible to you.</p>
---@field room Room
--- <p>Flag primary color. One of the <code>COLOR_*</code> constants.</p>
---@field color number
--- <p>A shorthand to <code>Memory.flags[flag.name]</code>. You can use it for quick access the flag's specific memory data object.</p>
---@field memory any
--- <p>Flag’s name. You can choose the name while creating a new flag, and it cannot be changed later. This name is a hash key to access the flag via the <a href="https://docs.screeps.com/api/#Game.flags">Game.flags</a> object. The maximum name length is 100 charactes.</p>
---@field name string
--- <p>Flag secondary color. One of the <code>COLOR_*</code> constants.</p>
---@field secondaryColor number
--- <p>Remove the flag.</p>
---@field remove fun()
--- <p>Set new color of the flag.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>color</code></td><td>string</td><td><p>Primary color of the flag. One of the <code>COLOR_*</code> constants.</p></td></tr><tr><td><code>secondaryColor</code><br/><em>optional</em></td><td>string</td><td><p>Secondary color of the flag. One of the <code>COLOR_*</code> constants.</p></td></tr></tbody></table>
---@field setColor fun(color:any,secondaryColor:any?)
--- <p>Set new position of the flag.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>x</code></td><td>number</td><td><p>The X position in the room.</p></td></tr><tr><td><code>y</code></td><td>number</td><td><p>The Y position in the room.</p></td></tr><tr><td><code>pos</code></td><td>object</td><td><p>Can be a <a href="https://docs.screeps.com/api/#RoomPosition">RoomPosition</a> object or any object containing <a href="https://docs.screeps.com/api/#RoomPosition">RoomPosition</a>.</p></td></tr></tbody></table>
---@field setPosition fun(x:any,y:any)|fun(pos:any)
local Flag = {}
