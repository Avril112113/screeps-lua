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
--- <p>Get an object with the specified unique ID. It may be a game object of any type. Only objects from the rooms which are visible to you can be accessed.</p>
---@field getObjectById fun(self:Game,id:string)
--- <p>Send a custom message at your profile email. This way, you can set up notifications to yourself on any occasion within the game. You can schedule up to 20 notifications during one game tick. Not available in the Simulation Room.</p>
---@field notify fun(self:Game,message:string,groupInterval:number?)
---@field cpu Game.cpu
---@field gcl Game.gcl
---@field gpl Game.gpl
---@field map Game.map
---@field market Game.market
---@field resources Game.resources
---@field shard Game.shard
local Game = {}

--- <p>An object containing information about your CPU usage with the following properties:</p>
---@class Game.cpu
--- <p>Your assigned CPU limit for the current shard.</p>
---@field limit number
--- <p>An amount of available CPU time at the current game tick.<br/>Usually it is higher than <code>Game.cpu.limit</code>. <a href="https://docs.screeps.com/cpu-limit.html">Learn more</a></p>
---@field tickLimit number
--- <p>An amount of unused CPU accumulated in your <a href="https://docs.screeps.com/cpu-limit.html#Bucket">bucket</a>.</p>
---@field bucket number
--- <p>An object with limits for each shard with shard names as keys. You can use <a href="https://docs.screeps.com/api/#Game.setShardLimits"><code>setShardLimits</code></a>
--- method to re-assign them.</p>
---@field shardLimits table<string,number>
--- <p>Whether full CPU is currently unlocked for your account.</p>
---@field unlocked boolean
--- <p>The time <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/getTime#Syntax" rel="noopener" target="_blank">in milliseconds since UNIX epoch time</a> until full CPU is unlocked for your account. This property is not defined when full CPU is not unlocked for your account or it's unlocked with a subscription.</p>
---@field unlockedTime number
--- <p><em>This method is only available when <strong>Virtual machine</strong> is set to <strong>Isolated</strong> in your <a href="https://screeps.com/a/#!/account/runtime" rel="noopener" target="_blank">account runtime settings</a>.</em> </p> <p>Use this method to get heap statistics for your virtual machine. The return value is almost identical to the Node.js function <a href="https://nodejs.org/dist/latest-v8.x/docs/api/v8.html#v8_v8_getheapstatistics" rel="noopener" target="_blank"><code>v8.getHeapStatistics()</code></a>. This function returns one additional property: <code>externally_allocated_size</code> which is the total amount of currently allocated memory which is not included in the v8 heap but counts against this isolate's memory limit. <code>ArrayBuffer</code> instances over a certain size are externally allocated and will be counted here.</p>
---@field getHeapStatistics fun(self:Game.cpu):({total_heap_size:integer,total_heap_size_executable:integer,total_physical_size:integer,total_available_size:integer,used_heap_size:integer,heap_size_limit:integer,malloced_memory:integer,peak_malloced_memory:integer,does_zap_garbage:integer,externally_allocated_size:integer})
--- <p>Get amount of CPU time used from the beginning of the current game tick. Always returns 0 in the Simulation mode.</p>
---@field getUsed fun(self:Game.cpu)
--- <p><em>This method is only available when <strong>Virtual machine</strong> is set to <strong>Isolated</strong> in your <a href="https://screeps.com/a/#!/account/runtime" rel="noopener" target="_blank">account runtime settings</a>.</em></p> <p>Reset your runtime environment and wipe all data in heap memory.</p>
---@field halt fun(self:Game.cpu)
--- <p>Allocate CPU limits to different shards. Total amount of CPU should remain equal to  <a href="https://docs.screeps.com/api/#Game.cpu"><code>Game.cpu.shardLimits</code></a>. This method can be used only once per 12 hours.</p>
---@field setShardLimits fun(self:Game.cpu,limits:table<string,number>):(OK|ERR_BUSY|ERR_INVALID_ARGS)
--- <p>Unlock full CPU for your account for additional 24 hours. This method will consume 1 CPU unlock bound to your account (See <a href="https://docs.screeps.com/api/#Game.resources"><code>Game.resources</code></a>).If full CPU is not currently unlocked for your account, it may take some time (up to 5 minutes) before unlock is applied to your account.</p>
---@field unlock fun(self:Game.cpu):(OK|ERR_NOT_ENOUGH_RESOURCES|ERR_FULL)
--- <p>Generate 1 pixel resource unit for 10000 CPU from your bucket.</p> <table class="api-return-codes"><thead><tr><th>constant</th><th>value</th><th>description</th></tr></thead><tbody><tr><td><code>OK</code></td><td>0</td><td><p>The operation has been scheduled successfully.</p></td></tr><tr><td><code>ERR_NOT_ENOUGH_RESOURCES</code></td><td>-6</td><td><p>Your bucket does not have enough CPU.</p></td></tr></tbody></table>
---@field generatePixel fun(self:Game.cpu)
local cpu = {}

--- <p>Your <a href="https://docs.screeps.com/control.html#Global-Control-Level">Global Control Level</a>, an object with the following properties :</p>
---@class Game.gcl
--- <p>The current level.</p>
---@field level number
--- <p>The current progress to the next level.</p>
---@field progress number
--- <p>The progress required to reach the next level.</p>
---@field progressTotal number
local gcl = {}

--- <p>Your Global Power Level, an object with the following properties :</p>
---@class Game.gpl
--- <p>The current level.</p>
---@field level number
--- <p>The current progress to the next level.</p>
---@field progress number
--- <p>The progress required to reach the next level.</p>
---@field progressTotal number
local gpl = {}

--- <p>A global object representing world map. Use it to navigate between rooms.</p>
---@class Game.map
--- <p>List all exits available from the room with the given name.</p>
---@field describeExits fun(self:Game.map,roomName:string):(table<integer,string>)
--- <p>Find the exit direction from the given room en route to another room.</p>
---@field findExit fun(self:Game.map,fromRoom:string|Room,toRoom:string|Room,opts:any?):(ERR_NO_PATH|ERR_INVALID_ARGS)
--- <p>Find route from the given room to another room.</p>
---@field findRoute fun(self:Game.map,fromRoom:string|Room,toRoom:string|Room,opts:any?):({exit:string,room:string}[]|ERR_NO_PATH)
--- <p>Get the linear distance (in rooms) between two rooms. You can use this function to estimate the energy cost of sending resources through terminals, or using observers and nukes.</p>
---@field getRoomLinearDistance fun(self:Game.map,roomName1:string,roomName2:string,continuous:any?)
--- <p>Get a <a href="https://docs.screeps.com/api/#Room-Terrain"><code>Room.Terrain</code></a> object which provides fast access to static terrain data. This method works for any room in the world even if you have no access to it.</p>
---@field getRoomTerrain fun(self:Game.map,roomName:string)
--- <div class="api-deprecated"><p>This method is deprecated and will be removed soon. Please use a faster method <a href="https://docs.screeps.com/api/#Game.map.getRoomTerrain"><code>Game.map.getRoomTerrain</code></a> instead.</p></div> <p>Get terrain type at the specified room position. This method works for any room in the world even if you have no access to it.</p>
---@field getTerrainAt fun(self:Game.map,x:number,y:number,roomName:string)|fun(self:Game.map,pos:RoomPosition)
--- <p>Returns the world size as a number of rooms between world corners. For example, for a world with rooms from W50N50 to E50S50 this method will return 102.</p>
---@field getWorldSize fun(self:Game.map)
--- <div class="api-deprecated"><p>This method is deprecated and will be removed soon. Please use <a href="https://docs.screeps.com/api/#Game.map.getRoomStatus"><code>Game.map.getRoomStatus</code></a> instead.</p></div> <p>Check if the room is available to move into.</p>
---@field isRoomAvailable fun(self:Game.map,roomName:string)
--- <p>Gets availablity status of the room with the specified name. Learn more about starting areas from <a href="https://docs.screeps.com/start-areas.html">this article</a>.</p>
---@field getRoomStatus fun(self:Game.map,roomName:string)
---@field visual Game.map.visual
local map = {}

--- <p>Map visuals provide a way to show various visual debug info on the game map. You can use the <code>Game.map.visual</code> object to draw simple shapes that are visible only to you. </p> <p>Map visuals are not stored in the database, their only purpose is to display something in your browser. All drawings will persist for one tick and will disappear if not updated. All <code>Game.map.visual</code> calls have no added CPU cost (their cost is natural and mostly related to simple <code>JSON.serialize</code> calls). However, there is a usage limit: you cannot post more than 1000 KB of serialized data. </p> <p>All draw coordinates are measured in global game coordinates (<a href="https://docs.screeps.com/api/#RoomPosition"><code>RoomPosition</code></a>).</p>
---@class Game.map.visual
--- <p>Draw a line.</p>
---@field line fun(self:Game.map.visual,pos1:RoomPosition,pos2:RoomPosition,style:any?)
--- <p>Draw a circle.</p>
---@field circle fun(self:Game.map.visual,pos:RoomPosition,style:any?)
--- <p>Draw a rectangle.</p>
---@field rect fun(self:Game.map.visual,topLeftPos:RoomPosition,width:number,height:number,style:any?)
--- <p>Draw a polyline.</p>
---@field poly fun(self:Game.map.visual,points:any[],style:any?)
--- <p>Draw a text label. You can use any valid Unicode characters, including <a href="http://unicode.org/emoji/charts/emoji-style.txt" target="_blank">emoji</a>.</p>
---@field text fun(self:Game.map.visual,text:string,pos:RoomPosition,style:any?)
--- <p>Remove all visuals from the map.</p>
---@field clear fun(self:Game.map.visual)
--- <p>Get the stored size of all visuals added on the map in the current tick. It must not exceed 1024,000 (1000 KB).</p>
---@field getSize fun(self:Game.map.visual)
--- <p>Returns a compact representation of all visuals added on the map in the current tick.</p>
---@field export fun(self:Game.map.visual)
--- <p>Add previously exported (with <a href="https://docs.screeps.com/api/#Game.map-visual.export">Game.map.visual.export</a>) map visuals to the map visual data of the current tick. </p>
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
--- <p>Estimate the energy transaction cost of <a href="https://docs.screeps.com/api/#StructureTerminal.send"><code>StructureTerminal.send</code></a> and <a href="https://docs.screeps.com/api/#Game.market.deal"><code>Game.market.deal</code></a> methods. The formula:</p>
---@field calcTransactionCost fun(self:Game.market,amount:number,roomName1:string,roomName2:string)
--- <p>Cancel a previously created order. The 5% fee is not returned.</p>
---@field cancelOrder fun(self:Game.market,orderId:string):(OK|ERR_INVALID_ARGS)
--- <p>Change the price of an existing order. If <code>newPrice</code> is greater than old price, you will be charged <code>(newPrice-oldPrice)*remainingAmount*0.05</code> credits.</p>
---@field changeOrderPrice fun(self:Game.market,orderId:string,newPrice:number):(OK|ERR_NOT_OWNER|ERR_NOT_ENOUGH_RESOURCES|ERR_INVALID_ARGS)
--- <p>Create a market order in your terminal. You will be charged <code>price*amount*0.05</code> credits when the order is placed. The maximum orders count is 300 per player. You can create an order at any time with any amount, it will be automatically activated and deactivated depending on the resource/credits availability.</p>
---@field createOrder fun(self:Game.market,params:table):(OK|ERR_NOT_OWNER|ERR_NOT_ENOUGH_RESOURCES|ERR_FULL|ERR_INVALID_ARGS)
--- <p>Execute a trade deal from your Terminal in <code>yourRoomName</code> to another player's Terminal using the specified buy/sell order. Your Terminal will be charged energy units of transfer cost regardless of the order resource type. You can use <a href="https://docs.screeps.com/api/#calcTransactionCost"><code>Game.market.calcTransactionCost</code></a> method to estimate it. When multiple players try to execute the same deal, the one with the shortest distance takes precedence. You cannot execute more than 10 deals during one tick.</p>
---@field deal fun(self:Game.market,orderId:string,amount:number,yourRoomName:any?):(OK|ERR_NOT_OWNER|ERR_NOT_ENOUGH_RESOURCES|ERR_FULL|ERR_INVALID_ARGS|ERR_TIRED)
--- <p>Add more capacity to an existing order. It will affect <code>remainingAmount</code> and <code>totalAmount</code> properties. You will be charged <code>price*addAmount*0.05</code> credits.</p>
---@field extendOrder fun(self:Game.market,orderId:string,addAmount:number):(OK|ERR_NOT_ENOUGH_RESOURCES|ERR_INVALID_ARGS)
--- <p>Get other players' orders currently active on the market. This method supports internal indexing by <code>resourceType</code>.</p>
---@field getAllOrders fun(self:Game.market,filter:any?)
--- <p>Get daily price history of the specified resource on the market for the last 14 days. </p>
---@field getHistory fun(self:Game.market,resourceType:any?):({resourceType:string,date:string,transactions:integer,volume:integer,avgPrice:number,stddevPrice:number}[])
--- <p>Retrieve info for specific market order.</p>
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
