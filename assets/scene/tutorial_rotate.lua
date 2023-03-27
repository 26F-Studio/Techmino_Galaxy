--[[ Levels
    1~40:    R/L
    41~80:   R/L/F
    81~120:  Random spawning direction
    121~160: Pentominoes
    161~200: Random spawning direction
]]
local parTime={50,40,35,40,30}

local level,score,time,passCD
local handID,handMat,targetMat
local texts=TEXT.new()
--[[
    COLOR.R,COLOR.F,COLOR.O,COLOR.Y,COLOR.L,COLOR.J,COLOR.G,COLOR.A,
    COLOR.C,COLOR.N,COLOR.S,COLOR.B,COLOR.V,COLOR.P,COLOR.M,COLOR.W,
]]
local shapes={
    -- Tetromino
    {matrix={{1,1,0},{0,1,1},{0,0,0}}},-- Z
    {matrix={{0,1,1},{1,1,0},{0,0,0}}},-- S
    {matrix={{1,0,0},{1,1,1},{0,0,0}}},-- J
    {matrix={{0,0,1},{1,1,1},{0,0,0}}},-- L
    {matrix={{0,1,0},{1,1,1},{0,0,0}}},-- T
    {unuse=true,matrix={{1,1},{1,1}}},-- O
    {matrix={{0,0,0,0},{1,1,1,1},{0,0,0,0},{0,0,0,0}}},-- I

    -- Pentomino
    {unuse=true,matrix={{1,1,0},{0,1,0},{0,1,1}}},-- Z5
    {unuse=true,matrix={{0,1,1},{0,1,0},{1,1,0}}},-- S5
    {matrix={{1,1,0},{1,1,1},{0,0,0}}},-- P
    {matrix={{0,1,1},{1,1,1},{0,0,0}}},-- Q
    {matrix={{1,0,0},{1,1,1},{0,1,0}}},-- F
    {matrix={{0,0,1},{1,1,1},{0,1,0}}},-- E
    {matrix={{0,1,0},{0,1,0},{1,1,1}}},-- T5
    {matrix={{1,0,1},{1,1,1},{0,0,0}}},-- U
    {matrix={{0,0,1},{0,0,1},{1,1,1}}},-- V
    {matrix={{1,0,0},{1,1,0},{0,1,1}}},-- W
    {unuse=true,matrix={{0,1,0},{1,1,1},{0,1,0}}},-- X
    {matrix={{0,0,0,0},{1,0,0,0},{1,1,1,1},{0,0,0,0}}},-- J5
    {matrix={{0,0,0,0},{0,0,0,1},{1,1,1,1},{0,0,0,0}}},-- L5
    {matrix={{0,0,0,0},{0,1,0,0},{1,1,1,1},{0,0,0,0}}},-- R
    {matrix={{0,0,0,0},{0,0,1,0},{1,1,1,1},{0,0,0,0}}},-- Y
    {matrix={{0,0,0,0},{1,1,0,0},{0,1,1,1},{0,0,0,0}}},-- N
    {matrix={{0,0,0,0},{0,0,1,1},{1,1,1,0},{0,0,0,0}}},-- H
    {unuse=true,matrix={{0,0,0,0,0},{0,0,0,0,0},{1,1,1,1,1},{0,0,0,0,0},{0,0,0,0,0}}},-- I5
}

local scene={}

local function newQuestion()
    passCD=false

    repeat
        if level>=4 then
            handID=math.random(8,#shapes)
        else
            handID=math.random(7)
        end
    until not shapes[handID].unuse

    handMat=TABLE.shift(shapes[handID].matrix)
    if level==3 or level==5 then handMat=TABLE.rotate(handMat,({'R','L','F'})[math.random(3)]) end

    local answer=({'R','L','F'})[math.random(level>=2 and 3 or 2)]
    targetMat=TABLE.rotate(TABLE.shift(handMat),answer)
end

local function reset()
    level=1
    score=0
    time=parTime[1]
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

function scene.enter()
    reset()
    playBgm('space','simp')
end

function scene.keyDown(key)
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
                    if time==0 or level==5 then
                        -- Too slow / Level Cleared
                        passCD=1e99
                        SFX.play('win')
                        texts:add{
                            text=Text.tutorial_pass,
                            color=time==0 and (level==1 and COLOR.lG or COLOR.lB) or COLOR.lY,
                            fontSize=80,
                            fontType='bold',
                            style='beat',
                            duration=2.6,
                            inPoint=.1,
                            outPoint=0,
                            exSize=1,
                        }
                        task_interiorAutoQuit(2.6)
                    else
                        -- Level Up
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
                time=math.max(time-1,0)
            end
            return
        end
    end

    action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        reset()
    elseif action=='back' then
        SCN.back('none')
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
    texts:update(dt)
    time=math.max(time-dt,0)
    if passCD then
        passCD=passCD-dt
        if passCD<=0 then
            newQuestion()
        end
    end
end

local size=60
function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(ColorTable[defaultMinoColor[handID]])

    -- Draw hand shape
    GC.translate(-#handMat*size/2,-#handMat*size/2-250)
    for y=1,#handMat do for x=1,#handMat[1] do
        if handMat[y][x]==1 then
            GC.rectangle('fill',(x-1)*size,(y-1)*size,size,size)
        end
    end end

    -- Draw target shape
    GC.translate(0,500)
    for y=1,#targetMat do for x=1,#targetMat[1] do
        if targetMat[y][x]==1 then
            GC.rectangle('fill',(x-1)*size,(y-1)*size,size,size)
        end
    end end

    GC.replaceTransform(SCR.xOy_m)

    -- Rotating center
    GC.setColor(COLOR.L)
    GC.circle('fill',0,-250,12)
    GC.circle('fill',0,250,12)

    -- Time
    local barLen=time/parTime[level]*313
    GC.setColor(1,1,1,.1)
    GC.rectangle('fill',-barLen,-6,2*barLen,12)

    -- Score
    GC.setColor(1,1,1,.42)
    FONT.set(80,'bold')
    GC.mStr(score.."/"..(40*level),0,-50)

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
