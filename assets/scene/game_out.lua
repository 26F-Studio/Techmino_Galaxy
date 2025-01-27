local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local timeScale=1
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
    ResetVirtualKeyMode(GAME.mainPlayer and GAME.mainPlayer.gameMode)
    scene.widgetList.pause.text=CanPause() and CHAR.icon.pause or CHAR.icon.back
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
        if CanPause() then
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
    if key=='f3' then timeScale=timeScale==0 and 1 or 0
    elseif key=='f4' then GAME.update(.001)
    elseif key=='f6' then love.system.setClipboardText(GAME.playerList[1]:serialize()) MSG('info',"Exported") return true
    elseif key=='f7' then GAME.playerList[1]:unserialize(love.system.getClipboardText()) MSG('info',"Imported") return true
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
    GAME.cursorDown(x,y,id)
end
function scene.touchMove(x,y,dx,dy,id)
    GAME.cursorMove(x,y,dx,dy,id)
end
function scene.touchUp(x,y,id)
    GAME.cursorUp(x,y,id)
end

function scene.mouseDown(x,y,button)
    GAME.cursorDown(x,y,button)
end
function scene.mouseMove(x,y,dx,dy)
    GAME.cursorMove(x,y,dx,dy,false)
end
function scene.mouseUp(x,y,button)
    GAME.cursorUp(x,y,button)
end

function scene.update(dt)
    if love.keyboard.isDown('f1') then
        dt=dt*.1
    elseif love.keyboard.isDown('f2') then
        dt=dt*2.6
    else
        dt=dt*timeScale
    end
    GAME.update(dt)
end

local getTC=love.touch.getTouches
local getPos=love.touch.getPosition
function scene.draw()
    GAME.render()

    gc.replaceTransform(SCR.xOy)
    if SETTINGS.system.touchControl then VCTRL.draw() end

    if SETTINGS.system.showTouch then
        gc.setColor(1,1,1,.5)
        gc.setLineWidth(4)
        for _,id in next,getTC() do
            local x,y=getPos(id)
            x,y=SCR.xOy:inverseTransformPoint(x,y)
            gc.circle('line',x,y,80)
        end
    end
end

scene.widgetList={
    {name='pause',type='button',pos={0,0},x=120,y=80,w=160,h=80,sound_trigger=false,fontSize=60,text=CHAR.icon.pause,onPress=function() sysAction('back') end},
}
return scene
