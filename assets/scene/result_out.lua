local scene={}

local time

function scene.enter()
    time=0
end

function scene.keyDown(key)
    local action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        SCN.pop()
        SCN.go('game_out',nil,GAME.mode.name)
    elseif action=='back' then
        SCN.back()
    end
end

function scene.update(dt)
    time=time+dt
end

function scene.draw()
    SCN.scenes['game_out'].draw()

    GC.setCanvas(Zenitha.getBigCanvas('result'))
    GC.clear(0,0,0,0)
    GAME.mode.resultPage(time)
    GC.setCanvas()

    GC.replaceTransform(SCR.origin)
    GC.setColor(.06,.06,.06,math.min(time,.626))
    GC.rectangle('fill',0,0,SCR.w,SCR.h)

    GC.setColor(1,1,1)
    GC.draw(Zenitha.getBigCanvas('result'))
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},x=120,y=80,w=160,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
