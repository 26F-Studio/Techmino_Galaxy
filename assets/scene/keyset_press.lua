---@type Zenitha.Scene
local scene={}

local mode,act
local keyLangStr
local result
local quitTimer
local escTimerWTF

function scene.load()
    mode=SCN.args[1]
    act=SCN.args[2]
    keyLangStr='keyset_'..mode..'_'..act
    result=false
    quitTimer=0
    escTimerWTF=false
    if SETTINGS.system.touchControl then resetVirtualKeyMode(mode) end
end

function scene.mouseDown(_,_,k) if k==2 then escTimerWTF=.26 end end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if result then return true end
    if key=='escape' and not escTimerWTF then
        escTimerWTF=.626
    elseif key=='backspace' then
        local L=KEYMAP[mode]:getKeys(act)
        if L then TABLE.clear(L) end
        result=Text.keyset_deleted
        FMOD.effect('beep_drop')
    else
        escTimerWTF=false
        result=key
        KEYMAP[mode]:remKey(key)
        KEYMAP[mode]:addKey(act,key)
        FMOD.effect('beep_rise')
    end
    return true
end

function scene.touchDown(x,y,id)
    if SETTINGS.system.touchControl and VCTRL.press(x,y,id) then return end
end
function scene.touchMove(x,y,_,_,id)
    if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end
end
function scene.touchUp(_,_,id)
    if SETTINGS.system.touchControl then VCTRL.release(id) end
end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.update(dt)
    if escTimerWTF then
        escTimerWTF=escTimerWTF-dt
        if escTimerWTF<=0 then
            SCN.back('none',SCN.args[1])
        end
    end
    if result then
        quitTimer=quitTimer+dt
        if quitTimer>.1 then
            SCN.back('none',SCN.args[1])
        end
    end
end

function scene.draw()
    GC.replaceTransform(SCR.origin)
    if escTimerWTF then
        GC.setColor(1,1,1,.1)
        local r=escTimerWTF/.626*SCR.w/2
        GC.rectangle('fill',SCR.w/2-r,SCR.h*.45,r*2,SCR.h*.1,5)
    end

    GC.replaceTransform(SCR.xOy_m)
    FONT.set(100) GC.strokePrint('full',4,COLOR.D,COLOR.L,Text[keyLangStr],0,-200,'center')
    FONT.set(60)  GC.strokePrint('full',2,COLOR.D,COLOR.L,result or Text.keyset_pressKey,0,-40,'center')
    FONT.set(35)  GC.strokePrint('full',2,COLOR.D,COLOR.L,Text.keyset_info,0,80,'center')

    GC.replaceTransform(SCR.xOy)
    if SETTINGS.system.touchControl then VCTRL.draw() end
end

scene.widgetList={
    {type='button',pos={1,0},x=-300,y=80,w=160,h=80,sound_trigger=false,fontSize=60,text=CHAR.key.backspace,code=WIDGET.c_pressKey('backspace')},
    {type='button',pos={1,0},x=-120,y=80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=function() SCN.back('none',SCN.args[1]) end},
}

return scene
