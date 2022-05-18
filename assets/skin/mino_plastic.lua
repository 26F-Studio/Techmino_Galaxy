local gc=love.graphics
local gc_translate,gc_scale=gc.translate,gc.scale
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle

local min=math.min

local COLOR=COLOR

local S={}
S.base='mino_default'

local X=3-- Border width

local function drawSide(B,x,y,bx,by)
    local U,D,L,R
    if not (B[y  ] and B[y  ][x+1]) then gc_rectangle('fill',bx+40 ,by   ,-X,40) R=true end
    if not (B[y  ] and B[y  ][x-1]) then gc_rectangle('fill',bx    ,by   ,X ,40) L=true end
    if not (B[y-1] and B[y-1][x  ]) then gc_rectangle('fill',bx    ,by+40,40,-X) D=true end
    if not (B[y+1] and B[y+1][x  ]) then gc_rectangle('fill',bx    ,by   ,40, X) U=true end

    if not (D or L or B[y-1] and B[y-1][x-1]) then gc_rectangle('fill',bx     ,by+40,X ,-X) end
    if not (U or L or B[y+1] and B[y+1][x-1]) then gc_rectangle('fill',bx     ,by   ,X , X) end
    if not (D or R or B[y-1] and B[y-1][x+1]) then gc_rectangle('fill',bx+40  ,by+40,-X,-X) end
    if not (U or R or B[y+1] and B[y+1][x+1]) then gc_rectangle('fill',bx+40  ,by   ,-X, X) end
end


function S.drawFieldCells(F)
    F=F._matrix
    for y=1,#F do for x=1,#F[1] do
        local C=F[y][x]
        if C then
            local bx,by=(x-1)*40,-y*40
            local r,g,b=unpack(ColorTable[C.color])
            gc_setColor(r,g,b)
            gc_rectangle('fill',bx,by,40,40)

            gc_setColor(r*.5,g*.5,b*.5)
            -- Reuse local var g,b
            g=C.nearby
            local U,D,L,R
            if not (g and g[F[y  ] and F[y  ][x+1]]) then gc_rectangle('fill',bx+40-X,by   ,X ,40) R=true end
            if not (g and g[F[y  ] and F[y  ][x-1]]) then gc_rectangle('fill',bx     ,by   ,X ,40) L=true end
            if not (g and g[F[y-1] and F[y-1][x  ]]) then gc_rectangle('fill',bx     ,by+40,40,-X) D=true end
            if not (g and g[F[y+1] and F[y+1][x  ]]) then gc_rectangle('fill',bx     ,by   ,40, X) U=true end

            if not (D or L or g[F[y-1] and F[y-1][x-1]]) then gc_rectangle('fill',bx     ,by+40,X ,-X) end
            if not (U or L or g[F[y+1] and F[y+1][x-1]]) then gc_rectangle('fill',bx     ,by   ,X , X) end
            if not (D or R or g[F[y-1] and F[y-1][x+1]]) then gc_rectangle('fill',bx+40-X,by+40,X ,-X) end
            if not (U or R or g[F[y+1] and F[y+1][x+1]]) then gc_rectangle('fill',bx+40-X,by   ,X , X) end
        end
    end end
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
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                local bx,by=(handX+x-2)*40,-(handY+y-1)*40
                local r,g,b=unpack(ColorTable[B[y][x].color])
                gc_setColor(r,g,b,S.getTime()%150/200)
                gc_rectangle('fill',bx,by,40,40)

                gc_setColor(r*.5,g*.5,b*.5,S.getTime()%150/200)
                drawSide(B,x,y,bx,by)
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
            gc_setColor(1,1,1,.26)
            gc_rectangle('fill',(handX+x-2)*40,-(ghostY+y-1)*40,40,40)
            drawSide(B,x,y,(handX+x-2)*40,-(ghostY+y-1)*40)
        end
    end end
end

function S.drawHand(B,handX,handY)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            local bx,by=(handX+x-2)*40,-(handY+y-1)*40
            local r,g,b=unpack(ColorTable[B[y][x].color])
            gc_setColor(r,g,b)
            gc_rectangle('fill',bx,by,40,40)

            gc_setColor(r*.5,g*.5,b*.5)
            drawSide(B,x,y,bx,by)
        end
    end end
end

function S.drawNext(n,B,unavailable)
    gc.push('transform')
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
                local bx,by=(x-#B[1]/2-1)*40,(y-#B/2)*-40
                local r,g,b=unpack(ColorTable[B[y][x].color])
                gc_setColor(r,g,b)
                gc_rectangle('fill',bx,by,40,40)

                gc_setColor(r*.5,g*.5,b*.5)
                drawSide(B,x,y,bx,by)
            end
        end end
    end
    gc.pop()
end

function S.drawHold(n,B,unavailable)
    gc.push('transform')
    gc_translate(-100,100*n-50)
    gc_scale(min(2.3/#B,3/#B[1],.86))
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            local bx,by=(x-#B[1]/2-1)*40,(y-#B/2)*-40
            local r,g,b
            if unavailable then
                r,g,b=.6,.6,.6
            else
                r,g,b=unpack(ColorTable[B[y][x].color])
            end

            gc_setColor(r,g,b)
            gc_rectangle('fill',bx,by,40,40)

            gc_setColor(r*.5,g*.5,b*.5)
            drawSide(B,x,y,bx,by)
        end
    end end
    gc.pop()
end

return S
