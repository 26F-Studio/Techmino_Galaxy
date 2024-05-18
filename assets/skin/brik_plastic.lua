--[[
    Base on brik_template:
    Connected cells
]]
local gc=love.graphics
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle

local unpack=unpack
local NumColor=CLR9

---@type Techmino.Skin.Brik
local S={}
S.base='brik_template'

local X=3 -- Cell border width

local function drawCell(B,x,y,r,g,b,a)
    gc_setColor(r,g,b,a)
    gc_rectangle('fill',0,0,40,40)

    local U,L,D,R
    if not (B[y+1] and B[y+1][x  ]) then gc_setColor(r*.65,g*.65,b*.65,a) gc_rectangle('fill', 0, 0,40, X) U=true end
    if not (B[y  ] and B[y  ][x-1]) then gc_setColor(r*.4 ,g*.4 ,b*.4 ,a) gc_rectangle('fill', 0, 0, X,40) L=true end
    if not (B[y-1] and B[y-1][x  ]) then gc_setColor(r*.4 ,g*.4 ,b*.4 ,a) gc_rectangle('fill', 0,40,40,-X) D=true end
    if not (B[y  ] and B[y  ][x+1]) then gc_setColor(r*.65,g*.65,b*.65,a) gc_rectangle('fill',40, 0,-X,40) R=true end

    if not (U or R or B[y+1] and B[y+1][x+1]) then gc_setColor(r*.8,g*.8,b*.8,a) gc_rectangle('fill',40,0 ,-X, X) end
    if not (U or L or B[y+1] and B[y+1][x-1]) then gc_setColor(r*.5,g*.5,b*.5,a) gc_rectangle('fill',0 ,0 , X, X) end
    if not (D or R or B[y-1] and B[y-1][x+1]) then gc_setColor(r*.5,g*.5,b*.5,a) gc_rectangle('fill',40,40,-X,-X) end
    if not (D or L or B[y-1] and B[y-1][x-1]) then gc_setColor(r*.3,g*.3,b*.3,a) gc_rectangle('fill',0 ,40, X,-X) end
end

local function getCID(F,y,x)
    local line=F[y]
    return line and line[x] and line[x].cid or false
end
function S.drawFieldCell(C,F,x,y)
    local r,g,b=unpack(NumColor[C.color])
    local a=C.alpha
    gc_setColor(r,g,b,a)
    gc_rectangle('fill',0,0,40,40)

    local c=C.conn
    if c then
        local U,L,D,R
        if not c[getCID(F,y+1,x  )] then gc_setColor(r*.65,g*.65,b*.65,a) gc_rectangle('fill', 0, 0,40, X) U=true end
        if not c[getCID(F,y  ,x+1)] then gc_setColor(r*.65,g*.65,b*.65,a) gc_rectangle('fill',40, 0,-X,40) R=true end
        if not c[getCID(F,y  ,x-1)] then gc_setColor(r*.4 ,g*.4 ,b*.4 ,a) gc_rectangle('fill', 0, 0, X,40) L=true end
        if not c[getCID(F,y-1,x  )] then gc_setColor(r*.4 ,g*.4 ,b*.4 ,a) gc_rectangle('fill', 0,40,40,-X) D=true end

        if not (U or R or c[getCID(F,y+1,x+1)]) then gc_setColor(r*.8,g*.8,b*.8,a) gc_rectangle('fill',40,0 ,-X, X) end
        if not (U or L or c[getCID(F,y+1,x-1)]) then gc_setColor(r*.5,g*.5,b*.5,a) gc_rectangle('fill',0 ,0 , X, X) end
        if not (D or R or c[getCID(F,y-1,x+1)]) then gc_setColor(r*.5,g*.5,b*.5,a) gc_rectangle('fill',40,40,-X,-X) end
        if not (D or L or c[getCID(F,y-1,x-1)]) then gc_setColor(r*.3,g*.3,b*.3,a) gc_rectangle('fill',0 ,40, X,-X) end
    end
end

function S.drawFloatHoldCell(C,disabled,B,x,y)
    if disabled then
        gc_setColor(.6,.6,.6,.25)
        gc_rectangle('fill',0,0,40,40)
    else
        local r,g,b=unpack(NumColor[C.color])
        local a=S.getTime()%150/200
        drawCell(B,x,y,r,g,b,a)
    end
end

function S.drawGhostCell(C,B,x,y)
    local r,g,b=unpack(NumColor[C.color])
    drawCell(B,x,y,r,g,b,.26)
end

function S.drawHandCell(C,B,x,y)
    local r,g,b=unpack(NumColor[C.color])
    drawCell(B,x,y,r,g,b,1)
end

local disabledColor={.6,.6,.6}

function S.drawNextCell(C,disabled,B,x,y)
    local r,g,b=unpack(disabled and disabledColor or NumColor[C.color])
    drawCell(B,x,y,r,g,b,1)
end

function S.drawHoldCell(C,disabled,B,x,y)
    local r,g,b=unpack(disabled and disabledColor or NumColor[C.color])
    drawCell(B,x,y,r,g,b,1)
end

return S
