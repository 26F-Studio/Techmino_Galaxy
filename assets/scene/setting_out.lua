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
        SaveSettings()
    end
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('fadeHeader') end end

function scene.keyDown(key,isRep)
    if isRep then return true end
    local act=KEYMAP.sys:getAction(key)
    if act=='back' then
        SCN.back('fadeHeader')
    elseif act=='setting' then
        SCN.swapTo('setting_out','none',IsShiftDown() and (page-2)%4+1 or page%4+1)
    elseif act=='help' then
        CallDict('setting_out')
        PROGRESS.setSecret('dict_shortcut')
    elseif key=='d' then
        _GetLatestBank()
    end
    return true
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_maxTPS(S)  return S.disp().." TPS" end
local function sliderShow_update(S)  return S.disp().."% "..(S.disp()*CONF.system.maxTPS/100).."UPS"    end
local function sliderShow_render(S)  return S.disp().."% "..(S.disp()*CONF.system.maxTPS/100).."FPS"    end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,fillColor='B',cornerR=15,sound_release='button_back',fontSize=40,text=BackText,onClick=WIDGET.c_backScn'fadeHeader'},

    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'settings_title'},
    {name='S1',type='button_invis',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.settings, sound_release='button_soft',onClick=function() if page~='1' then SCN.swapTo('setting_out','none',1) end end},
    {name='S2',type='button_invis',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.volUp,    sound_release='button_soft',onClick=function() if page~='2' then SCN.swapTo('setting_out','none',2) end end},
    {name='S3',type='button_invis',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.image,    sound_release='button_soft',onClick=function() if page~='3' then SCN.swapTo('setting_out','none',3) end end},
    {name='S4',type='button_invis',pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.bookmark, sound_release='button_soft',onClick=function() if page~='4' then SCN.swapTo('setting_out','none',4) end end},

    -- Controls
    {name='1',type='slider', pos={0,0},x=340, y=220,w=650, fontSize=35,text="ASD",widthLimit=260,axis={0,260,1},unit=false,disp=TABLE.func_getVal(CONF.game_brik,'asd'),  valueShow=sliderShow_time, code=function(v)
        CONF.game_brik.asd=v
        CONF.game_brik.asp=math.min(CONF.game_brik.asp,CONF.game_brik.asd)
        CONF.game_brik.adp=math.min(CONF.game_brik.adp,CONF.game_brik.asd)
        CONF.game_brik.ash=math.min(CONF.game_brik.ash,CONF.game_brik.asd)
    end},
    {name='1',type='slider', pos={0,0},x=340, y=300,w=300, fontSize=35,text="ASP",widthLimit=260,axis={0,120,1},unit=false,disp=TABLE.func_getVal(CONF.game_brik,'asp'),  valueShow=sliderShow_time, code=function(v)
        CONF.game_brik.asp=v
        CONF.game_brik.asd=math.max(CONF.game_brik.asd,CONF.game_brik.asp)
    end},
    {name='1',type='slider', pos={0,0},x=340, y=380,w=300, fontSize=35,text="ADP",widthLimit=260,axis={0,120,1},unit=false,disp=TABLE.func_getVal(CONF.game_brik,'adp'),  valueShow=sliderShow_time, code=function(v)
        CONF.game_brik.adp=v
        CONF.game_brik.asd=math.max(CONF.game_brik.asd,CONF.game_brik.adp)
    end},
    {name='1',type='switch', pos={0,0},x=750, y=380,h=40,                   fontSize=35,text=LANG'setting_softdropSkipAsd',disp=TABLE.func_getVal(CONF.game_brik,'softdropSkipAsd'),code=TABLE.func_revVal(CONF.game_brik,'softdropSkipAsd')}, -- visibleTick=function() return page=='1' and SETTINGS.game_brik.asp>0 end
    {name='1',type='slider', pos={0,0},x=340, y=460,w=650,                  fontSize=35,text="ASH",widthLimit=260,axis={0,260,1},unit=false,disp=TABLE.func_getVal(CONF.game_brik,'ash'),  valueShow=sliderShow_time, code=function(v) CONF.game_brik.ash=v; CONF.game_brik.asd=math.max(CONF.game_brik.asd,CONF.game_brik.ash) end},
    {name='1',type='button', pos={0,0},x=500, y=560,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_keymapping',     onClick=WIDGET.c_goScn('keyset_out','fadeHeader')},
    {name='1',type='switch', pos={0,0},x=360, y=700,h=40,                   fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(CONF.system,'touchControl'),code=TABLE.func_revVal(CONF.system,'touchControl')},
    {name='1',type='button', pos={0,0},x=500, y=780,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_touching',       onClick=WIDGET.c_goScn'keyset_touch_out',visibleTick=function() return page=='1' and CONF.system.touchControl end},

    -- Audio
    {name='2',type='slider_fill',pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(CONF.system,'mainVol'), code=TABLE.func_setVal(CONF.system,'mainVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=300,w=650, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(CONF.system,'bgmVol'),  code=TABLE.func_setVal(CONF.system,'bgmVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=380,w=650, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(CONF.system,'sfxVol'),  code=TABLE.func_setVal(CONF.system,'sfxVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=460,w=650, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(CONF.system,'vibVol'),  code=TABLE.func_setVal(CONF.system,'vibVol')},
    {name='2',type='switch',     pos={0,0},x=390, y=540,h=45,  fontSize=40,text=LANG'setting_autoMute',widthLimit=550, disp=TABLE.func_getVal(CONF.system,'autoMute'), code=TABLE.func_revVal(CONF.system,'autoMute')},
    {name='2',type='slider',     pos={0,0},x=340, y=660,w=260,             text=LANG'setting_fmod_maxChannel',      widthLimit=260, axis={4,8,1}, valueShow=function(S) return 2^S.disp() end, disp=function() return MATH.roundLog(CONF.system.fmod_maxChannel,2)      end, code=function(v) CONF.system.fmod_maxChannel=2^v      end},
    {name='2',type='slider',     pos={0,0},x=340, y=730,w=390,             text=LANG'setting_fmod_DSPBufferCount',  widthLimit=260, axis={2,8,1},                                              disp=TABLE.func_getVal(CONF.system,'fmod_DSPBufferCount'),                    code=TABLE.func_setVal(CONF.system,'fmod_DSPBufferCount')},
    {name='2',type='slider',     pos={0,0},x=340, y=800,w=650,             text=LANG'setting_fmod_DSPBufferLength', widthLimit=260, axis={3,16,1},valueShow=function(S) return 2^S.disp() end, disp=function() return MATH.roundLog(CONF.system.fmod_DSPBufferLength,2) end, code=function(v) CONF.system.fmod_DSPBufferLength=2^v end},
    {name='2',type='button',     pos={0,0},x=400, y=870,w=140, h=60,       text=LANG'setting_apply', onClick=function()
        if GAME.mode then return MSG('warn',Text.setting_tryApplyAudioInGame) end
        FMODLoadFunc()
        FMOD.setMainVolume(CONF.system.mainVol,true)
        StopBGM()
        PROGRESS.applyExteriorBGM()
        FMOD.effect('beep_notice')
    end},

    -- Video
    {name='3', type='slider_fill',pos={0,0},x=340, y=220,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(CONF.system,'hitWavePower'),                          code=TABLE.func_setVal(CONF.system,'hitWavePower')},
    {name='3', type='slider',     pos={0,0},x=340, y=300,w=500,     text=LANG'setting_maxTPS',      widthLimit=260,axis={120,400,10},unit=false,disp=TABLE.func_getVal(CONF.system,'maxTPS'),    valueShow=sliderShow_maxTPS,code=TABLE.func_setVal(CONF.system,'maxTPS')},
    {name='3', type='slider',     pos={0,0},x=340, y=380,w=500,     text=LANG'setting_updateRate',  widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(CONF.system,'updateRate'),valueShow=sliderShow_update,code=function(v) CONF.system.updateRate=v; CONF.system.renderRate=math.min(v,CONF.system.renderRate) end},
    {name='3', type='slider',     pos={0,0},x=340, y=460,w=500,     text=LANG'setting_renderRate',  widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(CONF.system,'renderRate'),valueShow=sliderShow_render,code=function(v) CONF.system.renderRate=v; CONF.system.updateRate=math.max(v,CONF.system.updateRate) end},
    {name='3', type='slider',     pos={0,0},x=340, y=540,w=500,     text=LANG'setting_stability',   widthLimit=260,axis={-1,1,0.1},              disp=TABLE.func_getVal(CONF.system,'stability'), valueShow=sliderShow_time,  code=TABLE.func_setVal(CONF.system,'stability')},
    {name='3', type='slider',     pos={0,0},x=340, y=620,w=250,     text=LANG'setting_msaa',        widthLimit=260,axis={0,4,1},                 disp=function() return CONF.system.msaa==0 and 0 or math.log(CONF.system.msaa,2) end, valueShow=function(S) return (S.disp()==0 and 0 or 2^S.disp()).."x" end, code=function(v) CONF.system.msaa=v==0 and 0 or 2^v; SaveSettings(); if TASK.lock('warnMessage',6.26) then MSG('warn',Text.setting_needRestart,6.26) end end},
    {name='3', type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_sysCursor',   widthLimit=260,disp=TABLE.func_getVal(CONF.system,'sysCursor'),   code=TABLE.func_revVal(CONF.system,'sysCursor')},
    {name='3', type='switch',     pos={1,0},x=-500,y=290,h=45,      text=LANG'setting_power',       widthLimit=260,disp=TABLE.func_getVal(CONF.system,'powerInfo'),   code=TABLE.func_revVal(CONF.system,'powerInfo')},
    {name='3', type='switch',     pos={1,0},x=-500,y=360,h=45,      text=LANG'setting_clean',       widthLimit=260,disp=TABLE.func_getVal(CONF.system,'cleanCanvas'), code=TABLE.func_revVal(CONF.system,'cleanCanvas')},
    {name='3f',type='switch',     pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_fullscreen',  widthLimit=260,disp=TABLE.func_getVal(CONF.system,'fullscreen'),  code=TABLE.func_revVal(CONF.system,'fullscreen')},
    {name='3p',type='switch',     pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_portrait',    widthLimit=260,disp=TABLE.func_getVal(CONF.system,'portrait'),    code=function() CONF.system.portrait = not CONF.system.portrait; SaveSettings(); if TASK.lock('warnMessage',6.26) then MSG('warn',Text.setting_needRestart,6.26) end end},
    {name='3', type='switch',     pos={1,0},x=-500,y=500,h=45,      text=LANG'setting_showTouch',   widthLimit=260,disp=TABLE.func_getVal(CONF.system,'showTouch'),   code=TABLE.func_revVal(CONF.system,'showTouch')},

    -- Other
    {name='4', type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_discord',     widthLimit=260,disp=TABLE.func_getVal(CONF.system,'discordConnect'),code=TABLE.func_revVal(CONF.system,'discordConnect')},

    -- Test button
    {name='test',type='button', pos={1,1},x=-300,y=-80,w=160, h=80,cornerR=10, fontSize=40,text=LANG'setting_test',onClick=function()
        if GAME.mode then return MSG('warn',Text.setting_tryTestInGame) end
        PlayExterior('brik/exterior/test')()
    end},

    -- Hints
    {name='1',type='hint',pos={0,0},x=210,y=220,floatText=LANG'setting_hint_asd'},
    {name='1',type='hint',pos={0,0},x=210,y=300,floatText=LANG'setting_hint_asp'},
    {name='1',type='hint',pos={0,0},x=210,y=380,floatText=LANG'setting_hint_adp'},
    {name='1',type='hint',pos={0,0},x=210,y=460,floatText=LANG'setting_hint_ash'},
    {name='3',type='hint',pos={0,0},x=100,y=540,floatText=LANG'setting_hint_stability'},
}
return scene
