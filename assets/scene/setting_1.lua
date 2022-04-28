local gc=love.graphics

local actionSelected

local scene={}

function scene.enter()
    actionSelected=false
end
function scene.leave()
    saveSetting()
    saveKey()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        if actionSelected then
            actionSelected=false
        else
            SCN.back()
        end
    elseif key=='backspace' then
        if actionSelected then
            TABLE.cut(KEYMAP:_getKeys(actionSelected))
            actionSelected=false
        end
    elseif actionSelected then
        for i=1,#KEYMAP do
            if KEYMAP[i].act==actionSelected then
                for j=1,#KEYMAP do
                    local k=TABLE.find(KEYMAP[j].keys,key)
                    if k then
                        table.remove(KEYMAP[j].keys,k)
                    end
                end
                table.insert(KEYMAP[i].keys,key)
                while #KEYMAP[i].keys>=5 do
                    table.remove(KEYMAP[i].keys,1)
                end
                actionSelected=false
                break
            end
        end
    end
end

function scene.draw()
    gc.replaceTransform(SCR.xOy_ur)
    local t=love.timer.getTime()
    -- Character
    gc.translate(-600,800)
    gc.setColor(1,1,1)
    gc.scale(.7)
    GC.draw(IMG.z.character)
    GC.draw(IMG.z.screen1, -91, -157+16*math.sin(t))
    GC.draw(IMG.z.screen2, 120, -166+16*math.sin(t+1))
    gc.setColor(1,1,1,.7+.3*math.sin(.6*t)) GC.draw(IMG.z.particle1, -50,                    42+6*math.sin(t*0.36))
    gc.setColor(1,1,1,.7+.3*math.sin(.7*t)) GC.draw(IMG.z.particle2, 110+6*math.sin(t*0.92), 55)
    gc.setColor(1,1,1,.7+.3*math.sin(.8*t)) GC.draw(IMG.z.particle3, -54+6*math.sin(t*0.48), -248)
    gc.setColor(1,1,1,.7+.3*math.sin(.9*t)) GC.draw(IMG.z.particle4, 133,                    -305+6*math.sin(t*0.40))

    gc.replaceTransform(SCR.xOy_ul)
    gc.translate(0,-SCN.curScroll)
    FONT.set(30)
    gc.setColor(COLOR.L)
    for i=1,39 do
        local y=660+70*i
        if actionSelected==KEYMAP[i].act then
            gc.setLineWidth(4)
            gc.setColor(t%.4<.2 and COLOR.lR or COLOR.lY)
            gc.rectangle('line',85,y-15,230,70,15)
            gc.setColor(COLOR.L)
        end
        local l=KEYMAP[i].keys
        for j=1,#l do
            GC.mStr(l[j],270+100*j,y)
        end
    end
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_fps(S)  return S.disp().." FPS" end
local function sliderShow_mul(S)  return S.disp().."%"    end
local function _selAct(act) if actionSelected==act then actionSelected=false else actionSelected=act end end
local function selAct(act) return function() _selAct(act) end end

scene.scrollHeight=2500
scene.widgetList={
    -- Game: handling
    WIDGET.new{type='slider',     pos={0,0},x=260, y=100,w=1000,    text=LANG'setting_das',         widthLimit=260,axis={0,260,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'das'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'das')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=160,w=1000,    text=LANG'setting_arr',         widthLimit=260,axis={0,120,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'arr'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'arr')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=220,w=1000,    text=LANG'setting_sdarr',       widthLimit=260,axis={0,100,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'sdarr'),      valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'sdarr')},

    -- Game: video
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=280,w=500,     text=LANG'setting_shakeness',   widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.game,'shakeness'),                             code=TABLE.func_setVal(SETTINGS.game,'shakeness')},

    -- System: audio
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=370,w=500,h=35,text=LANG'setting_mainVol',     widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'mainVol'),                             code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=420,w=500,h=35,text=LANG'setting_bgm',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),                              code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=470,w=500,h=35,text=LANG'setting_sfx',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),                              code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},

    -- System: video
    WIDGET.new{type='slider',     pos={0,0},x=260, y=520,w=500,     text=LANG'setting_maxFPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps,  code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=570,w=500,     text=LANG'setting_updRate',     widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=620,w=500,     text=LANG'setting_drawRate',    widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'drawRate')},

    -- System: other
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=370,           text=LANG'setting_sysCursor',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),                           code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=420,           text=LANG'setting_clickFX',     widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'clickFX'),                             code=TABLE.func_revVal(SETTINGS.system,'clickFX')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=470,           text=LANG'setting_power',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),                           code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=520,           text=LANG'setting_clean',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'),                         code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=570,           text=LANG'setting_fullscreen',  widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),                          code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=620,           text=LANG'setting_autoMute',    widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),                            code=TABLE.func_revVal(SETTINGS.system,'autoMute')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=670,           text=LANG'setting_showTouch',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),                           code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Act: keys
    WIDGET.new{type='button',     pos={0,0},x=200,y=750, w=220,h=60,text=LANG"key_game_restart",    fontSize=20,   code=selAct'game_restart'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=820, w=220,h=60,text=LANG"key_game_chat",       fontSize=20,   code=selAct'game_chat'     },
    WIDGET.new{type='button',     pos={0,0},x=200,y=890, w=220,h=60,text=LANG"key_act_moveLeft",    fontSize=20,   code=selAct'act_moveLeft'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=960, w=220,h=60,text=LANG"key_act_moveRight",   fontSize=20,   code=selAct'act_moveRight' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1030,w=220,h=60,text=LANG"key_act_rotateCW",    fontSize=20,   code=selAct'act_rotateCW'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1100,w=220,h=60,text=LANG"key_act_rotateCCW",   fontSize=20,   code=selAct'act_rotateCCW' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1170,w=220,h=60,text=LANG"key_act_rotate180",   fontSize=20,   code=selAct'act_rotate180' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1240,w=220,h=60,text=LANG"key_act_holdPiece",   fontSize=20,   code=selAct'act_holdPiece' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1310,w=220,h=60,text=LANG"key_act_softDrop",    fontSize=20,   code=selAct'act_softDrop'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1380,w=220,h=60,text=LANG"key_act_hardDrop",    fontSize=20,   code=selAct'act_hardDrop'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1450,w=220,h=60,text=LANG"key_act_sonicDrop",   fontSize=20,   code=selAct'act_sonicDrop' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1520,w=220,h=60,text=LANG"key_act_sonicLeft",   fontSize=20,   code=selAct'act_sonicLeft' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1590,w=220,h=60,text=LANG"key_act_sonicRight",  fontSize=20,   code=selAct'act_sonicRight'},
    WIDGET.new{type='button',     pos={0,0},x=200,y=1660,w=220,h=60,text=LANG"key_act_function1",   fontSize=20,   code=selAct'act_function1' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1730,w=220,h=60,text=LANG"key_act_function2",   fontSize=20,   code=selAct'act_function2' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1800,w=220,h=60,text=LANG"key_act_function3",   fontSize=20,   code=selAct'act_function3' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1870,w=220,h=60,text=LANG"key_act_function4",   fontSize=20,   code=selAct'act_function4' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=1940,w=220,h=60,text=LANG"key_act_target1",     fontSize=20,   code=selAct'act_target1'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2010,w=220,h=60,text=LANG"key_act_target2",     fontSize=20,   code=selAct'act_target2'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2080,w=220,h=60,text=LANG"key_act_target3",     fontSize=20,   code=selAct'act_target3'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2150,w=220,h=60,text=LANG"key_act_target4",     fontSize=20,   code=selAct'act_target4'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2220,w=220,h=60,text=LANG"key_menu_up",         fontSize=20,   code=selAct'menu_up'       },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2290,w=220,h=60,text=LANG"key_menu_down",       fontSize=20,   code=selAct'menu_down'     },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2360,w=220,h=60,text=LANG"key_menu_left",       fontSize=20,   code=selAct'menu_left'     },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2430,w=220,h=60,text=LANG"key_menu_right",      fontSize=20,   code=selAct'menu_right'    },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2500,w=220,h=60,text=LANG"key_menu_confirm",    fontSize=20,   code=selAct'menu_confirm'  },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2570,w=220,h=60,text=LANG"key_menu_back",       fontSize=20,   code=selAct'menu_back'     },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2640,w=220,h=60,text=LANG"key_rep_pause",       fontSize=20,   code=selAct'rep_pause'     },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2710,w=220,h=60,text=LANG"key_rep_prevFrame",   fontSize=20,   code=selAct'rep_prevFrame' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2780,w=220,h=60,text=LANG"key_rep_nextFrame",   fontSize=20,   code=selAct'rep_nextFrame' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2850,w=220,h=60,text=LANG"key_rep_speedDown",   fontSize=20,   code=selAct'rep_speedDown' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2920,w=220,h=60,text=LANG"key_rep_speedUp",     fontSize=20,   code=selAct'rep_speedUp'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=2990,w=220,h=60,text=LANG"key_rep_speed1_16x",  fontSize=20,   code=selAct'rep_speed1_16x'},
    WIDGET.new{type='button',     pos={0,0},x=200,y=3060,w=220,h=60,text=LANG"key_rep_speed1_6x",   fontSize=20,   code=selAct'rep_speed1_6x' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=3130,w=220,h=60,text=LANG"key_rep_speed1_2x",   fontSize=20,   code=selAct'rep_speed1_2x' },
    WIDGET.new{type='button',     pos={0,0},x=200,y=3200,w=220,h=60,text=LANG"key_rep_speed1x",     fontSize=20,   code=selAct'rep_speed1x'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=3270,w=220,h=60,text=LANG"key_rep_speed2x",     fontSize=20,   code=selAct'rep_speed2x'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=3340,w=220,h=60,text=LANG"key_rep_speed6x",     fontSize=20,   code=selAct'rep_speed6x'   },
    WIDGET.new{type='button',     pos={0,0},x=200,y=3410,w=220,h=60,text=LANG"key_rep_speed16x",    fontSize=20,   code=selAct'rep_speed16x'  },

    -- Test
    WIDGET.new{type='button',     pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG'setting_test',fontSize=45,        code=function() SCN.go('game_simp',nil,'test') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
