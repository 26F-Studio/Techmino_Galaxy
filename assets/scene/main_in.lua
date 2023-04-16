local consoleClickCount=0

local scene={}
function scene.enter()
    consoleClickCount=0
    PROGRESS.setEnv('interior')
    local visibleButtonName=PROGRESS.getMain()==1 and '1' or '2'
    for _,v in next,scene.widgetList do
        if v.name=='1' or v.name=='2' then
            v:setVisible(v.name==visibleButtonName)
        elseif v.name=='GameSet' then
            v.color=PROGRESS.getMain()<=2 and COLOR.L or COLOR.lD
        end
    end
    if PROGRESS.getMain()<=2 and (PROGRESS.getInteriorScore('sprint')>=200 or PROGRESS.getTotalInteriorScore()>=350) then
        PROGRESS.transcendTo(3)
    elseif PROGRESS.getMain()==1 and (PROGRESS.getTotalInteriorScore()>=150 or PROGRESS.getTutorialPassed()) then
        PROGRESS.transcendTo(2)
    end
end

function scene.keyDown(key,isRep)
    if key=='s' then SCN.swapTo('main_out','none') end
    if isRep then return end
    if KEYMAP.sys:getAction(key)=='back' then
        if PROGRESS.getMain()<=2 then
            if sureCheck('quit') then PROGRESS.quit() end
        else
            SCN.back('none')
        end
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
    GC.print("T",-215,-200)
    GC.print("echmino",-165,-200)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=0,sound='button_back',fontSize=70,text=CHAR.icon.back_chevron,code=WIDGET.c_pressKey'escape'},

    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=-270,y=-40,w=500,h=140, color='F',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playInterior'mino/interior/sprint'},
    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=270, y=-40,w=500,h=140, color='F',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playInterior'mino/interior/marathon'},

    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-360,y=-40,w=320,h=140, color='R',text=LANG'main_in_dig',     fontSize=40,cornerR=0,code=playInterior'mino/interior/dig'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=0,   y=-40,w=320,h=140, color='R',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playInterior'mino/interior/sprint'},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=360, y=-40,w=320,h=140, color='R',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playInterior'mino/interior/marathon'},

    WIDGET.new{name='1',type='button_fill',pos={.5,.5},x=0,   y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn('tutorial_in','none')},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=-270,y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn('tutorial_in','none')},
    WIDGET.new{name='2',type='button_fill',pos={.5,.5},x=270, y=140,w=500,h=140, color='Y',text=LANG'main_in_sandbox', fontSize=40,cornerR=0,code=playInterior'mino/interior/train'},

    WIDGET.new{name='LangSel',type='button', pos={.5,.5},x=-270,y=320,w=400,h=100,text=CHAR.icon.language,     fontSize=70,lineWidth=4,cornerR=0,code=WIDGET.c_goScn('lang_in','none')},
    WIDGET.new{name='GameSet',type='button', pos={.5,.5},x=270, y=320,w=400,h=100,text=LANG'main_in_settings', fontSize=40,lineWidth=4,cornerR=0,sound=false,code=function()
        if PROGRESS.getMain()<=2 or isCtrlPressed() then
            SFX.play('button_norm')
            SCN.go('setting_in','none')
        else
            consoleClickCount=consoleClickCount+1
            SFX.play('move_failed')
            SFX.play('suffocate',nil,nil,consoleClickCount-5.626)
            if consoleClickCount==6 then
                consoleClickCount=0
                SCN.go('_console')
            end
        end
    end},
}
return scene
