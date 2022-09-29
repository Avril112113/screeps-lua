-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>RawMemory object allows to implement your own memory stringifier instead of built-in serializer based on <code>JSON.stringify</code>. It also allows to request up to 10 MB of additional memory using asynchronous memory segments feature.</p> <p>You can also access memory segments of other players using methods below.</p>
---@class RawMemory
--- <div class="api-deprecated"><p>This property is deprecated and will be removed soon. Please use <a href="https://docs.screeps.com/api/#InterShardMemory"><code>InterShardMemory</code></a> instead.</p></div> <p>A string with a shared memory segment available on every world shard. Maximum string length is 100 KB.</p> <p><strong>Warning:</strong> this segment is not safe for concurrent usage! All shards have shared access to the same instance of data. When the segment contents is changed by two shards simultaneously, you may lose some data, since the segment string value is written all at once atomically. You must implement your own system to determine when each shard is allowed to rewrite the inter-shard memory, e.g. based on <a href="https://en.wikipedia.org/wiki/Mutual_exclusion" rel="noopener" target="_blank">mutual exclusions</a>.  </p>
---@deprecated
---@field interShardSegment string
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Get a raw string representation of the <code>Memory</code> object.</p>
---@field get fun(self:RawMemory)
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Set new <code>Memory</code> value.</p>
---@field set fun(self:RawMemory,value:string)
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Request memory segments using the list of their IDs. Memory segments will become available on the next tick in <a href="https://docs.screeps.com/api/#RawMemory.segments"><code>segments</code></a> object.</p>
---@field setActiveSegments fun(self:RawMemory,ids:any[])
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Request a memory segment of another user. The segment should be marked by its owner as public using <a href="https://docs.screeps.com/api/#RawMemory.setPublicSegments"><code>setPublicSegments</code></a>. The segment data will become available on the next tick in <a href="https://docs.screeps.com/api/#RawMemory.foreignSegment"><code>foreignSegment</code></a> object. You can only have access to one foreign segment at the same time.   </p>
---@field setActiveForeignSegment fun(self:RawMemory,username:string|nil,id:any?)
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Set the specified segment as your default public segment. It will be returned if no <code>id</code> parameter is passed to <a href="https://docs.screeps.com/api/#RawMemory.setActiveForeignSegment"><code>setActiveForeignSegment</code></a> by another user.   </p>
---@field setDefaultPublicSegment fun(self:RawMemory,id:number|nil)
--- ![0](imgs/cpu_0.png) - Insignificant CPU cost
--- <p>Set specified segments as public. Other users will be able to request access to them using <a href="https://docs.screeps.com/api/#RawMemory.setActiveForeignSegment"><code>setActiveForeignSegment</code></a>.     </p>
---@field setPublicSegments fun(self:RawMemory,ids:any[])
---@field segments RawMemory.segments
---@field foreignSegment RawMemory.foreignSegment
local RawMemory = {}

--- <p>An object with asynchronous memory segments available on this tick. Each object key is the segment ID with data in string values. Use <a href="https://docs.screeps.com/api/#RawMemory.setActiveSegments"><code>setActiveSegments</code></a> to fetch segments on the next tick. Segments data is saved automatically in the end of the tick. The maximum size per segment is 100 KB.</p>
---@class RawMemory.segments
local segments = {}

--- <p>An object with a memory segment of another player available on this tick. Use <a href="https://docs.screeps.com/api/#RawMemory.setActiveForeignSegment"><code>setActiveForeignSegment</code></a> to fetch segments on the next tick. The object consists of the following properties:</p> <table><thead><tr><th>parameter</th><th>type</th><th>description</th></tr></thead><tbody><tr><td><code>username</code></td><td>string</td><td><p>Another player's name.</p></td></tr><tr><td><code>id</code></td><td>number</td><td><p>The ID of the requested memory segment.</p></td></tr><tr><td><code>data</code></td><td>string</td><td><p>The segment contents.</p></td></tr></tbody></table>
---@class RawMemory.foreignSegment
local foreignSegment = {}
