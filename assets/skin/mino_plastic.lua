--[[
    Base on mino_template:
    Connected cells
]]
local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale=gc.translate,gc.scale
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle

local min=math.min

local COLOR=COLOR

---@type Techmino.skin.mino
local S={}
S.base='mino_template'

local X=3 -- Cell border width

local function drawCell(B,x,y,bx,by,r,g,b,a)
    gc_translate(bx,by)
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
    gc_translate(-bx,-by)
end

local function getCID(F,y,x)
    local line=F[y]
    return line and line[x] and line[x].cid or false
end
function S.drawFieldCell(C,F,x,y)
    -- local bx,by=(x-1)*40,-y*40
    local r,g,b=unpack(ColorTable[C.color])
    local a=C.alpha or 1
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

function S.drawFloatHold(n,B,handX,handY,unavailable)
    if unavailable then
        gc_setColor(.6,.6,.6,.25)
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                gc_rectangle('fill',(handX+x-2)*40,-(handY+y-1)*40,40,40)
            end
        end end
    else
        local a=S.getTime()%150/200
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                local r,g,b=unpack(ColorTable[B[y][x].color])
                drawCell(B,x,y,(handX+x-2)*40,-(handY+y-1)*40,r,g,b,a)
            end
        end end
    end
    FONT.set(50)
    gc_setColor(unavailable and COLOR.DL or COLOR.L)
    GC.mStr(n,(handX-1+#B[1]/2)*40,-(handY+#B/2)*40+5)
end


function S.drawGhost(B,handX,ghostY)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            drawCell(B,x,y,(handX+x-2)*40,-(ghostY+y-1)*40,1,1,1,.26)
        end
    end end
end

function S.drawHand(B,handX,handY)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            local r,g,b=unpack(ColorTable[B[y][x].color])
            drawCell(B,x,y,(handX+x-2)*40,-(handY+y-1)*40,r,g,b,1)
        end
    end end
end

function S.drawNext(n,B,unavailable)
    gc_push('transform')
    gc_translate(100,100*n-50)
    gc_scale(min(2.3/#B,3/#B[1],.86))
    if unavailable then
        gc_setColor(.6,.6,.6)
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                gc_rectangle('fill',(x-#B[1]/2-1)*40,(y-#B/2)*-40,40,40)
            end
        end end
    else
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                local r,g,b=unpack(ColorTable[B[y][x].color])
                drawCell(B,x,y,(x-#B[1]/2-1)*40,(y-#B/2)*-40,r,g,b,1)
            end
        end end
    end
    gc_pop()
end

function S.drawHold(n,B,unavailable)
    gc_push('transform')
    gc_translate(-100,100*n-50)
    gc_scale(min(2.3/#B,3/#B[1],.86))
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            local r,g,b
            if unavailable then
                r,g,b=.6,.6,.6
            else
                r,g,b=unpack(ColorTable[B[y][x].color])
            end

            drawCell(B,x,y,(x-#B[1]/2-1)*40,(y-#B/2)*-40,r,g,b,1)
        end
    end end
    gc_pop()
end

return S
