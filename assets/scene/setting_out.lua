local scene={}
local page
--[[ Pages:
    1 = Controls
    2 = Audio
    3 = Video
    4 = Gameplay
]]

local mobile=SYSTEM=='Android' or SYSTEM=='iOS'

function scene.enter()
    page=tostring(SCN.args[1] or 1)
    for _,v in next,scene.widgetList do
        if v.name then
            if v.name:sub(1,1)=='S' then
                v.color=v.name:sub(2,2)==page and 'lS' or 'L'
            else
                v:setVisible(type(v.name)=='string' and v.name:sub(1,1)==page)
            end
        end
    end
    if page=="3" then
        scene.widgetList["3f"]:setVisible(not mobile)
        scene.widgetList["3p"]:setVisible(mobile)
    end
    WIDGET._reset()
    BG.set('none')
end
function scene.leave()
    saveSettings()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if KEYMAP.sys:getAction(key)=='back' then
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
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},

    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_settings'},
    WIDGET.new{name='S1',type='button_invis',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.settings,  sound='move',code=function() if page~='1' then SCN.swapTo('setting_out','none',1) end end},
    WIDGET.new{name='S2',type='button_invis',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.volUp,     sound='move',code=function() if page~='2' then SCN.swapTo('setting_out','none',2) end end},
    WIDGET.new{name='S3',type='button_invis',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.video,     sound='move',code=function() if page~='3' then SCN.swapTo('setting_out','none',3) end end},
    WIDGET.new{name='S4',type='button_invis',pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.controller,sound='move',code=function() if page~='4' then SCN.swapTo('setting_out','none',4) end end},

    -- Controls
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_das',     widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'das'),     valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.das=v; SETTINGS.game_mino.arr=math.min(SETTINGS.game_mino.arr,SETTINGS.game_mino.das); SETTINGS.game_mino.dasHalt=math.min(SETTINGS.game_mino.dasHalt,SETTINGS.game_mino.das) end},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=300,w=300, fontSize=40,text=LANG'setting_arr',     widthLimit=260,axis={0,120,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'arr'),     valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.arr=v; SETTINGS.game_mino.das=math.max(SETTINGS.game_mino.das,SETTINGS.game_mino.arr) end},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=380,w=250, fontSize=40,text=LANG'setting_sdarr',   widthLimit=260,axis={0,100,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'sdarr'),   valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'sdarr')},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=460,w=650, fontSize=30,text=LANG'setting_dasHalt', widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'dasHalt'), valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.dasHalt=v; SETTINGS.game_mino.das=math.max(SETTINGS.game_mino.das,SETTINGS.game_mino.dasHalt) end},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=540,w=650, fontSize=30,text=LANG'setting_hdLockA', widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'hdLockA'), valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'hdLockA')},
    WIDGET.new{name='1',type='slider', pos={0,0},x=340, y=620,w=650, fontSize=30,text=LANG'setting_hdLockM', widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'hdLockM'), valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'hdLockM')},
    WIDGET.new{name='1',type='button', pos={0,0},x=500, y=720,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_keymapping',     code=WIDGET.c_goScn'keyset_list'},
    WIDGET.new{name='1',type='switch', pos={0,0},x=360, y=820,h=40,  labelPos='right',fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    WIDGET.new{name='1',type='button', pos={0,0},x=500, y=900,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_touching',       code=WIDGET.c_goScn'keyset_touch',visibleFunc=function() return page=='1' and SETTINGS.system.touchControl end},

    -- Audio
    WIDGET.new{name='2',type='slider_fill',pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{name='2',type='slider_fill',pos={0,0},x=340, y=300,w=650, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{name='2',type='slider_fill',pos={0,0},x=340, y=380,w=650, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    WIDGET.new{name='2',type='slider_fill',pos={0,0},x=340, y=460,w=650, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},
    WIDGET.new{name='2',type='switch',     pos={0,0},x=390, y=540,h=45,  fontSize=40,text=LANG'setting_autoMute',widthLimit=550,labelPos='right',         disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),                           code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    -- Video
    WIDGET.new{name='3',type='slider_fill',pos={0,0},x=340, y=220,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.system,'hitWavePower'),                       code=TABLE.func_setVal(SETTINGS.system,'hitWavePower')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=300,w=500,     text=LANG'setting_maxFPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps, code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=380,w=500,     text=LANG'setting_updRate',     widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul, code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=460,w=500,     text=LANG'setting_drawRate',    widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul, code=TABLE.func_setVal(SETTINGS.system,'drawRate')},
    WIDGET.new{name='3',type='slider',     pos={0,0},x=340, y=540,w=250,     text=LANG'setting_msaa',        widthLimit=260,axis={0,4,1},                 disp=function() return SETTINGS.system.msaa==0 and 0 or math.log(SETTINGS.system.msaa,2) end, valueShow=function(S) return (S.disp()==0 and 0 or 2^S.disp()).."x" end, code=function(v) SETTINGS.system.msaa=v==0 and 0 or 2^v; saveSettings(); if TASK.lock('warnMessage',6.26) then MES.new('warn',Text.setting_needRestart,6.26) end end},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_sysCursor',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),   code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=290,h=45,      text=LANG'setting_power',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),   code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=360,h=45,      text=LANG'setting_clean',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'), code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    WIDGET.new{name='3f',type='switch',    pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_fullscreen',  widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),  code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{name='3p',type='switch',    pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_portrait',    widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'portrait'),    code=function() SETTINGS.system.portrait = not SETTINGS.system.portrait; saveSettings(); if TASK.lock('warnMessage',6.26) then MES.new('warn',Text.setting_needRestart,6.26) end end},
    WIDGET.new{name='3',type='switch',     pos={1,0},x=-500,y=500,h=45,      text=LANG'setting_showTouch',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),   code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Gameplay
    -- ?

    WIDGET.new{type='button', pos={1,1},x=-300,y=-80,w=160, h=80,cornerR=10, fontSize=40,text=LANG'setting_test',           code=playExterior'mino/exterior/test'},
}
return scene
