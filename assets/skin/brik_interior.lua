--[[
    Base on brik_template:
    Remove HeightLines
    Remove DelayIndicator
    Simple open ceiling
    Simple grid
    Low precision timer
    Static starting counter
]]
local gc=love.graphics
local gc_setColor=gc.setColor
local gc_draw,gc_rectangle=gc.draw,gc.rectangle
local gc_printf=gc.printf
local gc_setLineWidth=gc.setLineWidth
local gc_line=gc.line

local COLOR=COLOR

---@type Techmino.Skin.Brik
local S={}
S.base='brik_template'

function S.drawFieldBorder()
    gc_setLineWidth(2)
    gc_setColor(1,1,1)
    gc_line(-201,-401,-201,401,201,401,201,-401)
end

local gridMark=GC.load{w=40,h=40,
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

S.drawHeightLines=NULL
S.drawAsdIndicator=NULL
S.drawDelayIndicator=NULL
S.drawLockDelayIndicator=NULL

function S.drawTime(time)
    gc_setColor(COLOR.dL)
    FONT.set(30,'number')
    gc_printf(("%.1f"):format(time/1000),-210-260,380,260,'right')
end

function S.drawStartingCounter(readyDelay)
    FONT.set(100)
    gc_setColor(COLOR.L)
    GC.mStr(math.floor((readyDelay-S.getTime())/1000)+1,0,-70)
end

return S
