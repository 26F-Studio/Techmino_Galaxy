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
    scene.widgetList.test:setVisible(not GAME.mode)
    WIDGET._reset()
    BG.set('none')
end
function scene.leave()
    saveSettings()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local act=KEYMAP.sys:getAction(key)
    if act=='back' then
        SCN.back('fadeHeader')
    elseif act=='setting' then
        SCN.swapTo('setting_out','none',isShiftPressed() and (page-2)%4+1 or page%4+1)
    elseif act=='help' then
        callDict('setting_out')
    end
end

function scene.draw()
    PROGRESS.drawExteriorHeader()
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_fps(S)  return S.disp().." FPS" end
local function sliderShow_mul(S)  return S.disp().."%"    end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},

    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'settings_title'},
    {name='S1',type='button_invis',pos={1,0},x=-800,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.settings,  sound_trigger='move',code=function() if page~='1' then SCN.swapTo('setting_out','none',1) end end},
    {name='S2',type='button_invis',pos={1,0},x=-600,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.volUp,     sound_trigger='move',code=function() if page~='2' then SCN.swapTo('setting_out','none',2) end end},
    {name='S3',type='button_invis',pos={1,0},x=-400,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.video,     sound_trigger='move',code=function() if page~='3' then SCN.swapTo('setting_out','none',3) end end},
    {name='S4',type='button_invis',pos={1,0},x=-200,y=60,w=150,h=100,cornerR=20,fontSize=70,text=CHAR.icon.controller,sound_trigger='move',code=function() if page~='4' then SCN.swapTo('setting_out','none',4) end end},

    -- Controls
    {name='1',type='slider', pos={0,0},x=340, y=220,w=650, fontSize=35,text=LANG'setting_asd',  widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'asd'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.asd=v; SETTINGS.game_mino.asp=math.min(SETTINGS.game_mino.asp,SETTINGS.game_mino.asd); SETTINGS.game_mino.ash=math.min(SETTINGS.game_mino.ash,SETTINGS.game_mino.asd) end},
    {name='1',type='slider', pos={0,0},x=340, y=300,w=300, fontSize=35,text=LANG'setting_asp',  widthLimit=260,axis={0,120,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'asp'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.asp=v; SETTINGS.game_mino.asd=math.max(SETTINGS.game_mino.asd,SETTINGS.game_mino.asp) end},
    {name='1',type='slider', pos={0,0},x=340, y=380,w=650, fontSize=35,text=LANG'setting_ash',  widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'ash'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.ash=v; SETTINGS.game_mino.asd=math.max(SETTINGS.game_mino.asd,SETTINGS.game_mino.ash) end},
    {name='1',type='slider', pos={0,0},x=340, y=460,w=650, fontSize=35,text=LANG'setting_aHdLock', widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'aHdLock'), valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'aHdLock')},
    {name='1',type='slider', pos={0,0},x=340, y=540,w=650, fontSize=35,text=LANG'setting_mHdLock', widthLimit=260,axis={0,260,1},smooth=true,disp=TABLE.func_getVal(SETTINGS.game_mino,'mHdLock'), valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'mHdLock')},
    {name='1',type='button', pos={0,0},x=500, y=640,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_keymapping',     code=WIDGET.c_goScn('keyset_out','fadeHeader')},
    {name='1',type='switch', pos={0,0},x=360, y=740,h=40,  labelPos='right',fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    {name='1',type='button', pos={0,0},x=500, y=820,w=360, h=80,cornerR=10, fontSize=40,text=LANG'setting_touching',       code=WIDGET.c_goScn'keyset_touch_out',visibleTick=function() return page=='1' and SETTINGS.system.touchControl end},

    -- Audio
    {name='2',type='slider_fill',pos={0,0},x=340, y=220,w=650, fontSize=40,text=LANG'setting_mainVol', widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'mainVol'), code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=300,w=650, fontSize=40,text=LANG'setting_bgm',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),  code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=380,w=650, fontSize=40,text=LANG'setting_sfx',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),  code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    {name='2',type='slider_fill',pos={0,0},x=340, y=460,w=650, fontSize=40,text=LANG'setting_vib',     widthLimit=260, disp=TABLE.func_getVal(SETTINGS.system,'vibVol'),  code=TABLE.func_setVal(SETTINGS.system,'vibVol')},
    {name='2',type='switch',     pos={0,0},x=390, y=540,h=45,  fontSize=40,text=LANG'setting_autoMute',widthLimit=550,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'autoMute'), code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    -- Video
    {name='3',type='slider_fill',pos={0,0},x=340, y=220,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.system,'hitWavePower'),                       code=TABLE.func_setVal(SETTINGS.system,'hitWavePower')},
    {name='3',type='slider',     pos={0,0},x=340, y=300,w=500,     text=LANG'setting_maxFPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps, code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    {name='3',type='slider',     pos={0,0},x=340, y=380,w=500,     text=LANG'setting_updRate',     widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul, code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    {name='3',type='slider',     pos={0,0},x=340, y=460,w=500,     text=LANG'setting_drawRate',    widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul, code=TABLE.func_setVal(SETTINGS.system,'drawRate')},
    {name='3',type='slider',     pos={0,0},x=340, y=540,w=250,     text=LANG'setting_msaa',        widthLimit=260,axis={0,4,1},                 disp=function() return SETTINGS.system.msaa==0 and 0 or math.log(SETTINGS.system.msaa,2) end, valueShow=function(S) return (S.disp()==0 and 0 or 2^S.disp()).."x" end, code=function(v) SETTINGS.system.msaa=v==0 and 0 or 2^v; saveSettings(); if TASK.lock('warnMessage',6.26) then MSG.new('warn',Text.setting_needRestart,6.26) end end},
    {name='3',type='switch',     pos={1,0},x=-500,y=220,h=45,      text=LANG'setting_sysCursor',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),   code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    {name='3',type='switch',     pos={1,0},x=-500,y=290,h=45,      text=LANG'setting_power',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),   code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    {name='3',type='switch',     pos={1,0},x=-500,y=360,h=45,      text=LANG'setting_clean',       widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'), code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    {name='3f',type='switch',    pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_fullscreen',  widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),  code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    {name='3p',type='switch',    pos={1,0},x=-500,y=430,h=45,      text=LANG'setting_portrait',    widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'portrait'),    code=function() SETTINGS.system.portrait = not SETTINGS.system.portrait; saveSettings(); if TASK.lock('warnMessage',6.26) then MSG.new('warn',Text.setting_needRestart,6.26) end end},
    {name='3',type='switch',     pos={1,0},x=-500,y=500,h=45,      text=LANG'setting_showTouch',   widthLimit=260,labelPos='right', disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),   code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Gameplay
    -- ?

    {name='test',type='button', pos={1,1},x=-300,y=-80,w=160, h=80,cornerR=10, fontSize=40,text=LANG'setting_test',code=playExterior'mino/exterior/test',visibleFunc=function() return not GAME.mode end},
}
return scene
