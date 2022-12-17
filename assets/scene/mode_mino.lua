local scene={}

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

local cam={
    x0=0,y0=0,k0=1,
    x=0,y=0,k=1,
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
        self.x=MATH.expApproach(self.x,self.x0,dt*16)
        self.y=MATH.expApproach(self.y,self.y0,dt*16)
        self.k=MATH.expApproach(self.k,self.k0,dt*16)
        self.transform:setTransformation(self.x,60+self.y,.026*math.sin(love.timer.getTime()/2.6),self.k)
    end,
}

function scene.enter()
    for i=1,3 do
        pSys[i]:reset()
        pSys[i]:start()
    end
end

function scene.mouseDown(x,y,k)
    if k==1 then
        x,y=SCR.xOy:transformPoint(x,y)
        x,y=SCR.xOy_m:inverseTransformPoint(x,y)
        x,y=cam.transform:inverseTransformPoint(x,y)
    end
end
function scene.mouseMove(_,_,dx,dy)
    if love.mouse.isDown(1) then
        cam:move(dx,dy)
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
    for i=1,3 do
        pSys[i]:update(dt)
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
    -- TODO

    -- Draw back and particles
    GC.rotate(MATH.tau*-1/4)GC.setColor(1,0,0,.01)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(0,1,0,.01)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(0,0,1,.01)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(1,.26,.26)GC.draw(pSys[1])
    GC.rotate(MATH.tau/3)GC.setColor(.26,1,.26)GC.draw(pSys[2])
    GC.rotate(MATH.tau/3)GC.setColor(.26,.26,1)GC.draw(pSys[3])

    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_mode_mino'},
}
return scene
