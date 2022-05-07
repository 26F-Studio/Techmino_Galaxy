local scene={}

function scene.enter()
    BG.set('image')BG.send('image',.12,IMG.cover)
    playBgm('blank','-base')
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='return' then
        SCN.go('game_simp',nil,'sprint')
    elseif key=='c' then
        SCN.go('_console')
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={.5,.75},  x=-500,w=120,fontSize=80, text=CHAR.icon.language,  code=WIDGET.c_goScn'setting_lang'},
    WIDGET.new{type='button',pos={.20,.2},  w=420,h=200, fontSize=50, text='MARATHON', code=function() SCN.go('game_simp',nil,'marathon') end},
    WIDGET.new{type='button',pos={.50,.2},  w=420,h=200, fontSize=70, text='SPRINT',   code=function() SCN.go('game_simp',nil,'sprint') end},
    WIDGET.new{type='button',pos={.80,.2},  w=420,h=200, fontSize=50, text='ULTRA',    code=function() SCN.go('game_simp',nil,'ultra') end},
    WIDGET.new{type='button',pos={.20,.45}, w=420,h=200, fontSize=70, text='SOLO',     code=function() SCN.go('game_simp',nil,'solo') end},
    WIDGET.new{type='button',pos={.50,.45}, w=420,h=200, fontSize=70, text='',         code=NULL},
    WIDGET.new{type='button',pos={.80,.45}, w=420,h=200, fontSize=60, text='',         code=NULL},
    WIDGET.new{type='button',pos={.5,.75},  w=626,h=200, fontSize=100,text=LANG'main_1_setting',code=WIDGET.c_goScn('setting_1')},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=50,text=CHAR.icon.cross_thick,code=WIDGET.c_backScn},
}
return scene
