local scene={}

local map,act
local result
local quitTimer

function scene.enter()
    map=SCN.args[1]
    act=SCN.args[2]
    result=false
    quitTimer=0
    VCTRL.reset()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if result then return end
    if key=='escape' then
        SCN.pop() SCN.swapTo('keyset_list','none',SCN.args[1])
    elseif key=='backspace' then
        local L=KEYMAP[map]:getKeys(act)
        if L then TABLE.cut(L) end
        result=Text.keyset_deleted
        SFX.play('beep_2')
    else
        result=key
        KEYMAP[map]:remKey(key)
        KEYMAP[map]:addKey(act,key)
        SFX.play('beep_1')
    end
end

function scene.touchDown(x,y,id)
    if VCTRL.press(x,y,id) then return end
end
function scene.touchMove(x,y,_,_,id)
    VCTRL.move(x,y,id)
end
function scene.touchUp(_,_,id)
    VCTRL.release(id)
end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.update(dt)
    if result then
        quitTimer=quitTimer+dt
        if quitTimer>.1 then
            SCN.pop() SCN.swapTo('keyset_list','none',SCN.args[1])
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
    VCTRL.draw()
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,0},x=-300,y=80,w=160,h=80,sound=false,fontSize=60,text=CHAR.key.backspace,code=WIDGET.c_pressKey('backspace')},
    WIDGET.new{type='button',pos={1,0},x=-120,y=80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=function() SCN.pop() SCN.swapTo('keyset_list','none',SCN.args[1]) end},
}

return scene
