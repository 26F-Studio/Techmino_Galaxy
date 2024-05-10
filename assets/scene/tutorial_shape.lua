local level,score
local time,totalTime
local noControl
local quest,choices
local texts

--[[ Levels
    1~40:    R/L(+F after 20)
    41~80:   Random spawning direction
]]
local passTime=60
local parTime={30,35}
local questList={
    {quest={0,0,0}, good='J L O',   bad='S Z',},
    {quest={0,0,1}, good='S L O',   bad='J T',},
    {quest={0,0,2}, good='L O',     bad='Z S T I',},
    {quest={0,0,3}, good='O J',     bad='Z S L T I',},
    {quest={0,1,0}, good='T I',     bad='J L O',},
    {quest={0,1,1}, good='L T I',   bad='S',},
    {quest={0,1,2}, good='Z T I',   bad='S J L O',},
    {quest={0,1,3}, good='Z T',     bad='S J L I',},
    {quest={0,2,0}, good='J L I',   bad='Z S T O',},
    {quest={0,2,1}, good='S J T I', bad='Z L O',},
    {quest={0,2,2}, good='J I',     bad='Z S',},
    {quest={0,2,3}, good='Z J I',   bad='S L O',},
    {quest={0,3,0}, good='I',       bad='Z S J L T O',},
    {quest={0,3,1}, good='I L',     bad='Z S J T O',},
    {quest={0,3,2}, good='T I',     bad='Z L O',},
    {quest={0,3,3}, good='I',       bad='Z S L T',},
    {quest={1,0,1}, good='Z S T',   bad='J L O',},
    {quest={1,0,2}, good='S T',     bad='Z L O',},
    {quest={1,0,3}, good='S T',     bad='Z J O I',},
    {quest={2,0,2}, good='J L',     bad='Z S T O',},
    {quest={2,0,3}, good='L',       bad='Z J T O',},
    {quest={3,0,3}, good='I',       bad='Z S T O',},
} for _,v in next,questList do
    v.good=v.good:split(' ')
    v.bad=v.bad:split(' ')
end

local rnd=math.random

---@type Zenitha.Scene
local scene={}

local function flipPiece(name)
    return
        name=='Z' and 'S' or
        name=='S' and 'Z' or
        name=='J' and 'L' or
        name=='L' and 'J' or
        name
end

local function newQuestion()
    local q=questList[rnd(#questList)]
    if TABLE.find(q,3) then q=questList[rnd(#questList)] end
    local flip=MATH.roll()

    quest=TABLE.copy(q.quest)
    if flip then TABLE.reverse(quest) end

    local c1=q.good[rnd(#q.good)]
    local c2=q.bad[rnd(#q.bad)]
    if flip then c1,c2=flipPiece(c1),flipPiece(c2) end

    choices={c1,c2}
    for i=1,#choices do
        local piece=Brik.get(choices[i])
        choices[i]={
            shape=TABLE.copy(piece.shape),
            color=NumColor[defaultBrikColor[piece.id]],
            correct=i==1,
        }
        if level==2 then
            for _=0,rnd(3) do
                choices[i].shape=TABLE.rotate(choices[i].shape,'R')
            end
        end
    end
    if MATH.roll() then
        TABLE.reverse(choices)
    end
end

local function reset()
    autoQuitInterior(true)
    level=1
    score=0
    time=passTime
    totalTime=0
    noControl=false
    newQuestion()

    texts:clear()
    texts:add{
        y=-180,
        text=Text.tutorial_shape_1,
        fontSize=40,
        style='appear',
        duration=6.26,
    }
    texts:add{
        y=-120,
        text=Text.tutorial_shape_2,
        fontSize=25,
        style='appear',
        duration=6.26,
    }
end

local function endGame(passLevel)
    noControl=true
    texts:add{
        text=passLevel==0 and Text.tutorial_notpass or Text.tutorial_pass,
        color=({[0]=COLOR.lR,COLOR.lG,COLOR.lY})[passLevel],
        fontSize=80,
        fontType='bold',
        style='beat',
        styleArg=1,
        duration=2.6,
        inPoint=.1,
        outPoint=0,
    }
    autoQuitInterior()
end

local function answer(option)
    if noControl then return end
    if choices[option].correct then
        score=score+1
        if score%40==0 then
            -- End game check
            if level==1 then
                if time>parTime[1] then
                    -- Just pass
                    endGame(1)
                    FMOD.effect('win')
                else
                    level=2
                    time=parTime[2]
                    FMOD.effect('beep_notice')
                end
                PROGRESS.setTutorialPassed(3)
            elseif level==2 then
                -- Cleared
                endGame(2)
                FMOD.effect('win')
            end
        else
            -- Correct
            FMOD.effect('beep_rise')
        end
    else
        FMOD.effect('fail')
    end
    newQuestion()
end

function scene.enter()
    texts=TEXT.new()
    reset()
    playBgm('space')
end
function scene.leave()
    texts=nil
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local action
    action=KEYMAP.brik:getAction(key)
    if action=='moveLeft' or action=='moveRight' then
        answer(action=='moveLeft' and 1 or 2)
        return
    end
    action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        reset()
    elseif action=='back' then
        if sureCheck('back') then SCN.back('none') end
    end
end

function scene.update(dt)
    totalTime=totalTime+dt
    if not noControl then
        time=math.max(time-dt,0)
        if time==0 then
            if level==1 then
                endGame(0)
                FMOD.effect('fail')
            else
                endGame(1)
                FMOD.effect('win')
            end
        end
    end

    if texts then texts:update(dt) end
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)

    -- Questionmark
    -- GC.setColor(COLOR.L)
    -- FONT.set(100,'bold')
    -- GC.mStr("?",0,-330)

    local len=#quest
    -- Grid
    for i=0,len do
        GC.setLineWidth((i==0 or i==len) and 3 or 1)
        GC.setColor(1,1,1,(i==0 or i==len) and 1 or .42)
        local x=60*(i-len/2)
        GC.line(x,380,x,20)
    end
    for i=0,6 do
        GC.setLineWidth(i==0 and 3 or 1)
        GC.setColor(1,1,1,i==0 and 1 or .42)
        local y=380-60*i
        GC.line(-len*30,y,len*30,y)
    end
    -- Field
    GC.setColor(NumColor[-1])
    for i=1,len do
        GC.rectangle('fill',60*(i-1-len/2),380,60,-60*quest[i])
    end

    -- Choices
    for i=1,#choices do
        GC.push('transform')
        GC.translate(600*(i-1-(#choices-1)/2),0)
        local mat=choices[i].shape
        GC.translate(-#mat[1]*30,#mat*30)
        GC.setColor(choices[i].color)
        for y=1,#mat do
            for x=1,#mat[y] do
                if mat[y][x] then
                    GC.rectangle('fill',(x-1)*60,-(y-1)*60,60,-60)
                end
            end
        end
        GC.pop()
    end

    -- Score
    GC.setColor(1,1,1,.42)
    FONT.set(80,'bold')
    GC.mStr(score.."/"..(40*level),0,-110)

    -- Time
    if level>1 then
        local barLen=time/parTime[level]*313
        GC.setColor(1,1,1,.26)
        GC.rectangle('fill',-barLen,-180,2*barLen,10)
    else
        GC.replaceTransform(SCR.xOy_l)
        GC.setLineWidth(2)
        GC.setColor(COLOR.L)
        GC.rectangle('line',200-3,150+3,20+6,-300-6)
        GC.rectangle('fill',200,150,20,-300*math.max(passTime-totalTime,0)/passTime)
    end

    -- Floating texts
    if texts then
        GC.replaceTransform(SCR.xOy_m)
        GC.scale(2)
        texts:draw()
    end
end

scene.widgetList={
    {type='button',pos={.5,.5},x=-300,y=0,w=260,h=260,sound_trigger=false,code=function() answer(1) end},
    {type='button',pos={.5,.5},x=300,y=0,w=260,h=260,sound_trigger=false,code=function() answer(2) end},
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
