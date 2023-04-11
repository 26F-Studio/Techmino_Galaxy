local gc=love.graphics

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

function scene.enter()
    BG.set('none')

    TABLE.cut(keyButtons)
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
function scene.leave()
    saveKey()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
    end
end

function scene.draw()
    FONT.set(25)
    gc.setColor(COLOR.L)
    for i=1,#keyButtons do
        local l=i<#keyButtons-2 and KEYMAP.mino[i].keys or sysKeyInfo[i-#keyButtons+3].keys
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
    WIDGET.new{type='button', x=600,y=80, w=200,h=70,cornerR=0,text=LANG"keyset_mino_moveLeft",  fontSize=20,color='lG',code=selAct('mino','moveLeft' )},
    WIDGET.new{type='button', x=600,y=160,w=200,h=70,cornerR=0,text=LANG"keyset_mino_moveRight", fontSize=20,color='lG',code=selAct('mino','moveRight')},
    WIDGET.new{type='button', x=600,y=240,w=200,h=70,cornerR=0,text=LANG"keyset_mino_rotateCW",  fontSize=20,color='lG',code=selAct('mino','rotateCW' )},
    WIDGET.new{type='button', x=600,y=320,w=200,h=70,cornerR=0,text=LANG"keyset_mino_rotateCCW", fontSize=20,color='lG',code=selAct('mino','rotateCCW')},
    WIDGET.new{type='button', x=600,y=400,w=200,h=70,cornerR=0,text=LANG"keyset_mino_rotate180", fontSize=20,color='lG',code=selAct('mino','rotate180')},
    WIDGET.new{type='button', x=600,y=480,w=200,h=70,cornerR=0,text=LANG"keyset_mino_softDrop",  fontSize=20,color='lG',code=selAct('mino','softDrop' )},
    WIDGET.new{type='button', x=600,y=560,w=200,h=70,cornerR=0,text=LANG"keyset_mino_hardDrop",  fontSize=20,color='lG',code=selAct('mino','hardDrop' )},
    WIDGET.new{type='button', x=600,y=640,w=200,h=70,cornerR=0,text=LANG"keyset_mino_holdPiece", fontSize=20,color='lG',code=selAct('mino','holdPiece')},
    WIDGET.new{type='button', x=600,y=720,w=200,h=70,cornerR=0,text=LANG"keyset_sys_restart",    fontSize=20,color='lG',code=selAct('sys', 'restart'  )},
    WIDGET.new{type='button', x=600,y=800,w=200,h=70,cornerR=0,text=LANG"keyset_sys_back",       fontSize=20,color='lG',code=selAct('sys', 'back'     )},
    WIDGET.new{type='button', x=600,y=880,w=200,h=70,cornerR=0,text=LANG"keyset_sys_quit",       fontSize=20,color='lG',code=selAct('sys', 'quit'     )},

    WIDGET.new{type='button',pos={1,1},x=-300,y=-80,w=160,h=80,cornerR=0,text=LANG"setting_test",fontSize=40,code=playInterior'mino/interior/test'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='button_back',cornerR=0,fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
