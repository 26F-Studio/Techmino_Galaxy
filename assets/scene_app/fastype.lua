local gc=love.graphics
local rnd=math.random

local levels={
    A_Z="ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    Z_A="ZYXWVUTSRQPONMLKJIHGFEDCBA",
    Hello="HELLOWORLD",
    TG1="TECHMINOGALAXYHAOWAN",
    TG2="TECHMINOGALAXYISFUN",
    KeyTest1="THEQUICKBROWNFOXJUMPSOVERALAZYDOG",
    KeyTest2="THEFIVEBOXINGWIZARDSJUMPQUICKLY",
    Roll1="QWERTYUIOPASDFGHJKLZXCVBNM",
    Roll2="QAZWSXEDCRFVTGBYHNUJMIKOLP",
    Roll3="ZAQWSXCDERFVBGTYHNMJUIKLOP",
    Stair1="ZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCVZXCV",
    Stair2="ZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCVCXZXCV",
    Stair3="XZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCVXZCV",
    Stair4="ZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXVZCXV",
    BPW="OHOOOOOOOOOAAAAEAAIAUJOOOOOOOOOOOAAEOAAUUAEEEEEEEEEAAAAEAEIEAJOOOOOOOOOOEEEEOAAAAAAA",
}

---@type Zenitha.Scene
local scene={}

local levelName="A_Z"
local targetString
local startTime,time
local state,progress=0
local frameKeyCount,mistake

function scene.load()
    BG.set('space')
    levelName="A_Z"
    targetString=levels.A_Z
    progress=1
    frameKeyCount=0
    mistake=0
    startTime=0
    time=0
    state=0
    scene.widgetList.keyboard:setVisible(MOBILE)
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if #key==1 then
        if state<2 and frameKeyCount<3 then
            if key:upper():byte()==targetString:byte(progress) then
                progress=progress+1
                frameKeyCount=frameKeyCount+1
                TEXT:add{
                    text=key:upper(),
                    x=rnd(300,1300),y=rnd(650,900),
                    a=.626,
                    fontSize=90,
                    style='score',
                    duration=.4,
                }
                FMOD.effect('inputbox_input')
                if progress==2 then
                    state=1
                    startTime=love.timer.getTime()
                elseif progress>#targetString then
                    time=love.timer.getTime()-startTime
                    state=2
                    FMOD.effect('beep_rise')
                end
            elseif progress>1 then
                mistake=mistake+1
                FMOD.effect('rotate_failed')
            end
        end
    elseif key=='left' or key=='right' then
        if state==0 then
            scene.widgetList.level:arrowKey(key)
        end
    elseif key=='space' then
        progress=1
        mistake=0
        time=0
        state=0
    elseif key=='escape' then
        if SureCheck('back') then SCN.back() end
    end
    return true
end

function scene.update()
    if state==1 then
        frameKeyCount=0
        time=love.timer.getTime()-startTime
    end
end

function scene.draw()
    FONT.set(40)
    gc.setColor(COLOR.L)
    gc.print(("%.3f"):format(time),1026,80)
    gc.print(mistake,1026,150)

    if state>0 then
        gc.print(("%.3f/s"):format((progress-1)/time),1026,220)
    end

    if state==2 then
        gc.setColor(.9,.9,0)-- win
    elseif state==1 then
        gc.setColor(.9,.9,.9)-- game
    elseif state==0 then
        gc.setColor(.2,.8,.2)-- ready
    end

    FONT.set(100)
    GC.mStr(state==1 and #targetString-progress+1 or state==0 and "Ready" or state==2 and "Win",800,200)

    gc.setColor(COLOR.L)
    gc.print(targetString:sub(progress,progress),120,280,0,2)
    gc.print(targetString:sub(progress+1),300,380)

    gc.setColor(1,1,1,.7)
    FONT.set(40)
    gc.print(targetString,120,520)
end

scene.widgetList={
    WIDGET.new{type='selector',name='level',text="",x=220,y=640,w=200,list={'A_Z','Z_A','HELLO','TG1','TG2','KeyTest1','KeyTest2','Roll1','Roll2','Roll3','Stair1','Stair2','Stair3','Stair4','BPW'},disp=function() return levelName end,code=function(i) levelName=i; targetString=levels[i] end,visibleTick=function() return state==0 end},
    WIDGET.new{type='button',  x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,onClick=WIDGET.c_pressKey'space'},
    WIDGET.new{type='button',  name='keyboard',x=160,y=210,w=180,h=100,fontSize=60,text=CHAR.icon.keyboard,onClick=function() love.keyboard.setTextInput(true,0,select(2,SCR.xOy:transformPoint(0,500)),1,1) end},
    WIDGET.new{type='button',  pos={1,1},x=-120,y=-80,w=160,h=80,sound_release='button_back',fontSize=60,text=CHAR.icon.back,onClick=WIDGET.c_backScn()},
}

return scene
