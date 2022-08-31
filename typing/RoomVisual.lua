-- WARNING: THIS FILE IS GENERATED, DO NOT MODIFY.


--- <p><img align="right" src="./Screeps Documentation_files/visual.png"/></p> <p>Room visuals provide a way to show various visual debug info in game rooms. You can use the <code>RoomVisual</code> object to draw simple shapes that are visible only to you. Every existing <code>Room</code> object already contains the <a href="https://docs.screeps.com/api/#Room.visual"><code>visual</code></a> property, but you also can create new <code>RoomVisual</code> objects for any room (even without visibility) using the <a href="https://docs.screeps.com/api/#RoomVisual.constructor">constructor</a>.</p> <p>Room visuals are not stored in the database, their only purpose is to display something in your browser. All drawings will persist for one tick and will disappear if not updated. All <code>RoomVisual</code> API calls have no added CPU cost (their cost is natural and mostly related to simple <code>JSON.serialize</code> calls). However, there is a usage limit: you cannot post more than 500 KB  of serialized data per one room (see <a href="https://docs.screeps.com/api/#RoomVisual.getSize"><code>getSize</code></a> method).</p> <p>All draw coordinates are measured in game coordinates and centered to tile centers, i.e. (10,10) will point to the center of the creep at <code>x:10; y:10</code> position. Fractional coordinates are allowed.</p>
---@class RoomVisual
--- <p>The name of the room.</p>
---@field roomName string
--- <p>Draw a line.</p>
---@field line fun(self:RoomVisual,x1:number,y1:number,x2:number,y2:number,style:any?)|fun(self:RoomVisual,pos1:RoomPosition,pos2:RoomPosition,style:any?)
--- <p>Draw a circle.</p>
---@field circle fun(self:RoomVisual,x:number,y:number,style:any?)|fun(self:RoomVisual,pos:RoomPosition,style:any?)
--- <p>Draw a rectangle.</p>
---@field rect fun(self:RoomVisual,x:number,y:number,width:number,height:number,style:any?)|fun(self:RoomVisual,topLeftPos:RoomPosition,width:number,height:number,style:any?)
--- <p>Draw a polyline.</p>
---@field poly fun(self:RoomVisual,points:any[],style:any?)
--- <p>Draw a text label. You can use any valid Unicode characters, including <a href="http://unicode.org/emoji/charts/emoji-style.txt" target="_blank">emoji</a>.</p>
---@field text fun(self:RoomVisual,text:string,x:number,y:number,style:any?)|fun(self:RoomVisual,text:string,pos:RoomPosition,style:any?)
--- <p>Remove all visuals from the room.</p>
---@field clear fun(self:RoomVisual)
--- <p>Get the stored size of all visuals added in the room in the current tick. It must not exceed 512,000 (500 KB).</p>
---@field getSize fun(self:RoomVisual)
--- <p>Returns a compact representation of all visuals added in the room in the current tick.</p>
---@field export fun(self:RoomVisual)
--- <p>Add previously exported (with <a href="https://docs.screeps.com/api/#RoomVisual.export">RoomVisual.export</a>) room visuals to the room visual data of the current tick. </p>
---@field import fun(self:RoomVisual,val:string)
local RoomVisual = {}
