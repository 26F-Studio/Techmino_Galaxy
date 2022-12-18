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

local scene={}

-- Y X
--  *
--  Z
local modes={
    -- {pos={0,0,0}},
    {pos={1,1,0}},
    {pos={1,0,1}},
    {pos={0,1,1}},
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
    transform=love.math.newTransform(),
    move=function(self,dx,dy)
        self.x0=self.x0+dx
        self.y0=self.y0+dy
        local dist=MATH.distance(0,0,self.x0,self.y0)
        if dist>4000 then
            local angle=math.atan2(self.y0,self.x0)
            self.x0=4000*math.cos(angle)
            self.y0=4000*math.sin(angle)
        end
    end,
    scale=function(self,dk)
        local k0=self.k0
        self.k0=MATH.clamp(self.k0*dk,.2,1.26)
        dk=self.k0/k0
        self.x0,self.y0=self.x0*dk,self.y0*dk
    end,
    update=function(self,dt)
        self.a0=.026*math.sin(love.timer.getTime()/1.26)

        self.x=MATH.expApproach(self.x,self.x0,dt*16)
        self.y=MATH.expApproach(self.y,self.y0,dt*16)
        self.k=MATH.expApproach(self.k,self.k0,dt*16)
        self.a=MATH.expApproach(self.a,self.a0,dt*2.6)
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
end

local function onMode(x,y)
    x,y=SCR.xOy:transformPoint(x,y)
    x,y=SCR.xOy_m:inverseTransformPoint(x,y)
    x,y=cam.transform:inverseTransformPoint(x,y)
    for i,m in next,modes do
        if m.valid and MATH.distance(x,y,m.x,m.y)<m.r*.933 then
            return m
        end
    end
    return false
end
function scene.mouseDown(x,y,k)
    if k==1 then
        local m=onMode(x,y)
        if m then
            if m==modeSelected then
                -- TODO
            else
                modeSelected=m
            end
        else
            scene.mouseMove(x,y,0,0)
        end
    end
end
function scene.mouseMove(x,y,dx,dy)
    if love.mouse.isDown(1) then
        cam:move(dx,dy)
    else
        modeFocused=onMode(x,y)
    end
end
function scene.wheelMoved(dx,dy)
    cam:scale(1.1^(dx+dy))
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.update(dt)
    pSys[1]:update(dt)
    pSys[2]:update(dt)
    pSys[3]:update(dt)
    for _,m in next,modes do
        m.active=MATH.expApproach(m.active,(m==modeSelected or m==modeFocused) and 1 or 0,dt*6)
    end
    cam:update(dt)
    if love.keyboard.isDown('up','down','left','right') then
        if not love.keyboard.isDown('lctrl','rctrl') then
            local dx,dy=0,0
            if love.keyboard.isDown('up')    then dy=dy+dt*1260 end
            if love.keyboard.isDown('down')  then dy=dy-dt*1260 end
            if love.keyboard.isDown('left')  then dx=dx+dt*1260 end
            if love.keyboard.isDown('right') then dx=dx-dt*1260 end
            cam:move(dx,dy)
        else
            if love.keyboard.isDown('up','right')  then cam:scale(2.6^dt) end
            if love.keyboard.isDown('down','left') then cam:scale(1/2.6^dt) end
        end
    end
end

function scene.draw()
    -- Move camera
    GC.replaceTransform(SCR.xOy_m)
    GC.applyTransform(cam.transform)

    -- Draw modes
    for _,m in next,modes do
        GC.push('transform')
        GC.translate(m.x,m.y)
        GC.scale(1+m.active*.1)
        GC.rotate(cam.a)
        GC.setLineWidth(8)
        GC.setColor(1,1,1,.42)
        GC.regPolygon('line',0,0,m.r,6,tau/12-cam.a)
        GC.setLineWidth(2)
        GC.setColor(1,1,1)
        GC.regPolygon('line',0,0,m.r,6,tau/12-cam.a)
        if m==modeSelected or m.active>.001 then
            local rb=m==modeSelected and .42 or 1
            GC.setLineWidth(8)
            GC.setColor(rb,1,rb,m==modeSelected and 1 or m.active*.26)
            GC.regPolygon('line',0,0,m.r+16,6,tau/12-cam.a)
        end
        GC.pop()
    end

    -- Draw back and particles
    GC.rotate(-tau/4)GC.setColor(1,0,0,.01)GC.polygon('fill',mapPoly)
    GC.rotate(tau/3)GC.setColor(0,1,0,.01)GC.polygon('fill',mapPoly)
    GC.rotate(tau/3)GC.setColor(0,0,1,.01)GC.polygon('fill',mapPoly)
    GC.rotate(tau/3)GC.setColor(1,.26,.26)GC.draw(pSys[1])
    GC.rotate(tau/3)GC.setColor(.26,1,.26)GC.draw(pSys[2])
    GC.rotate(tau/3)GC.setColor(.26,.26,1)GC.draw(pSys[3])

    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_mode_mino'},
}
return scene
