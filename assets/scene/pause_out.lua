local sin=math.sin

local scene={}

local pauseText

function scene.enter()
    pauseText=GC.newText(FONT.get(80,'bold'),Text.pause)
end
function scene.leave()
    SCN.scenes['game_out'].leave()
end

local function sysAction(action)
    if action=='quit' then
        SFX.play('pause_quit')
        SCN.back()
    elseif action=='back' then
        SFX.play('unpause')
        SCN.swapTo('game_out','none')
    elseif action=='restart' then
        SFX.play('pause_restart')
        SCN.swapTo('game_out',nil,GAME.mode.name)
    elseif action=='setting' then
        SFX.play('pause_setting')
        SCN.go('setting_out')
    end
end
function scene.keyDown(key,isRep)
    if isRep then return end
    sysAction(KEYMAP.sys:getAction(key))
end

function scene.touchDown(x,y,id) if SETTINGS.system.touchControl then VCTRL.press(x,y,id) end end
function scene.touchMove(x,y,_,_,id) if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end end
function scene.touchUp(_,_,id) if SETTINGS.system.touchControl then VCTRL.release(id) end end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.draw()
    GAME.render()

    GC.replaceTransform(SCR.origin)
    GC.setColor(0,0,0,.626)
    GC.rectangle('fill',0,0,SCR.w,SCR.h)

    GC.replaceTransform(SCR.xOy)
    if SETTINGS.system.touchControl then VCTRL.draw() end

    GC.replaceTransform(SCR.xOy_m)
    GC.scale(2)
    GC.setColor(COLOR.L)

    local t=love.timer.getTime()
    GC.setColorMask(true,false,false,true)
    GC.mDraw(pauseText,sin(3*t),sin(5*t))
    GC.setColorMask(false,true,false,true)
    GC.mDraw(pauseText,sin(6.5*t),sin(2*t))
    GC.setColorMask(false,false,true,true)
    GC.mDraw(pauseText,sin(3.5*t),sin(5.5*t))
    GC.setColorMask()
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},  x= 120,y= 80, w=160,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
    WIDGET.new{type='button',pos={.5,.5},x= 0,  y=-160,w=180,h=90,fontSize=60,sound=false,text=CHAR.icon.retry,    code=function() sysAction('restart') end},
    WIDGET.new{type='button',pos={.5,.5},x=-110,y= 170,w=180,h=90,fontSize=60,sound=false,text=CHAR.icon.play,     code=function() sysAction('back') end},
    WIDGET.new{type='button',pos={.5,.5},x= 110,y= 170,w=180,h=90,fontSize=60,sound=false,text=CHAR.icon.settings, code=function() sysAction('setting') end},
}
return scene
