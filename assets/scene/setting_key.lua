local gc=love.graphics

local scene={}

function scene.enter()
    BG.set('none')
end
function scene.leave()
    saveKey()
end

function scene.draw()
    FONT.set(25)
    gc.setColor(COLOR.L)
    for i=1,#KEYMAP do
        local l=KEYMAP[i].keys
        for j=1,#l do
            GC.mStr(l[j],
                scene.widgetList[i].x+79+80*j,
                scene.widgetList[i].y-20
            )
        end
    end
end

local function _selAct(act)
    SCN.go('setting_presskey','none',act)
end
local function selAct(act) return function() _selAct(act) end end

scene.widgetList={
    WIDGET.new{type='button', x=140, y=80,  w=200,h=60,text=LANG"key_act_moveLeft",   fontSize=20, color='lG',code=selAct'act_moveLeft'  },
    WIDGET.new{type='button', x=140, y=150, w=200,h=60,text=LANG"key_act_moveRight",  fontSize=20, color='lG',code=selAct'act_moveRight' },
    WIDGET.new{type='button', x=140, y=220, w=200,h=60,text=LANG"key_act_rotateCW",   fontSize=20, color='lG',code=selAct'act_rotateCW'  },
    WIDGET.new{type='button', x=140, y=290, w=200,h=60,text=LANG"key_act_rotateCCW",  fontSize=20, color='lG',code=selAct'act_rotateCCW' },
    WIDGET.new{type='button', x=140, y=360, w=200,h=60,text=LANG"key_act_rotate180",  fontSize=20, color='lG',code=selAct'act_rotate180' },
    WIDGET.new{type='button', x=140, y=430, w=200,h=60,text=LANG"key_act_holdPiece",  fontSize=20, color='lG',code=selAct'act_holdPiece' },
    WIDGET.new{type='button', x=140, y=500, w=200,h=60,text=LANG"key_act_softDrop",   fontSize=20, color='lG',code=selAct'act_softDrop'  },
    WIDGET.new{type='button', x=140, y=570, w=200,h=60,text=LANG"key_act_hardDrop",   fontSize=20, color='lG',code=selAct'act_hardDrop'  },
    WIDGET.new{type='button', x=140, y=640, w=200,h=60,text=LANG"key_act_sonicDrop",  fontSize=20, color='lG',code=selAct'act_sonicDrop' },
    WIDGET.new{type='button', x=140, y=710, w=200,h=60,text=LANG"key_act_sonicLeft",  fontSize=20, color='lG',code=selAct'act_sonicLeft' },
    WIDGET.new{type='button', x=140, y=780, w=200,h=60,text=LANG"key_act_sonicRight", fontSize=20, color='lG',code=selAct'act_sonicRight'},
    WIDGET.new{type='button', x=140, y=850, w=200,h=60,text=LANG"key_act_function1",  fontSize=20, color='lG',code=selAct'act_function1' },
    WIDGET.new{type='button', x=140, y=920, w=200,h=60,text=LANG"key_act_function2",  fontSize=20, color='lG',code=selAct'act_function2' },
    WIDGET.new{type='button', x=670, y=80,  w=200,h=60,text=LANG"key_act_function3",  fontSize=20, color='lG',code=selAct'act_function3' },
    WIDGET.new{type='button', x=670, y=150, w=200,h=60,text=LANG"key_act_function4",  fontSize=20, color='lG',code=selAct'act_function4' },
    WIDGET.new{type='button', x=670, y=220, w=200,h=60,text=LANG"key_act_function5",  fontSize=20, color='lG',code=selAct'act_function5' },
    WIDGET.new{type='button', x=670, y=290, w=200,h=60,text=LANG"key_act_function6",  fontSize=20, color='lG',code=selAct'act_function6' },
    WIDGET.new{type='button', x=670, y=360, w=200,h=60,text=LANG"key_game_restart",   fontSize=20, color='lR',code=selAct'game_restart'  },
    WIDGET.new{type='button', x=670, y=430, w=200,h=60,text=LANG"key_game_chat",      fontSize=20, color='lR',code=selAct'game_chat'     },
    WIDGET.new{type='button', x=670, y=500, w=200,h=60,text=LANG"key_menu_up",        fontSize=20, color='LD',code=selAct'menu_up'       },
    WIDGET.new{type='button', x=670, y=570, w=200,h=60,text=LANG"key_menu_down",      fontSize=20, color='LD',code=selAct'menu_down'     },
    WIDGET.new{type='button', x=670, y=640, w=200,h=60,text=LANG"key_menu_left",      fontSize=20, color='LD',code=selAct'menu_left'     },
    WIDGET.new{type='button', x=670, y=710, w=200,h=60,text=LANG"key_menu_right",     fontSize=20, color='LD',code=selAct'menu_right'    },
    WIDGET.new{type='button', x=670, y=780, w=200,h=60,text=LANG"key_menu_confirm",   fontSize=20, color='LD',code=selAct'menu_confirm'  },
    WIDGET.new{type='button', x=670, y=850, w=200,h=60,text=LANG"key_menu_back",      fontSize=20, color='LD',code=selAct'menu_back'     },
    WIDGET.new{type='button', x=670, y=920, w=200,h=60,text=LANG"key_rep_pause",      fontSize=20, color='LD',code=selAct'rep_pause'     },
    WIDGET.new{type='button', x=1200,y=80,  w=200,h=60,text=LANG"key_rep_prevFrame",  fontSize=20, color='LD',code=selAct'rep_prevFrame' },
    WIDGET.new{type='button', x=1200,y=150, w=200,h=60,text=LANG"key_rep_nextFrame",  fontSize=20, color='LD',code=selAct'rep_nextFrame' },
    WIDGET.new{type='button', x=1200,y=220, w=200,h=60,text=LANG"key_rep_speedDown",  fontSize=20, color='LD',code=selAct'rep_speedDown' },
    WIDGET.new{type='button', x=1200,y=290, w=200,h=60,text=LANG"key_rep_speedUp",    fontSize=20, color='LD',code=selAct'rep_speedUp'   },
    WIDGET.new{type='button', x=1200,y=360, w=200,h=60,text=LANG"key_rep_speed1_16x", fontSize=20, color='LD',code=selAct'rep_speed1_16x'},
    WIDGET.new{type='button', x=1200,y=430, w=200,h=60,text=LANG"key_rep_speed1_6x",  fontSize=20, color='LD',code=selAct'rep_speed1_6x' },
    WIDGET.new{type='button', x=1200,y=500, w=200,h=60,text=LANG"key_rep_speed1_2x",  fontSize=20, color='LD',code=selAct'rep_speed1_2x' },
    WIDGET.new{type='button', x=1200,y=570, w=200,h=60,text=LANG"key_rep_speed1x",    fontSize=20, color='LD',code=selAct'rep_speed1x'   },
    WIDGET.new{type='button', x=1200,y=640, w=200,h=60,text=LANG"key_rep_speed2x",    fontSize=20, color='LD',code=selAct'rep_speed2x'   },
    WIDGET.new{type='button', x=1200,y=710, w=200,h=60,text=LANG"key_rep_speed6x",    fontSize=20, color='LD',code=selAct'rep_speed6x'   },
    WIDGET.new{type='button', x=1200,y=780, w=200,h=60,text=LANG"key_rep_speed16x",   fontSize=20, color='LD',code=selAct'rep_speed16x'  },

    -- Test
    WIDGET.new{type='button',     pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG'setting_test',fontSize=45,        code=function() SCN.go('game_simp',nil,'test') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
