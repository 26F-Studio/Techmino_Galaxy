local scene={}
local page
--[[ Pages:
    1 = Controls
    2 = Audio
    3 = Video
    4 = Gameplay
]]

function scene.enter()
    page=tostring(SCN.args[1] or 1)
    for _,v in next,scene.widgetList do
        if v.name then
            if v.name:sub(1,1)=='S' then
                v.color=v.name:sub(2,2)==page and 'L' or 'LD'
            else
                v._visible=v.name==page
            end
        end
    end
    WIDGET._reset()
    BG.set('none')
end
function scene.leave()
    saveSettings()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        SCN.back('fadeHeader')
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_fps(S)  return S.disp().." FPS" end
local function sliderShow_mul(S)  return S.disp().."%"    end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn('fadeHeader')},

    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_settings'},
    WIDGET.new{name='S1',type='button_invis',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.settings,  code=function() if page~='1'then SCN.swapTo('setting_out','none',1) end end},
    WIDGET.new{name='S2',type='button_invis',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.volUp,     code=function() if page~='2'then SCN.swapTo('setting_out','none',2) end end},
    WIDGET.new{name='S3',type='button_invis',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.video,     code=function() if page~='3'then SCN.swapTo('setting_out','none',3) end end},
    WIDGET.new{name='S4',type='button_invis',pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.controller,code=function() if page~='4'then SCN.swapTo('setting_out','none',4) end end},

    -- Controls
    WIDGET.new{name='1',type='button', pos={0,0},x=500, y=270,w=360,h=80,cornerR=10,fontSize=40, text=LANG'setting_keymapping',     code=function() SCN.go('keyset_list',nil,'mino') end},
    WIDGET.new{name='1',type='switch', pos={0,0},x=360, y=390,h=40, labelPos='right',fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    WIDGET.new{name='1',type='button', pos={0,0},x=500, y=470,w=360,h=80,cornerR=10,fontSize=40, text=LANG'setting_touching',       code=WIDGET.c_goScn'keyset_touch',visibleFunc=function() return page=='1' and SETTINGS.system.touchControl end},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=620,w=650, fontSize=40,text=LANG'setting_das',     widthLimit=380,axis={100,260,10},   disp=TABLE.func_getVal(SETTINGS.game_mino,'das'),    valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'das')},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=700,w=650, fontSize=40,text=LANG'setting_arr',     widthLimit=380,axis={20,120,10},    disp=TABLE.func_getVal(SETTINGS.game_mino,'arr'),    valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'arr')},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=780,w=650, fontSize=40,text=LANG'setting_sdarr',   widthLimit=380,axis={20,100,10},    disp=TABLE.func_getVal(SETTINGS.game_mino,'sdarr'),  valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'sdarr')},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=860,w=650, fontSize=40,text=LANG'setting_dascut',  widthLimit=380,axis={0,100,10},     disp=TABLE.func_getVal(SETTINGS.game_mino,'dascut'), valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'dascut')},

    -- Audio
    WIDGET.new{name='2',type='slider', pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_mainVol', widthLimit=380, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{name='2',type='slider', pos={0,0},x=340, y=300,w=650, fontSize=40,text=LANG'setting_bgm',     widthLimit=380, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{name='2',type='slider', pos={0,0},x=340, y=380,w=650, fontSize=40,text=LANG'setting_sfx',     widthLimit=380, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    WIDGET.new{name='2',type='slider', pos={0,0},x=340, y=460,w=650, fontSize=40,text=LANG'setting_vib',     widthLimit=380, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},
    WIDGET.new{name='2',type='switch', pos={0,0},x=390, y=540,h=45,  fontSize=40,text=LANG'setting_autoMute',widthLimit=550,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),                            code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    -- Video
    WIDGET.new{name='3',type='slider_fill',pos={0,0},x=340, y=220,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=380,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.system,'hitWavePower'),                        code=TABLE.func_setVal(SETTINGS.system,'hitWavePower')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=300,w=500,     text=LANG'setting_maxFPS',      widthLimit=380,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps,  code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=380,w=500,     text=LANG'setting_updRate',     widthLimit=380,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=460,w=500,     text=LANG'setting_drawRate',    widthLimit=380,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'drawRate')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_sysCursor',   widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),   code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=290,h=45,      text=LANG'setting_clickFX',     widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'clickFX'),     code=TABLE.func_revVal(SETTINGS.system,'clickFX')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=360,h=45,      text=LANG'setting_power',       widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),   code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_clean',       widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'), code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=500,h=45,      text=LANG'setting_fullscreen',  widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),  code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=570,h=45,      text=LANG'setting_showTouch',   widthLimit=380,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),   code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Gameplay
    -- ?
}
return scene
