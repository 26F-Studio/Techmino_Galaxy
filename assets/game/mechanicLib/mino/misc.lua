local gc=love.graphics
local misc={}

function misc.invincible_event_afterLock(P)
    if P.field:getHeight()>P.settings.spawnH-1 then
        for y=1,P.field:getHeight()-(P.settings.spawnH-1) do for x=1,P.settings.fieldW do
            if not P.field:getCell(x,y) then
                P.field:setCell({},x,y)
            end
        end end
        P:playSound('desuffocate')
    end
end

function misc.slowHide_event_gameOver(P)
    P:showInvis(4,626)
end

function misc.fastHide_event_gameOver(P)
    P:showInvis(1,100)
end

do --coverField
    function misc.coverField_event_playerInit(P)
        P.modeData.coverAlpha=0
    end
    function misc.coverField_event_always(P)
        if P.finished then
            if P.modeData.coverAlpha>2000 then
                P.modeData.coverAlpha=P.modeData.coverAlpha-1
            end
        else
            if P.modeData.coverAlpha<2600 then
                P.modeData.coverAlpha=P.modeData.coverAlpha+1
            end
        end
    end
    function misc.coverField_event_gameOver(P)
        P:showInvis()
    end
    function misc.coverField_event_drawInField(P)
        gc.setColor(.26,.26,.26,P.modeData.coverAlpha/2600)
        gc.rectangle('fill',0,0,P.settings.fieldW*40,-P.settings.spawnH*40)
    end
end

function misc.noRotate_event_playerInit(P)
    P:switchAction('rotateCW',false)
    P:switchAction('rotateCCW',false)
    P:switchAction('rotate180',false)
end

function misc.noMove_event_playerInit(P)
    P:switchAction('moveLeft',false)
    P:switchAction('moveRight',false)
end

function misc.noFallAfterClear_event_afterClear(P,clear)
    for i=clear.line,1,-1 do
        table.insert(P.field._matrix,clear.lines[i],TABLE.new(false,P.settings.fieldW))
    end
    P.field:fresh()
end

do-- swapDirection
    function misc.swapDirection_event_playerInit(P)
        P.modeData.flip=false
    end
    function misc.swapDirection_event_key(P)
        if P.modeData.flip then
            P.keyState.rotateCW,P.keyState.rotateCCW=P.keyState.rotateCCW,P.keyState.rotateCW
            P.keyState.moveLeft,P.keyState.moveRight=P.keyState.moveRight,P.keyState.moveLeft
        end
    end
    function misc.swapDirection_event_afterLock(P)
        P.modeData.flip=not P.modeData.flip
        P.actions.rotateCW,P.actions.rotateCCW=P.actions.rotateCCW,P.actions.rotateCW
        P.actions.moveLeft,P.actions.moveRight=P.actions.moveRight,P.actions.moveLeft
    end
end

function misc.flipBoard_event_afterLock(P)
    for y=1,P.field:getHeight() do
        TABLE.reverse(P.field._matrix[y])
    end
end

do-- randomPress
    local decreaseLimit,decreaseAmount=260,120
    local minInterval,maxInterval=1620,2600
    function misc.randomPress_event_playerInit(P)
        P.modeData.randomPressTimer=maxInterval
    end
    function misc.randomPress_event_beforePress(P)
        if P.modeData.randomPressTimer>decreaseLimit then
            P.modeData.randomPressTimer=P.modeData.randomPressTimer-decreaseAmount
        end
    end
    function misc.randomPress_event_always(P)
        if not P.timing then return end
        P.modeData.randomPressTimer=P.modeData.randomPressTimer-1
        if P.modeData.randomPressTimer==0 then
            local r=P:random(P.holdTime==0 and 5 or 4)
            if r==1 then
                P:moveLeft()
            elseif r==2 then
                P:moveRight()
            elseif r==3 then
                P:rotate('R')
            elseif r==4 then
                P:rotate('L')
            elseif r==5 then
                P:hold()
            end
            P.modeData.randomPressTimer=P:random(minInterval,maxInterval)
        end
    end
end

do-- symmetery
    function misc.symmetery_event_initPlayer(P)
        P.modeData._coords={}
    end
    function misc.symmetery_event_afterDrop(P)
        local CB=P.hand.matrix
        for y=1,#CB do for x=1,#CB[1] do if CB[y][x] then
            table.insert(P.modeData._coords,{P.handX+x-1,P.handY+y-1})
        end end end
    end
    function misc.symmetery_event_afterLock(P)
        local id=nil
        for _,coord in next,P.modeData._coords do
            local C=P.field:getCell((P.settings.fieldW+1)-coord[1],coord[2])
            C=C and C.id or false
            if id==nil then
                id=C
            elseif id~=C then
                for _,coord in next,P.modeData._coords do
                    P.field:setCell(false,coord[1],coord[2])
                end
                break
            end
        end
        TABLE.cut(P.modeData._coords)
    end
end

do-- wind
    function misc.wind_event_playerInit(P)
        P.modeData.windTargetStrength=(P:random()<.5 and -1 or 1)*P:random(1260,1600)
        P.modeData.windStrength=0
        P.modeData.windCounter=0

        P.modeData.invertTimes={}
        for i=1,P:random(4,6) do
            P.modeData.invertTimes[i]=P:random(2,38)
        end
        table.sort(P.modeData.invertTimes)
    end
    function misc.wind_event_always(P)
        if not P.timing then return end
        local md=P.modeData
        md.windStrength=md.windStrength+MATH.sign(md.windTargetStrength-md.windStrength)
        md.windCounter=md.windCounter+md.windStrength
        if math.abs(md.windCounter)>=62000 then
            if P.hand then
                P[md.windCounter<0 and 'moveLeft' or 'moveRight'](P)
            end
            md.windCounter=md.windCounter-MATH.sign(md.windCounter)*62000
        end
    end
    function misc.wind_event_afterClear(P)
        local md=P.modeData
        if #md.invertTimes>0 and md.line>md.invertTimes[1] then
            while #md.invertTimes>0 and md.line>md.invertTimes[1] do
                table.remove(md.invertTimes,1)
            end
            md.windTargetStrength=-MATH.sign(md.windTargetStrength)*P:random(1260,1600)
        end
    end
    function misc.wind_event_drawInField(P)
        gc.setLineWidth(4)
        gc.setColor(1,.626,.626,.626)
        gc.circle('fill',P.settings.fieldW*(20+P.modeData.windStrength/100),-400,P.modeData.windStrength/60,6)
        gc.setLineWidth(8)
        gc.setColor(1,.942,.942,.42)
        gc.line(P.settings.fieldW*20,-400,P.settings.fieldW*(20+P.modeData.windStrength/100),-400)
    end
end

return misc
