local scene={}

local time

function scene.enter()
    time=0
end

function scene.keyDown(key)
    local action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        SCN.pop()
        SCN.go('game_in','none',GAME.mode.name)
    elseif action=='back' then
        SCN.back('none')
    end
end

function scene.update(dt)
    GAME.update(dt*.626)
    time=time+dt
end

function scene.draw()
    SCN.scenes['game_in'].draw()

    GC.setCanvas(Zenitha.getBigCanvas('result'))
    GC.clear(0,0,0,0)
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
