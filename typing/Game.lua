-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>The main global game object containing all the game play information.</p>
---@class Game
--- <p>A hash containing all your construction sites with their id as hash keys.</p>
---@field constructionSites table<string,ConstructionSite>
--- <p>A hash containing all your creeps with creep names as hash keys.</p>
---@field creeps table<string,Creep>
--- <p>A hash containing all your flags with flag names as hash keys.</p>
---@field flags table<string,Flag>
--- <p>A hash containing all your power creeps with their names as hash keys. Even power creeps not spawned in the world can be accessed here. </p>
---@field powerCreeps table<string,PowerCreep>
--- <p>A hash containing all the rooms available to you with room names as hash keys. A room is visible if you have a creep or an owned structure in it.</p>
---@field rooms table<string,Room>
--- <p>A hash containing all your spawns with spawn names as hash keys.</p>
---@field spawns table<string,StructureSpawn>
--- <p>A hash containing all your structures with structure id as hash keys.</p>
---@field structures table<string,Structure>
--- <p>System game tick counter. It is automatically incremented on every tick. <a href="https://docs.screeps.com/game-loop.html">Learn more</a></p>
---@field time number
--- <h2 class="api-property api-property--method" id="Game.getObjectById"><span class="api-property__name">Game.getObjectById</span><span class="api-property__args">(id)</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Get an object with the specified unique ID. It may be a game object of any type. Only objects from the rooms which are visible to you can be accessed.</p>
---@field getObjectById fun(self:Game,id:string)
--- <h2 class="api-property api-property--method" id="Game.notify"><span class="api-property__name">Game.notify</span><span class="api-property__args">(message, [groupInterval])</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Send a custom message at your profile email. This way, you can set up notifications to yourself on any occasion within the game. You can schedule up to 20 notifications during one game tick. Not available in the Simulation Room.</p>
---@field notify fun(self:Game,message:string,groupInterval:number?)
---@field cpu Game.cpu
---@field gcl Game.gcl
---@field gpl Game.gpl
---@field map Game.map
---@field market Game.market
---@field resources Game.resources
---@field shard Game.shard
local Game = {}

--- <p>An object containing information about your CPU usage with the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>limit</code></td><td>number</td><td><p>Your assigned CPU limit for the current shard.</p></td></tr><tr><td><code>tickLimit</code></td><td>number</td><td><p>An amount of available CPU time at the current game tick.<br/>Usually it is higher than <code>Game.cpu.limit</code>. <a href="https://docs.screeps.com/cpu-limit.html">Learn more</a></p></td></tr><tr><td><code>bucket</code></td><td>number</td><td><p>An amount of unused CPU accumulated in your <a href="https://docs.screeps.com/cpu-limit.html#Bucket">bucket</a>.</p></td></tr><tr><td><code>shardLimits</code></td><td>object<br/>&lt;string,number&gt;</td><td><p>An object with limits for each shard with shard names as keys. You can use <a href="https://docs.screeps.com/api/#Game.setShardLimits"><code>setShardLimits</code></a>method to re-assign them.</p></td></tr><tr><td><code>unlocked</code></td><td>boolean </td><td><p>Whether full CPU is currently unlocked for your account.</p></td></tr><tr><td><code>unlockedTime</code></td><td>number </td><td><p>The time <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getTime#Syntax" rel="noopener" target="_blank">in milliseconds since UNIX epoch time</a> until full CPU is unlocked for your account. This property is not defined when full CPU is not unlocked for your account or it's unlocked with a subscription.</p></td></tr></tbody></table>
---@class Game.cpu
--- <h2 class="api-property api-property--method" id="Game.cpu.getHeapStatistics"><span class="api-property__name">Game.cpu.getHeapStatistics</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p><em>This method is only available when <strong>Virtual machine</strong> is set to <strong>Isolated</strong> in your <a href="https://screeps.com/a/#!/account/runtime" rel="noopener" target="_blank">account runtime settings</a>.</em> </p> <p>Use this method to get heap statistics for your virtual machine. The return value is almost identical to the Node.js function <a href="https://nodejs.org/dist/latest-v8.x/docs/api/v8.html#v8_v8_getheapstatistics" rel="noopener" target="_blank"><code>v8.getHeapStatistics()</code></a>. This function returns one additional property: <code>externally_allocated_size</code> which is the total amount of currently allocated memory which is not included in the v8 heap but counts against this isolate's memory limit. <code>ArrayBuffer</code> instances over a certain size are externally allocated and will be counted here.</p>
---@field getHeapStatistics fun(self:Game.cpu):({total_heap_size:integer,total_heap_size_executable:integer,total_physical_size:integer,total_available_size:integer,used_heap_size:integer,heap_size_limit:integer,malloced_memory:integer,peak_malloced_memory:integer,does_zap_garbage:integer,externally_allocated_size:integer})
--- <h2 class="api-property api-property--method" id="Game.cpu.getUsed"><span class="api-property__name">Game.cpu.getUsed</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Get amount of CPU time used from the beginning of the current game tick. Always returns 0 in the Simulation mode.</p>
---@field getUsed fun(self:Game.cpu)
--- <h2 class="api-property api-property--method" id="Game.cpu.halt"><span class="api-property__name">Game.cpu.halt</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p><em>This method is only available when <strong>Virtual machine</strong> is set to <strong>Isolated</strong> in your <a href="https://screeps.com/a/#!/account/runtime" rel="noopener" target="_blank">account runtime settings</a>.</em></p>
---@field halt fun(self:Game.cpu)
--- <h2 class="api-property api-property--method" id="Game.cpu.setShardLimits"><span class="api-property__name">Game.cpu.setShardLimits</span><span class="api-property__args">(limits)</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Allocate CPU limits to different shards. Total amount of CPU should remain equal to  <a href="https://docs.screeps.com/api/#Game.cpu"><code>Game.cpu.shardLimits</code></a>. This method can be used only once per 12 hours.</p>
---@field setShardLimits fun(self:Game.cpu,limits:table<string,number>)
--- <h2 class="api-property api-property--method" id="Game.cpu.unlock"><span class="api-property__name">Game.cpu.unlock</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Unlock full CPU for your account for additional 24 hours. This method will consume 1 CPU unlock bound to your account (See <a href="https://docs.screeps.com/api/#Game.resources"><code>Game.resources</code></a>).If full CPU is not currently unlocked for your account, it may take some time (up to 5 minutes) before unlock is applied to your account.</p>
---@field unlock fun(self:Game.cpu)
--- <h2 class="api-property api-property--method" id="Game.cpu.generatePixel"><span class="api-property__name">Game.cpu.generatePixel</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--3" title="This method has high CPU cost."></div></h2> <p>Generate 1 pixel resource unit for 10000 CPU from your bucket.</p>
---@field generatePixel fun(self:Game.cpu)
local cpu = {}

--- <p>Your <a href="https://docs.screeps.com/control.html#Global-Control-Level">Global Control Level</a>, an object with the following properties :</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>level</code></td><td>number</td><td><p>The current level.</p></td></tr><tr><td><code>progress</code></td><td>number</td><td><p>The current progress to the next level.</p></td></tr><tr><td><code>progressTotal</code></td><td>number</td><td><p>The progress required to reach the next level.</p></td></tr></tbody></table>
---@class Game.gcl
local gcl = {}

--- <p>Your Global Power Level, an object with the following properties :</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>level</code></td><td>number</td><td><p>The current level.</p></td></tr><tr><td><code>progress</code></td><td>number</td><td><p>The current progress to the next level.</p></td></tr><tr><td><code>progressTotal</code></td><td>number</td><td><p>The progress required to reach the next level.</p></td></tr></tbody></table>
---@class Game.gpl
local gpl = {}

--- <p>A global object representing world map. Use it to navigate between rooms.</p>
---@class Game.map
--- <h2 class="api-property api-property--method" id="Game.map.describeExits"><span class="api-property__name">Game.map.describeExits</span><span class="api-property__args">(roomName)</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>List all exits available from the room with the given name.</p>
---@field describeExits fun(self:Game.map,roomName:string):(table<integer,string>)
--- <h2 class="api-property api-property--method" id="Game.map.findExit"><span class="api-property__name">Game.map.findExit</span><span class="api-property__args">(fromRoom, toRoom, [opts])</span><div class="api-property__cpu api-property__cpu--3" title="This method has high CPU cost."></div></h2> <p>Find the exit direction from the given room en route to another room.</p>
---@field findExit fun(self:Game.map,fromRoom:string|Room,toRoom:string|Room,opts:any?)
--- <h2 class="api-property api-property--method" id="Game.map.findRoute"><span class="api-property__name">Game.map.findRoute</span><span class="api-property__args">(fromRoom, toRoom, [opts])</span><div class="api-property__cpu api-property__cpu--3" title="This method has high CPU cost."></div></h2> <p>Find route from the given room to another room.</p>
---@field findRoute fun(self:Game.map,fromRoom:string|Room,toRoom:string|Room,opts:any?):({exit:string,room:string}[])
--- <h2 class="api-property api-property--method" id="Game.map.getRoomLinearDistance"><span class="api-property__name">Game.map.getRoomLinearDistance</span><span class="api-property__args">(roomName1, roomName2, [continuous])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Get the linear distance (in rooms) between two rooms. You can use this function to estimate the energy cost of sending resources through terminals, or using observers and nukes.</p>
---@field getRoomLinearDistance fun(self:Game.map,roomName1:string,roomName2:string,continuous:any?)
--- <h2 class="api-property api-property--method" id="Game.map.getRoomTerrain"><span class="api-property__name">Game.map.getRoomTerrain</span><span class="api-property__args">(roomName)</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Get a <a href="https://docs.screeps.com/api/#Room-Terrain"><code>Room.Terrain</code></a> object which provides fast access to static terrain data. This method works for any room in the world even if you have no access to it.</p>
---@field getRoomTerrain fun(self:Game.map,roomName:string)
--- <h2 class="api-property api-property--method api-property--deprecated" id="Game.map.getTerrainAt"><span class="api-property__name">Game.map.getTerrainAt</span><span class="api-property__args">(x, y, roomName)<br/>(pos)</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <div class="api-deprecated"><p>This method is deprecated and will be removed soon. Please use a faster method <a href="https://docs.screeps.com/api/#Game.map.getRoomTerrain"><code>Game.map.getRoomTerrain</code></a> instead.</p></div> <p>Get terrain type at the specified room position. This method works for any room in the world even if you have no access to it.</p>
---@field getTerrainAt fun(self:Game.map,x:number,y:number,roomName:string)|fun(self:Game.map,pos:RoomPosition)
--- <h2 class="api-property api-property--method" id="Game.map.getWorldSize"><span class="api-property__name">Game.map.getWorldSize</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2>
---@field getWorldSize fun(self:Game.map)
--- <h2 class="api-property api-property--method api-property--deprecated" id="Game.map.isRoomAvailable"><span class="api-property__name">Game.map.isRoomAvailable</span><span class="api-property__args">(roomName)</span><div class="api-property__cpu api-property__cpu--2" title="This method has medium CPU cost."></div></h2> <div class="api-deprecated"><p>This method is deprecated and will be removed soon. Please use <a href="https://docs.screeps.com/api/#Game.map.getRoomStatus"><code>Game.map.getRoomStatus</code></a> instead.</p></div> <p>Check if the room is available to move into.</p>
---@field isRoomAvailable fun(self:Game.map,roomName:string)
--- <h2 class="api-property api-property--method" id="Game.map.getRoomStatus"><span class="api-property__name">Game.map.getRoomStatus</span><span class="api-property__args">(roomName)</span><div class="api-property__cpu api-property__cpu--2" title="This method has medium CPU cost."></div></h2> <p>Gets availablity status of the room with the specified name. Learn more about starting areas from <a href="https://docs.screeps.com/start-areas.html">this article</a>.</p>
---@field getRoomStatus fun(self:Game.map,roomName:string)
---@field visual Game.map.visual
local map = {}

--- <p>Map visuals provide a way to show various visual debug info on the game map. You can use the <code>Game.map.visual</code> object to draw simple shapes that are visible only to you. </p> <p>Map visuals are not stored in the database, their only purpose is to display something in your browser. All drawings will persist for one tick and will disappear if not updated. All <code>Game.map.visual</code> calls have no added CPU cost (their cost is natural and mostly related to simple <code>JSON.serialize</code> calls). However, there is a usage limit: you cannot post more than 1000 KB of serialized data. </p> <p>All draw coordinates are measured in global game coordinates (<a href="https://docs.screeps.com/api/#RoomPosition"><code>RoomPosition</code></a>).</p>
---@class Game.map.visual
--- <h2 class="api-property api-property--method" id="Game.map-visual.line"><span class="api-property__name">line</span><span class="api-property__args">(pos1, pos2, [style])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Draw a line.</p>
---@field line fun(self:Game.map.visual,pos1:RoomPosition,pos2:RoomPosition,style:any?)
--- <h2 class="api-property api-property--method" id="Game.map-visual.circle"><span class="api-property__name">circle</span><span class="api-property__args">(pos, [style])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Draw a circle.</p>
---@field circle fun(self:Game.map.visual,pos:RoomPosition,style:any?)
--- <h2 class="api-property api-property--method" id="Game.map-visual.rect"><span class="api-property__name">rect</span><span class="api-property__args">(topLeftPos, width, height, [style])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Draw a rectangle.</p>
---@field rect fun(self:Game.map.visual,topLeftPos:RoomPosition,width:number,height:number,style:any?)
--- <h2 class="api-property api-property--method" id="Game.map-visual.poly"><span class="api-property__name">poly</span><span class="api-property__args">(points, [style])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Draw a polyline.</p>
---@field poly fun(self:Game.map.visual,points:any[],style:any?)
--- <h2 class="api-property api-property--method" id="Game.map-visual.text"><span class="api-property__name">text</span><span class="api-property__args">(text, pos, [style])</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Draw a text label. You can use any valid Unicode characters, including <a href="http://unicode.org/emoji/charts/emoji-style.txt" target="_blank">emoji</a>.</p>
---@field text fun(self:Game.map.visual,text:string,pos:RoomPosition,style:any?)
--- <h2 class="api-property api-property--method" id="Game.map-visual.clear"><span class="api-property__name">clear</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Remove all visuals from the map.</p>
---@field clear fun(self:Game.map.visual)
--- <h2 class="api-property api-property--method" id="Game.map-visual.getSize"><span class="api-property__name">getSize</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Get the stored size of all visuals added on the map in the current tick. It must not exceed 1024,000 (1000 KB).</p>
---@field getSize fun(self:Game.map.visual)
--- <h2 class="api-property api-property--method" id="Game.map-visual.export"><span class="api-property__name">export</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Returns a compact representation of all visuals added on the map in the current tick.</p>
---@field export fun(self:Game.map.visual)
--- <h2 class="api-property api-property--method" id="Game.map-visual.import"><span class="api-property__name">import</span><span class="api-property__args">(val)</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Add previously exported (with <a href="https://docs.screeps.com/api/#Game.map-visual.export">Game.map.visual.export</a>) map visuals to the map visual data of the current tick. </p>
---@field import fun(self:Game.map.visual,val:string)
local visual = {}

--- <p>A global object representing the in-game market. You can use this object to track resource transactions to/from your terminals, and your buy/sell orders.</p> <p>Learn more about the market system from <a href="https://docs.screeps.com/market.html">this article</a>.</p>
---@class Game.market
--- <p>Your current credits balance.</p>
---@field credits number
--- <p>An array of the last 100 incoming transactions to your terminals with the following format:</p>
---@field incomingTransactions any[]
--- <p>An array of the last 100 outgoing transactions from your terminals with the following format:</p>
---@field outgoingTransactions any[]
--- <h2 class="api-property api-property--method" id="Game.market.calcTransactionCost"><span class="api-property__name">Game.market.calcTransactionCost</span><span class="api-property__args">(amount, roomName1, roomName2)</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Estimate the energy transaction cost of <a href="https://docs.screeps.com/api/#StructureTerminal.send"><code>StructureTerminal.send</code></a> and <a href="https://docs.screeps.com/api/#Game.market.deal"><code>Game.market.deal</code></a> methods. The formula:</p>
---@field calcTransactionCost fun(self:Game.market,amount:number,roomName1:string,roomName2:string)
--- <h2 class="api-property api-property--method" id="Game.market.cancelOrder"><span class="api-property__name">Game.market.cancelOrder</span><span class="api-property__args">(orderId)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Cancel a previously created order. The 5% fee is not returned.</p>
---@field cancelOrder fun(self:Game.market,orderId:string)
--- <h2 class="api-property api-property--method" id="Game.market.changeOrderPrice"><span class="api-property__name">Game.market.changeOrderPrice</span><span class="api-property__args">(orderId, newPrice)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Change the price of an existing order. If <code>newPrice</code> is greater than old price, you will be charged <code>(newPrice-oldPrice)*remainingAmount*0.05</code> credits.</p>
---@field changeOrderPrice fun(self:Game.market,orderId:string,newPrice:number)
--- <h2 class="api-property api-property--method" id="Game.market.createOrder"><span class="api-property__name">Game.market.createOrder</span><span class="api-property__args">(params)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Create a market order in your terminal. You will be charged <code>price*amount*0.05</code> credits when the order is placed. The maximum orders count is 300 per player. You can create an order at any time with any amount, it will be automatically activated and deactivated depending on the resource/credits availability.</p>
---@field createOrder fun(self:Game.market,params:table)
--- <h2 class="api-property api-property--method" id="Game.market.deal"><span class="api-property__name">Game.market.deal</span><span class="api-property__args">(orderId, amount, [yourRoomName])</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Execute a trade deal from your Terminal in <code>yourRoomName</code> to another player's Terminal using the specified buy/sell order. Your Terminal will be charged energy units of transfer cost regardless of the order resource type. You can use <a href="https://docs.screeps.com/api/#calcTransactionCost"><code>Game.market.calcTransactionCost</code></a> method to estimate it. When multiple players try to execute the same deal, the one with the shortest distance takes precedence. You cannot execute more than 10 deals during one tick.</p>
---@field deal fun(self:Game.market,orderId:string,amount:number,yourRoomName:any?)
--- <h2 class="api-property api-property--method" id="Game.market.extendOrder"><span class="api-property__name">Game.market.extendOrder</span><span class="api-property__args">(orderId, addAmount)</span><div class="api-property__cpu api-property__cpu--A" title="This method is an action that changes game state. It has additional 0.2 CPU cost added to its natural cost in case if OK code is returned."></div></h2> <p>Add more capacity to an existing order. It will affect <code>remainingAmount</code> and <code>totalAmount</code> properties. You will be charged <code>price*addAmount*0.05</code> credits.</p>
---@field extendOrder fun(self:Game.market,orderId:string,addAmount:number)
--- <h2 class="api-property api-property--method" id="Game.market.getAllOrders"><span class="api-property__name">Game.market.getAllOrders</span><span class="api-property__args">([filter])</span><div class="api-property__cpu api-property__cpu--3" title="This method has high CPU cost."></div></h2> <p>Get other players' orders currently active on the market. This method supports internal indexing by <code>resourceType</code>.</p>
---@field getAllOrders fun(self:Game.market,filter:any?)
--- <h2 class="api-property api-property--method" id="Game.market.getHistory"><span class="api-property__name">Game.market.getHistory</span><span class="api-property__args">([resourceType])</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Get daily price history of the specified resource on the market for the last 14 days. </p>
---@field getHistory fun(self:Game.market,resourceType:any?):({resourceType:string,date:string,transactions:integer,volume:integer,avgPrice:number,stddevPrice:number}[])
--- <h2 class="api-property api-property--method" id="Game.market.getOrderById"><span class="api-property__name">Game.market.getOrderById</span><span class="api-property__args">(id)</span><div class="api-property__cpu api-property__cpu--1" title="This method has low CPU cost."></div></h2> <p>Retrieve info for specific market order.</p>
---@field getOrderById fun(self:Game.market,id:string)
---@field orders Game.market.orders
local market = {}

--- <p>An object with your active and inactive buy/sell orders on the market.See<a href="https://docs.screeps.com/api/#getAllOrders"><code>getAllOrders</code></a>for properties explanation.</p>
---@class Game.market.orders
local orders = {}

--- <p>An object with your global resources that are bound to the account, like pixels or cpu unlocks. Each object key is a resource constant, values are resources amounts.</p>
---@class Game.resources
local resources = {}

--- <p>An object describing the world shard where your script is currently being executed in.</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>name</code></td><td>string</td><td><p>The name of the shard.</p></td></tr><tr><td><code>type</code></td><td>string</td><td><p>Currently always equals to <code>normal</code>.</p></td></tr><tr><td><code>ptr</code></td><td>boolean</td><td><p>Whether this shard belongs to the <a href="https://docs.screeps.com/ptr.html">PTR</a>.</p></td></tr></tbody></table>
---@class Game.shard
local shard = {}
