local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local sysKeyInfo={
    {act='?',keys={'[???]'}},
    {act='?',keys={'[???]'}},
    {act='?',keys={'[???]'}},
}
sysKeyInfo.restart=sysKeyInfo[1]
sysKeyInfo.back=sysKeyInfo[2]
sysKeyInfo.quit=sysKeyInfo[3]
local keyButtons={}

function scene.load()
    BG.set('none')

    TABLE.clear(keyButtons)
    for i=1,#scene.widgetList do
        table.insert(keyButtons,scene.widgetList[i])
    end
    table.remove(keyButtons)
    table.remove(keyButtons)

    for i=1,#KEYMAP.sys do
        local act=KEYMAP.sys[i].act
        if sysKeyInfo[act] then
            sysKeyInfo[act].act=KEYMAP.sys[i].act
            sysKeyInfo[act].keys=KEYMAP.sys[i].keys
        end
    end
end
function scene.unload()
    if SCN.stackChange<0 then
        saveKey()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('none') end end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
    end
    return true
end

function scene.draw()
    FONT.set(25)
    gc.setColor(COLOR.L)
    for i=1,#keyButtons do
        local l=i<#keyButtons-2 and KEYMAP.brik[i].keys or sysKeyInfo[i-#keyButtons+3].keys
        for j=1,#l do
            GC.mStr(l[j],
                keyButtons[i].x+79+80*j,
                keyButtons[i].y-20
            )
        end
    end
end

local function _selAct(mode,act)
    SCN.go('keyset_press','none',mode,act)
end
local function selAct(mode,act)
    return function() _selAct(mode,act) end
end

scene.widgetList={
    {type='button', x=600,y=80, w=200,h=70,cornerR=0,text=LANG"keyset_brik_moveLeft",  fontSize=20,color='lG',code=selAct('brik','moveLeft' )},
    {type='button', x=600,y=160,w=200,h=70,cornerR=0,text=LANG"keyset_brik_moveRight", fontSize=20,color='lG',code=selAct('brik','moveRight')},
    {type='button', x=600,y=240,w=200,h=70,cornerR=0,text=LANG"keyset_brik_rotateCW",  fontSize=20,color='lG',code=selAct('brik','rotateCW' )},
    {type='button', x=600,y=320,w=200,h=70,cornerR=0,text=LANG"keyset_brik_rotateCCW", fontSize=20,color='lG',code=selAct('brik','rotateCCW')},
    {type='button', x=600,y=400,w=200,h=70,cornerR=0,text=LANG"keyset_brik_rotate180", fontSize=20,color='lG',code=selAct('brik','rotate180')},
    {type='button', x=600,y=480,w=200,h=70,cornerR=0,text=LANG"keyset_brik_softDrop",  fontSize=20,color='lG',code=selAct('brik','softDrop' )},
    {type='button', x=600,y=560,w=200,h=70,cornerR=0,text=LANG"keyset_brik_hardDrop",  fontSize=20,color='lG',code=selAct('brik','hardDrop' )},
    {type='button', x=600,y=640,w=200,h=70,cornerR=0,text=LANG"keyset_brik_holdPiece", fontSize=20,color='lG',code=selAct('brik','holdPiece')},
    {type='button', x=600,y=720,w=200,h=70,cornerR=0,text=LANG"keyset_sys_restart",    fontSize=20,color='lG',code=selAct('sys', 'restart'  )},
    {type='button', x=600,y=800,w=200,h=70,cornerR=0,text=LANG"keyset_sys_back",       fontSize=20,color='lG',code=selAct('sys', 'back'     )},
    {type='button', x=600,y=880,w=200,h=70,cornerR=0,text=LANG"keyset_sys_quit",       fontSize=20,color='lG',code=selAct('sys', 'quit'     )},

    {type='button',pos={1,1},x=-300,y=-80,w=160,h=80,cornerR=0,text=LANG"setting_test",fontSize=40,code=playInterior'brik/interior/test',visibleFunc=function() return not GAME.mode end},
    {type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',cornerR=0,fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
