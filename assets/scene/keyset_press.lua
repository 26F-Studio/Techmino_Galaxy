local scene={}

local map,act
local result
local quitTimer

function scene.enter()
    map=SCN.args[1]
    act=SCN.args[2]
    result=false
    quitTimer=0
    if SETTINGS.system.touchControl then VCTRL.reset() end
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if result then return end
    if key=='escape' then
        SCN.back('none',SCN.args[1])
    elseif key=='backspace' then
        local L=KEYMAP[map]:getKeys(act)
        if L then TABLE.cut(L) end
        result=Text.keyset_deleted
        SFX.play('beep_down')
    else
        result=key
        KEYMAP[map]:remKey(key)
        KEYMAP[map]:addKey(act,key)
        SFX.play('beep_rise')
    end
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
    if result then
        quitTimer=quitTimer+dt
        if quitTimer>.1 then
            SCN.back('none',SCN.args[1])
        end
    end
end

function scene.draw()
    FONT.set(100)
    GC.shadedPrint(Text['key_'..act],800,300,'center',4,8)
    FONT.set(60)
    GC.shadedPrint(result or Text.keyset_pressKey,800,460,'center',2,8)
    FONT.set(35)
    GC.shadedPrint(Text.keyset_info,800,580,'center',2,8)
    if SETTINGS.system.touchControl then VCTRL.draw() end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,0},x=-300,y=80,w=160,h=80,sound=false,fontSize=60,text=CHAR.key.backspace,code=WIDGET.c_pressKey('backspace')},
    WIDGET.new{type='button',pos={1,0},x=-120,y=80,w=160,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=function() SCN.back('none',SCN.args[1]) end},
}

return scene
