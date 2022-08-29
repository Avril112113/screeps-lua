-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><code>InterShardMemory</code> object provides an interface for communicating between shards. Your script is executed separatedly on each shard, and their <a href="https://docs.screeps.com/api/#Memory"><code>Memory</code></a> objects are isolated from each other. In order to pass messages and data between shards, you need to use <code>InterShardMemory</code> instead.</p> <p>Every shard can have its own 100 KB of data in string format that can be accessed by all other shards. A shard can write only to its own data, other shards' data is read-only.</p> <p>This data has nothing to do with <code>Memory</code> contents, it's a separate data container.      </p>
---@class InterShardMemory
--- <h2 class="api-property api-property--method" id="InterShardMemory.getLocal"><span class="api-property__name">InterShardMemory.getLocal</span><span class="api-property__args">()</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2>
---@field getLocal fun(self:InterShardMemory)
--- <h2 class="api-property api-property--method" id="InterShardMemory.setLocal"><span class="api-property__name">InterShardMemory.setLocal</span><span class="api-property__args">(value)</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Replace the current shard's data with the new value.</p>
---@field setLocal fun(self:InterShardMemory,value:string)
--- <h2 class="api-property api-property--method" id="InterShardMemory.getRemote"><span class="api-property__name">InterShardMemory.getRemote</span><span class="api-property__args">(shard)</span><div class="api-property__cpu api-property__cpu--0" title="This method has insignificant CPU cost."></div></h2> <p>Returns the string contents of another shard's data.</p>
---@field getRemote fun(self:InterShardMemory,shard:string)
local InterShardMemory = {}
