local gc=love.graphics

local scene={}

local keyMode
local keyMap
local keyButtons={}

function scene.enter()
    BG.set('none')

    keyMode=SCN.args[1] or keyMode
    keyMap=KEYMAP[keyMode]

    TABLE.cut(keyButtons)
    for i=1,#scene.widgetList do
        if scene.widgetList[i].name then
            local visible=scene.widgetList[i].name==keyMode
            scene.widgetList[i]:setVisible(visible)
            if visible then
                table.insert(keyButtons,scene.widgetList[i])
            end
        end
    end
end
function scene.leave()
    saveKey()
end

function scene.draw()
    FONT.set(25)
    gc.setColor(COLOR.L)
    for i=1,#keyMap do
        local l=keyMap[i].keys
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
    WIDGET.new{type='button', name='mino', x=140, y=70,  w=200,h=60,text=LANG"keyset_mino_moveLeft",   fontSize=20, color='lG',code=selAct('mino','moveLeft'  )},
    WIDGET.new{type='button', name='mino', x=140, y=140, w=200,h=60,text=LANG"keyset_mino_moveRight",  fontSize=20, color='lG',code=selAct('mino','moveRight' )},
    WIDGET.new{type='button', name='mino', x=140, y=210, w=200,h=60,text=LANG"keyset_mino_rotateCW",   fontSize=20, color='lG',code=selAct('mino','rotateCW'  )},
    WIDGET.new{type='button', name='mino', x=140, y=280, w=200,h=60,text=LANG"keyset_mino_rotateCCW",  fontSize=20, color='lG',code=selAct('mino','rotateCCW' )},
    WIDGET.new{type='button', name='mino', x=140, y=350, w=200,h=60,text=LANG"keyset_mino_rotate180",  fontSize=20, color='lG',code=selAct('mino','rotate180' )},
    WIDGET.new{type='button', name='mino', x=140, y=420, w=200,h=60,text=LANG"keyset_mino_softDrop",   fontSize=20, color='lG',code=selAct('mino','softDrop'  )},
    WIDGET.new{type='button', name='mino', x=140, y=490, w=200,h=60,text=LANG"keyset_mino_hardDrop",   fontSize=20, color='lG',code=selAct('mino','hardDrop'  )},
    WIDGET.new{type='button', name='mino', x=140, y=560, w=200,h=60,text=LANG"keyset_mino_holdPiece",  fontSize=20, color='lG',code=selAct('mino','holdPiece' )},
    WIDGET.new{type='button', name='mino', x=140, y=630, w=200,h=60,text=LANG"keyset_mino_sonicDrop",  fontSize=20, color='lG',code=selAct('mino','sonicDrop' )},
    WIDGET.new{type='button', name='mino', x=140, y=700, w=200,h=60,text=LANG"keyset_mino_sonicLeft",  fontSize=20, color='lG',code=selAct('mino','sonicLeft' )},
    WIDGET.new{type='button', name='mino', x=140, y=770, w=200,h=60,text=LANG"keyset_mino_sonicRight", fontSize=20, color='lG',code=selAct('mino','sonicRight')},
    WIDGET.new{type='button', name='mino', x=900, y=70,  w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('mino','func1')},
    WIDGET.new{type='button', name='mino', x=900, y=140, w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('mino','func2')},
    WIDGET.new{type='button', name='mino', x=900, y=210, w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('mino','func3')},
    WIDGET.new{type='button', name='mino', x=900, y=280, w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('mino','func4')},
    WIDGET.new{type='button', name='mino', x=900, y=350, w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('mino','func5')},
    WIDGET.new{type='button', name='mino', x=900, y=420, w=200,h=60,text=LANG"keyset_func6",           fontSize=20, color='lY',code=selAct('mino','func6')},

    WIDGET.new{type='button', name='puyo',x=140, y=70,   w=200,h=60,text=LANG"keyset_puyo_moveLeft",   fontSize=20, color='lG',code=selAct('puyo','moveLeft' )},
    WIDGET.new{type='button', name='puyo',x=140, y=140,  w=200,h=60,text=LANG"keyset_puyo_moveRight",  fontSize=20, color='lG',code=selAct('puyo','moveRight')},
    WIDGET.new{type='button', name='puyo',x=140, y=210,  w=200,h=60,text=LANG"keyset_puyo_rotateCW",   fontSize=20, color='lG',code=selAct('puyo','rotateCW' )},
    WIDGET.new{type='button', name='puyo',x=140, y=280,  w=200,h=60,text=LANG"keyset_puyo_rotateCCW",  fontSize=20, color='lG',code=selAct('puyo','rotateCCW')},
    WIDGET.new{type='button', name='puyo',x=140, y=350,  w=200,h=60,text=LANG"keyset_puyo_rotate180",  fontSize=20, color='lG',code=selAct('puyo','rotate180')},
    WIDGET.new{type='button', name='puyo',x=140, y=420,  w=200,h=60,text=LANG"keyset_puyo_softDrop",   fontSize=20, color='lG',code=selAct('puyo','softDrop' )},
    WIDGET.new{type='button', name='puyo',x=140, y=490,  w=200,h=60,text=LANG"keyset_puyo_hardDrop",   fontSize=20, color='lG',code=selAct('puyo','hardDrop' )},
    WIDGET.new{type='button', name='puyo',x=900, y=70,   w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('puyo','func1')},
    WIDGET.new{type='button', name='puyo',x=900, y=140,  w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('puyo','func2')},
    WIDGET.new{type='button', name='puyo',x=900, y=210,  w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('puyo','func3')},
    WIDGET.new{type='button', name='puyo',x=900, y=280,  w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('puyo','func4')},
    WIDGET.new{type='button', name='puyo',x=900, y=350,  w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('puyo','func5')},
    WIDGET.new{type='button', name='puyo',x=900, y=420,  w=200,h=60,text=LANG"keyset_func6",           fontSize=20, color='lY',code=selAct('puyo','func6')},

    WIDGET.new{type='button', name='gem', x=140, y=70,   w=200,h=60,text=LANG"keyset_gem_swapLeft",    fontSize=20, color='lG',code=selAct('gem', 'swapLeft' )},
    WIDGET.new{type='button', name='gem', x=140, y=140,  w=200,h=60,text=LANG"keyset_gem_swapRight",   fontSize=20, color='lG',code=selAct('gem', 'swapRight')},
    WIDGET.new{type='button', name='gem', x=140, y=210,  w=200,h=60,text=LANG"keyset_gem_swapUp",      fontSize=20, color='lG',code=selAct('gem', 'swapUp'   )},
    WIDGET.new{type='button', name='gem', x=140, y=280,  w=200,h=60,text=LANG"keyset_gem_swapDown",    fontSize=20, color='lG',code=selAct('gem', 'swapDown' )},
    WIDGET.new{type='button', name='gem', x=140, y=350,  w=200,h=60,text=LANG"keyset_gem_rotateCW",    fontSize=20, color='lG',code=selAct('gem', 'rotateCW' )},
    WIDGET.new{type='button', name='gem', x=140, y=420,  w=200,h=60,text=LANG"keyset_gem_rotateCCW",   fontSize=20, color='lG',code=selAct('gem', 'rotateCCW')},
    WIDGET.new{type='button', name='gem', x=140, y=490,  w=200,h=60,text=LANG"keyset_gem_rotate180",   fontSize=20, color='lG',code=selAct('gem', 'rotate180')},
    WIDGET.new{type='button', name='gem', x=140, y=560,  w=200,h=60,text=LANG"keyset_gem_moveLeft",    fontSize=20, color='lG',code=selAct('gem', 'moveLeft' )},
    WIDGET.new{type='button', name='gem', x=140, y=630,  w=200,h=60,text=LANG"keyset_gem_moveRight",   fontSize=20, color='lG',code=selAct('gem', 'moveRight')},
    WIDGET.new{type='button', name='gem', x=140, y=700,  w=200,h=60,text=LANG"keyset_gem_moveUp",      fontSize=20, color='lG',code=selAct('gem', 'moveUp'   )},
    WIDGET.new{type='button', name='gem', x=140, y=770,  w=200,h=60,text=LANG"keyset_gem_moveDown",    fontSize=20, color='lG',code=selAct('gem', 'moveDown' )},
    WIDGET.new{type='button', name='gem', x=900, y=70,   w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('gem', 'func1')},
    WIDGET.new{type='button', name='gem', x=900, y=140,  w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('gem', 'func2')},
    WIDGET.new{type='button', name='gem', x=900, y=210,  w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('gem', 'func3')},
    WIDGET.new{type='button', name='gem', x=900, y=280,  w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('gem', 'func4')},
    WIDGET.new{type='button', name='gem', x=900, y=350,  w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('gem', 'func5')},
    WIDGET.new{type='button', name='gem', x=900, y=420,  w=200,h=60,text=LANG"keyset_func6",           fontSize=20, color='lY',code=selAct('gem', 'func6')},

    WIDGET.new{type='button', name='sys', x=140, y=70,   w=200,h=60,text=LANG"keyset_sys_restart",     fontSize=20, color='lB',code=selAct('sys', 'restart')},
    WIDGET.new{type='button', name='sys', x=140, y=140,  w=200,h=60,text=LANG"keyset_sys_chat",        fontSize=20, color='lB',code=selAct('sys', 'chat'   )},
    WIDGET.new{type='button', name='sys', x=140, y=210,  w=200,h=60,text=LANG"keyset_sys_up",          fontSize=20, color='lB',code=selAct('sys', 'up'     )},
    WIDGET.new{type='button', name='sys', x=140, y=280,  w=200,h=60,text=LANG"keyset_sys_down",        fontSize=20, color='lB',code=selAct('sys', 'down'   )},
    WIDGET.new{type='button', name='sys', x=140, y=350,  w=200,h=60,text=LANG"keyset_sys_left",        fontSize=20, color='lB',code=selAct('sys', 'left'   )},
    WIDGET.new{type='button', name='sys', x=140, y=420,  w=200,h=60,text=LANG"keyset_sys_right",       fontSize=20, color='lB',code=selAct('sys', 'right'  )},
    WIDGET.new{type='button', name='sys', x=140, y=490,  w=200,h=60,text=LANG"keyset_sys_select",      fontSize=20, color='lB',code=selAct('sys', 'select' )},
    WIDGET.new{type='button', name='sys', x=140, y=560,  w=200,h=60,text=LANG"keyset_sys_back",        fontSize=20, color='lB',code=selAct('sys', 'back'   )},

    WIDGET.new{type='button', pos={1,1},x=-300,y=-80,    w=160,h=80,text=LANG'keyset_test', fontSize=45,code=function() SCN.go('game_simp',nil,'test_mino') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
