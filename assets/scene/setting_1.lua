local gc=love.graphics

local actionSelected

local scene={}

function scene.enter()
    actionSelected=false
end
function scene.leave()
    saveSetting()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        if actionSelected then
            actionSelected=false
        else
            SCN.back()
        end
    elseif actionSelected then
        for i=1,#KEYMAP do
            if KEYMAP[i].act==actionSelected then
                for j=1,#KEYMAP do
                    local k=TABLE.find(KEYMAP[j].keys,'key')
                    if k then
                        table.remove(KEYMAP[j].keys,k)
                    end
                end
                table.insert(KEYMAP[i].keys,key)
                break
            end
        end
    end
end

function scene.draw()
    local t=love.timer.getTime()
    -- Character
    gc.translate(1000,800)
    gc.setColor(1,1,1)
    gc.scale(.7)
    GC.draw(IMG.z.character)
    GC.draw(IMG.z.screen1, -91, -157+16*math.sin(t))
    GC.draw(IMG.z.screen2, 120, -166+16*math.sin(t+1))
    gc.setColor(1,1,1,.7+.3*math.sin(.6*t)) GC.draw(IMG.z.particle1, -50,                    42+6*math.sin(t*0.36))
    gc.setColor(1,1,1,.7+.3*math.sin(.7*t)) GC.draw(IMG.z.particle2, 110+6*math.sin(t*0.92), 55)
    gc.setColor(1,1,1,.7+.3*math.sin(.8*t)) GC.draw(IMG.z.particle3, -54+6*math.sin(t*0.48), -248)
    gc.setColor(1,1,1,.7+.3*math.sin(.9*t)) GC.draw(IMG.z.particle4, 133,                    -305+6*math.sin(t*0.40))
end

local function sliderShow_time(S) return S.disp().." ms"  end
local function sliderShow_fps(S)  return S.disp().." FPS" end
local function sliderShow_mul(S)  return S.disp().."%"    end

scene.widgetList={
    -- Game: handling
    WIDGET.new{type='slider',     pos={0,0},x=260, y=100,w=1000,    text=LANG'setting_das',         widthLimit=260,axis={0,260,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'das'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'das')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=160,w=1000,    text=LANG'setting_arr',         widthLimit=260,axis={0,120,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'arr'),        valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'arr')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=220,w=1000,    text=LANG'setting_sdarr',       widthLimit=260,axis={0,100,1},smooth=true,   disp=TABLE.func_getVal(SETTINGS.game,'sdarr'),      valueShow=sliderShow_time, code=TABLE.func_setVal(SETTINGS.game,'sdarr')},

    -- Game: video
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=280,w=500,     text=LANG'setting_shakeness',   widthLimit=260,axis={0,1},                   disp=TABLE.func_getVal(SETTINGS.game,'shakeness'),                             code=TABLE.func_setVal(SETTINGS.game,'shakeness')},

    -- System: audio
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=370,w=500,h=35,text=LANG'setting_mainVol',     widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'mainVol'),                             code=TABLE.func_setVal(SETTINGS.system,'mainVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=420,w=500,h=35,text=LANG'setting_bgm',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),                              code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
    WIDGET.new{type='slider_fill',pos={0,0},x=260, y=470,w=500,h=35,text=LANG'setting_sfx',         widthLimit=260,                              disp=TABLE.func_getVal(SETTINGS.system,'sfxVol'),                              code=TABLE.func_setVal(SETTINGS.system,'sfxVol')},

    -- System: video
    WIDGET.new{type='slider',     pos={0,0},x=260, y=520,w=500,     text=LANG'setting_maxFPS',      widthLimit=260,axis={120,400,10},smooth=true,disp=TABLE.func_getVal(SETTINGS.system,'maxFPS'),   valueShow=sliderShow_fps,  code=TABLE.func_setVal(SETTINGS.system,'maxFPS')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=570,w=500,     text=LANG'setting_updRate',     widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'updRate'),  valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'updRate')},
    WIDGET.new{type='slider',     pos={0,0},x=260, y=620,w=500,     text=LANG'setting_drawRate',    widthLimit=260,axis={20,100,10},             disp=TABLE.func_getVal(SETTINGS.system,'drawRate'), valueShow=sliderShow_mul,  code=TABLE.func_setVal(SETTINGS.system,'drawRate')},

    -- System: other
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=370,           text=LANG'setting_sysCursor',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'sysCursor'),                           code=TABLE.func_revVal(SETTINGS.system,'sysCursor')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=420,           text=LANG'setting_clickFX',     widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'clickFX'),                             code=TABLE.func_revVal(SETTINGS.system,'clickFX')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=470,           text=LANG'setting_power',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'powerInfo'),                           code=TABLE.func_revVal(SETTINGS.system,'powerInfo')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=520,           text=LANG'setting_clean',       widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'cleanCanvas'),                         code=TABLE.func_revVal(SETTINGS.system,'cleanCanvas')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=570,           text=LANG'setting_fullscreen',  widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'fullscreen'),                          code=TABLE.func_revVal(SETTINGS.system,'fullscreen')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=620,           text=LANG'setting_autoMute',    widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'autoMute'),                            code=TABLE.func_revVal(SETTINGS.system,'autoMute')},
    WIDGET.new{type='checkBox',   pos={1,0},x=-420,y=670,           text=LANG'setting_showTouch',   widthLimit=360,labelPos='right',             disp=TABLE.func_getVal(SETTINGS.system,'showTouch'),                           code=TABLE.func_revVal(SETTINGS.system,'showTouch')},

    -- Test
    WIDGET.new{type='button',     pos={1,1},x=-300,y=-80,w=160,h=80,text=LANG'setting_test',fontSize=45,        code=function() SCN.go('game_simp',nil,'test') end},

    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
