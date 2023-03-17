--[[
    Base on mino_simp:
    Simple grid
    Low precision timer
]]
local gc=love.graphics
local gc_setColor=gc.setColor
local gc_draw,gc_rectangle=gc.draw,gc.rectangle
local gc_printf=gc.printf

local COLOR=COLOR

local S={}
S.base='mino_simp'

local gridMark=GC.load{40,40,
    {'setCL',1,1,1,.26},
    {'fRect',0,0,40,1},
    {'fRect',0,39,40,1},
    {'fRect',0,1,1,38},
    {'fRect',39,1,1,38},
}
function S.drawFieldBackground(fieldW)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,40*fieldW,-80*fieldW)
    gc_setColor(1,1,1)
    for x=1,fieldW do for y=1,2*fieldW do
        gc_draw(gridMark,x*40-40,-y*40)
    end end
end

function S.drawTime(time)
    gc_setColor(COLOR.dL)
    FONT.set(30,'number')
    gc_printf(("%.1f"):format(time/1000),-210-260,380,260,'right')
end

return S
