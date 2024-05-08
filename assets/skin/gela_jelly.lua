local gc=love.graphics
local gc_setColor=gc.setColor
local gc_rectangle,gc_polygon=gc.rectangle,gc.polygon

local NumColor=NumColor

---@type Techmino.skin.gela
local S={}
S.base='gela_template'

local function drawSide(B,x,y,connH)
    local c=B[y][x].color
    local t
    if connH and y>connH then return end
    if B[y  ] then t=B[y  ][x+1] if t and t.connClear and t.color==c then gc_polygon('fill',40,8  ,40,32, 30,35, 30,5 ) end end
    if B[y  ] then t=B[y  ][x-1] if t and t.connClear and t.color==c then gc_polygon('fill',0 ,8  ,0 ,32, 10,35, 10,5 ) end end
    if B[y-1] then t=B[y-1][x  ] if t and t.connClear and t.color==c then gc_polygon('fill',8 ,40, 32,40, 35,30 ,5 ,30) end end
    if connH and y+1>connH then return end
    if B[y+1] then t=B[y+1][x  ] if t and t.connClear and t.color==c then gc_polygon('fill',8 ,0 , 32,0 , 35,10 ,5 ,10) end end
end

function S.drawFieldCell(C,F,x,y,connH)
    if not C.clearing or S.getTime()%100<=50 then
        gc_setColor(NumColor[C.color])
        gc_rectangle('fill',2,2,36,36,15)
        drawSide(F,x,y,connH)
    end
end

local strokeR=3
function S.drawHandCellStroke(_,_,_,_)
    gc_setColor(.9,.9,.9)
    gc_rectangle('fill',2-strokeR,2-strokeR,36+2*strokeR,36+2*strokeR,15+strokeR)
end

function S.drawHandCell(C,B,x,y)
    gc_setColor(NumColor[C.color])
    gc_rectangle('fill',2,2,36,36,15)
    drawSide(B,x,y)
end

function S.drawNextCell(C,_,B,x,y)
    gc_setColor(NumColor[C.color])
    gc_rectangle('fill',2,2,36,36,15)
    drawSide(B,x,y)
end

return S
