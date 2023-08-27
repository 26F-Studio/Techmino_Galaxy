local scene={}

local textOffset=6
local versionText=GC.newText(FONT.get(35,'bold'))
local terminalName=GC.newText(FONT.get(35))

function scene.enter()
    if MATH.roll(.026) then textOffset=26 end
    PROGRESS.setEnv('exterior')
    versionText:set(VERSION.appVer)
    terminalName:set(("TERM[%s]"):format(SYSTEM:sub(1,3):upper()))
end

local function sysAction(action)
    if action=='help' then
        callDict('aboutDict_hidden')
    elseif action=='setting' then
        SCN.go('setting_out','fadeHeader')
    elseif action=='back' then
        if sureCheck('quit') then PROGRESS.quit() end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return end
    sysAction(KEYMAP.sys:getAction(key))
end

function scene.update(dt)
    textOffset=MATH.expApproach(textOffset,0,6.26*dt)
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_m)
    GC.translate(-700,-290)

    -- System info
    GC.draw(versionText,40,190)
    GC.draw(terminalName,60+versionText:getWidth(),190)

    -- Title with animation
    GC.draw(IMG.title_techmino,-textOffset,0,nil,.55)
    FONT.set(190,'galaxy_thin')
    GC.setColor(.08,.08,.084)
    for a=0,MATH.tau,MATH.tau/20 do
        GC.print('GALAXY',455+7*math.cos(a)+textOffset,60+7*math.sin(a))
    end
    GC.setColor(1,1,1)
    GC.print('GALAXY',455+textOffset,60)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=15,sound_trigger='button_back',fontSize=70,text=CHAR.icon.power,code=function() sysAction('back') end,visibleFunc=function() return SYSTEM~='iOS' end},

    WIDGET.new{type='button_invis',pos={1,0},x=-200,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.video,     sound_trigger='move',code=WIDGET.c_goScn('main_in','none')},
    WIDGET.new{type='button_invis',pos={1,0},x=-400,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.info_circ, sound_trigger='move',code=WIDGET.c_goScn('about_out','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-600,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.music,     sound_trigger='move',code=WIDGET.c_goScn('musicroom','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-800,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.language,  sound_trigger='move',code=WIDGET.c_goScn('lang_out','fadeHeader')},

    WIDGET.new{type='button', pos={.5,.5},x=-475,y=80, w=530,h=100,text=function() return CHAR.icon.person    ..' '..Text.main_out_single    end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('simulation','fadeHeader')},
    WIDGET.new{type='button', pos={.5,.5},x=95,  y=80, w=530,h=100,text=function() return CHAR.icon.people    ..' '..Text.main_out_multi     end, fontSize=40,cornerR=26,color='lD',sound_trigger=false},

    WIDGET.new{type='button', pos={.5,.5},x=-570,y=220,w=340,h=100,text=function() return CHAR.icon.settings  ..' '..Text.main_out_settings  end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('setting_out','fadeHeader')},
    WIDGET.new{type='button', pos={.5,.5},x=-190,y=220,w=340,h=100,text=function() return CHAR.icon.statistics..' '..Text.main_out_stat      end, fontSize=40,cornerR=26,color='lD',sound_trigger=false},
    WIDGET.new{type='button', pos={.5,.5},x=190, y=220,w=340,h=100,text=function() return CHAR.icon.zictionary..' '..Text.main_out_dict      end, fontSize=40,cornerR=26,code=function() callDict('aboutDict') end},
}
return scene
