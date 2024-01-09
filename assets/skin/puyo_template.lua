local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate=gc.translate
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
    local flashing=S.getTime()%100<=50
    if C and (not C.clearing or flashing) then
        gc_setColor(ColorTable[C.color])
        gc_rectangle('fill',x,y,36,36,15)
    end
end

function S.drawGhost(B,handX,ghostY)
    gc_setColor(1,1,1,.162)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_rectangle('fill',(handX+x-2)*40+2,-(ghostY+y-1)*40+2,36,36,15)
        end
    end end
end

local strokeR=4
function S.drawHandStroke(B,handX,handY)
    gc_setColor(1,1,1)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_rectangle('fill',(handX+x-2)*40+2-strokeR,-(handY+y-1)*40+2-strokeR,36+2*strokeR,36+2*strokeR,15)
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
