local gc=love.graphics
local tc=love.touch

local scene={}

local repMode=false

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

    if SETTINGS.system.showTouch then
        gc.setColor(1,1,1,.5)
        gc.setLineWidth(4)
        for _,id in next,tc.getTouches() do
            local x,y=tc.getPosition(id)
            x,y=SCR.xOy:transformPoint(x,y)
            gc.circle('line',x,y,80)
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
