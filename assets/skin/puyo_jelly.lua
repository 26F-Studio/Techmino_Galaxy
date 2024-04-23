local gc=love.graphics
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle

---@type Techmino.skin.puyo
local S={}
S.base='puyo_template'

local function drawSide(B,x,y)
    local c=B[y][x].color
    local t
    if B[y  ] then t=B[y  ][x+1] if t and t.connClear and t.color==c then gc_rectangle('fill',40, 8,  -5,24) end end
    if B[y  ] then t=B[y  ][x-1] if t and t.connClear and t.color==c then gc_rectangle('fill',0,  8,  5 ,24) end end
    if B[y-1] then t=B[y-1][x  ] if t and t.connClear and t.color==c then gc_rectangle('fill',8,  40, 24,-5) end end
    if B[y+1] then t=B[y+1][x  ] if t and t.connClear and t.color==c then gc_rectangle('fill',8,  0,  24, 5) end end
end

function S.drawFieldCell(C,F,x,y)
    if not C.clearing or S.getTime()%100<=50 then
        gc_setColor(ColorTable[C.color])
        gc_rectangle('fill',2,2,36,36,15)
        drawSide(F,x,y)
    end
end

function S.drawHandCell(C,B,x,y)
    gc_setColor(ColorTable[C.color])
    gc_rectangle('fill',2,2,36,36,15)
    drawSide(B,x,y)
end

function S.drawNextCell(C,_,B,x,y)
    gc_setColor(ColorTable[C.color])
    gc_rectangle('fill',2,2,36,36,18)
    drawSide(B,x,y)
end

return S
