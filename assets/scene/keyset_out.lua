local gc=love.graphics

---@type Zenitha.Scene
local scene={}

local keyMode='sys'
local keyMap
local keyButtons={}

function scene.load()
    BG.set('none')

    keyMap=KEYMAP[keyMode]

    TABLE.clear(keyButtons)

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
function scene.unload()
    if SCN.stackChange<0 then
        saveKey()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('fadeHeader') end end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='`' and isAltPressed then
        scene.widgetList.Sacry._visible=true
        scene.widgetList.Sgela._visible=true
        scene.widgetList.Sbrik._visible=true
        scene.widgetList.Ssys._visible=true
    end
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('fadeHeader')
    end
    return true
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
    {type='button',name='brik',x=140,y=180,w=200,h=60,text=LANG"keyset_brik_moveLeft",   fontSize=20, color='lG',code=selAct('brik','moveLeft'  )},
    {type='button',name='brik',x=140,y=250,w=200,h=60,text=LANG"keyset_brik_moveRight",  fontSize=20, color='lG',code=selAct('brik','moveRight' )},
    {type='button',name='brik',x=140,y=320,w=200,h=60,text=LANG"keyset_brik_rotateCW",   fontSize=20, color='lG',code=selAct('brik','rotateCW'  )},
    {type='button',name='brik',x=140,y=390,w=200,h=60,text=LANG"keyset_brik_rotateCCW",  fontSize=20, color='lG',code=selAct('brik','rotateCCW' )},
    {type='button',name='brik',x=140,y=460,w=200,h=60,text=LANG"keyset_brik_rotate180",  fontSize=20, color='lG',code=selAct('brik','rotate180' )},
    {type='button',name='brik',x=140,y=530,w=200,h=60,text=LANG"keyset_brik_softDrop",   fontSize=20, color='lG',code=selAct('brik','softDrop'  )},
    {type='button',name='brik',x=140,y=600,w=200,h=60,text=LANG"keyset_brik_hardDrop",   fontSize=20, color='lG',code=selAct('brik','hardDrop'  )},
    {type='button',name='brik',x=140,y=670,w=200,h=60,text=LANG"keyset_brik_holdPiece",  fontSize=20, color='lG',code=selAct('brik','holdPiece' )},
    {type='button',name='brik',x=140,y=740,w=200,h=60,text=LANG"keyset_brik_skip",       fontSize=20, color='lG',code=selAct('brik','skip' )},
    {type='button',name='brik',x=900,y=180,w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('brik','func1')},
    {type='button',name='brik',x=900,y=250,w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('brik','func2')},
    {type='button',name='brik',x=900,y=320,w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('brik','func3')},
    {type='button',name='brik',x=900,y=390,w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('brik','func4')},
    {type='button',name='brik',x=900,y=460,w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('brik','func5')},

    {type='button',name='gela',x=140,y=180,w=200,h=60,text=LANG"keyset_gela_moveLeft",   fontSize=20, color='lG',code=selAct('gela','moveLeft' )},
    {type='button',name='gela',x=140,y=250,w=200,h=60,text=LANG"keyset_gela_moveRight",  fontSize=20, color='lG',code=selAct('gela','moveRight')},
    {type='button',name='gela',x=140,y=320,w=200,h=60,text=LANG"keyset_gela_rotateCW",   fontSize=20, color='lG',code=selAct('gela','rotateCW' )},
    {type='button',name='gela',x=140,y=390,w=200,h=60,text=LANG"keyset_gela_rotateCCW",  fontSize=20, color='lG',code=selAct('gela','rotateCCW')},
    {type='button',name='gela',x=140,y=460,w=200,h=60,text=LANG"keyset_gela_rotate180",  fontSize=20, color='lG',code=selAct('gela','rotate180')},
    {type='button',name='gela',x=140,y=530,w=200,h=60,text=LANG"keyset_gela_softDrop",   fontSize=20, color='lG',code=selAct('gela','softDrop' )},
    {type='button',name='gela',x=140,y=600,w=200,h=60,text=LANG"keyset_gela_hardDrop",   fontSize=20, color='lG',code=selAct('gela','hardDrop' )},
    {type='button',name='gela',x=140,y=670,w=200,h=60,text=LANG"keyset_gela_skip",       fontSize=20, color='lG',code=selAct('gela','skip' )},
    {type='button',name='gela',x=900,y=180,w=200,h=60,text=LANG"keyset_func1",           fontSize=20, color='lY',code=selAct('gela','func1')},
    {type='button',name='gela',x=900,y=250,w=200,h=60,text=LANG"keyset_func2",           fontSize=20, color='lY',code=selAct('gela','func2')},
    {type='button',name='gela',x=900,y=320,w=200,h=60,text=LANG"keyset_func3",           fontSize=20, color='lY',code=selAct('gela','func3')},
    {type='button',name='gela',x=900,y=390,w=200,h=60,text=LANG"keyset_func4",           fontSize=20, color='lY',code=selAct('gela','func4')},
    {type='button',name='gela',x=900,y=460,w=200,h=60,text=LANG"keyset_func5",           fontSize=20, color='lY',code=selAct('gela','func5')},

    {type='button',name='acry', x=140,y=180,w=200,h=60,text=LANG"keyset_acry_swapLeft",  fontSize=20, color='lG',code=selAct('acry', 'swapLeft' )},
    {type='button',name='acry', x=140,y=250,w=200,h=60,text=LANG"keyset_acry_swapRight", fontSize=20, color='lG',code=selAct('acry', 'swapRight')},
    {type='button',name='acry', x=140,y=320,w=200,h=60,text=LANG"keyset_acry_swapUp",    fontSize=20, color='lG',code=selAct('acry', 'swapUp'   )},
    {type='button',name='acry', x=140,y=390,w=200,h=60,text=LANG"keyset_acry_swapDown",  fontSize=20, color='lG',code=selAct('acry', 'swapDown' )},
    {type='button',name='acry', x=140,y=460,w=200,h=60,text=LANG"keyset_acry_twistCW",   fontSize=20, color='lG',code=selAct('acry', 'twistCW'  )},
    {type='button',name='acry', x=140,y=530,w=200,h=60,text=LANG"keyset_acry_twistCCW",  fontSize=20, color='lG',code=selAct('acry', 'twistCCW' )},
    {type='button',name='acry', x=140,y=600,w=200,h=60,text=LANG"keyset_acry_twist180",  fontSize=20, color='lG',code=selAct('acry', 'twist180' )},
    {type='button',name='acry', x=140,y=670,w=200,h=60,text=LANG"keyset_acry_moveLeft",  fontSize=20, color='lG',code=selAct('acry', 'moveLeft' )},
    {type='button',name='acry', x=140,y=740,w=200,h=60,text=LANG"keyset_acry_moveRight", fontSize=20, color='lG',code=selAct('acry', 'moveRight')},
    {type='button',name='acry', x=140,y=810,w=200,h=60,text=LANG"keyset_acry_moveUp",    fontSize=20, color='lG',code=selAct('acry', 'moveUp'   )},
    {type='button',name='acry', x=140,y=880,w=200,h=60,text=LANG"keyset_acry_moveDown",  fontSize=20, color='lG',code=selAct('acry', 'moveDown' )},
    {type='button',name='acry', x=140,y=950,w=200,h=60,text=LANG"keyset_acry_skip",      fontSize=20, color='lG',code=selAct('acry', 'skip' )},
    {type='button',name='acry', x=900,y=180,w=200,h=60,text=LANG"keyset_func1",          fontSize=20, color='lY',code=selAct('acry', 'func1')},
    {type='button',name='acry', x=900,y=250,w=200,h=60,text=LANG"keyset_func2",          fontSize=20, color='lY',code=selAct('acry', 'func2')},
    {type='button',name='acry', x=900,y=320,w=200,h=60,text=LANG"keyset_func3",          fontSize=20, color='lY',code=selAct('acry', 'func3')},
    {type='button',name='acry', x=900,y=390,w=200,h=60,text=LANG"keyset_func4",          fontSize=20, color='lY',code=selAct('acry', 'func4')},
    {type='button',name='acry', x=900,y=460,w=200,h=60,text=LANG"keyset_func5",          fontSize=20, color='lY',code=selAct('acry', 'func5')},

    {type='button',name='sys', x=140,y=180,w=200,h=60,text=LANG"keyset_sys_view",        fontSize=20, color='lC',code=selAct('sys', 'view'   )},
    {type='button',name='sys', x=140,y=250,w=200,h=60,text=LANG"keyset_sys_restart",     fontSize=20, color='lC',code=selAct('sys', 'restart')},
    {type='button',name='sys', x=140,y=320,w=200,h=60,text=LANG"keyset_sys_chat",        fontSize=20, color='lC',code=selAct('sys', 'chat'   )},
    {type='button',name='sys', x=140,y=390,w=200,h=60,text=LANG"keyset_sys_back",        fontSize=20, color='lC',code=selAct('sys', 'back'   )},
    {type='button',name='sys', x=140,y=460,w=200,h=60,text=LANG"keyset_sys_quit",        fontSize=20, color='lC',code=selAct('sys', 'quit'   )},
    {type='button',name='sys', x=140,y=530,w=200,h=60,text=LANG"keyset_sys_setting",     fontSize=20, color='lC',code=selAct('sys', 'setting')},
    {type='button',name='sys', x=140,y=600,w=200,h=60,text=LANG"keyset_sys_help",        fontSize=20, color='lC',code=selAct('sys', 'help'   )},
    {type='button',name='sys', x=900,y=180,w=200,h=60,text=LANG"keyset_sys_left",        fontSize=20, color='lC',code=selAct('sys', 'left'   )},
    {type='button',name='sys', x=900,y=250,w=200,h=60,text=LANG"keyset_sys_right",       fontSize=20, color='lC',code=selAct('sys', 'right'  )},
    {type='button',name='sys', x=900,y=320,w=200,h=60,text=LANG"keyset_sys_up",          fontSize=20, color='lC',code=selAct('sys', 'up'     )},
    {type='button',name='sys', x=900,y=390,w=200,h=60,text=LANG"keyset_sys_down",        fontSize=20, color='lC',code=selAct('sys', 'down'   )},
    {type='button',name='sys', x=900,y=460,w=200,h=60,text=LANG"keyset_sys_select",      fontSize=20, color='lC',code=selAct('sys', 'select' )},

    {type='button_invis',name='Sacry',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=60,text="G",fontType='bold',sound_trigger='button_soft',code=function() if keyMode~='acry' then keyMode='acry'; scene.load() end end,visibleFunc=function() return PROGRESS.getStyleUnlock('acry') end},
    {type='button_invis',name='Sgela',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=60,text="P",fontType='bold',sound_trigger='button_soft',code=function() if keyMode~='gela' then keyMode='gela'; scene.load() end end,visibleFunc=function() return PROGRESS.getStyleUnlock('gela') end},
    {type='button_invis',name='Sbrik',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=60,text="M",fontType='bold',sound_trigger='button_soft',code=function() if keyMode~='brik' then keyMode='brik'; scene.load() end end,visibleFunc=function() return PROGRESS.getStyleUnlock('brik') end},
    {type='button_invis',name='Ssys', pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=60,text="S",fontType='bold',sound_trigger='button_soft',code=function() if keyMode~='sys'  then keyMode='sys';  scene.load() end end},

    {type='button',pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG"setting_test",fontSize=40,code=playExterior('brik/exterior/test'),visibleFunc=function() return not GAME.mode end},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'settings_title'},
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
}
return scene
