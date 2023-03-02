local scene={}

local textOffset=6
local versionText=GC.newText(FONT.get(35,'bold'))
local terminalName=GC.newText(FONT.get(35,'thin'))

function scene.enter()
    if MATH.roll(.026) then textOffset=26 end
    PROGRESS.setEnv('exterior')
    versionText:set(VERSION.appVer)
    terminalName:set(("TERM[%s]"):format(SYSTEM:sub(1,3):upper()))
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        if sureCheck('quit') then PROGRESS.quit() end
    end
end

function scene.update(dt)
    textOffset=MATH.expApproach(textOffset,0,6.26*dt)
end

function scene.draw()
    PROGRESS.drawExteriorHeader()

    -- Title with animation
    GC.replaceTransform(SCR.xOy_m)
    GC.translate(-700,-290)
    -- Techmino
    GC.setColor(1,1,1)
    GC.draw(IMG.title.techmino,-textOffset,0,nil,.55)
    -- Galaxy
    GC.setColor(.08,.08,.084)
    for a=0,MATH.tau,MATH.tau/20 do
        GC.draw(IMG.title.galaxy,450+10*math.cos(a)+textOffset,130+10*math.sin(a),nil,.7)
    end
    GC.setColor(1,1,1)
    GC.draw(IMG.title.galaxy,450+textOffset,130,nil,.7)
    GC.draw(versionText,40,190)
    GC.draw(terminalName,60+versionText:getWidth(),190)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=15,sound='button_back',fontSize=70,text=CHAR.icon.power,code=WIDGET.c_pressKey'escape',visibleFunc=function() return SYSTEM~='iOS' end},

    WIDGET.new{type='button_invis',pos={1,0},x=-250,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.video,     sound='move',code=WIDGET.c_goScn('main_in','none')},
    WIDGET.new{type='button_invis',pos={1,0},x=-400,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.info_circ, sound='move',code=WIDGET.c_goScn('about_out','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-550,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.music,     sound='move',code=WIDGET.c_goScn('musicroom','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-700,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.language,  sound='move',code=WIDGET.c_goScn('lang_out','fadeHeader')},

    WIDGET.new{type='button', pos={.5,.5},x=-475,y=80, w=530,h=100,text=function() return CHAR.icon.person    ..' '..Text.main_out_single    end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('positioning','fadeHeader')},
    WIDGET.new{type='button', pos={.5,.5},x=95,  y=80, w=530,h=100,text=function() return CHAR.icon.people    ..' '..Text.main_out_multi     end, fontSize=40,cornerR=26,color='lD',sound=false},

    WIDGET.new{type='button', pos={.5,.5},x=-570,y=220,w=340,h=100,text=function() return CHAR.icon.settings  ..' '..Text.main_out_settings  end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('setting_out','fadeHeader')},
    WIDGET.new{type='button', pos={.5,.5},x=-190,y=220,w=340,h=100,text=function() return CHAR.icon.statistics..' '..Text.main_out_stat      end, fontSize=40,cornerR=26,color='lD',sound=false},
    WIDGET.new{type='button', pos={.5,.5},x=190, y=220,w=340,h=100,text=function() return CHAR.icon.zictionary..' '..Text.main_out_dict      end, fontSize=40,cornerR=26,color='lD',sound=false},
}
return scene
