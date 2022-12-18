local tau=MATH.tau

local pSys={
    particleSystemTemplate.minoMapBack:clone(),
    particleSystemTemplate.minoMapBack:clone(),
    particleSystemTemplate.minoMapBack:clone()
}
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

local scene={}

-- Y X
--  *
--  Z
local modes={
    -- {pos={0,0,0}},
    {pos={1,1,0},mode='marathon'},
    {pos={1,0,1},mode='ultra'},
    {pos={0,1,1},mode='sprint'},
}
for _,m in next,modes do
    m.valid=true
    m.active=0
    m.x=260*(m.pos[1]-m.pos[2])*(3^.5/2)
    m.y=260*(m.pos[3]-(m.pos[1]+m.pos[2])*.5)
    m.r=100
end

local cam={
    x0=0,y0=0,k0=.9,a0=0,
    x=0,y=0,k=2,a=.26,
    swing=0,
    cursor=false,
    transform=love.math.newTransform(),
    move=function(self,dx,dy)
        self.x0=self.x0+dx
        self.y0=self.y0+dy
        local dist=MATH.distance(0,0,self.x0,self.y0)/self.k0
        if dist>4000 then
            local angle=math.atan2(self.y0,self.x0)
            self.x0=4000*math.cos(angle)*self.k0
            self.y0=4000*math.sin(angle)*self.k0
        end
    end,
    rotate=function(self,da)
        self.a0=self.a0+da
    end,
    scale=function(self,dk)
        local k0=self.k0
        self.k0=MATH.clamp(self.k0*dk,.2,1.26)
        dk=self.k0/k0
        self.x0,self.y0=self.x0*dk,self.y0*dk
    end,
    update=function(self,dt)
        self.swing=.026*math.sin(love.timer.getTime()/1.26)

        self.x=MATH.expApproach(self.x,self.x0,dt*16)
        self.y=MATH.expApproach(self.y,self.y0,dt*16)
        self.k=MATH.expApproach(self.k,self.k0,dt*16)
        self.a=MATH.expApproach(self.a,self.a0+self.swing,dt*6.26)
        self.transform:setTransformation(self.x,100+self.y,self.a,self.k)
    end,
}

---@type table
---| false
local modeFocused=false

---@type table
---| false
local modeSelected=false

function scene.enter()
    for i=1,3 do
        pSys[i]:reset()
        pSys[i]:start()
    end
    enterFX.timer=false
    cam.cursor=false
    PROGRESS.playExteriorBGM()
end

local function _onMode(x,y)
    x,y=SCR.xOy:transformPoint(x,y)
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
    modeSelected=m
    if m then
        SFX.play('mode_select')
    end
end
local function _enterMode(m)
    if m then
        enterFX.timer=0
        enterFX.x,enterFX.y,enterFX.r=m.x,m.y,m.r
        SFX.play('mode_enter')
        SCN.go('game_out','fade','mino/exterior/'..m.mode)
    end
end
function scene.mouseClick(x,y,k)
    cam.cursor=false
    if k==1 then
        local m=_onMode(x,y)
        if m and m==modeSelected then
            _enterMode(m)
        else
            _selectMode(m)
        end
    end
end
function scene.mouseMove(x,y,dx,dy)
    cam.cursor=false
    if love.mouse.isDown(1) then
        cam:move(dx,dy)
    else
        modeFocused=_onMode(x,y)
    end
end
function scene.wheelMoved(dx,dy)
    cam.cursor=false
    if love.keyboard.isDown('lctrl','rctrl') then
        cam:rotate(-(dx+dy)*.26)
    else
        cam:scale(1.1^(dx+dy))
    end
end
function scene.touchMove(_,_,dx,dy)
    cam.cursor=false
    cam:move(dx,dy)
end
function scene.touchDown(x,y)
    cam.cursor=false
    scene.touchMove(x,y)
end
function scene.touchClick(x,y)
    cam.cursor=false
    scene.mouseClick(x,y,1)
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='space' or key=='return' then
        if modeFocused and modeFocused==modeSelected then
            _enterMode(modeSelected)
        else
            _selectMode(modeFocused)
        end
    elseif key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.update(dt)
    for _,m in next,modes do
        if m.valid then
            m.active=MATH.expApproach(m.active,(m==modeSelected or m==modeFocused) and 1 or 0,dt*6)
        end
    end
    if love.keyboard.isDown('up','down','left','right') then
        if love.keyboard.isDown('lctrl','rctrl') then
            if love.keyboard.isDown('up')    then cam:scale(2.6^dt) end
            if love.keyboard.isDown('down')  then cam:scale(1/2.6^dt) end
            if love.keyboard.isDown('right') then cam:rotate(dt*2.6) end
            if love.keyboard.isDown('left')  then cam:rotate(-dt*2.6) end
        else
            local dx,dy=0,0
            if love.keyboard.isDown('up')    then cam.cursor=true dy=dy+dt*1260 end
            if love.keyboard.isDown('down')  then cam.cursor=true dy=dy-dt*1260 end
            if love.keyboard.isDown('left')  then cam.cursor=true dx=dx+dt*1260 end
            if love.keyboard.isDown('right') then cam.cursor=true dx=dx-dt*1260 end
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
    if cam.cursor then
        modeFocused=_onMode(800,600)
    end
end

function scene.draw()
    -- Move camera
    GC.replaceTransform(SCR.xOy_m)

    -- Draw cam center (for keyboard)
    if cam.cursor then
        GC.push('transform')
        GC.translate(0,100)
        GC.rotate(cam.a)
        GC.setColor(COLOR.L)
        GC.setLineWidth(4)
        GC.line(0,-10,0,-30)
        GC.line(8.62,5,26,15)
        GC.line(-8.62,5,-26,15)
        GC.pop()
    end

    -- Move camera
    GC.applyTransform(cam.transform)

    -- Draw modes
    for _,m in next,modes do
        if m.valid then
            GC.push('transform')
            GC.translate(m.x,m.y)
            GC.scale(1+m.active*.1)
            GC.rotate(-cam.a)
            GC.setLineWidth(8)
            GC.setColor(1,1,1,.42)
            GC.regPolygon('line',0,0,m.r,6,tau/12)
            GC.setLineWidth(2)
            GC.setColor(1,1,1)
            GC.regPolygon('line',0,0,m.r,6,tau/12)
            if m==modeSelected or m.active>.001 then
                local rb=m==modeSelected and .42 or 1
                GC.setLineWidth(8)
                GC.setColor(rb,1,rb,m==modeSelected and 1 or m.active*.26)
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

    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_mode_mino'},
}
return scene
