local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate=gc.translate
local gc_setColor=gc.setColor
local gc_rectangle=gc.rectangle
local gc_setLineWidth=gc.setLineWidth

local S={}
S.base='mino_template'

function S.drawFieldBackground(fieldW)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,40*fieldW,-80*fieldW)
end

function S.drawFieldCells(F)
    F=F._matrix
    local flashing=S.getTime()%100<=50
    for y=1,#F do for x=1,#F[1] do
        local C=F[y][x]
        if C and (not C.clearing or flashing) then
            gc_setColor(ColorTable[C.color])
            gc_rectangle('fill',(x-1)*40+2,-y*40+2,36,36,15)
        end
    end end
end

function S.drawGhost(B,handX,ghostY)
    gc_setColor(1,1,1,.162)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_rectangle('fill',(handX+x-2)*40+2,-(ghostY+y-1)*40+2,36,36,15)
        end
    end end
end

function S.drawHand(B,handX,handY)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_setColor(ColorTable[B[y][x].color])
            gc_rectangle('fill',(handX+x-2)*40+2,-(handY+y-1)*40+2,36,36,15)
        end
    end end
end

function S.drawNextBorder(slot)
    gc_setColor(0,0,0,.26)
    gc_rectangle('fill',30,0,100,100*slot)
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',30,0,100,100*slot)
end

function S.drawNext(n,B)
    gc_push('transform')
    gc_translate(80,100*n-50)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_setColor(ColorTable[B[y][x].color])
            gc_rectangle('fill',(x-#B[1]/2-1)*40+2,(y-#B/2)*-40,36,36,15)
        end
    end end
    gc_pop()
end

return S
