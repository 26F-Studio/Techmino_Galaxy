local level,score,time,totalTime,passCD,protect
local handID,handMat,targetMat
local texts=TEXT.new()

--[[ Levels
    1~40:    R/L(+F after 20)
    41~80:  Random spawning direction
    81~120: Pentominoes
    121~160: Random spawning direction
]]
local passTime=60
local parTime={35,45,40,45}

local shapes do
    local X,_=true,false
    shapes={
        -- Tetromino
        {matrix={{X,X,_},{_,X,X},{_,_,_}},no180=true},-- Z
        {matrix={{_,X,X},{X,X,_},{_,_,_}},no180=true},-- S
        {matrix={{X,_,_},{X,X,X},{_,_,_}}},-- J
        {matrix={{_,_,X},{X,X,X},{_,_,_}}},-- L
        {matrix={{_,X,_},{X,X,X},{_,_,_}}},-- T
        {unuse=true,matrix={{X,X},{X,X}}},-- O
        {matrix={{_,_,_,_},{X,X,X,X},{_,_,_,_},{_,_,_,_}},no180=true},-- I

        -- Pentomino
        {unuse=true,matrix={{X,X,_},{_,X,_},{_,X,X}}},-- Z5
        {unuse=true,matrix={{_,X,X},{_,X,_},{X,X,_}}},-- S5
        {matrix={{X,X,_},{X,X,X},{_,_,_}}},-- P
        {matrix={{_,X,X},{X,X,X},{_,_,_}}},-- Q
        {matrix={{X,_,_},{X,X,X},{_,X,_}}},-- F
        {matrix={{_,_,X},{X,X,X},{_,X,_}}},-- E
        {matrix={{_,X,_},{_,X,_},{X,X,X}}},-- T5
        {matrix={{X,_,X},{X,X,X},{_,_,_}}},-- U
        {matrix={{_,_,X},{_,_,X},{X,X,X}}},-- V
        {matrix={{X,_,_},{X,X,_},{_,X,X}}},-- W
        {unuse=true,matrix={{_,X,_},{X,X,X},{_,X,_}}},-- X
        {matrix={{_,_,_,_},{X,_,_,_},{X,X,X,X},{_,_,_,_}}},-- J5
        {matrix={{_,_,_,_},{_,_,_,X},{X,X,X,X},{_,_,_,_}}},-- L5
        {matrix={{_,_,_,_},{_,X,_,_},{X,X,X,X},{_,_,_,_}}},-- R
        {matrix={{_,_,_,_},{_,_,X,_},{X,X,X,X},{_,_,_,_}}},-- Y
        {matrix={{_,_,_,_},{X,X,_,_},{_,X,X,X},{_,_,_,_}}},-- N
        {matrix={{_,_,_,_},{_,_,X,X},{X,X,X,_},{_,_,_,_}}},-- H
        {unuse=true,matrix={{_,_,_,_,_},{_,_,_,_,_},{X,X,X,X,X},{_,_,_,_,_},{_,_,_,_,_}}},-- I5
    }
end

local scene={}

local function newQuestion()
    passCD=false

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
    level=1
    score=0
    time=parTime[1]
    totalTime=0
    passCD=false
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
    passCD=1e99
    texts:add{
        text=passLevel==0 and Text.tutorial_notpass or Text.tutorial_pass,
        color=({[0]=COLOR.lR,COLOR.lG,COLOR.lB,COLOR.lY})[passLevel],
        fontSize=80,
        fontType='bold',
        style='beat',
        duration=2.6,
        inPoint=.1,
        outPoint=0,
        exSize=1,
    }
    task_interiorAutoQuit(2.6)
end

function scene.enter()
    reset()
    playBgm('space','simp')
end

function scene.leave()
    texts:clear()
end

function scene.keyDown(key,isRep)
    if isRep then return end

    local action
    if not passCD then
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
                passCD=.26
                score=score+1
                if score%40==0 then
                    -- End game check
                    if time==0 then
                        SFX.play('win')
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
                    time=math.max(time-1,0)
                    totalTime=totalTime+1
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
    if passCD~=1e99 then
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
    if passCD then
        passCD=passCD-dt
        if passCD<=0 then
            newQuestion()
        end
    end
    texts:update(dt)
end

local size=60
function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(ColorTable[defaultMinoColor[handID]])

    -- Draw hand shape
    GC.translate(-#handMat*size/2,-#handMat*size/2-250)
    for y=1,#handMat do for x=1,#handMat[1] do
        if handMat[y][x] then
            GC.rectangle('fill',(x-1)*size,(y-1)*size,size,size)
        end
    end end

    -- Draw target shape
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
        GC.rectangle('line',100-3,150+3,20+6,-300-6)
        GC.rectangle('fill',100,150,20,-300*math.max(passTime-totalTime,0)/passTime)
    end

    -- Draw Floating Texts
    GC.replaceTransform(SCR.xOy_m)
    GC.scale(2)
    texts:draw()

    -- Touch control
    if SETTINGS.system.touchControl then
        GC.replaceTransform(SCR.xOy)
        VCTRL.draw()
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},
}
return scene
