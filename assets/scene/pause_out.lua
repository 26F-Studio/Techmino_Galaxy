local sin=math.sin

local scene={}

local pauseText

function scene.enter()
    pauseText=GC.newText(FONT.get(80,'bold'),Text.pause)
end

local function sysAction(action)
    if action=='restart' then
        SFX.play('fail')
        SCN.swapTo('game_out',nil,GAME.mode.name)
    elseif action=='back' then
        SFX.play('solve')
        SCN.swapTo('game_out','none')
    elseif action=='setting' then
        SCN.go('setting_out')
    else
        return
    end
    return true
end
function scene.keyDown(key,isRep)
    if isRep then return end

    if not sysAction(KEYMAP.sys:getAction(key)) then
        SCN.scenes['game_out'].keyDown(key)
    end
end
function scene.keyUp(...)     SCN.scenes['game_out'].keyUp(...)     end
function scene.touchDown(...) SCN.scenes['game_out'].touchDown(...) end
function scene.touchMove(...) SCN.scenes['game_out'].touchMove(...) end
function scene.touchUp(...)   SCN.scenes['game_out'].touchUp(...)   end
function scene.mouseDown(...) SCN.scenes['game_out'].mouseDown(...) end
function scene.mouseMove(...) SCN.scenes['game_out'].mouseMove(...) end
function scene.mouseUp(...)   SCN.scenes['game_out'].mouseUp(...)   end

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
    WIDGET.new{type='button',pos={.5,.5},x= 0,  y=-160,w=180,h=90,fontSize=60,text=CHAR.icon.retry,    code=function() sysAction('restart') end},
    WIDGET.new{type='button',pos={.5,.5},x=-110,y= 170,w=180,h=90,fontSize=60,text=CHAR.icon.play,     code=function() sysAction('back') end},
    WIDGET.new{type='button',pos={.5,.5},x= 110,y= 170,w=180,h=90,fontSize=60,text=CHAR.icon.settings, code=function() sysAction('setting') end},
}
return scene
