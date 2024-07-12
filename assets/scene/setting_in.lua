local settingHint

---@type Zenitha.Scene
local scene={}

function scene.load()
    settingHint=PROGRESS.get('main')<2 and PROGRESS.get('launchCount')<=3
end
function scene.unload()
    saveSettings()
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('none') end end
function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
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

    {type='slider',   name='asd',  pos={1,.5},x=-852.3,y=250,w=702.3,text=LANG'setting_asd',  widthLimit=260,axis={20,260,10},disp=TABLE.func_getVal(SETTINGS.game_brik,'asd'),  valueShow=sliderShow_time, code=function(v)
        scene.widgetList.asd.fillColor={COLOR.HSL(0,1,.5+.5*MATH.icLerp(20,100,v))}
        SETTINGS.game_brik.asd=v
        SETTINGS.game_brik.asp=math.min(SETTINGS.game_brik.asp,SETTINGS.game_brik.asd)
    end},
    {type='slider',   name='asp',  pos={1,.5},x=-852.3,y=350,w=702.3,text=LANG'setting_asp',  widthLimit=260,axis={0,120,10}, disp=TABLE.func_getVal(SETTINGS.game_brik,'asp'),  valueShow=sliderShow_time, code=function(v)
        scene.widgetList.asp.fillColor={COLOR.HSL(0,1,.5+.5*MATH.icLerp(-10,5,v))}
        SETTINGS.game_brik.asp=v
        SETTINGS.game_brik.asd=math.max(SETTINGS.game_brik.asd,SETTINGS.game_brik.asp)
    end},
}
return scene
