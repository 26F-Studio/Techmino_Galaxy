local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_draw,gc_line=gc.draw,gc.line
local gc_rectangle,gc_circle=gc.rectangle,gc.circle
local gc_printf=gc.printf

local max,min=math.max,math.min

local COLOR=COLOR

local S={}

local crossR,crossL=1,6
local gridMark=GC.load{45,45,
    {'setCL',1,1,1,.26},
    {'fRect',0, 0, crossL, crossR},
    {'fRect',0, 0, crossR, crossL},
    {'fRect',45,0, -crossL,crossR},
    {'fRect',45,0, -crossR,crossL},
    {'fRect',0, 45,crossL, -crossR},
    {'fRect',0, 45,crossR, -crossR-crossL},
    {'fRect',45,45,-crossL,-crossR},
    {'fRect',45,45,-crossR,-crossR-crossL},
}
function S.drawFieldBackground(fieldSize)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,45*fieldSize,-45*fieldSize)
    gc_setColor(1,1,1)
    for x=1,fieldSize do for y=1,fieldSize do
        gc_draw(gridMark,x*45-45,-y*45)
    end end
end

function S.drawSwapCursor(cx,cy)
    gc_setLineWidth(4)
    gc_setColor(1,1,1,.6)
    gc_rectangle('line',cx*45-45,-cy*45,45,45)
end

function S.drawTwistCursor(sx,sy)
    gc_setLineWidth(4)
    gc_setColor(1,1,1,.6)
    gc_circle('line',sx*45,-sy*45,50)
end

function S.drawFieldBorder()
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',-361,-361,722,722)
end

function S.drawFieldCells(F)
    local flashing=S.getTime()%60<=20
    gc_setLineWidth(3)
    for y=1,#F do for x=1,#F[1] do
        local C=F[y][x]
        if C and (not C.clearTimer or flashing) then
            local r,g,b=unpack(ColorTable[C.id*8-7])
            local dx,dy=0,0
            if C.moveTimer then
                dx,dy=C.moveTimer/C.moveDelay*C.dx,C.moveTimer/C.moveDelay*C.dy
            end
            gc_setColor(r,g,b)
            gc_rectangle('line',(x+dx)*45-37,-(y+dy)*45+8,29,29)
            gc_setColor(r,g,b,.6)
            gc_rectangle('fill',(x+dx)*45-37,-(y+dy)*45+8,29,29)
        end
    end end
end

function S.drawGarbageBuffer(garbageBuffer)
    local y=0
    for i=1,#garbageBuffer do
        local g=garbageBuffer[i]
        local h=g.power*45
        if y+h>800 then
            h=800-y
        end
        if g.time<g.time0 then
            gc_setColor(COLOR.R)
            gc_rectangle('fill',370,360-y-h+3,10,h-6)
            gc_setColor(COLOR.L)
            local progress=g.time/g.time0
            gc_rectangle('fill',370,360-y-h+3+(h-6)*(1-progress),10,(h-6)*progress)
        else
            gc_setColor(S.getTime()%100<50 and COLOR.R or COLOR.L)
            gc_rectangle('fill',370,360-y-h+3,10,h-6)
        end
        y=y+h
        if y>=800 then break end
    end
end

function S.drawTime(time)
    gc_setColor(COLOR.dL)
    FONT.set(30)
    gc_printf(("%.3f"):format(time/1000),-370-260,330,260,'right')
end

function S.drawStartingCounter(readyDelay)
    gc_push('transform')
    local num=math.floor((readyDelay-S.getTime())/1000)+1
    local r,g,b
    local d=1-S.getTime()%1000/1000-- from .999 to 0

    if     num==1 then r,g,b=1.00,0.70,0.70 if d>.75 then gc_scale(1,1+(d/.25-3)^2) end
    elseif num==2 then r,g,b=0.98,0.85,0.75 if d>.75 then gc_scale(1+(d/.25-3)^2,1) end
    elseif num==3 then r,g,b=0.70,0.80,0.98 if d>.75 then gc_rotate((d-.75)^3*40) end
    elseif num==4 then r,g,b=0.95,0.93,0.50
    elseif num==5 then r,g,b=0.70,0.95,0.70
    else  r,g,b=max(1.26-num/10,0),max(1.26-num/10,0),max(1.26-num/10,0)
    end

    FONT.set(100)

    -- Warping number
    gc_push('transform')
        gc_scale((1.5-d*.6)^1.5)
        gc_setColor(r,g,b,d)
        GC.mStr(num,0,-70)
        gc_setColor(1,1,1,1.5*d-0.5)
        GC.mStr(num,0,-70)
    gc_pop()

    -- Scaling + Fading number
    gc_scale(min(d/.333,1)^.4)
    gc_setColor(r,g,b)
    GC.mStr(num,0,-70)
    gc_setColor(1,1,1,1.5*d-0.5)
    GC.mStr(num,0,-70)
    gc_pop()
end

return S
