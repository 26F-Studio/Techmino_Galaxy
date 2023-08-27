local gc=love.graphics

local scene={}

local keyMode='sys'
local keyMap
local keyButtons={}

function scene.enter(mode)
    BG.set('none')

    keyMode=mode or keyMode
    keyMap=KEYMAP[keyMode]

    TABLE.cut(keyButtons)

    for _,v in next,scene.widgetList do
        if v.name then
            if v.name:sub(1,1)=='S' then
                v.color=v.name:sub(2)==keyMode and 'lS' or 'L'
            else
                local visible=v.name==keyMode
                v:setVisible(visible)
                if visible then
                    table.insert(keyButtons,v)
                end
            end
        end
    end
    WIDGET._reset()
end
function scene.leave()
    saveKey()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('fadeHeader')
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy)
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
    WIDGET.new{type='button',name='mino',x=140,y=200,w=200,h=60,text=LANG"keyset_mino_moveLeft",   fontSize=20, color='lG',code=selAct('mino','moveLeft'  )},
    WIDGET.new{type='button',name='mino',x=140,y=270,w=200,h=60,text=LANG"keyset_mino_moveRight",  fontSize=20, color='lG',code=selAct('mino','moveRight' )},
    WIDGET.new{type='button',name='mino',x=140,y=340,w=200,h=60,text=LANG"keyset_mino_rotateCW",   fontSize=20, color='lG',code=selAct('mino','rotateCW'  )},
    WIDGET.new{type='button',name='mino',x=140,y=410,w=200,h=60,text=LANG"keyset_mino_rotateCCW",  fontSize=20, color='lG',code=selAct('mino','rotateCCW' )},
    WIDGET.new{type='button',name='mino',x=140,y=480,w=200,h=60,text=LANG"keyset_mino_rotate180",  fontSize=20, color='lG',code=selAct('mino','rotate180' )},
    WIDGET.new{type='button',name='mino',x=140,y=550,w=200,h=60,text=LANG"keyset_mino_softDrop",   fontSize=20, color='lG',code=selAct('mino','softDrop'  )},
    WIDGET.new{type='button',name='mino',x=140,y=620,w=200,h=60,text=LANG"keyset_mino_hardDrop",   fontSize=20, color='lG',code=selAct('mino','hardDrop'  )},
    WIDGET.new{type='button',name='mino',x=140,y=690,w=200,h=60,text=LANG"keyset_mino_holdPiece",  fontSize=20, color='lG',code=selAct('mino','holdPiece' )},
    WIDGET.new{type='button',name='mino',x=140,y=760,w=200,h=60,text=LANG"keyset_mino_skip",       fontSize=20, color='lG',code=selAct('mino','skip' )},
    WIDGET.new{type='button',name='mino',x=900,y=200,w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('mino','func1')},
    WIDGET.new{type='button',name='mino',x=900,y=270,w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('mino','func2')},
    WIDGET.new{type='button',name='mino',x=900,y=340,w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('mino','func3')},
    WIDGET.new{type='button',name='mino',x=900,y=410,w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('mino','func4')},
    WIDGET.new{type='button',name='mino',x=900,y=480,w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('mino','func5')},

    WIDGET.new{type='button',name='puyo',x=140,y=200,w=200,h=60,text=LANG"keyset_puyo_moveLeft",   fontSize=20, color='lG',code=selAct('puyo','moveLeft' )},
    WIDGET.new{type='button',name='puyo',x=140,y=270,w=200,h=60,text=LANG"keyset_puyo_moveRight",  fontSize=20, color='lG',code=selAct('puyo','moveRight')},
    WIDGET.new{type='button',name='puyo',x=140,y=340,w=200,h=60,text=LANG"keyset_puyo_rotateCW",   fontSize=20, color='lG',code=selAct('puyo','rotateCW' )},
    WIDGET.new{type='button',name='puyo',x=140,y=410,w=200,h=60,text=LANG"keyset_puyo_rotateCCW",  fontSize=20, color='lG',code=selAct('puyo','rotateCCW')},
    WIDGET.new{type='button',name='puyo',x=140,y=480,w=200,h=60,text=LANG"keyset_puyo_rotate180",  fontSize=20, color='lG',code=selAct('puyo','rotate180')},
    WIDGET.new{type='button',name='puyo',x=140,y=550,w=200,h=60,text=LANG"keyset_puyo_softDrop",   fontSize=20, color='lG',code=selAct('puyo','softDrop' )},
    WIDGET.new{type='button',name='puyo',x=140,y=620,w=200,h=60,text=LANG"keyset_puyo_hardDrop",   fontSize=20, color='lG',code=selAct('puyo','hardDrop' )},
    WIDGET.new{type='button',name='puyo',x=140,y=970,w=200,h=60,text=LANG"keyset_puyo_skip",       fontSize=20, color='lG',code=selAct('puyo','skip' )},
    WIDGET.new{type='button',name='puyo',x=900,y=200,w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('puyo','func1')},
    WIDGET.new{type='button',name='puyo',x=900,y=270,w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('puyo','func2')},
    WIDGET.new{type='button',name='puyo',x=900,y=340,w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('puyo','func3')},
    WIDGET.new{type='button',name='puyo',x=900,y=410,w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('puyo','func4')},
    WIDGET.new{type='button',name='puyo',x=900,y=480,w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('puyo','func5')},

    WIDGET.new{type='button',name='gem', x=140,y=200,w=200,h=60,text=LANG"keyset_gem_swapLeft",    fontSize=20, color='lG',code=selAct('gem', 'swapLeft' )},
    WIDGET.new{type='button',name='gem', x=140,y=270,w=200,h=60,text=LANG"keyset_gem_swapRight",   fontSize=20, color='lG',code=selAct('gem', 'swapRight')},
    WIDGET.new{type='button',name='gem', x=140,y=340,w=200,h=60,text=LANG"keyset_gem_swapUp",      fontSize=20, color='lG',code=selAct('gem', 'swapUp'   )},
    WIDGET.new{type='button',name='gem', x=140,y=410,w=200,h=60,text=LANG"keyset_gem_swapDown",    fontSize=20, color='lG',code=selAct('gem', 'swapDown' )},
    WIDGET.new{type='button',name='gem', x=140,y=480,w=200,h=60,text=LANG"keyset_gem_twistCW",     fontSize=20, color='lG',code=selAct('gem', 'twistCW'  )},
    WIDGET.new{type='button',name='gem', x=140,y=550,w=200,h=60,text=LANG"keyset_gem_twistCCW",    fontSize=20, color='lG',code=selAct('gem', 'twistCCW' )},
    WIDGET.new{type='button',name='gem', x=140,y=620,w=200,h=60,text=LANG"keyset_gem_twist180",    fontSize=20, color='lG',code=selAct('gem', 'twist180' )},
    WIDGET.new{type='button',name='gem', x=140,y=690,w=200,h=60,text=LANG"keyset_gem_moveLeft",    fontSize=20, color='lG',code=selAct('gem', 'moveLeft' )},
    WIDGET.new{type='button',name='gem', x=140,y=760,w=200,h=60,text=LANG"keyset_gem_moveRight",   fontSize=20, color='lG',code=selAct('gem', 'moveRight')},
    WIDGET.new{type='button',name='gem', x=140,y=830,w=200,h=60,text=LANG"keyset_gem_moveUp",      fontSize=20, color='lG',code=selAct('gem', 'moveUp'   )},
    WIDGET.new{type='button',name='gem', x=140,y=900,w=200,h=60,text=LANG"keyset_gem_moveDown",    fontSize=20, color='lG',code=selAct('gem', 'moveDown' )},
    WIDGET.new{type='button',name='gem', x=140,y=970,w=200,h=60,text=LANG"keyset_gem_skip",        fontSize=20, color='lG',code=selAct('gem', 'skip' )},
    WIDGET.new{type='button',name='gem', x=900,y=200,w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('gem', 'func1')},
    WIDGET.new{type='button',name='gem', x=900,y=270,w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('gem', 'func2')},
    WIDGET.new{type='button',name='gem', x=900,y=340,w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('gem', 'func3')},
    WIDGET.new{type='button',name='gem', x=900,y=410,w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('gem', 'func4')},
    WIDGET.new{type='button',name='gem', x=900,y=480,w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('gem', 'func5')},

    WIDGET.new{type='button',name='sys', x=140,y=200,w=200,h=60,text=LANG"keyset_sys_view",        fontSize=20, color='lC',code=selAct('sys', 'view'   )},
    WIDGET.new{type='button',name='sys', x=140,y=270,w=200,h=60,text=LANG"keyset_sys_restart",     fontSize=20, color='lC',code=selAct('sys', 'restart')},
    WIDGET.new{type='button',name='sys', x=140,y=340,w=200,h=60,text=LANG"keyset_sys_chat",        fontSize=20, color='lC',code=selAct('sys', 'chat'   )},
    WIDGET.new{type='button',name='sys', x=140,y=410,w=200,h=60,text=LANG"keyset_sys_back",        fontSize=20, color='lC',code=selAct('sys', 'back'   )},
    WIDGET.new{type='button',name='sys', x=140,y=480,w=200,h=60,text=LANG"keyset_sys_quit",        fontSize=20, color='lC',code=selAct('sys', 'quit'   )},
    WIDGET.new{type='button',name='sys', x=140,y=550,w=200,h=60,text=LANG"keyset_sys_setting",     fontSize=20, color='lC',code=selAct('sys', 'setting')},
    WIDGET.new{type='button',name='sys', x=140,y=620,w=200,h=60,text=LANG"keyset_sys_help",        fontSize=20, color='lC',code=selAct('sys', 'help'   )},
    WIDGET.new{type='button',name='sys', x=900,y=200,w=200,h=60,text=LANG"keyset_sys_left",        fontSize=20, color='lC',code=selAct('sys', 'left'   )},
    WIDGET.new{type='button',name='sys', x=900,y=270,w=200,h=60,text=LANG"keyset_sys_right",       fontSize=20, color='lC',code=selAct('sys', 'right'  )},
    WIDGET.new{type='button',name='sys', x=900,y=340,w=200,h=60,text=LANG"keyset_sys_up",          fontSize=20, color='lC',code=selAct('sys', 'up'     )},
    WIDGET.new{type='button',name='sys', x=900,y=410,w=200,h=60,text=LANG"keyset_sys_down",        fontSize=20, color='lC',code=selAct('sys', 'down'   )},
    WIDGET.new{type='button',name='sys', x=900,y=480,w=200,h=60,text=LANG"keyset_sys_select",      fontSize=20, color='lC',code=selAct('sys', 'select' )},

    WIDGET.new{type='button_invis',name='Sgem', pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=60,text="G",fontType='bold',sound_trigger='move',code=function() if keyMode~='gem'  then scene.enter('gem')  end end,visibleFunc=function() return PROGRESS.getModeUnlocked('gem_wip') end},
    WIDGET.new{type='button_invis',name='Spuyo',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=60,text="P",fontType='bold',sound_trigger='move',code=function() if keyMode~='puyo' then scene.enter('puyo') end end,visibleFunc=function() return PROGRESS.getModeUnlocked('puyo_wip') end},
    WIDGET.new{type='button_invis',name='Smino',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=60,text="M",fontType='bold',sound_trigger='move',code=function() if keyMode~='mino' then scene.enter('mino') end end,visibleFunc=function() return PROGRESS.getModeUnlocked('mino_stdMap') end},
    WIDGET.new{type='button_invis',name='Ssys', pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=60,text="S",fontType='bold',sound_trigger='move',code=function() if keyMode~='sys'  then scene.enter('sys')  end end},

    WIDGET.new{type='button',pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG"setting_test",fontSize=40,code=playExterior'mino/exterior/test',visibleFunc=function() return not GAME.mode end},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'settings_title'},
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
}
return scene
