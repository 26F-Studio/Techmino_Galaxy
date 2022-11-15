local scene={}

function scene.enter()
    BG.set('none')
    PROGRESS.playBGM_main_in()
    for _,v in next,scene.widgetList do
        if v.name then
            v._visible=v.name==tostring(PROGRESS.getMain())
        end
    end
end

function scene.keyDown(key,isRep)
    if key=='s' then SCN.swapTo('main_out','none') end
    if isRep then return end
    if key=='escape' then
        if sureCheck('quit') then PROGRESS.quit() end
    end
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(1,1,1)

    -- Draw progress bar
    if PROGRESS.getMain()>=2 then
        GC.rectangle('fill',-160,36,320*PROGRESS.getInteriorScore('dig')/150,7)
        GC.rectangle('fill',-520,36,320*PROGRESS.getInteriorScore('sprint')/150,7)
        GC.rectangle('fill',200, 36,320*PROGRESS.getInteriorScore('marathon')/150,7)
    end

    -- Draw logo & verNum
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
    FONT.set(100)
    GC.scale(2)
    GC.print("T",-235,-200)
    GC.print("echmino",-180,-200)
end

scene.widgetList={
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=-270,y=-40,w=500,h=140, color='R',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playMode'mino/interior/sprint'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=270, y=-40,w=500,h=140, color='R',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playMode'mino/interior/marathon'},

    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-360,y=-40,w=320,h=140, color='R',text=LANG'main_in_dig',     fontSize=40,cornerR=0,code=playMode'mino/interior/dig'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=0,   y=-40,w=320,h=140, color='R',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playMode'mino/interior/sprint'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=360, y=-40,w=320,h=140, color='R',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playMode'mino/interior/marathon'},

    WIDGET.new{type='button_fill',pos={.5,.5},x=-270,y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial'},
    WIDGET.new{type='button_fill',pos={.5,.5},x=270, y=140,w=500,h=140, color='Y',text=LANG'main_in_sandbox', fontSize=40,cornerR=0,code=playMode'mino/interior/train'},

    WIDGET.new{type='button',     pos={.5,.5},x=-270,y=320,w=400,h=100,text=CHAR.icon.language,               fontSize=70,lineWidth=4,cornerR=0,code=WIDGET.c_goScn'lang_in'},
    WIDGET.new{type='button',     pos={.5,.5},x=270, y=320,w=400,h=100,text=LANG'main_in_settings',           fontSize=40,lineWidth=4,cornerR=0,code=WIDGET.c_goScn'setting_in'},
}
return scene
