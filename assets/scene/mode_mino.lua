local scene={}

local ps={
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
    x=0,y=0,
    k=1,a=0,
    move=function(self,dx,dy)
        self.x=self.x+dx
        self.y=self.y+dy
        local dist=MATH.distance(0,0,self.x,self.y)
        if dist>4000 then
            local angle=math.atan2(self.y,self.x)
            self.x=4000*math.cos(angle)
            self.y=4000*math.sin(angle)
        end
    end
}

function scene.enter()
    for i=1,3 do
        ps[i]:reset()
        ps[i]:start()
    end
end

function scene.mouseDown(x,y,k)

end
function scene.mouseMove(_,_,dx,dy)
    if love.mouse.isDown(1) then
        cam:move(dx/cam.k,dy/cam.k)
    end
end
function scene.wheelMoved(dx,dy)
    cam.k=MATH.clamp(cam.k*1.1^(dx+dy),.2,1.26)
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.update(dt)
    for i=1,3 do
        ps[i]:update(dt)
    end
    if love.keyboard.isDown('up','down','left','right') then
        if not love.keyboard.isDown('lctrl','rctrl') then
            local dx,dy=0,0
            if love.keyboard.isDown('up')    then dy=dy+dt*1260/cam.k end
            if love.keyboard.isDown('down')  then dy=dy-dt*1260/cam.k end
            if love.keyboard.isDown('left')  then dx=dx+dt*1260/cam.k end
            if love.keyboard.isDown('right') then dx=dx-dt*1260/cam.k end
            cam:move(dx,dy)
        else
            if love.keyboard.isDown('up','right')  then cam.k=MATH.clamp(cam.k*2.6^dt,.2,1.26) end
            if love.keyboard.isDown('down','left') then cam.k=MATH.clamp(cam.k/2.6^dt,.2,1.26) end
        end
    end
end

function scene.draw()
    cam.a=.026*math.sin(love.timer.getTime()/2.6)

    -- Move camera
    GC.replaceTransform(SCR.xOy_m)
    GC.translate(0,60)
    GC.scale(cam.k)
    GC.translate(cam.x,cam.y)
    GC.rotate(cam.a)

    -- Draw modes
    -- TODO

    -- Draw back and particles
    GC.rotate(MATH.tau*-1/4)GC.setColor(1,0,0,.026)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(0,1,0,.026)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(0,0,1,.026)GC.polygon('fill',mapPoly)
    GC.rotate(MATH.tau/3)GC.setColor(1,.26,.26)GC.draw(ps[1])
    GC.rotate(MATH.tau/3)GC.setColor(.26,1,.26)GC.draw(ps[2])
    GC.rotate(MATH.tau/3)GC.setColor(.26,.26,1)GC.draw(ps[3])


    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_mode_mino'},
}
return scene
