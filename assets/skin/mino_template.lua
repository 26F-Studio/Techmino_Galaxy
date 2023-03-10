--[[
    Pure color cells
    All basic components
    Animated starting counter
]]
local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_draw,gc_line=gc.draw,gc.line
local gc_rectangle=gc.rectangle
local gc_printf=gc.printf

local max,min=math.max,math.min

local COLOR=COLOR

local S={}

local crossR,crossL=1,6
local gridMark=GC.load{40,40,
    {'setCL',1,1,1,.26},
    {'fRect',0, 0, crossL, crossR},
    {'fRect',0, 0, crossR, crossL},
    {'fRect',40,0, -crossL,crossR},
    {'fRect',40,0, -crossR,crossL},
    {'fRect',0, 40,crossL, -crossR},
    {'fRect',0, 40,crossR, -crossR-crossL},
    {'fRect',40,40,-crossL,-crossR},
    {'fRect',40,40,-crossR,-crossR-crossL},
}
function S.drawFieldBackground(fieldW)
    gc_setColor(0,0,0,.42)
    gc_rectangle('fill',0,0,40*fieldW,-80*fieldW)
    gc_setColor(1,1,1)
    for x=1,fieldW do for y=1,2*fieldW do
        gc_draw(gridMark,x*40-40,-y*40)
    end end
end

function S.drawFieldBorder()
    gc_setLineWidth(2)
    gc_setColor(1,1,1)
    gc_line(-201,-401,-201,401,201,401,201,-401)
    gc_setColor(1,1,1,.626)
    gc_line(-201,-401,-181,-401)
    gc_line(201,-401,181,-401)
end

function S.fallingCurve(t) return t end
function S.drawFieldCells(F,y)
    for x=1,#F[1] do
        local C=F[y][x]
        if C then
            local r,g,b=unpack(ColorTable[C.color])
            gc_setColor(r,g,b,C.alpha)
            gc_rectangle('fill',(x-1)*40,-y*40,40,40)
        end
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
        for y=1,#B do for x=1,#B[1] do
            if B[y][x] then
                local r,g,b=unpack(ColorTable[B[y][x].color])
                gc_setColor(r,g,b,S.getTime()%150/200)
                gc_rectangle('fill',(handX+x-2)*40,-(handY+y-1)*40,40,40)
            end
        end end
    end
    FONT.set(50)
    gc_setColor(unavailable and COLOR.DL or COLOR.L)
    GC.mStr(n,(handX-1+#B[1]/2)*40,-(handY+#B/2)*40+5)
end

function S.drawHeightLines(fieldW,maxSpawnH,spawnH,lockoutH,deathH,voidH)
    gc_setColor(.0,.4,1.,S.getTime()%600<300 and .3 or .5) gc_rectangle('fill',0,-maxSpawnH-1 ,fieldW,2)
    gc_setColor(.0,.4,1.,.8) gc_rectangle('fill',0,-spawnH   -1 ,fieldW,2)
    gc_setColor(1.,.5,.0,.6) gc_rectangle('fill',0,-lockoutH -1 ,fieldW,2)
    gc_setColor(1.,.0,.0,.6) gc_rectangle('fill',0,-deathH   -1 ,fieldW,2)
    gc_setColor(.0,.0,.0,.6) gc_rectangle('fill',0,-voidH    -40,fieldW,40)
end

function S.drawDasIndicator(dir,charge,dasMax,arrMax,dasHalt)
    if not dir then return end

    if charge>0 then
        gc_setColor(1,1,1,min(charge/dasMax,1)*.4)
        gc_rectangle('fill',202*dir,401,5*dir*min(charge/dasMax,1),-800)
        if charge>dasMax then
            gc_setColor(0,.62,1,.4)
            gc_rectangle('fill',202*dir,401,5*dir,-800*min((charge-dasMax)/arrMax%1,1))
        end
    else
        gc_setColor(1,0,.62,.5)
        gc_rectangle('fill',202*dir,401,5*dir,-800*charge/(dasMax-dasHalt))
    end
end

function S.drawDelayIndicator(color,value)
    gc_setColor(color)
    gc_rectangle('fill',-199,403,398*math.min(value,1),8)

    gc_setLineWidth(2)
    gc_setColor(1,1,1)
    gc_rectangle('line',-201,401,402,12)
end

function S.drawGarbageBuffer(garbageBuffer)
    local y=0
    for i=1,#garbageBuffer do
        local g=garbageBuffer[i]
        local h=g.power*40
        if y+h>800 then
            h=800-y
        end
        if g.time<g.time0 then
            gc_setColor(COLOR.R)
            gc_rectangle('fill',210,400-y-h+3,10,h-6)
            gc_setColor(COLOR.L)
            local progress=g.time/g.time0
            gc_rectangle('fill',210,400-y-h+3+(h-6)*(1-progress),10,(h-6)*progress)
        else
            gc_setColor(S.getTime()%100<50 and COLOR.R or COLOR.L)
            gc_rectangle('fill',210,400-y-h+3,10,h-6)
        end
        y=y+h
        if y>=800 then break end
    end
end

function S.drawLockDelayIndicator(freshCondition,freshChance)
    if freshChance>0 then
        gc_setColor(
            freshCondition=='any' and COLOR.dL or
            freshCondition=='fall' and COLOR.R or
            freshCondition=='none' and COLOR.D or
            COLOR.random(4)
        )
        for i=1,min(freshChance,15) do gc_rectangle('fill',-218+26*i-1,420-1,20+2,5+2) end
        gc_setColor(COLOR.hsv(min((freshChance-1)/14,1)/2.6,.4,.9))
        for i=1,min(freshChance,15) do gc_rectangle('fill',-218+26*i,420,20,5) end
    end
end

function S.drawGhost(B,handX,ghostY)
    gc_setColor(1,1,1,.162)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_rectangle('fill',(handX+x-2)*40,-(ghostY+y-1)*40,40,40)
        end
    end end
end

function S.drawHand(B,handX,handY)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            gc_setColor(ColorTable[B[y][x].color])
            gc_rectangle('fill',(handX+x-2)*40,-(handY+y-1)*40,40,40)
        end
    end end
end

function S.drawNextBorder(slot)
    gc_setColor(0,0,0,.26)
    gc_rectangle('fill',30,0,140,100*slot)
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',30,0,140,100*slot)
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
                gc_setColor(ColorTable[B[y][x].color])
                gc_rectangle('fill',(x-#B[1]/2-1)*40,(y-#B/2)*-40,40,40)
            end
        end end
    end
    gc_pop()
end

function S.drawHoldBorder(mode,slot)
    gc_setLineWidth(2)
    if mode=='hold' then
        gc_setColor(0,0,0,.26)
        gc_rectangle('fill',-170,0,140,100*slot)
        gc_setColor(COLOR.L)
        gc_rectangle('line',-170,0,140,100*slot)
    elseif mode=='swap' then
        gc_setColor(0,0,0,.26)
        gc_rectangle('fill',430,0,140,100*slot)
        gc_setColor(COLOR.L)
        gc_rectangle('line',430,0,140,100*slot)
    end
end

function S.drawHold(n,B,unavailable)
    gc_push('transform')
    gc_translate(-100,100*n-50)
    gc_scale(min(2.3/#B,3/#B[1],.86))
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            if unavailable then
                gc_setColor(.6,.6,.6)
            else
                gc_setColor(ColorTable[B[y][x].color])
            end
            gc_rectangle('fill',(x-#B[1]/2-1)*40,(y-#B/2)*-40,40,40)
        end
    end end
    gc_pop()
end

function S.drawTime(time)
    gc_setColor(COLOR.dL)
    FONT.set(30)
    gc_printf(("%.3f"):format(time/1000),-210-260,380,260,'right')
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
