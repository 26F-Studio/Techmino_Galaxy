local gc=love.graphics

local scene={}

function scene.enter()
    BG.set('image')BG.send('image',.12,IMG.cover)
end

function scene.leave()
    saveSettings()
end

function scene.draw()
    gc.replaceTransform(SCR.xOy_ur)
    local t=love.timer.getTime()
    -- Character
    gc.translate(-600,800-SCN.curScroll)
    gc.setColor(1,1,1)
    gc.scale(.7)
    GC.mDraw(IMG.z.character)
    GC.mDraw(IMG.z.screen1, -91, -157+16*math.sin(t))
    GC.mDraw(IMG.z.screen2, 120, -166+16*math.sin(t+1))
    gc.setColor(1,1,1,.7+.3*math.sin(.6*t)) GC.mDraw(IMG.z.particle1, -50,                    42+6*math.sin(t*0.36))
    gc.setColor(1,1,1,.7+.3*math.sin(.7*t)) GC.mDraw(IMG.z.particle2, 110+6*math.sin(t*0.92), 55)
    gc.setColor(1,1,1,.7+.3*math.sin(.8*t)) GC.mDraw(IMG.z.particle3, -54+6*math.sin(t*0.48), -248)
    gc.setColor(1,1,1,.7+.3*math.sin(.9*t)) GC.mDraw(IMG.z.particle4, 133,                    -305+6*math.sin(t*0.40))
end

local function sliderShow_fps(S)  return S.disp().." FPS" end
local function sliderShow_mul(S)  return S.disp().."%"    end

scene.widgetList={
    -- Game submenus
    WIDGET.new{type='button',     pos={.5,0},x=0,y=200,w=400,h=160, text=LANG'setting_mino',        color='LP',fontSize=60, code=WIDGET.c_goScn'setting_mino'},
    WIDGET.new{type='button',     pos={.2,0},x=0,y=200,w=400,h=160, text=LANG'setting_puyo',        color='LR',fontSize=60, code=WIDGET.c_goScn'setting_puyo'},
    WIDGET.new{type='button',     pos={.8,0},x=0,y=200,w=400,h=160, text=LANG'setting_gem',         color='LB',fontSize=60, code=WIDGET.c_goScn'setting_gem'},

    -- System: audio
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=400,w=500,h=30,text=LANG'setting_mainVol',     widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'mainVol'),                             code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=450,w=500,h=30,text=LANG'setting_bgm',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),                              code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=500,w=500,h=30,text=LANG'setting_sfx',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),                              code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},

    -- System: video
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=600,w=500,h=30,text=LANG'setting_hitWavePower',widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.system,'hitWavePower'),                        code=TABLE.func_setVal(SETTINGS.system,'hitWavePower')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=660,w=500,     text=LANG'setting_maxFPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps,  code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=710,w=500,     text=LANG'setting_updRate',     widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=760,w=500,     text=LANG'setting_drawRate',    widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'drawRate')},

    -- System: other
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=400,h=35,      text=LANG'setting_sysCursor',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),                           code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=450,h=35,      text=LANG'setting_clickFX',     widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'clickFX'),                             code=TABLE.func_revVal(SETTINGS.system,'clickFX')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=500,h=35,      text=LANG'setting_power',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),                           code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=550,h=35,      text=LANG'setting_clean',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'),                         code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=600,h=35,      text=LANG'setting_fullscreen',  widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),                          code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=650,h=35,      text=LANG'setting_autoMute',    widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),                            code=TABLE.func_revVal(SETTINGS.system,'autoMute')},
    WIDGET.new{type='switch',     pos={1,0},x=-420,y=700,h=35,      text=LANG'setting_showTouch',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),                           code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    WIDGET.new{type='button',     pos={0,1},x=160,y=-80,w=160,h=80, text=CHAR.icon.keyboard,fontSize=60,code=function() SCN.go('keyset_list',nil,'sys') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}
return scene
