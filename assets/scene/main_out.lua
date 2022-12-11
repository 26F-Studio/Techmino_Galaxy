local scene={}

local versionText=GC.newText(FONT.get(35,'bold'))
local terminalName=GC.newText(FONT.get(35,'thin'))

function scene.enter()
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

function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy)
    GC.translate(100,210)
    GC.setColor(1,1,1)
    GC.draw(IMG.title.techmino,0,0,nil,.55)
    GC.setColor(.08,.08,.084)
    for a=0,MATH.tau,MATH.tau/20 do
        GC.draw(IMG.title.galaxy,450+10*math.cos(a),130+10*math.sin(a),nil,.7)
    end
    GC.setColor(1,1,1)
    GC.draw(IMG.title.galaxy,450,130,nil,.7)
    GC.draw(versionText,40,190)
    GC.draw(terminalName,60+versionText:getWidth(),190)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=15,sound='back',fontSize=70,text=CHAR.icon.power,code=WIDGET.c_pressKey'escape',visibleFunc=function() return SYSTEM~='iOS' end},

    WIDGET.new{type='button_invis',pos={1,0},x=-250,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.console,   sound='move',code=function() if sureCheck('enter') then SCN.go('_console') end end},
    WIDGET.new{type='button_invis',pos={1,0},x=-400,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.home,      sound='move',code=WIDGET.c_goScn('main_in','none')},
    WIDGET.new{type='button_invis',pos={1,0},x=-550,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.info_circ, sound='move',code=WIDGET.c_goScn('about_out','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-700,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.music,     sound='move',code=WIDGET.c_goScn('musicroom','fadeHeader')},
    WIDGET.new{type='button_invis',pos={1,0},x=-850,y=60,w=80,cornerR=20,fontSize=65,text=CHAR.icon.language,  sound='move',code=WIDGET.c_goScn('lang_out','fadeHeader')},

    WIDGET.new{type='button',   x=325,  y=580,w=530,h=100,text=function() return CHAR.icon.person    ..' '..Text.main_out_single    end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('positioning','fadeHeader')},
    WIDGET.new{type='button',   x=895,  y=580,w=530,h=100,text=function() return CHAR.icon.people    ..' '..Text.main_out_multi     end, fontSize=40,cornerR=26,color='lD',sound=false},

    WIDGET.new{type='button',   x=230,  y=720,w=340,h=100,text=function() return CHAR.icon.settings  ..' '..Text.main_out_settings  end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('setting_out','fadeHeader')},
    WIDGET.new{type='button',   x=610,  y=720,w=340,h=100,text=function() return CHAR.icon.statistics..' '..Text.main_out_stat      end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('stat','fadeHeader')},
    WIDGET.new{type='button',   x=990,  y=720,w=340,h=100,text=function() return CHAR.icon.zictionary..' '..Text.main_out_dict      end, fontSize=40,cornerR=26,code=WIDGET.c_goScn('dict','fadeHeader')},
}
return scene
