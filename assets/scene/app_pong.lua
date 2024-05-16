local gc=love.graphics

local abs=math.abs
local max,min=math.max,math.min
local rnd=math.random

---@type Zenitha.Scene
local scene={}

local state

local player={} -- Player data
local ball={ -- Rotation Y
    x=640,y=360,
    vx=0,vy=0,
    ry=0,
}

local W,H=1400,900
local autoMoveFactor=26
local moveAcc,maxMoveSpeed=2600,2600
local rollRate,ryTransSpeed=0.62,620

function scene.enter()
    BG.set('none')
    state=0

    ball.x,ball.y=640,360
    ball.vx,ball.vy=0,0
    ball.ry=0

    player[1]={
        score=0,
        y=360,
        vy=0,
        targetY=false,
    }
    player[2]={
        score=0,
        y=360,
        vy=0,
        targetY=false,
    }
end

local function start()
    state=1
    ball.vx=MATH.coin(360,-360)
    ball.vy=rnd()*6-3
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='space' then
        if state==0 then
            start()
        end
    elseif key=='r' then
        state=0
        ball.x,ball.y=640,360
        ball.vx,ball.vy=0,0
        ball.ry=0
        player[1].score,player[2].score=0,0
        FMOD.effect('rotate')
    elseif key=='w' or key=='s' then
        player[1].targetY=false
    elseif key=='up' or key=='down' then
        player[2].targetY=false
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    end
    return true
end
function scene.touchDown(x,y)
    scene.touchMove(x,y)
    if state==0 then start() end
end
function scene.mouseDown(_,_,k) if state==0 and k==1 then start() end end
function scene.touchMove(x,y)(x<640 and player[1] or player[2]).targetY=y end
function scene.mouseMove(x,y)(x<640 and player[1] or player[2]).targetY=y end

-- Rect Area X:150~1130 Y:20~700
function scene.update(dt)
    -- Update pads
    for i=1,2 do
        local P=player[i]
        if P.targetY then
            P.vy=P.vy+(P.targetY-P.y)*dt*autoMoveFactor
        else
            if isKeyDown(P==player[1] and 'w' or 'up') then
                P.vy=max(P.vy-moveAcc*dt,-maxMoveSpeed)
            end
            if isKeyDown(P==player[1] and 's' or 'down') then
                P.vy=min(P.vy+moveAcc*dt,maxMoveSpeed)
            end
        end
        P.vy=MATH.expApproach(P.vy,0,dt*6.26)
        P.y=P.y+P.vy*dt
        if P.y~=MATH.clamp(P.y,70,650) then
            P.y=MATH.clamp(P.y,70,650)
            P.vy=-P.vy*0.626
        end
    end

    -- Update ball
    ball.x,ball.y=ball.x+ball.vx*dt,ball.y+ball.vy*dt
    if ball.ry~=0 then
        local dry=ball.ry-MATH.linearApproach(ball.ry,0,ryTransSpeed*dt)
        ball.vy=ball.vy+dry
        ball.ry=ball.ry-dry
        -- if ball.ry>0 then
        --     ball.ry=max(ball.ry-ryTransSpeed,0)
        --     ball.vy=ball.vy-ryTransSpeed*dt
        -- else
        --     ball.ry=min(ball.ry+ryTransSpeed,0)
        --     ball.vy=ball.vy+ryTransSpeed*dt
        -- end
    end
    if state==1 then -- Playing
        -- Player Hit
        if ball.x<160 or ball.x>1120 then
            local P=ball.x<160 and player[1] or player[2]
            local d=ball.y-P.y
            if abs(d)<60 then
                ball.vx=-(ball.vx+MATH.sign(ball.vx)*6)
                ball.vy=ball.vy+d*.08+P.vy*.5
                ball.ry=P.vy*rollRate
                FMOD.effect('touch')
            else
                state=2
            end
        end
        -- Wall Hit
        if ball.y<30 or ball.y>690 then
            ball.y=ball.y<30 and 30 or 690
            ball.vy,ball.ry=-ball.vy,-ball.ry
            FMOD.effect('move')
        end
    elseif state==2 then -- Game over
        if ball.x<-120 or ball.x>1400 or ball.y<-40 or ball.y>760 then
            state=0
            ball.x,ball.y=640,360
            ball.vx,ball.vy=0,0

            local winner=ball.x>640 and 1 or 2
            player[winner].score=player[winner].score+1
            TEXT:add({text="+1",x=winner==1 and 470 or 810,y=226,fontSize=50,style='score'})
            FMOD.effect('beep_rise')
        end
    end
end

function scene.draw()
    -- Draw score
    gc.setColor(.4,.4,.4)
    FONT.set(100)
    GC.mStr(player[1].score,470,20)
    GC.mStr(player[2].score,810,20)

    -- Draw boundary
    gc.setColor(COLOR.L)
    gc.setLineWidth(4)
    gc.line(134,20,1146,20)
    gc.line(134,700,1146,700)

    -- Draw ball & speed line
    gc.setColor(1,1,1-abs(ball.ry)*.16)
    gc.circle('fill',ball.x,ball.y,10)
    gc.setColor(1,1,1,.1)
    gc.line(ball.x+ball.vx*22,ball.y+ball.vy*22,ball.x+ball.vx*30,ball.y+ball.vy*30)

    -- Draw pads
    gc.setColor(1,.8,.8)
    gc.rectangle('fill',134,player[1].y-50,16,100)
    gc.setColor(.8,.8,1)
    gc.rectangle('fill',1130,player[2].y-50,16,100)

    FONT.set(30)
    gc.print(ball.vx,100,100)
    gc.print(ball.vy,100,120)
end

scene.widgetList={
    WIDGET.new{type='button',x=640,y=45,w=150,h=50,fontSize=35,text=CHAR.icon.retry,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='button',x=640,y=675,w=150,h=50,fontSize=40,sound_trigger='button_back',text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
