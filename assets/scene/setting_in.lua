local settingHint

local scene={}

function scene.enter()
    settingHint=PROGRESS.get('main')<2 and PROGRESS.get('launchCount')<=3

    local L=scene.widgetList
    if PROGRESS.get('main')==1 then
        L.asd.y=250
        L.asp.y=350
        L.adp:setVisible(false)
    else
        L.asd.y=150
        L.asp.y=250
        L.adp.y=350
        L.adp:setVisible(true)
    end
    WIDGET._reset()
end
function scene.leave()
    saveSettings()
end

function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
    else
        return true
    end
end

function scene.draw()
    -- Notify new player about setting
    if settingHint then
        GC.replaceTransform(SCR.xOy)
        GC.setLineWidth(6)
        GC.setColor(.626,1,.626,.26+.1*math.sin(2.6*love.timer.getTime()))
        local W=scene.widgetList[MOBILE and 'setTouch' or 'setKey']
        GC.mRect('line',W._x,W._y,W.w+42,W.h+42)
    end
end

local function sliderShow_time(S) return S.disp().." ms"  end

scene.widgetList={
    {type='button',   pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    {type='button',   name='setKey',pos={0,.5},x=290,y=-180,w=360,h=80,  lineWidth=4,cornerR=0,                 fontSize=40,text=LANG'setting_keymapping',     code=WIDGET.c_goScn('keyset_in','none')},
    {type='checkBox', pos={0,.5},x=130,y=-60, w=40,                      lineWidth=4,cornerR=0,labelPos='right',fontSize=40,text=LANG'setting_enableTouching', disp=TABLE.func_getVal(SETTINGS.system,'touchControl'),code=TABLE.func_revVal(SETTINGS.system,'touchControl')},
    {type='button',   name='setTouch',pos={0,.5},x=290,y=20,  w=360,h=80,lineWidth=4,cornerR=0,                 fontSize=40,text=LANG'setting_touching',       code=WIDGET.c_goScn('keyset_touch_in','none'),visibleTick=TABLE.func_getVal(SETTINGS.system,'touchControl')},
    {type='checkBox', pos={0,.5},x=130,y=250, w=40,                      lineWidth=4,cornerR=0,labelPos='right',fontSize=40,text=LANG'setting_fullscreen',     disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'), code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    {type='checkBox', pos={0,.5},x=130,y=350, w=40,                      lineWidth=4,cornerR=0,labelPos='right',fontSize=40,text=LANG'setting_autoMute',       disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),   code=TABLE.func_revVal(SETTINGS.system,'autoMute')},

    {type='slider',   pos={1,.5},x=-550, y=-370,w=400,fontSize=40,text=LANG'setting_mainVol',widthLimit=260,disp=TABLE.func_getVal(SETTINGS.system,'mainVol'),code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    {type='slider',   pos={1,.5},x=-550, y=-290,w=400,fontSize=40,text=LANG'setting_bgm',    widthLimit=260,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'), code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    {type='slider',   pos={1,.5},x=-550, y=-210,w=400,fontSize=40,text=LANG'setting_sfx',    widthLimit=260,disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'), code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},
    {type='slider',   pos={1,.5},x=-550, y=-130,w=400,fontSize=40,text=LANG'setting_vib',    widthLimit=260,disp=TABLE.func_getVal(SETTINGS.system,'vibVol'), code=TABLE.func_setVal(SETTINGS.system,'vibVol')},

    {type='slider',   name='asd',  pos={1,.5},x=-800,y=50, w=650,text=LANG'setting_asd',  widthLimit=260,axis={100,260,10},disp=TABLE.func_getVal(SETTINGS.game_mino,'asd'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.asd=v; SETTINGS.game_mino.asp=math.min(SETTINGS.game_mino.asp,SETTINGS.game_mino.asd) end},
    {type='slider',   name='asp',  pos={1,.5},x=-800,y=150,w=650,text=LANG'setting_asp',  widthLimit=260,axis={20,120,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'asp'),  valueShow=sliderShow_time, code=function(v) SETTINGS.game_mino.asp=v; SETTINGS.game_mino.asd=math.max(SETTINGS.game_mino.asd,SETTINGS.game_mino.asp) end},
    {type='slider',   name='adp',pos={1,.5},x=-800,y=250,w=650,text=LANG'setting_adp',widthLimit=260,axis={20,100,10}, disp=TABLE.func_getVal(SETTINGS.game_mino,'adp'),valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game_mino,'adp')},
}
return scene
