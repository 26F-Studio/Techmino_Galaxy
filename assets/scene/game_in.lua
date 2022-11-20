local gc=love.graphics

local scene={}

function scene.enter()
    VCTRL.reset()
    GAME.reset(SCN.args[1])
    GAME.start()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local action

    local p=GAME.mainPlayer
    if p then
        action=KEYMAP[p.gameMode]:getAction(key)
        if action then
            GAME.press(action)
            return
        end
    end

    action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        scene.enter()
    elseif action=='back' then
        if sureCheck('back') then SCN.back() end
    end
end

function scene.keyUp(key)
    local action

    local p=GAME.mainPlayer
    if p then
        action=KEYMAP[p.gameMode]:getAction(key)
        if action then
            GAME.release(action)
            return
        end
    end
end

function scene.touchDown(x,y,id)
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='mino' or GAME.mainPlayer.gameMode=='puyo' then
            if SETTINGS.system.touchControl then VCTRL.press(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='gem' then
            GAME.mainPlayer:mouseDown(x,y,id)
        end
    end
end
function scene.touchMove(x,y,dx,dy,id)
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='mino' or GAME.mainPlayer.gameMode=='puyo' then
            if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='gem' then
            GAME.mainPlayer:mouseMove(x,y,dx,dy,id)
        end
    end
end
function scene.touchUp(x,y,id)
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='mino' or GAME.mainPlayer.gameMode=='puyo' then
            if SETTINGS.system.touchControl then VCTRL.release(id) end
        elseif GAME.mainPlayer.gameMode=='gem' then
            GAME.mainPlayer:mouseUp(x,y,id)
        end
    end
end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.update(dt)
    GAME.update(dt)
end

function scene.draw()
    GAME.render()

    gc.replaceTransform(SCR.xOy)
    if SETTINGS.system.touchControl then VCTRL.draw() end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
