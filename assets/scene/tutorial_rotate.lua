local scene={}

function scene.enter()
end

function scene.keyDown(key)
    local action

    action=KEYMAP.mino:getAction(key)
    if action then
        if action=='rotateCW' then
        elseif action=='rotateCCW' then
        elseif action=='rotate180' then
        end
        return
    end

    action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        SCN.swapTo('tutorial_rotate','none',GAME.mode.name)
    elseif action=='back' then
        SCN.back('none')
    end
end

function scene.update(dt)
end

function scene.draw()
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
