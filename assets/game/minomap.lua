-- Y X
--  *
--  Z
local modes={
    {pos={1,1,0},     path='mino/exterior/',name='marathon',       connect={'ultra'}},
    {pos={1,0,1},     path='mino/exterior/',name='ultra',          connect={'sprint'}},
    {pos={0,1,1},     path='mino/exterior/',name='sprint',         connect={'marathon'}},
}

local pSys={} for i=1,3 do pSys[i]=particleSystemTemplate.minoMapBack:clone() end
local mapPoly={
    0,0,
    6200,10738.715,
    12400,0,
    6200,-10738.715,
}
local enterFX={
    timer=false,
    x=false,
    y=false,
    r=false,
}
local cam={
    x0=0,y0=0,k0=.9,a0=0,
    x=0,y=0,k=2,a=.26,
    swing=0,
    cursor=false,
    transform=love.math.newTransform(),
}
function cam:move(dx,dy)
    self.x0=self.x0+dx
    self.y0=self.y0+dy
    local dist=MATH.distance(0,0,self.x0,self.y0)/self.k0
    if dist>4000 then
        local angle=math.atan2(self.y0,self.x0)
        self.x0=4000*math.cos(angle)*self.k0
        self.y0=4000*math.sin(angle)*self.k0
    end
end
function cam:rotate(da)
    self.a0=self.a0+da
end
function cam:scale(dk)
    local k0=self.k0
    self.k0=MATH.clamp(self.k0*dk,.2,1.26)
    dk=self.k0/k0
    self.x0,self.y0=self.x0*dk,self.y0*dk
end
function cam:update(dt)
    self.swing=.026*math.sin(love.timer.getTime()/1.26)

    self.x=MATH.expApproach(self.x,self.x0,dt*16)
    self.y=MATH.expApproach(self.y,self.y0,dt*16)
    self.k=MATH.expApproach(self.k,self.k0,dt*16)
    self.a=MATH.expApproach(self.a,self.a0+self.swing,dt*6.26)
    self.transform:setTransformation(self.x,100+self.y,self.a,self.k)
end

---@type table
---| false
local focused=false

---@type table
---| false
local selected=false

local map={}

-- Initialize modes' graphic values
for _,m in next,modes do
    m.valid=false
    m.active=0
    m.x=260*(m.pos[1]-m.pos[2])*(3^.5/2)
    m.y=260*(m.pos[3]-(m.pos[1]+m.pos[2])*.5)
    m.r=100
end

-- Generate string-mode pairs
local modes_str={} for i=1,#modes do modes_str[modes[i].name]=modes[i] end

-- Bridges connecting modes
local bridges={}

local function _newBridge(m1,m2)
    local x1,y1=m1.x,m1.y
    local x2,y2=m2.x,m2.y
    local dist=MATH.distance(x1,y1,x2,y2)

    -- Cut in-mode parts
    local p1,p2=(m1.r*1.2)/dist,1-(m2.r*1.2)/dist
    x1,y1,x2,y2=
        x1*(1-p1)+x2*p1,
        y1*(1-p1)+y2*p1,
        x1*(1-p2)+x2*p2,
        y1*(1-p2)+y2*p2

    table.insert(bridges,{
        timer=0,
        x1=x1,y1=y1,
        x2=x2,y2=y2,
        q1x=x1*.25+x2*.75,q1y=y1*.25+y2*.75,
        q2x=x1*.50+x2*.50,q2y=y1*.50+y2*.50,
        q3x=x1*.75+x2*.25,q3y=y1*.75+y2*.25,
    })
end

-- Map methods
function map:loadUnlocked(modeList)
    assert(type(modeList)=='table',"WTF why modeList isn't table")

    -- Unlock modes
    for _,v in next,modeList do
        local m=modes_str[v]
        assert(m,"WTF mode '"..tostring(v).."' doesn't exist")
        m.valid=true
        for _,name in next,m.connect do
            assert(modes_str[name],"WTF mode '"..tostring(name).."' doesn't exist")
        end
    end

    -- Create bridges
    for _,m1 in next,modes do
        if m1.valid then
            for _,name in next,m1.connect do
                local m2=modes_str[name]
                assert(m2,"WTF mode '"..tostring(name).."' doesn't exist")
                if m2.valid then
                    _newBridge(m1,m2)
                end
            end
        end
    end
end

function map:reset()
    for i=1,3 do
        pSys[i]:reset()
        pSys[i]:start()
    end
    cam.cursor=false
    enterFX.timer=false
    focused=false
    selected=false
end

function map:hideCursor() cam.cursor=false end
function map:showCursor() cam.cursor=true end

local function _onMode(x,y)
    x,y=SCR.xOy_m:inverseTransformPoint(x,y)
    x,y=cam.transform:inverseTransformPoint(x,y)
    for _,m in next,modes do
        if m.valid and MATH.distance(x,y,m.x,m.y)<m.r*1.26 then
            return m
        end
    end
    return false
end
local function _selectMode(m)
    selected=m
    if m then
        SFX.play('mode_select')
    end
end
local function _enterMode(m)
    if m then
        enterFX.timer=0
        enterFX.x,enterFX.y,enterFX.r=m.x,m.y,m.r
        SFX.play('mode_enter')
        SCN.go('game_out','fade',m.path..m.name)
    end
end

function map:moveCam(dx,dy)
    cam:move(dx,dy)
end
function map:rotateCam(da)
    cam:rotate(da)
end
function map:scaleCam(dk)
    cam:scale(dk)
end

function map:mouseMove(x,y)
    focused=_onMode(x,y)
end
function map:mouseClick(x,y)
    local m=_onMode(x,y)
    if m and m==selected then
        _enterMode(m)
    else
        _selectMode(m)
    end
end
function map:keyboardMove(x,y)
    if cam.cursor then
        focused=_onMode(x,y)
    end
end
function map:keyboardSelect()
    if focused and focused==selected then
        _enterMode(selected)
    else
        _selectMode(focused)
    end
end

function map:update(dt)
    for _,m in next,modes do
        if m.valid then
            m.active=MATH.expApproach(m.active,(m==selected or m==focused) and 1 or 0,dt*6)
        end
    end
    for _,b in next,bridges do
        b.timer=b.timer+dt
    end
    if love.keyboard.isDown('up','down','left','right') then
        self:showCursor()
        if love.keyboard.isDown('lctrl','rctrl') then
            if love.keyboard.isDown('up')    then cam:scale(2.6^dt) end
            if love.keyboard.isDown('down')  then cam:scale(1/2.6^dt) end
            if love.keyboard.isDown('right') then cam:rotate(dt*2.6) end
            if love.keyboard.isDown('left')  then cam:rotate(-dt*2.6) end
        else
            local dx,dy=0,0
            if love.keyboard.isDown('up')    then dy=dy+dt*1260 end
            if love.keyboard.isDown('down')  then dy=dy-dt*1260 end
            if love.keyboard.isDown('left')  then dx=dx+dt*1260 end
            if love.keyboard.isDown('right') then dx=dx-dt*1260 end
            cam:move(dx,dy)
        end
    end
    cam:update(dt)
    pSys[1]:update(dt)
    pSys[2]:update(dt)
    pSys[3]:update(dt)
    if enterFX.timer then
        enterFX.timer=enterFX.timer+dt
    end
end

local tau=MATH.tau
function map:draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.applyTransform(cam.transform)

    -- Draw bridges
    GC.setColor(1,1,1,.8)
    GC.setLineWidth(30)
    for _,b in next,bridges do GC.line(b.x1,b.y1,b.x2,b.y2) end
    GC.setColor(0,0,0,.6)
    GC.setLineWidth(20)
    for _,b in next,bridges do GC.line(b.x1,b.y1,b.x2,b.y2) end
    for _,b in next,bridges do
        for i=0,.75,.25 do
            local t=(b.timer/2.6+i)%1
            GC.setColor(1,1,1,-t*(t-1)*4)
            GC.circle('fill',MATH.interpolate(t,0,b.x1,1,b.x2),MATH.interpolate(t,0,b.y1,1,b.y2),6,6)
        end
    end

    -- Draw modes
    for _,m in next,modes do
        if m.valid then
            GC.push('transform')
            GC.translate(m.x,m.y)
            GC.scale(1+m.active*.1)
            GC.rotate(-cam.a)

            -- Outline
            GC.setLineWidth(8)
            GC.setColor(1,1,1,.42)
            GC.regPolygon('line',0,0,m.r,6,tau/12)
            GC.setColor(1,1,1)
            GC.setLineWidth(2)
            GC.regPolygon('line',0,0,m.r,6,tau/12)

            -- Name
            FONT.set(30)
            GC.setColor(COLOR.L)
            GC.mStr(m.name,0,-21)

            -- Selecting frame
            if m==selected or m.active>.001 then
                local rb=m==selected and .42 or 1
                GC.setLineWidth(8)
                GC.setColor(rb,1,rb,m==selected and 1 or m.active*.26)
                GC.regPolygon('line',0,0,m.r+16,6,tau/12)
            end
            GC.pop()
        end
    end

    -- Draw clickFX
    if enterFX.timer then
        GC.setColor(1,1,1,math.min(enterFX.timer*62,1))
        GC.setLineWidth(4+enterFX.timer*260)
        GC.regPolygon('line',enterFX.x,enterFX.y,(enterFX.r)*260^enterFX.timer,6,tau/12-cam.a)
    end

    -- Draw back and particles
    GC.rotate(-tau/4)GC.setColor(1,0,0,.01)GC.polygon('fill',mapPoly)GC.scale(.5)GC.setColor(0,0,0,.0626)GC.polygon('fill',mapPoly)GC.scale(2)
    GC.rotate(tau/3) GC.setColor(0,1,0,.01)GC.polygon('fill',mapPoly)GC.scale(.5)GC.setColor(0,0,0,.0626)GC.polygon('fill',mapPoly)GC.scale(2)
    GC.rotate(tau/3) GC.setColor(0,0,1,.01)GC.polygon('fill',mapPoly)GC.scale(.5)GC.setColor(0,0,0,.0626)GC.polygon('fill',mapPoly)GC.scale(2)
    GC.rotate(tau/3) GC.setColor(1,.26,.26)GC.draw(pSys[1])
    GC.rotate(tau/3) GC.setColor(.26,1,.26)GC.draw(pSys[2])
    GC.rotate(tau/3) GC.setColor(.26,.26,1)GC.draw(pSys[3])

    -- Draw keyboard cursor
    GC.replaceTransform(SCR.xOy_m)
    if cam.cursor then
        GC.push('transform')
        GC.translate(0,100)
        GC.rotate(-cam.a)
        GC.setColor(COLOR.L)
        GC.setLineWidth(4)
        GC.line(0,-10,0,-30)
        GC.line(8.62,5,26,15)
        GC.line(-8.62,5,-26,15)
        GC.pop()
    end
end

return map
