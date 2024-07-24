local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local function startGame(modeName)
    GAME.unload()
    GAME.load(modeName)
end
function scene.load()
    PROGRESS.applyInteriorBG()
    if SCN.args[1] then
        startGame(SCN.args[1])
    end
    resetVirtualKeyMode(GAME.mainPlayer and GAME.mainPlayer.gameMode)
    scene.widgetList.pause.text=canPause() and CHAR.icon.pause or CHAR.icon.back
    WIDGET._reset()
end
function scene.unload()
    if SCN.stackChange<0 then
        GAME.unload()
    end
end

local function sysAction(action)
    if action=='restart' then
        if GAME.playing then
            startGame(GAME.mode.name)
        end
    elseif action=='back' then
        if canPause() then
            SCN.swapTo('pause_in','none')
        else
            SCN.back('none')
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    local action

    local p=GAME.mainPlayer
    if p then
        action=KEYMAP[p.gameMode]:getAction(key)
        if action then
            GAME.press(action)
            return true
        end
    end

    sysAction(KEYMAP.sys:getAction(key))

    return true
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
        if GAME.mainPlayer.gameMode=='brik' or GAME.mainPlayer.gameMode=='gela' then
            if SETTINGS.system.touchControl then VCTRL.press(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='acry' then
            GAME.mainPlayer:mouseDown(x,y,id)
        end
    end
end
function scene.touchMove(x,y,dx,dy,id)
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='brik' or GAME.mainPlayer.gameMode=='gela' then
            if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='acry' then
            GAME.mainPlayer:mouseMove(x,y,dx,dy,id)
        end
    end
end
function scene.touchUp(x,y,id)
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='brik' or GAME.mainPlayer.gameMode=='gela' then
            if SETTINGS.system.touchControl then VCTRL.release(id) end
        elseif GAME.mainPlayer.gameMode=='acry' then
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

    if SETTINGS.system.touchControl then
        gc.replaceTransform(SCR.xOy)
        VCTRL.draw()
    end
end

scene.widgetList={
    {name='pause',type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.pause,code=function() sysAction('back') end},
}
return scene
