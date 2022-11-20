local scene={}
function scene.enter()
    PROGRESS.setEnv('interior')
    local visibleButtonName=PROGRESS.getMain()==1 and '1' or '2'
    for _,v in next,scene.widgetList do
        if v.name then
            v:setVisible(v.name==visibleButtonName)
        end
    end
    if PROGRESS.getMain()<=2 and (PROGRESS.getInteriorScore('sprint')>=200 or PROGRESS.getTotalInteriorScore()>=350) then
        PROGRESS.transendTo(3)
    elseif PROGRESS.getMain()==1 and (PROGRESS.getTotalInteriorScore()>=150 or PROGRESS.getTutorialPassed()) then
        PROGRESS.transendTo(2)
    end
end

function scene.keyDown(key,isRep)
    if key=='s' then SCN.swapTo('main_out','none') end
    if isRep then return end
    if key=='escape' then
        if sureCheck('quit') then PROGRESS.quit() end
    end
end

local function scoreColor(x,score)
    if score<160 then
        GC.setColor(1,1,1)
        GC.rectangle('fill',x,36,320*score/160,7)
    else
        GC.setColor(1,5-score/40,5-score/40)
        GC.rectangle('fill',x,36,320,7)
    end
end
function scene.draw()
    GC.replaceTransform(SCR.xOy_m)

    -- Draw progress bar
    if PROGRESS.getMain()>=2 then
        scoreColor(-520,PROGRESS.getInteriorScore('dig'))
        scoreColor(-160,PROGRESS.getInteriorScore('sprint'))
        scoreColor(200, PROGRESS.getInteriorScore('marathon'))
    end

    -- Draw logo & verNum
    GC.setColor(1,1,1)
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
    FONT.set(100)
    GC.scale(2)
    GC.print("T",-235,-200)
    GC.print("echmino",-180,-200)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=0,sound='back',fontSize=70,text=CHAR.icon.back_chevron,code=WIDGET.c_backScn()},

    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=-270,y=-40,w=500,h=140, color='F',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playMode'mino/interior/sprint'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=270, y=-40,w=500,h=140, color='F',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playMode'mino/interior/marathon'},

    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-360,y=-40,w=320,h=140, color='R',text=LANG'main_in_dig',     fontSize=40,cornerR=0,code=playMode'mino/interior/dig'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=0,   y=-40,w=320,h=140, color='R',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playMode'mino/interior/sprint'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=360, y=-40,w=320,h=140, color='R',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playMode'mino/interior/marathon'},

    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=0,   y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-270,y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=270, y=140,w=500,h=140, color='Y',text=LANG'main_in_sandbox', fontSize=40,cornerR=0,code=playMode'mino/interior/train'},

    WIDGET.new{type='button',     pos={.5,.5},x=-270,y=320,w=400,h=100,text=CHAR.icon.language,               fontSize=70,lineWidth=4,cornerR=0,code=WIDGET.c_goScn'lang_in'},
    WIDGET.new{type='button',     pos={.5,.5},x=270, y=320,w=400,h=100,text=LANG'main_in_settings',           fontSize=40,lineWidth=4,cornerR=0,code=WIDGET.c_goScn'setting_in'},
}
return scene
