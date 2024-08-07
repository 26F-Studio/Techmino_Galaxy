local gc=love.graphics
local tc=love.touch

---@type Zenitha.Scene
local scene={}

local repMode=false

local function startGame(modeName)
    GAME.unload()
    GAME.load(modeName)
    GAME.camera.k0=1
end
function scene.load()
    PROGRESS.applyExteriorBG()
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
    elseif action=='view' then
        -- TODO: more camera modes
        if GAME.camera.k0>.8 then
            GAME.camera:scale(3/5)
        else
            GAME.camera:scale(5/3)
        end
    elseif action=='back' then
        if canPause() then
            FMOD.effect('pause_pause')
            SCN.swapTo('pause_out','none')
        else
            SCN.back()
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end

    -- Debug
    if key=='f6' then love.system.setClipboardText(GAME.playerList[1]:serialize()) MSG.new('info',"Exported") return true
    elseif key=='f7' then GAME.playerList[1]:unserialize(love.system.getClipboardText()) MSG.new('info',"Imported") return true
    end

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
    x,y=SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y))
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='brik' or GAME.mainPlayer.gameMode=='gela' then
            if SETTINGS.system.touchControl then VCTRL.press(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='acry' then
            GAME.mainPlayer:mouseDown(x,y,id)
        end
    end
end
function scene.touchMove(x,y,dx,dy,id)
    x,y=SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y))
    if GAME.mainPlayer then
        if GAME.mainPlayer.gameMode=='brik' or GAME.mainPlayer.gameMode=='gela' then
            if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end
        elseif GAME.mainPlayer.gameMode=='acry' then
            GAME.mainPlayer:mouseMove(x,y,dx,dy,id)
        end
    end
end
function scene.touchUp(x,y,id)
    x,y=SCR.xOy_m:inverseTransformPoint(SCR.xOy:transformPoint(x,y))
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
    if love.keyboard.isDown('f1') then
        dt=dt*.1
    elseif love.keyboard.isDown('f2') then
        dt=dt*2.6
    end
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
            x,y=SCR.xOy:inverseTransformPoint(x,y)
            gc.circle('line',x,y,80)
        end
    end
end

scene.widgetList={
    {name='pause',type='button',pos={0,0},x=120,y=80,w=160,h=80,sound_trigger=false,fontSize=60,text=CHAR.icon.pause,code=function() sysAction('back') end},
}
return scene
