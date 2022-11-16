local scene={}

function scene.leave()
    saveSettings()
end

function scene.draw()
    PROGRESS.drawExteriorHeadbox()
end

local function sliderShow_time(S) return S.disp().." ms"  end

scene.scrollHeight=800
scene.widgetList={
    WIDGET.new{type='button',   pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back', fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},

    WIDGET.new{type='button',   pos={0,.5},x=290,y=-180,w=360,h=80,cornerR=0, fontSize=40, text=LANG'setting_keymapping',     code=function() SCN.go('keyset_list',nil,'mino') end},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=-60, w=40,labelPos='right',fontSize=40, text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    WIDGET.new{type='button',   pos={0,.5},x=290,y=20,  w=360,h=80,cornerR=0, fontSize=40, text=LANG'setting_touching',       code=WIDGET.c_goScn'keyset_touch',visibleFunc=TABLE.func_getVal(SETTINGS.system,'touchControl')},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=250, w=40,labelPos='right',fontSize=40, text=LANG'setting_fullscreen',     disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'), code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=350, w=40,labelPos='right',fontSize=40, text=LANG'setting_autoMute',       disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),   code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-370,w=400, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-290,w=400, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-210,w=400, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-130,w=400, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},

    WIDGET.new{type='slider',   pos={1,.5},x=-800, y=50, w=650, text=LANG'setting_das',    widthLimit=260,axis={100,260,10},disp=TABLE.func_getVal(SETTINGS.game_mino,'das'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'das')},
    WIDGET.new{type='slider',   pos={1,.5},x=-800, y=150,w=650, text=LANG'setting_arr',    widthLimit=260,axis={20,120,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'arr'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'arr')},
    WIDGET.new{type='slider',   pos={1,.5},x=-800, y=250,w=650, text=LANG'setting_sdarr',  widthLimit=260,axis={20,100,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'sdarr'),      valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'sdarr')},
    WIDGET.new{type='slider',   pos={1,.5},x=-800, y=350,w=650, text=LANG'setting_dascut', widthLimit=260,axis={0,100,10},  disp=TABLE.func_getVal(SETTINGS.game_mino,'dascut'),     valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'dascut')},
}
return scene
