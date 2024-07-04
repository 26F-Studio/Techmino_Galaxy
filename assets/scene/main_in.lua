local consoleClickCount
local settingHint

---@type Zenitha.Scene
local scene={}
function scene.load()
    consoleClickCount=0
    settingHint=PROGRESS.get('main')<2 and PROGRESS.get('launchCount')<=3
    PROGRESS.applyEnv('interior')
    local visibleButtonName=PROGRESS.get('main')==1 and '1' or '2'
    for _,v in next,scene.widgetList do
        if v.name=='1' or v.name=='2' then
            v:setVisible(v.name==visibleButtonName)
        elseif v.name=='GameSet' then
            v.color=PROGRESS.get('main')<=2 and COLOR.L or COLOR.lD
        end
    end
    if PROGRESS.get('main')<=2 and (PROGRESS.getInteriorScore('sprint')>=200 or PROGRESS.getTotalInteriorScore()>=350) then
        PROGRESS.transcendTo(3)
    elseif PROGRESS.get('main')==1 and (PROGRESS.getTotalInteriorScore()>=150 or PROGRESS.getTutorialPassed()) then
        PROGRESS.transcendTo(2)
    end
end

local function sysAction(action)
    if action=='back' then
        if PROGRESS.get('main')<=2 then
            if sureCheck('quit') then PROGRESS.quit() end
        else
            SCN.back('none')
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    sysAction(KEYMAP.sys:getAction(key))
    return true
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

    -- Progress bar
    if PROGRESS.get('main')>=2 then
        scoreColor(-520,PROGRESS.getInteriorScore('dig'))
        scoreColor(-160,PROGRESS.getInteriorScore('sprint'))
        scoreColor(200, PROGRESS.getInteriorScore('marathon'))
    end

    -- Logo & verNum
    GC.setColor(1,1,1)
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
    FONT.set(100)
    GC.scale(2)
    GC.print("T",-215,-200)
    GC.print("echmino",-165,-200)

    -- Notify new player about setting
    if settingHint then
        GC.replaceTransform(SCR.xOy)
        GC.setLineWidth(6)
        GC.setColor(.626,1,.626,.26+.1*math.sin(2.6*love.timer.getTime()))
        local W=scene.widgetList.GameSet
        GC.mRect('line',W._x,W._y,W.w+42,W.h+42)
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=60,y=60,w=80,color='R',cornerR=0,sound_trigger='button_back',fontSize=70,text=CHAR.icon.back_chevron,code=function() sysAction('back') end},

    {name='1',type='button_fill',pos={.5,.5},x=-270,y=-40,w=500,h=140, color='F',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playInterior'brik/interior/sprint'},
    {name='1',type='button_fill',pos={.5,.5},x=270, y=-40,w=500,h=140, color='F',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playInterior'brik/interior/marathon'},

    {name='2',type='button_fill',pos={.5,.5},x=-360,y=-40,w=320,h=140, color='R',text=LANG'main_in_dig',     fontSize=40,cornerR=0,code=playInterior'brik/interior/dig'},
    {name='2',type='button_fill',pos={.5,.5},x=0,   y=-40,w=320,h=140, color='R',text=LANG'main_in_sprint',  fontSize=40,cornerR=0,code=playInterior'brik/interior/sprint'},
    {name='2',type='button_fill',pos={.5,.5},x=360, y=-40,w=320,h=140, color='R',text=LANG'main_in_marathon',fontSize=40,cornerR=0,code=playInterior'brik/interior/marathon'},

    {name='1',type='button_fill',pos={.5,.5},x=0,   y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn('tutorial_in','none')},
    {name='2',type='button_fill',pos={.5,.5},x=-270,y=140,w=500,h=140, color='B',text=LANG'main_in_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn('tutorial_in','none')},
    {name='2',type='button_fill',pos={.5,.5},x=270, y=140,w=500,h=140, color='Y',text=LANG'main_in_sandbox', fontSize=40,cornerR=0,code=playInterior'brik/interior/train'},

    {name='LangSel',type='button', pos={.5,.5},x=-270,y=320,w=400,h=100,text=CHAR.icon.language,     fontSize=70,lineWidth=4,cornerR=0,code=WIDGET.c_goScn('lang_in','none')},
    {name='GameSet',type='button', pos={.5,.5},x=270, y=320,w=400,h=100,text=LANG'main_in_settings', fontSize=40,lineWidth=4,cornerR=0,sound_trigger=false,code=function()
        if PROGRESS.get('main')<=2 or isCtrlPressed() then
            FMOD.effect('button_norm')
            SCN.go('setting_in','none')
        else
            consoleClickCount=consoleClickCount+1
            FMOD.effect('move_failed')
            FMOD.effect('suffocate',{tune=consoleClickCount-6.26})
            if consoleClickCount==6 then
                consoleClickCount=0
                PROGRESS.setSecret('interior_console')
                SCN.go('_console')
            end
        end
    end},
}
return scene
