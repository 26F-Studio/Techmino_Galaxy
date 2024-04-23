local gc=love.graphics
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle
local gc_setLineWidth=gc.setLineWidth

---@type Techmino.skin.puyo
local S={}
S.base='mino_template'

function S.drawFieldBackground(fieldW)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,40*fieldW,-80*fieldW)
end

function S.drawFieldCell(C,_,x,y)
    if not C.clearing or S.getTime()%100<=50 then
        gc_setColor(ColorTable[C.color])
        gc_rectangle('fill',x,y,36,36,15)
    end
end

function S.drawGhostCell(_,_,_,_)
    gc_setColor(1,1,1,.162)
    gc_rectangle('fill',2,2,36,36,15)
end

local strokeR=4
function S.drawHandCellStroke(_,_,_,_)
    gc_setColor(1,1,1)
    gc_rectangle('fill',2-strokeR,2-strokeR,36+2*strokeR,36+2*strokeR,15)
end

function S.drawHandCell(C,_,_,_)
    gc_setColor(ColorTable[C.color])
    gc_rectangle('fill',2,2,36,36,15)
end

function S.drawNextBorder(slot)
    gc_setColor(0,0,0,.26)
    gc_rectangle('fill',30,0,100,100*slot)
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',30,0,100,100*slot)
end

local unavailableColor={.6,.6,.6}

function S.drawNextCell(C,unavailable,_,_,_)
    gc_setColor(unavailable and unavailableColor or ColorTable[C.color])
    gc_rectangle('fill',2,2,36,36,18)
end

return S
