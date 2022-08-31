-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p>An object that can contain resources in its cargo.</p> <p>There are two types of stores in the game: general purpose stores and limited stores.</p> <ul><li><p>General purpose stores can contain any resource within its capacity (e.g. creeps, containers, storages, terminals).</p></li><li><p>Limited stores can contain only a few types of resources needed for that particular object (e.g. spawns, extensions, labs, nukers).</p></li></ul> <p>The <code>Store</code> prototype is the same for both types of stores, but they have different behavior depending on the <code>resource</code> argument in its methods.</p> <p>You can get specific resources from the store by addressing them as object properties:</p>
---@class Store
--- <p>Returns capacity of this store for the specified resource. For a general purpose store, it returns total capacity if <code>resource</code> is undefined.</p>
---@field getCapacity fun(self:Store,resource:any?)
--- <p>Returns free capacity for the store. For a limited store, it returns the capacity available for the specified resource if <code>resource</code> is defined and valid for this store. </p>
---@field getFreeCapacity fun(self:Store,resource:any?)
--- <p>Returns the capacity used by the specified resource. For a general purpose store, it returns total used capacity if <code>resource</code> is undefined. </p>
---@field getUsedCapacity fun(self:Store,resource:any?)
local Store = {}
