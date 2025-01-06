---@type Zenitha.Scene
local scene={}
local page
--[[ Pages:
    1 = Controls
    2 = Audio
    3 = Video
    4 = Gameplay
]]

function scene.load()
    page=tostring(SCN.args[1] or 1)
    for _,v in next,scene.widgetList do
        if v.name and #v.name<=2 then
            if v.name:sub(1,1)=='S' then
                v.color=v.name:sub(2,2)==page and 'lS' or 'L'
            else
                v:setVisible(type(v.name)=='string' and v.name:sub(1,1)==page)
            end
        end
    end
    if page=="3" then
        scene.widgetList["3f"]:setVisible(not MOBILE)
        scene.widgetList["3p"]:setVisible(MOBILE)
    end
    WIDGET._reset()
    BG.set('none')
end
function scene.unload()
    if SCN.stackChange<0 then
        saveSettings()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('fadeHeader') end end

function scene.keyDown(key,isRep)
    if isRep then return true end
    local act=KEYMAP.sys:getAction(key)
    if act=='back' then
        SCN.back('fadeHeader')
    elseif act=='setting' then
        SCN.swapTo('setting_out','none',isShiftDown() and (page-2)%4+1 or page%4+1)
    elseif act=='help' then
        callDict('setting_out')
        PROGRESS.setSecret('dict_shortcut')
    elseif key=='d' then
        _getLatestBank()
    end
    return true
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_maxTPS(S)  return S.disp().." TPS" end
local function sliderShow_update(S)  return S.disp().."% "..(S.disp()*SETTINGS.system.maxTPS/100).."UPS"    end
local function sliderShow_render(S)  return S.disp().."% "..(S.disp()*SETTINGS.system.maxTPS/100).."FPS"    end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,fillColor='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},

    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'settings_title'},
    {name='S1',type='button_invis',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.settings,  sound_trigger='button_soft',code=function() if page~='1' then SCN.swapTo('setting_out','none',1) end end},
    {name='S2',type='button_invis',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.volUp,     sound_trigger='button_soft',code=function() if page~='2' then SCN.swapTo('setting_out','none',2) end end},
    {name='S3',type='button_invis',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.video,     sound_trigger='button_soft',code=function() if page~='3' then SCN.swapTo('setting_out','none',3) end end},
    {name='S4',type='button_invis',pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.controller,sound_trigger='button_soft',code=function() if page~='4' then SCN.swapTo('setting_out','none',4) end end},

    -- Controls
    {name='1',type='slider', pos={0,0},x=340, y=220,w=650, fontSize=35,text="ASD",widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_brik,'asd'),  valueShow=sliderShow_time, code=function(v)
        SETTINGS.game_brik.asd=v
        SETTINGS.game_brik.asp=math.min(SETTINGS.game_brik.asp,SETTINGS.game_brik.asd)
        SETTINGS.game_brik.adp=math.min(SETTINGS.game_brik.adp,SETTINGS.game_brik.asd)
        SETTINGS.game_brik.ash=math.min(SETTINGS.game_brik.ash,SETTINGS.game_brik.asd)
    end},
    {name='1',type='slider', pos={0,0},x=340, y=300,w=300, fontSize=35,text="ASP",widthLimit=260,axis={0,120,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_brik,'asp'),  valueShow=sliderShow_time, code=function(v)
        SETTINGS.game_brik.asp=v
        SETTINGS.game_brik.asd=math.max(SETTINGS.game_brik.asd,SETTINGS.game_brik.asp)
    end},
    {name='1',type='slider', pos={0,0},x=340, y=380,w=300, fontSize=35,text="ADP",widthLimit=260,axis={0,120,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_brik,'adp'),  valueShow=sliderShow_time, code=function(v)
        SETTINGS.game_brik.adp=v
        SETTINGS.game_brik.asd=math.max(SETTINGS.game_brik.asd,SETTINGS.game_brik.adp)
    end},
    {name='1',type='switch', pos={0,0},x=750, y=380,h=40,  labelPos='right',fontSize=35,text=LANG'setting_softdropSkipAsd',disp=TABLE.func_getVal(SETTINGS.game_brik,'softdropSkipAsd'),code=TABLE.func_revVal(SETTINGS.game_brik,'softdropSkipAsd')}, -- visibleTick=function() return page=='1' and SETTINGS.game_brik.asp>0 end
    {name='1',type='slider', pos={0,0},x=340, y=460,w=650, fontSize=35,text="ASH",widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_brik,'ash'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_brik.ash=v; SETTINGS.game_brik.asd=math.max(SETTINGS.game_brik.asd,SETTINGS.game_brik.ash) end},
    {name='1',type='button', pos={0,0},x=500, y=560,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_keymapping',     code=WIDGET.c_goScn('keyset_out','fadeHeader')},
    {name='1',type='switch', pos={0,0},x=360, y=700,h=40,  labelPos='right',fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    {name='1',type='button', pos={0,0},x=500, y=780,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_touching',       code=WIDGET.c_goScn'keyset_touch_out',visibleTick=function() return page=='1' and SETTINGS.system.touchControl end},

    -- Audio
    {name='2',type='slider_fill',pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=300,w=650, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=380,w=650, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=460,w=650, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},
    {name='2',type='switch',     pos={0,0},x=390, y=540,h=45,  fontSize=40,text=LANG'setting_autoMute',widthLimit=550,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'autoMute'), code=TABLE.func_revVal(SETTINGS.system,'autoMute')},
    {name='2',type='slider',     pos={0,0},x=340, y=660,w=260, fontSize=30,text=LANG'setting_fmod_maxChannel',      widthLimit=260, axis={4,8,1}, valueShow=function(S) return 2^S.disp() end, disp=function() return MATH.roundLog(SETTINGS.system.fmod_maxChannel,2)      end, code=function(v) SETTINGS.system.fmod_maxChannel=2^v      end},
    {name='2',type='slider',     pos={0,0},x=340, y=730,w=390, fontSize=30,text=LANG'setting_fmod_DSPBufferCount',  widthLimit=260, axis={2,8,1},                                              disp=TABLE.func_getVal(SETTINGS.system,'fmod_DSPBufferCount'),                    code=TABLE.func_setVal(SETTINGS.system,'fmod_DSPBufferCount')},
    {name='2',type='slider',     pos={0,0},x=340, y=800,w=650, fontSize=30,text=LANG'setting_fmod_DSPBufferLength', widthLimit=260, axis={3,16,1},valueShow=function(S) return 2^S.disp() end, disp=function() return MATH.roundLog(SETTINGS.system.fmod_DSPBufferLength,2) end, code=function(v) SETTINGS.system.fmod_DSPBufferLength=2^v end},
    {name='2',type='button',     pos={0,0},x=400, y=870,w=140, h=60,fontSize=30,text=LANG'setting_apply', code=function()
        if GAME.mode then return MSG('warn',Text.setting_tryApplyAudioInGame) end
        FMODLoadFunc()
        FMOD.setMainVolume(SETTINGS.system.mainVol,true)
        stopBgm()
        PROGRESS.applyExteriorBGM()
        FMOD.effect('beep_notice')
    end},

    -- Video
    {name='3', type='slider_fill',pos={0,0},x=340, y=220,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.system,'hitWavePower'),                          code=TABLE.func_setVal(SETTINGS.system,'hitWavePower')},
    {name='3', type='slider',     pos={0,0},x=340, y=300,w=500,     text=LANG'setting_maxTPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxTPS'),    valueShow=sliderShow_maxTPS,code=TABLE.func_setVal(SETTINGS.system,'maxTPS')},
    {name='3', type='slider',     pos={0,0},x=340, y=380,w=500,     text=LANG'setting_updateRate',  widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updateRate'),valueShow=sliderShow_update,code=function(v) SETTINGS.system.updateRate=v; SETTINGS.system.renderRate=math.min(v,SETTINGS.system.renderRate) end},
    {name='3', type='slider',     pos={0,0},x=340, y=460,w=500,     text=LANG'setting_renderRate',  widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'renderRate'),valueShow=sliderShow_render,code=function(v) SETTINGS.system.renderRate=v; SETTINGS.system.updateRate=math.max(v,SETTINGS.system.updateRate) end},
    {name='3', type='slider',     pos={0,0},x=340, y=540,w=500,     text=LANG'setting_stability',   widthLimit=260,axis={-1,1,0.1},              disp=TABLE.func_getVal(SETTINGS.system,'stability'), valueShow=sliderShow_time,  code=TABLE.func_setVal(SETTINGS.system,'stability')},
    {name='3', type='slider',     pos={0,0},x=340, y=620,w=250,     text=LANG'setting_msaa',        widthLimit=260,axis={0,4,1},                 disp=function() return SETTINGS.system.msaa==0 and 0 or math.log(SETTINGS.system.msaa,2) end, valueShow=function(S) return (S.disp()==0 and 0 or 2^S.disp()).."x" end, code=function(v) SETTINGS.system.msaa=v==0 and 0 or 2^v; saveSettings(); if TASK.lock('warnMessage',6.26) then MSG('warn',Text.setting_needRestart,6.26) end end},
    {name='3', type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_sysCursor',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),   code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    {name='3', type='switch',     pos={1,0},x=-500,y=290,h=45,      text=LANG'setting_power',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),   code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    {name='3', type='switch',     pos={1,0},x=-500,y=360,h=45,      text=LANG'setting_clean',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'), code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    {name='3f',type='switch',     pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_fullscreen',  widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),  code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    {name='3p',type='switch',     pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_portrait',    widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'portrait'),    code=function() SETTINGS.system.portrait = not SETTINGS.system.portrait; saveSettings(); if TASK.lock('warnMessage',6.26) then MSG('warn',Text.setting_needRestart,6.26) end end},
    {name='3', type='switch',     pos={1,0},x=-500,y=500,h=45,      text=LANG'setting_showTouch',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),   code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Gameplay
    -- ?

    -- Test button
    {name='test',type='button', pos={1,1},x=-300,y=-80,w=160, h=80,cornerR=10, fontSize=40,text=LANG'setting_test',
        code=function()
            if GAME.mode then return MSG('warn',Text.setting_tryTestInGame) end
            playExterior('brik/exterior/test')()
        end,
    },

    -- Hints
    {name='1',type='hint',pos={0,0},x=210,y=220,floatText=LANG'setting_hint_asd'},
    {name='1',type='hint',pos={0,0},x=210,y=300,floatText=LANG'setting_hint_asp'},
    {name='1',type='hint',pos={0,0},x=210,y=380,floatText=LANG'setting_hint_adp'},
    {name='1',type='hint',pos={0,0},x=210,y=460,floatText=LANG'setting_hint_ash'},
    {name='3',type='hint',pos={0,0},x=100,y=540,floatText=LANG'setting_hint_stability'},
}
return scene
