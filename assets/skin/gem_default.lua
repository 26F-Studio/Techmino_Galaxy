local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_draw=gc.draw
local gc_rectangle,gc_circle,gc_polygon=gc.rectangle,gc.circle,gc.polygon
local gc_printf=gc.printf

local max,min=math.max,math.min

local COLOR=COLOR

local S={}

local crossR,crossL=1,6
local gridMark=GC.load{45,45,
    {'setCL',1,1,1,.42},
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

function S.drawSwapCursor(cx,cy,lock)
    gc_setLineWidth(lock and 4 or 2)
    gc_setColor(1,1,1,lock and .8 or .6)
    gc_rectangle('line',cx*45-45,-cy*45,45,45)
end

function S.drawTwistCursor(sx,sy)
    gc_setLineWidth(2)
    gc_setColor(1,1,1,.6)
    gc_circle('line',sx*45,-sy*45,50)
end

function S.drawFieldBorder()
    gc_setLineWidth(2)
    gc_setColor(COLOR.L)
    gc_rectangle('line',-361,-361,722,722)
end

local gemShapes={
    {-- Red Square
        color={COLOR.hsv(.97,.9,1,.5)},
        coords={
            -16,-10,
            -10,-16,
            10,-16,
            16,-10,
            16,10,
            10,16,
            -10,16,
            -16,10,
        },
    },
    {-- Orange Hexagon
        color={COLOR.hsv(.1,.9,1,.5)},
        coords=(function()
            local l={}
                for i=0,5 do
                    table.insert(l,18*math.cos(-MATH.pi/2+MATH.tau*i/6))
                    table.insert(l,18*math.sin(-MATH.pi/2+MATH.tau*i/6))
                end
            return l
        end)()
    },
    {-- Yellow Rhombus
        color={COLOR.hsv(.18,.9,1,.5)},
        coords=(function()
            local l={}
                for i=0,3 do
                    table.insert(l,17*math.cos(MATH.tau*i/4))
                    table.insert(l,17*math.sin(MATH.tau*i/4))
                end
            return l
        end)()
    },
    {-- Green Octagon
        color={COLOR.hsv(.33,.85,.9,.5)},
        coords=(function()
            local l={}
                for i=0,5 do
                    table.insert(l,18*math.cos(MATH.tau*i/6))
                    table.insert(l,18*math.sin(MATH.tau*i/6))
                end
            return l
        end)()
    },
    {-- Blue Diamond
        color={COLOR.hsv(.58,1,1,.5)},
        coords={
            0,18,
            17,-5,
            8,-16,
            -8,-16,
            -17 ,-5,
        },
    },
    {-- Magenta Triangle
        color={COLOR.hsv(.86,.9,1,.5)},
        coords={
            0,-15,
            16,15,
            -16,15,
        },
    },
    {-- White Circle
        color={COLOR.hsv(0,0,1,.5)},
        coords=(function()
            local l={}
                for i=0,15 do
                    table.insert(l,16*math.cos(MATH.tau*i/16))
                    table.insert(l,16*math.sin(MATH.tau*i/16))
                end
            return l
        end)()
    },
}
for i=1,#gemShapes do
    gemShapes[i].lineColor=TABLE.shift(gemShapes[i].color)
    gemShapes[i].lineColor[4]=nil
end
local function drawGem(g)
    local id=g.id
    gc_setColor(gemShapes[id].lineColor)
    gc_polygon('line',gemShapes[id].coords)
    gc_setColor(gemShapes[id].color)
    gc_polygon('fill',gemShapes[id].coords)
    if g.explodeStyle then
        gc_setColor(g.explodeStyle==1 and COLOR.O or COLOR.lC)
        gc_circle('line',0,0,5+.5*math.sin(S.getTime()*.01))
    end
end
function S.drawFieldCells(F)
    gc_setLineWidth(2)
    for y=1,#F do for x=1,#F[1] do
        local G=F[y][x]
        if G then
            gc_push('transform')
            if G.moveTimer then
                local d=G.moveTimer/G.moveDelay
                if G.fall then
                    d=-d*(d-2)
                else
                    d=-math.cos(d*math.pi)/2+.5
                end
                gc_translate(45*(x+d*G.dx)-22.5,-45*(y+d*G.dy)+22.5)
            else
                gc_translate(45*x-22.5,-45*y+22.5)
            end
            if G.clearTimer and not G.generate then
                local i=G.clearTimer/G.clearDelay
                gc_scale(-2*i^2+3*i)
            end
            drawGem(G)
            gc_pop()
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
