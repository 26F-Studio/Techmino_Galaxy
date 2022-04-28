local gc=love.graphics
local max,min=math.max,math.min

local S={
    nextPosX=300,
    nextPosY=-400+50,
    nextStep=100,
    holdPosX=-300,
    holdPosY=-400+50,
    holdStep=100,
}

function S.drawFieldGrid(fieldW,gridHeight)
    gc.setColor(1,1,1,.26)
    local rad,len=1,6-- Line width/length
    for x=1,fieldW do
        x=(x-1)*40
        for y=1,gridHeight do
            y=-y*40
            gc.rectangle('fill',x,y,len,rad)
            gc.rectangle('fill',x,y+rad,rad,len-rad)
            gc.rectangle('fill',x+40,y,-len,rad)
            gc.rectangle('fill',x+40,y+rad,-rad,len-rad)
            gc.rectangle('fill',x,y+40,len,-rad)
            gc.rectangle('fill',x,y+40-rad,rad,rad-len)
            gc.rectangle('fill',x+40,y+40,-len,-rad)
            gc.rectangle('fill',x+40,y+40-rad,-rad,rad-len)
        end
    end
end
function S.drawFieldBorder()
    gc.setLineWidth(2)
    gc.setColor(1,1,1)
    gc.line(-201,-401,-201, 401,201, 401,201,-401)
    gc.setColor(1,1,1,.626)
    gc.line(-201,-401,201,-401)
end

function S.drawFieldCells(F)
    for y=1,F:getHeight() do for x=1,F:getWidth() do
        local C=F:getCell(x,y)
        if C then
            gc.setColor(ColorTable[C.color])
            gc.rectangle('fill',(x-1)*40,-y*40,40,40)
        end
    end end
end

function S.drawFloatHold(B,handX,handY,unavailable)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            if unavailable then
                gc.setColor(.6,.6,.6,.25)
            else
                local r,g,b=unpack(ColorTable[B[y][x].color])
                gc.setColor(r,g,b,.25)
            end

            gc.rectangle('fill',(handX+x-2)*40,-(handY+y-1)*40,40,40)
        end
    end end
end

function S.drawHeightLines(fieldW,spawnH,lockoutH,deathH,voidH)
    gc.setColor(.0,.4,1.,.8) gc.rectangle('fill',0,-spawnH  -2 ,fieldW,4 )
    gc.setColor(1.,.5,.0,.6) gc.rectangle('fill',0,-lockoutH-2 ,fieldW,4 )
    gc.setColor(1.,.0,.0,.6) gc.rectangle('fill',0,-deathH  -2 ,fieldW,4 )
    gc.setColor(.0,.0,.0,.6) gc.rectangle('fill',0,-voidH   -40,fieldW,40)
end

function S.drawDelayIndicator(mode,value)
    gc.setLineWidth(2)
    gc.setColor(1,1,1)
    gc.rectangle('line',-201,401,402,12)

    if mode=='spawn' then
        gc.setColor(COLOR.lB)
    elseif mode=='death' then
        gc.setColor(COLOR.R)
    elseif mode=='drop' then
        gc.setColor(COLOR.lG)
    elseif mode=='lock' then
        gc.setColor(COLOR.L)
    end
    gc.rectangle('fill',-199,403,398*math.min(value,1),8)
end

function S.drawLockDelayIndicator(freshCondition,freshChance)
    if freshChance>0 then
        gc.setColor(
            freshCondition=='any' and COLOR.dL or
            freshCondition=='fall' and COLOR.R or
            freshCondition=='none' and COLOR.D or
            COLOR.random(4)
        )
        for i=1,min(freshChance,15) do gc.rectangle('fill',-218+26*i-1,420-1,20+2,5+2) end
        gc.setColor(COLOR.hsv(min((freshChance-1)/14,1)/2.6,.4,.9))
        for i=1,min(freshChance,15) do gc.rectangle('fill',-218+26*i,420,20,5) end
    end
end

function S.drawGhost(CB,handX,ghostY)
    gc.setColor(1,1,1,.26)
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            gc.rectangle('fill',(handX+x-2)*40,-(ghostY+y-1)*40,40,40)
        end
    end end
end

function S.drawHand(CB,handX,handY)
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            gc.setColor(ColorTable[CB[y][x].color])
            gc.rectangle('fill',(handX+x-2)*40,-(handY+y-1)*40,40,40)
        end
    end end
end

function S.drawNext(B,unavailable)
    local k=min(2.3/#B,3/#B[1],.86)
    gc.scale(k)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            if unavailable then
                gc.setColor(.6,.6,.6)
            else
                gc.setColor(ColorTable[B[y][x].color])
            end
            gc.rectangle('fill',(x-#B[1]/2-1)*40,(y-#B/2)*-40,40,40)
        end
    end end
    gc.scale(1/k)
end

function S.drawHold(B,unavailable)
    local k=min(2.3/#B,3/#B[1],.86)
    gc.scale(k)
    for y=1,#B do for x=1,#B[1] do
        if B[y][x] then
            if unavailable then
                gc.setColor(.6,.6,.6)
            else
                gc.setColor(ColorTable[B[y][x].color])
            end
            gc.rectangle('fill',(x-#B[1]/2-1)*40,(y-#B/2)*-40,40,40)
        end
    end end
    gc.scale(1/k)
end

function S.drawTime(time)
    gc.setColor(COLOR.dL)
    FONT.set(30)
    gc.printf(("%.3f"):format(time/1000),-210-260,380,260,'right')
end

function S.drawStartingCounter(readyDelay,time)
    gc.push('transform')
    local num=math.floor((readyDelay-time)/1000)+1
    local r,g,b
    local d=1-time%1000/1000-- from .999 to 0

    if     num==1 then r,g,b=1.00,0.70,0.70 if d>.75 then gc.scale(1,1+(d/.25-3)^2) end
    elseif num==2 then r,g,b=0.98,0.85,0.75 if d>.75 then gc.scale(1+(d/.25-3)^2,1) end
    elseif num==3 then r,g,b=0.70,0.80,0.98 if d>.75 then gc.rotate((d-.75)^3*40) end
    elseif num==4 then r,g,b=0.95,0.93,0.50
    elseif num==5 then r,g,b=0.70,0.95,0.70
    else  r,g,b=max(1.26-num/10,0),max(1.26-num/10,0),max(1.26-num/10,0)
    end

    FONT.set(100)

    -- Warping number
    gc.push('transform')
        gc.scale((1.5-d*.6)^1.5)
        gc.setColor(r,g,b,d)
        GC.mStr(num,0,-70)
        gc.setColor(1,1,1,1.5*d-0.5)
        GC.mStr(num,0,-70)
    gc.pop()

    -- Scaling + Fading number
    gc.scale(min(d/.333,1)^.4)
    gc.setColor(r,g,b)
    GC.mStr(num,0,-70)
    gc.setColor(1,1,1,1.5*d-0.5)
    GC.mStr(num,0,-70)
    gc.pop()
end

return S
