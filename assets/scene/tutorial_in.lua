---@type Zenitha.Scene
local scene={}

local buttonTexts={
    'tutorial_basic',
    'tutorial_sequence',
    'tutorial_stackBasic',
    'tutorial_finesseBasic',
    'tutorial_finessePractice',
    'tutorial_allclearPractice',
    'tutorial_techrashPractice',
    'tutorial_finessePlus',
}
local function B(t)
    local w={
        type='button_fill',
        pos={.5,.52},
        w=620,h=140,
        fillColor='B',
        fontSize=50,
        cornerR=0,
    }
    TABLE.update(w,t)
    return WIDGET.new(w)
end
local function playTutorial(level)
    local unlock=PROGRESS.getTutorialPassed(level)
    if unlock==0 then
    elseif unlock<=2 or IsCtrlDown() then
        SCN.go('game_in','none','brik/interior/tutorial/'..(
            level==1 and '1.basic' or
            level==2 and '2.sequence' or
            level==3 and '3.stackBasic' or
            level==4 and '4.finesseBasic'
        ))
    else
        -- MSG('warn','Coming Soon')
        SCN.go('game_in','none','brik/interior/tutorial/'..(
            level==1 and '5.finessePractice' or
            level==2 and '6.allclearPractice' or
            level==3 and '7.techrashPractice' or
            level==4 and '8.finessePlus'
        ))
    end
end

function scene.load()
    for _,v in next,scene.widgetList do
        if v.name then
            local id=tonumber(v.name:sub(-1))
            local state=PROGRESS.getTutorialPassed(id)
            if state==0 then
                v.color='lD'
                v.text="???"
            elseif state<=2 then
                v.color=state==1 and 'B' or 'lG'
                v.text=LANG(buttonTexts[id])
            else
                v.color='lR'
                v.text=LANG(buttonTexts[4+id])
            end
        end
    end
    WIDGET._reset()
    PROGRESS.applyInteriorBGM()
end

function scene.mouseDown(_,_,k) if k==2 then SCN.back('none') end end
function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
        return true
    end
end

function scene.draw()
    if PROGRESS.get('main')>1 then
        GC.replaceTransform(SCR.xOy_m)
        GC.setColor(1,1,1,.42)
        GC.rectangle('fill',-7,-250,4,540)
    end
end

function scene.overDraw()
    -- Glitch effect after III
    if PROGRESS.get('main')>=3 then
        DrawGlitch()
    end
end

scene.widgetList={
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    B{name='T1',x=-350,y=-180,text=LANG'tutorial_basic',        code=function() playTutorial(1) end},
    B{name='T2',x=-350,y= 180,text=LANG'tutorial_sequence',     code=function() playTutorial(2) end},

    B{name='T3',x= 350,y=-180,text=LANG'tutorial_stackBasic',   code=function() playTutorial(3) end},
    B{name='T4',x= 350,y= 180,text=LANG'tutorial_finesseBasic', code=function() playTutorial(4) end},
}
return scene
