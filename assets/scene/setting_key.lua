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
    SCN.go('setting_key_press','none',act)
end
local function selAct(act) return function() _selAct(act) end end

scene.widgetList={
    WIDGET.new{type='button', x=140, y=70,  w=200,h=60,text=LANG"key_act_moveLeft",   fontSize=20, color='lG',code=selAct'act_moveLeft'  },
    WIDGET.new{type='button', x=140, y=140, w=200,h=60,text=LANG"key_act_moveRight",  fontSize=20, color='lG',code=selAct'act_moveRight' },
    WIDGET.new{type='button', x=140, y=210, w=200,h=60,text=LANG"key_act_rotateCW",   fontSize=20, color='lG',code=selAct'act_rotateCW'  },
    WIDGET.new{type='button', x=140, y=280, w=200,h=60,text=LANG"key_act_rotateCCW",  fontSize=20, color='lG',code=selAct'act_rotateCCW' },
    WIDGET.new{type='button', x=140, y=350, w=200,h=60,text=LANG"key_act_rotate180",  fontSize=20, color='lG',code=selAct'act_rotate180' },
    WIDGET.new{type='button', x=140, y=420, w=200,h=60,text=LANG"key_act_holdPiece",  fontSize=20, color='lG',code=selAct'act_holdPiece' },
    WIDGET.new{type='button', x=140, y=490, w=200,h=60,text=LANG"key_act_softDrop",   fontSize=20, color='lG',code=selAct'act_softDrop'  },
    WIDGET.new{type='button', x=140, y=560, w=200,h=60,text=LANG"key_act_hardDrop",   fontSize=20, color='lG',code=selAct'act_hardDrop'  },
    WIDGET.new{type='button', x=140, y=630, w=200,h=60,text=LANG"key_act_sonicDrop",  fontSize=20, color='lG',code=selAct'act_sonicDrop' },
    WIDGET.new{type='button', x=140, y=700, w=200,h=60,text=LANG"key_act_sonicLeft",  fontSize=20, color='lG',code=selAct'act_sonicLeft' },
    WIDGET.new{type='button', x=140, y=770, w=200,h=60,text=LANG"key_act_sonicRight", fontSize=20, color='lG',code=selAct'act_sonicRight'},
    WIDGET.new{type='button', x=140, y=840, w=200,h=60,text=LANG"key_act_function1",  fontSize=20, color='lG',code=selAct'act_function1' },
    WIDGET.new{type='button', x=140, y=910, w=200,h=60,text=LANG"key_act_function2",  fontSize=20, color='lG',code=selAct'act_function2' },
    WIDGET.new{type='button', x=900, y=70,  w=200,h=60,text=LANG"key_act_function3",  fontSize=20, color='lG',code=selAct'act_function3' },
    WIDGET.new{type='button', x=900, y=140, w=200,h=60,text=LANG"key_act_function4",  fontSize=20, color='lG',code=selAct'act_function4' },
    WIDGET.new{type='button', x=900, y=210, w=200,h=60,text=LANG"key_act_function5",  fontSize=20, color='lG',code=selAct'act_function5' },
    WIDGET.new{type='button', x=900, y=280, w=200,h=60,text=LANG"key_act_function6",  fontSize=20, color='lG',code=selAct'act_function6' },
    WIDGET.new{type='button', x=900, y=350, w=200,h=60,text=LANG"key_game_restart",   fontSize=20, color='lR',code=selAct'game_restart'  },
    WIDGET.new{type='button', x=900, y=420, w=200,h=60,text=LANG"key_game_chat",      fontSize=20, color='lR',code=selAct'game_chat'     },
    WIDGET.new{type='button', x=900, y=490, w=200,h=60,text=LANG"key_menu_up",        fontSize=20, color='LD',code=selAct'menu_up'       },
    WIDGET.new{type='button', x=900, y=560, w=200,h=60,text=LANG"key_menu_down",      fontSize=20, color='LD',code=selAct'menu_down'     },
    WIDGET.new{type='button', x=900, y=630, w=200,h=60,text=LANG"key_menu_left",      fontSize=20, color='LD',code=selAct'menu_left'     },
    WIDGET.new{type='button', x=900, y=700, w=200,h=60,text=LANG"key_menu_right",     fontSize=20, color='LD',code=selAct'menu_right'    },
    WIDGET.new{type='button', x=900, y=770, w=200,h=60,text=LANG"key_menu_confirm",   fontSize=20, color='LD',code=selAct'menu_confirm'  },
    WIDGET.new{type='button', x=900, y=840, w=200,h=60,text=LANG"key_menu_back",      fontSize=20, color='LD',code=selAct'menu_back'     },

    WIDGET.new{type='button',pos={1,1},x=-480,y=-80,w=160,h=80,text=LANG'setting_key_touch',fontSize=45,code=WIDGET.c_goScn('setting_key_touch')},
    WIDGET.new{type='button',pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG'setting_key_test',fontSize=45,code=function() SCN.go('game_simp',nil,'test') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
