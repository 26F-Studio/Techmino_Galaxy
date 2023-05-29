local controlCD
local level,score
local time,totalTime
local protect-- Prevent punishment 90 when need 180 for one time
local handID,handMat,targetMat
local texts

--[[ Levels
    1~40:    R/L(+F after 20)
    41~80:   Random spawning direction
    81~120:  Pentominoes
    121~160: Random spawning direction
]]
local passTime=60
local parTime={35,45,40,45}

local shapes do
    local O,_=true,false
    shapes={
        -- Tetromino
        {matrix={{O,O,_},{_,O,O},{_,_,_}},no180=true},-- Z
        {matrix={{_,O,O},{O,O,_},{_,_,_}},no180=true},-- S
        {matrix={{O,_,_},{O,O,O},{_,_,_}}},-- J
        {matrix={{_,_,O},{O,O,O},{_,_,_}}},-- L
        {matrix={{_,O,_},{O,O,O},{_,_,_}}},-- T
        {unuse=true,matrix={{O,O},{O,O}}},-- O
        {matrix={{_,_,_,_},{O,O,O,O},{_,_,_,_},{_,_,_,_}},no180=true},-- I

        -- Pentomino
        {unuse=true,matrix={{O,O,_},{_,O,_},{_,O,O}}},-- Z5
        {unuse=true,matrix={{_,O,O},{_,O,_},{O,O,_}}},-- S5
        {matrix={{O,O,_},{O,O,O},{_,_,_}}},-- P
        {matrix={{_,O,O},{O,O,O},{_,_,_}}},-- Q
        {matrix={{O,_,_},{O,O,O},{_,O,_}}},-- F
        {matrix={{_,_,O},{O,O,O},{_,O,_}}},-- E
        {matrix={{_,O,_},{_,O,_},{O,O,O}}},-- T5
        {matrix={{O,_,O},{O,O,O},{_,_,_}}},-- U
        {matrix={{_,_,O,_},{_,_,O,O},{O,O,O,_},{_,_,_,_}}},-- V
        {matrix={{O,_,_},{O,O,_},{_,O,O}}},-- W
        {unuse=true,matrix={{_,O,_},{O,O,O},{_,O,_}}},-- X
        {matrix={{_,_,_,_},{O,_,_,_},{O,O,O,O},{_,_,_,_}}},-- J5
        {matrix={{_,_,_,_},{_,_,_,O},{O,O,O,O},{_,_,_,_}}},-- L5
        {matrix={{_,_,_,_},{_,O,_,_},{O,O,O,O},{_,_,_,_}}},-- R
        {matrix={{_,_,_,_},{_,_,O,_},{O,O,O,O},{_,_,_,_}}},-- Y
        {matrix={{_,_,_,_},{O,O,_,_},{_,O,O,O},{_,_,_,_}}},-- N
        {matrix={{_,_,_,_},{_,_,O,O},{O,O,O,_},{_,_,_,_}}},-- H
        {unuse=true,matrix={{_,_,_,_,_},{_,_,_,_,_},{O,O,O,O,O},{_,_,_,_,_},{_,_,_,_,_}}},-- I5
    }
end

local scene={}

local function newQuestion()
    controlCD=false

    repeat
        if level>=3 then
            handID=math.random(8,#shapes)
        else
            handID=math.random(7)
        end
    until not shapes[handID].unuse

    handMat=TABLE.shift(shapes[handID].matrix)
    if level==2 or level==4 then handMat=TABLE.rotate(handMat,({'R','L','F'})[math.random(3)]) end

    local answer=({'R','L','F'})[math.random((not shapes[handID].no180 and score>=20) and 3 or 2)]
    protect=answer=='F'
    targetMat=TABLE.rotate(TABLE.shift(handMat),answer)
end

local function reset()
    autoQuitInterior(true)
    level=1
    score=0
    time=parTime[1]
    totalTime=0
    controlCD=false
    newQuestion()

    texts:clear()
    texts:add{
        y=-50,
        text=Text.tutorial_rotating_1,
        fontSize=40,
        style='appear',
        duration=6.26,
    }
    texts:add{
        y=50,
        text=Text.tutorial_rotating_2,
        fontSize=25,
        style='appear',
        duration=6.26,
    }
end

local function endGame(passLevel)
    controlCD=1e99
    texts:add{
        text=passLevel==0 and Text.tutorial_notpass or Text.tutorial_pass,
        color=({[0]=COLOR.lR,COLOR.lG,COLOR.lB,COLOR.lY})[passLevel],
        fontSize=80,
        fontType='bold',
        style='beat',
        styleArg=1,
        duration=2.6,
        inPoint=.1,
        outPoint=0,
    }
    if passLevel>0 then SFX.play('win') end
    autoQuitInterior()
end

function scene.enter()
    texts=TEXT.new()
    reset()
    playBgm('space','simp')
end

function scene.leave()
    texts=nil
end

function scene.keyDown(key,isRep)
    if isRep then return end

    local action
    if not controlCD then
        action=KEYMAP.mino:getAction(key)
        if action and action:find('rotate')==1 then
            SFX.play('rotate')

            if action=='rotateCW' then
                handMat=TABLE.rotate(handMat,'L')
            elseif action=='rotateCCW' then
                handMat=TABLE.rotate(handMat,'R')
            elseif action=='rotate180' then
                handMat=TABLE.rotate(handMat,'F')
            end

            local same=true
            for i=1,#handMat do
                if not TABLE.compare(handMat[i],targetMat[i]) then
                    same=false
                    break
                end
            end
            if same then
                controlCD=.26
                score=score+1
                if score%40==0 then
                    -- End game check
                    if time==0 then
                        -- Just pass
                        endGame(1)
                        PROGRESS.setTutorialPassed(6)
                    elseif level==4 then
                        -- Cleared
                        endGame(3)
                    else
                        -- Level Up
                        if level==1 then
                            PROGRESS.setTutorialPassed(6)
                        end
                        level=level+1
                        time=parTime[level]
                        SFX.play('beep_notice')
                    end
                else
                    -- Correct
                    SFX.play('beep_rise')
                end
            else
                -- Punishment
                if protect then
                    protect=false
                else
                    time=math.max(time-1.26,0)
                    totalTime=totalTime+1.26
                end
            end
            return
        end
    end

    action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        reset()
    elseif action=='back' then
        if sureCheck('back') then SCN.back('none') end
    end
end

function scene.touchDown(x,y,id)
    if SETTINGS.system.touchControl then VCTRL.press(x,y,id) end
end
function scene.touchMove(x,y,_,_,id)
    if SETTINGS.system.touchControl then VCTRL.move(x,y,id) end
end
function scene.touchUp(_,_,id)
    if SETTINGS.system.touchControl then VCTRL.release(id) end
end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.update(dt)
    -- Timer & check
    totalTime=totalTime+dt
    time=math.max(time-dt,0)
    if controlCD~=1e99 then
        if level>1 then
            if time==0 then
                endGame(level>=3 and 2 or 1)
                PROGRESS.setTutorialPassed(6)
            end
        elseif totalTime>passTime then
            SFX.play('fail')
            endGame(0)
        end
    end

    -- Auto next level
    if controlCD then
        controlCD=controlCD-dt
        if controlCD<=0 then
            newQuestion()
        end
    end

    if texts then texts:update(dt) end
end

local size=60
function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(ColorTable[defaultMinoColor[handID]])

    -- Hand shape
    GC.translate(-#handMat*size/2,-#handMat*size/2-250)
    for y=1,#handMat do for x=1,#handMat[1] do
        if handMat[y][x] then
            GC.rectangle('fill',(x-1)*size,(y-1)*size,size,size)
        end
    end end

    -- Target shape
    GC.translate(0,500)
    for y=1,#targetMat do for x=1,#targetMat[1] do
        if targetMat[y][x] then
            GC.rectangle('fill',(x-1)*size,(y-1)*size,size,size)
        end
    end end

    GC.replaceTransform(SCR.xOy_m)

    -- Rotating center
    GC.setColor(COLOR.L)
    GC.circle('fill',0,-250,10)
    GC.circle('fill',0,250,10)

    -- Score
    GC.setColor(1,1,1,.42)
    FONT.set(80,'bold')
    GC.mStr(score.."/"..(40*level),0,-50)

    -- Time
    if level>1 then
        local barLen=time/parTime[level]*313
        GC.setColor(1,1,1,.26)
        GC.rectangle('fill',-barLen,55,2*barLen,10)
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

    -- Touch control
    if SETTINGS.system.touchControl then
        GC.replaceTransform(SCR.xOy)
        VCTRL.draw()
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
