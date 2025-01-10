--[[
    Base on brik_template:
]]
local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_scale,gc_rotate=gc.scale,gc.rotate
local gc_setColor,gc_setLineWidth=gc.setColor,gc.setLineWidth
local gc_draw,gc_line=gc.draw,gc.line
local gc_rectangle,gc_circle,gc_polygon=gc.rectangle,gc.circle,gc.polygon
local gc_setShader=gc.setShader

local stc_reset,stc_rect,stc_stop=GC.stc_reset,GC.stc_rect,GC.stc_stop

local max,min=math.max,math.min

local COLOR=COLOR
local RGB9=RGB9

---@type Techmino.Skin.Brik
local S={}
S.base='brik_template'

local X=5 -- Cell border width

local function drawCell(B,x,y,r,g,b,a)
    gc_setColor(r,g,b,a)
    gc_rectangle('fill',0,0,40,40)
    gc_setColor(r*.8,g*.8,b*.8,a)
    gc_polygon('fill',X,X,X,40-X,15,40-X,25,X)

    gc_circle('fill',28,20+6,4)
    gc_setColor(r,g,b,a)
    gc_circle('fill',12,20-6,4)

    gc_setColor(r*.626,g*.626,b*.626,(B[y+1] and B[y+1][x  ]) and a*0.3 or a) gc_rectangle('fill', 0, 0,40, X)
    gc_setColor(r*.626,g*.626,b*.626,(B[y  ] and B[y  ][x-1]) and a*0.3 or a) gc_rectangle('fill', 0, 0, X,40)
    gc_setColor(r*.626,g*.626,b*.626,(B[y-1] and B[y-1][x  ]) and a*0.3 or a) gc_rectangle('fill', 0,40,40,-X)
    gc_setColor(r*.626,g*.626,b*.626,(B[y  ] and B[y  ][x+1]) and a*0.3 or a) gc_rectangle('fill',40, 0,-X,40)
end
local crossR=1
local gridMark=(function()
    local l={w=40,h=40}
    for x=0,39 do
        table.insert(l,{'setCL',1,1,1,.062+(math.abs(19.5-x)/62)^1.62})
        table.insert(l,{'fRect',x,0, 1,crossR})
        table.insert(l,{'fRect',x,39,1,crossR})
    end
    for y=1,38 do
        table.insert(l,{'setCL',1,1,1,.062+(math.abs(19.5-y)/62)^1.62})
        table.insert(l,{'fRect',0, y,crossR,1})
        table.insert(l,{'fRect',39,y,crossR,1})
    end
    return GC.load(l)
end)()
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

    gc_setColor(1,.6,.6,.626)
    gc_line(-201,-401,-181,-401)

    gc_setColor(1,.7,.7)
    gc_line(-201,-401,-201,401)
    gc_setColor(1,.8,.8)
    gc_line(-201,401,201,401)
    gc_setColor(1,.9,.9)
    gc_line(201,401,201,-401)

    gc_setColor(1,1,1,.626)
    gc_line(201,-401,181,-401)
end

local function getCID(F,y,x)
    local line=F[y]
    return line and line[x] and line[x].cid or false
end
function S.drawFieldCell(C,F,x,y)
    local r,g,b=unpack(RGB9[C.color])
    local a=C.alpha or 1
    gc_setColor(r,g,b,a)
    gc_rectangle('fill',0,0,40,40)
    gc_setColor(r*.8,g*.8,b*.8,a)
    gc_polygon('fill',X,X,X,40-X,15,40-X,25,X)

    gc_circle('fill',28,20+6,4)
    gc_setColor(r,g,b,a)
    gc_circle('fill',12,20-6,4)

    local c=C.conn
    if c then
        gc_setColor(r*.626,g*.626,b*.626,c[getCID(F,y+1,x  )] and a*.3 or a) gc_rectangle('fill', 0, 0,40, X)
        gc_setColor(r*.626,g*.626,b*.626,c[getCID(F,y  ,x+1)] and a*.3 or a) gc_rectangle('fill',40, 0,-X,40)
        gc_setColor(r*.626,g*.626,b*.626,c[getCID(F,y  ,x-1)] and a*.3 or a) gc_rectangle('fill', 0, 0, X,40)
        gc_setColor(r*.626,g*.626,b*.626,c[getCID(F,y-1,x  )] and a*.3 or a) gc_rectangle('fill', 0,40,40,-X)
    end
end
-- function S.drawFloatHold(C,disabled,B,handX,handY)
--     -- TODO
-- end
-- function S.drawHeightLines(fieldW,maxSpawnH,spawnH,lockoutH,deathH,voidH)
--     -- TODO
-- end
-- function S.drawAsdIndicator(dir,charge,asdMax,aspMax,ash)
--     -- TODO
-- end
-- function S.drawDelayIndicator(color,value)
--     -- TODO
-- end
-- function S.drawGarbageBuffer(garbageBuffer)
--     -- TODO
-- end
local batch=gc.newSpriteBatch(TEX.touhou.orb,15)
for i=1,15 do batch:add(-214+26*i,418) end
local color2map={
    any=COLOR.L,
    fall=COLOR.R,
    none=COLOR.D,
}
function S.drawLockDelayIndicator(freshCondition,freshChance,timeRem)
    if timeRem>0 then
        gc_setColor(COLOR.HSV(timeRem/2.6,.4,.9,.62))
        gc_rectangle('fill',-200,415,400*timeRem,22)
    end
    if freshChance>0 then
        gc_setColor(1,1,1,.42)
        for i=1,freshChance do gc_rectangle('fill',-214+26*i,418,16,16) end

        stc_reset()
        stc_rect(-200,415,400*timeRem,22)
        SHADER.dualColor:send('color1',COLOR.HSV((freshChance-1)/14/2.6,.6,.8))
        SHADER.dualColor:send('color2',unpack(color2map[freshCondition]))
        gc_setShader(SHADER.dualColor)
        batch:setDrawRange(1,freshChance)
        gc_draw(batch)
        gc_setShader()
        stc_stop()
    end
end

function S.drawGhostCell(C,B,x,y)
    local r,g,b=unpack(RGB9[C.color])
    drawCell(B,x,y,r,g,b,.26)
end

function S.drawHandCell(C,B,x,y)
    local r,g,b=unpack(RGB9[C.color])
    drawCell(B,x,y,r,g,b,1)
end

local disabledColor={.6,.6,.6}

-- function S.drawNextBorder(mode)
--     TODO
-- end
function S.drawNextCell(C,disabled,B,x,y)
    local r,g,b=unpack(disabled and disabledColor or RGB9[C.color])
    drawCell(B,x,y,r,g,b,1)
end

function S.drawHoldBorder(mode,slot)
    if slot<=0 then return end
    gc_setLineWidth(2)
    if mode=='hold' then
        gc_setColor(0,0,0,.26)
        gc_rectangle('fill',-170,0,140,100*slot)
        gc_setColor(1,.7,.7)
        gc_rectangle('line',-170,0,140,100*slot)
    elseif mode=='swap' then
        gc_setColor(0,0,0,.26)
        gc_rectangle('fill',430,0,140,100*slot)
        gc_setColor(1,.7,.7)
        gc_rectangle('line',430,0,140,100*slot)
    end
end
function S.drawHoldCell(C,disabled,B,x,y)
    local r,g,b=unpack(disabled and disabledColor or RGB9[C.color])
    drawCell(B,x,y,r,g,b,1)
end
-- function S.drawTime(time)
--     -- TODO
-- end
-- function S.drawInfoPanel(x,y,w,h)
--     -- TODO
-- end
function S.drawStartingCounter(readyDelay)
    gc_push('transform')
    local num=math.ceil((readyDelay-S.getTime())/1000)
    local r,g,b=.8,.8,.8
    local d=(readyDelay-S.getTime())%1000/1000 -- from .999 to 0

    if num<=3 and d>.75 then
        if     num==1 then gc_scale(1,1+(d/.25-3)^2)
        elseif num==2 then gc_scale(1+(d/.25-3)^2,1)
        elseif num==3 then gc_rotate((d-.75)^3*40)
        end
    end
    if num%2==1 then r=1 end

    FONT.set(100)

    -- Warping number
    gc_push('transform')
        gc_scale((1.5-d*.6)^1.5)
        gc_setColor(r,g,b,d/(.5+num/3))
        GC.mStr(num,0,-70)
        gc_setColor(r,g,b,(1.5*d-0.5)/(.5+num/3))
        GC.mStr(num,0,-70)
    gc_pop()

    -- Scaling + Fading number
    gc_scale(min(d/.333,1)^.4)
    gc_setColor(r,g,b)
    GC.mStr(num,0,-70)
    gc_setColor(r,g,b,1.5*d-0.5)
    GC.mStr(num,0,-70)
    gc_pop()
end

return S
