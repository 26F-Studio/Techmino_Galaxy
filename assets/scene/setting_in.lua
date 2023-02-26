local scene={}

function scene.enter()
    local L=scene.widgetList
    if PROGRESS.getMain()==1 then
        L.das.y=250
        L.arr.y=350
        L.sdarr:setVisible(false)
    else
        L.das.y=150
        L.arr.y=250
        L.sdarr.y=350
        L.sdarr:setVisible(true)
    end
    WIDGET._reset()
end
function scene.leave()
    saveSettings()
end

function scene.keyDown(key)
    if key=='escape' then
        SCN.back('none')
    else
        return true
    end
end

local function sliderShow_time(S) return S.disp().." ms"  end

scene.widgetList={
    WIDGET.new{type='button',   pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    WIDGET.new{type='button',   pos={0,.5},x=290,y=-180,w=360,h=80,lineWidth=4,cornerR=0,                  fontSize=40, text=LANG'setting_keymapping',     code=WIDGET.c_goScn('keyset_in','none')},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=-60, w=40,      lineWidth=4,cornerR=0,labelPos='right', fontSize=40, text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    WIDGET.new{type='button',   pos={0,.5},x=290,y=20,  w=360,h=80,lineWidth=4,cornerR=0,                  fontSize=40, text=LANG'setting_touching',       code=WIDGET.c_goScn('keyset_touch','none'),visibleFunc=TABLE.func_getVal(SETTINGS.system,'touchControl')},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=250, w=40,      lineWidth=4,cornerR=0,labelPos='right', fontSize=40, text=LANG'setting_fullscreen',     disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'), code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{type='checkBox', pos={0,.5},x=130,y=350, w=40,      lineWidth=4,cornerR=0,labelPos='right', fontSize=40, text=LANG'setting_autoMute',       disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),   code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-370,w=400, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-290,w=400, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-210,w=400, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    WIDGET.new{type='slider',   pos={1,.5},x=-550, y=-130,w=400, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},

    WIDGET.new{type='slider',   name='das',    pos={1,.5},x=-800, y=50, w=650, text=LANG'setting_das',    widthLimit=260,axis={100,260,10},disp=TABLE.func_getVal(SETTINGS.game_mino,'das'),        valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.das=v; SETTINGS.game_mino.arr=math.min(SETTINGS.game_mino.arr,SETTINGS.game_mino.das) end},
    WIDGET.new{type='slider',   name='arr',    pos={1,.5},x=-800, y=150,w=650, text=LANG'setting_arr',    widthLimit=260,axis={20,120,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'arr'),        valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.arr=v; SETTINGS.game_mino.das=math.max(SETTINGS.game_mino.das,SETTINGS.game_mino.arr) end},
    WIDGET.new{type='slider',   name='sdarr',  pos={1,.5},x=-800, y=250,w=650, text=LANG'setting_sdarr',  widthLimit=260,axis={20,100,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'sdarr'),      valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'sdarr')},
}
return scene
