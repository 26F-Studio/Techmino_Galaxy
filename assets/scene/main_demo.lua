local scene={}

function scene.enter()
    playBgm('blank','base')
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='return' then
        SCN.go('game_simp',nil,'mino/sprint')
    elseif key=='c' then
        SCN.go('_console')
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={.5,.75},  x=-450,w=120,fontSize=80, text=CHAR.icon.language,  code=WIDGET.c_goScn'setting_lang'},
    WIDGET.new{type='button',pos={.5,.75},  x=-600,w=120,fontSize=90, text=CHAR.icon.music,     code=WIDGET.c_goScn'musicroom'},
    WIDGET.new{type='button',pos={.20,.2},  w=420,h=200, fontSize=50, text='MARATHON', code=playMode'mino/marathon'},
    WIDGET.new{type='button',pos={.50,.2},  w=420,h=200, fontSize=70, text='SPRINT',   code=playMode'mino/sprint'},
    WIDGET.new{type='button',pos={.80,.2},  w=420,h=200, fontSize=50, text='ULTRA',    code=playMode'mino/ultra'},
    WIDGET.new{type='button',pos={.20,.45}, w=420,h=200, fontSize=70, text='BATTLE',   code=playMode'battle'},
    WIDGET.new{type='button_fill',pos={.50,.45}, w=420,h=200, fontSize=70, text='',    code=NULL},
    WIDGET.new{type='button_fill',pos={.80,.45}, w=420,h=200, fontSize=60, text='',    code=NULL},
    WIDGET.new{type='button',pos={.5,.75},  w=626,h=200, fontSize=100,text=LANG'main_test_setting',code=WIDGET.c_goScn'setting_test'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=50,text=CHAR.icon.cross_big,code=WIDGET.c_backScn},
}
return scene
