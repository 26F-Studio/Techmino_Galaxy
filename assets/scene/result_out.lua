---@type Zenitha.Scene
local scene={}

local time

function scene.load()
    time=0
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back() end end
function scene.keyDown(key)
    local action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        SCN.swapTo('game_out',nil,GAME.mode.name)
    elseif action=='back' then
        SCN.back()
    end
    return true
end

function scene.update(dt)
    GAME.update(dt*.26)
    time=time+dt
end

function scene.draw()
    SCN.scenes['game_out'].draw()

    GC.setCanvas(ZENITHA.bigCanvas.result)
    GC.clear(0,0,0,0)
    GC.replaceTransform(SCR.xOy)
    GAME.mode.resultPage(time)
    GC.setCanvas()

    GC.replaceTransform(SCR.origin)
    GC.setColor(.06,.06,.06,math.min(time,.626))
    GC.rectangle('fill',0,0,SCR.w,SCR.h)

    GC.setColor(1,1,1)
    GC.draw(ZENITHA.bigCanvas.result)
end

scene.widgetList={
    {type='button',pos={0,0},x=120,y=80,w=160,h=80,sound_release='button_back',fontSize=60,text=CHAR.icon.back,onClick=WIDGET.c_backScn()},
}
return scene
