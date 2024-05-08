local gc=love.graphics
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle
local gc_setLineWidth=gc.setLineWidth

local NumColor=NumColor

---@type Techmino.skin.gela
local S={}
S.base='brik_template'

function S.drawFieldBackground(fieldW)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,40*fieldW,-80*fieldW)
end

function S.drawFieldCell(C,_,x,y,_)
    if not C.clearing or S.getTime()%100<=50 then
        gc_setColor(NumColor[C.color])
        gc_rectangle('fill',x,y,36,36,15)
    end
end

function S.drawGhostCell(_,_,_,_)
    gc_setColor(1,1,1,.162)
    gc_rectangle('fill',2,2,36,36,15)
end

local strokeR=2
function S.drawHandCellStroke(_,_,_,_)
    gc_setColor(1,1,1)
    gc_rectangle('fill',2-strokeR,2-strokeR,36+2*strokeR,36+2*strokeR,15+strokeR)
end

function S.drawHandCell(C,_,_,_)
    gc_setColor(NumColor[C.color])
    gc_rectangle('fill',2,2,36,36,15)
end

function S.drawNextBorder(slot)
    gc_setColor(0,0,0,.26)
    gc_rectangle('fill',30,0,100,100*slot)
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',30,0,100,100*slot)
end

local disabledColor={.6,.6,.6}

function S.drawNextCell(C,disabled,_,_,_)
    gc_setColor(disabled and disabledColor or NumColor[C.color])
    gc_rectangle('fill',2,2,36,36,18)
end

return S
