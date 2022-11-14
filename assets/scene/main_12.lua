local scene={}

function scene.enter()
    BG.set('none')
    PROGRESS.playBGM_main_12()
    for _,v in next,scene.widgetList do
        if v.name then
            v._visible=v.name==tostring(PROGRESS.data.main)
        end
    end
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='return' then
        SCN.go('game_simp',nil,'mino/sprint')
    elseif key=='c' then
        SCN.go('_console')
    elseif key=='escape' then
        if sureCheck('quit') then SCN.back() end
    end
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(1,1,1)
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
    FONT.set(100)
    GC.scale(2)
    GC.print("echmino",-180,-200)
    GC.print("T",-235,-200)
end

scene.widgetList={
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=-270,y=-40,w=500,h=140, color='R',text=LANG'main_12_sprint',  fontSize=40,cornerR=0,code=playMode'mino/sprint'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=270, y=-40,w=500,h=140, color='R',text=LANG'main_12_marathon',fontSize=40,cornerR=0,code=playMode'mino/marathon'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=-270,y=140,w=500,h=140, color='B',text=LANG'main_12_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial_12'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=270, y=140,w=500,h=140, color='Y',text=LANG'main_12_sandbox', fontSize=40,cornerR=0,code=WIDGET.c_goScn'sandbox_1'},

    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-200,y=-40,w=360,h=140, color='R',text=LANG'main_12_sprint',  fontSize=40,cornerR=0,code=playMode'mino/sprint'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=200, y=-40,w=360,h=140, color='R',text=LANG'main_12_marathon',fontSize=40,cornerR=0,code=playMode'mino/marathon'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-200,y=140,w=360,h=140, color='B',text=LANG'main_12_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial_12'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=200, y=140,w=360,h=140, color='Y',text=LANG'main_12_sandbox', fontSize=40,cornerR=0,code=WIDGET.c_goScn'sandbox_1'},

    WIDGET.new{type='button',     pos={.5,.5},x=-400,y=320,w=360,h=100,text=CHAR.icon.language,               fontSize=70,cornerR=0,code=WIDGET.c_goScn'setting_lang'},
    WIDGET.new{type='button',     pos={.5,.5},x=0,   y=320,w=360,h=100,text=LANG'main_12_settings',           fontSize=40,cornerR=0,code=WIDGET.c_goScn'setting_1'},
    WIDGET.new{type='button',     pos={.5,.5},x=400, y=320,w=360,h=100,text=LANG'main_12_musicroom',          fontSize=40,cornerR=0,code=WIDGET.c_goScn'musicroom'},
}
return scene
