local scene={}

local time

function scene.enter()
    time=0
end

function scene.keyDown(key)
    if key=='escape' then
        SCN.back('none')
    else
        return true
    end
end

function scene.update(dt)
    time=time+dt
end

function scene.draw()
    SCN.scenes['game_in'].draw()

    GC.setCanvas(Zenitha.getBigCanvas('result'))
    GC.clear(1,1,1,0)
    GAME.mode.resultPage(time)
    GC.setCanvas()

    GC.replaceTransform(SCR.origin)
    GC.setColor(.06,.06,.06,.626)
    GC.rectangle('fill',0,0,SCR.w,SCR.h)

    GC.setColor(1,1,1)
    GC.draw(Zenitha.getBigCanvas('result'))
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
