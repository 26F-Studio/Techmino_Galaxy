local ins,rem=table.insert,table.remove
local gc=love.graphics

--- @type Techmino.Mech.mino
local misc={}

function misc.interior_soundEvent_countDown(num)
    SFX.playSample('lead',num>0 and 'E4' or 'E5')
end

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

function misc.suffocateLock_event_whenSuffocate(P)
    local clearCount=#P.clearHistory
    P.deathTimer=false
    P.ghostState=false
    P:createDesuffocateEffect()
    P:minoDropped()
    if clearCount==#P.clearHistory then
        P:finish('WA')
    end
end

function misc.slowHide_event_gameOver(P)
    P:showInvis(4,626)
end

function misc.fastHide_event_gameOver(P)
    P:showInvis(1,100)
end

do -- coverField
    function misc.coverField_switch_auto(P)
        local md=P.modeData
        if not md._coverAlpha then
            md._coverAlpha=0
            md.coverAlpha=2600
            P:addEvent('always',misc.coverField_event_always)
            P:addEvent('gameOver',misc.coverField_event_gameOver)
            P:addEvent('drawInField',misc.coverField_event_drawInField)
        else
            md.coverAlpha=md.coverAlpha==0 and 2600 or md.coverAlpha==2600 and 0 or md.coverAlpha
        end
    end
    function misc.coverField_event_always(P)
        local md=P.modeData
        if md._coverAlpha and md._coverAlpha~=md.coverAlpha then
            md._coverAlpha=md._coverAlpha+MATH.sign(md.coverAlpha-md._coverAlpha)
        end
    end
    function misc.coverField_event_gameOver(P)
        P:showInvis()
        P.modeData.coverAlpha=2000
    end
    function misc.coverField_event_drawInField(P)
        local md=P.modeData
        if md._coverAlpha and md._coverAlpha>0 then
            gc.setColor(.26,.26,.26,md._coverAlpha/2600)
            gc.rectangle('fill',0,0,P.settings.fieldW*40,-P.settings.spawnH*40)
        end
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

do -- swapDirection
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

function misc.flipBoardLR(P)
    local matrix=P.field._matrix
    local width=P.settings.fieldW
    for y=1,P.field:getHeight() do
        TABLE.reverse(matrix[y])
        for x=1,width do
            P:setCellBias(x,y,{x=width+1-2*x,expBack=.026})
        end
    end
    P:freshGhost()
end
function misc.flipBoardUD(P)
    TABLE.reverse(P.field._matrix)
    local height=P.field:getHeight()
    for y=1,height do
        for x=1,P.settings.fieldW do
            P:setCellBias(x,y,{y=height+1-2*y,expBack=.026})
        end
    end
    P:freshGhost()
end
function misc.invertBoard(P,fromH,toH)
    local F=P.field
    local mat=F._matrix
    for y=fromH or 1,toH or F:getHeight() do
        for x=1,P.settings.fieldW do
            mat[y][x]=not mat[y][x] and {color=0}
        end
    end
end
function misc.spinBoard(P,dx)
    if dx==0 then return end
    dx=dx and dx%P.settings.fieldW or P:random(1,P.settings.fieldW-1)
    if dx>=P.settings.fieldW/2 then dx=dx-P.settings.fieldW end
    local ip=dx>0 and 1 or P.settings.fieldW
    local rp=dx>0 and P.settings.fieldW or 1
    for _=1,math.abs(dx) do
        for y=1,P.field:getHeight() do
            local line=P.field._matrix[y]
            ins(line,ip,rem(line,rp))
        end
    end
    P:freshGhost()
end

do -- randomPress
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

do -- symmetery
    function misc.symmetery_event_afterLock(P)
        local currentPos={}

        local CB=P.hand.matrix
        for y=1,#CB do for x=1,#CB[1] do if CB[y][x] then
            ins(currentPos,{P.handX+x-1,P.handY+y-1})
        end end end

        local id=nil
        for _,checkPos in next,currentPos do
            local C=P.field:getCell((P.settings.fieldW+1)-checkPos[1],checkPos[2])
            C=C and C.id or false
            if id==nil then
                id=C
            elseif id~=C then
                for _,clearPos in next,currentPos do
                    P.field:setCell(false,clearPos[1],clearPos[2])
                end
                -- TODO: other punishment
                break
            end
        end
    end
end

do -- wind
    function misc.wind_switch_auto(P)
        local md=P.modeData
        if md.wind_enabled then
            md.wind_enabled=false
            md.windStrength=false
            md._windStrength=false
            md.windCounter=false
            md.invertPoints=false
        else
            md.wind_enabled=true
            md.windStrength=(P:random()<.5 and -1 or 1)*P:random(1260,1600)
            md._windStrength=0
            md.windCounter=0

            md.invertPoints={}
            for i=1,P:random(4,6) do
                md.invertPoints[i]=P:random(2,38)
            end
            table.sort(md.invertPoints)
        end
        local setEvent=P.modeData.wind_enabled and P.addEvent or P.delEvent
        setEvent(P,'always',misc.wind_event_always)
        setEvent(P,'afterClear',misc.wind_event_afterClear)
        setEvent(P,'drawInField',misc.wind_event_drawInField)
    end
    function misc.wind_event_always(P)
        if not P.timing then return end
        local md=P.modeData
        md._windStrength=md._windStrength+MATH.sign(md.windStrength-md._windStrength)
        md.windCounter=md.windCounter+math.abs(md._windStrength)
        if md.windCounter>=62e3 then
            if P.hand then
                P[md._windStrength<0 and 'moveLeft' or 'moveRight'](P)
            end
            md.windCounter=md.windCounter-62e3
        end
    end
    function misc.wind_event_afterClear(P)
        local md=P.modeData
        if #md.invertPoints>0 and md.line>md.invertPoints[1] then
            while #md.invertPoints>0 and md.line>md.invertPoints[1] do
                rem(md.invertPoints,1)
            end
            md.windStrength=-MATH.sign(md.windStrength)*P:random(1260,1600)
        end
    end
    function misc.wind_event_drawInField(P)
        gc.setLineWidth(4)
        gc.setColor(1,.626,.626,.626)
        gc.circle('fill',P.settings.fieldW*(20+P.modeData._windStrength/100),-400,P.modeData._windStrength/60,6)
        gc.setLineWidth(8)
        gc.setColor(1,.942,.942,.42)
        gc.line(P.settings.fieldW*20,-400,P.settings.fieldW*(20+P.modeData._windStrength/100),-400)
    end
end

do -- obstacle
    local minDist=3
    local maxHeight=3
    local extraCount=3

    function misc.obstacle_generateField(P)
        local F=P.field
        local w=P.settings.fieldW
        local r0,r1=0
        TABLE.cut(F._matrix)
        for y=1,maxHeight do
            F._matrix[y]=TABLE.new(false,w)
            repeat
                r1=P:random(1,w)
            until math.abs(r1-r0)>=minDist;
            F._matrix[y][r1]=P:newCell(0)
            r0=r1
        end
        for _=1,extraCount do
            local x,y
            repeat
                x=P:random(1,w)
                y=math.floor(P:random()^2.6*(maxHeight-1))+1
            until not F._matrix[y][x]
            F._matrix[y][x]=P:newCell(0)
        end
        for y=1,maxHeight do
            if TABLE.count(F._matrix[y],false)==w then
                F._matrix[y][P:random(1,w)]=false
            end
        end
    end

    function misc.obstacle_event_playerInit(P)
        P.modeData.score=0
        misc.obstacle_generateField(P)
    end

    misc.obstacle_event_afterClear=TABLE.newPool(function(self,lineCount)
        self[lineCount]=function(P,clear)
            local score=math.ceil((clear.line+1)/2)
            P.modeData.score=math.min(P.modeData.score+score,lineCount)
            P.texts:add{
                text="+"..score,
                fontSize=80,
                a=.626,
                duration=.626,
                inPoint=0,
                outPoint=1,
            }
            if P.modeData.score>=lineCount then
                P:finish('AC')
            else
                misc.obstacle_generateField(P)
            end
        end
        return self[lineCount]
    end)
    misc.obstacle_event_drawOnPlayer=TABLE.newPool(function(self,lineCount)
        self[lineCount]=function(P)
            P:drawInfoPanel(-380,-60,160,120)
            FONT.set(80) GC.mStr(lineCount-P.modeData.score,-300,-70)
            FONT.set(30) GC.mStr(Text.target_line,-300,15)
        end
        return self[lineCount]
    end)
end

do -- Cascade
    local function getSolidMat(P)
        local F=P.field
        local visitedMat={}
        for y=1,F:getHeight() do
            visitedMat[y]=TABLE.new(false,F._width)
        end

        local pointsToCheck={}
        for x=1,F._width do
            ins(pointsToCheck,{x,1})
        end
        local ptr=#pointsToCheck
        while ptr>0 do
            local x,y=pointsToCheck[ptr][1],pointsToCheck[ptr][2]
            ptr=ptr-1
            if F:getCell(x,y) and not visitedMat[y][x] then
                local L=P:getConnectedCells(x,y)
                for i=1,#L do
                    local x2,y2=L[i][1],L[i][2]
                    visitedMat[y2][x2]=true
                    if visitedMat[y+1] then
                        pointsToCheck[ptr+1]={x2,y2+1}
                        ptr=ptr+1
                    end
                end
            end
        end
        return visitedMat
    end
    function misc.cascade_check(P)
        local F=P.field
        local solidMat=getSolidMat(P)

        for y=1,#solidMat do
            for x=1,F._width do
                if not solidMat[y][x] and F:getCell(x,y) then
                    return true
                end
            end
        end

        return false
    end
    function misc.cascade_fall(P)
        local F=P.field
        local solidMat=getSolidMat(P)

        for y=1,#solidMat do
            for x=1,F._width do
                if not solidMat[y][x] and F:getCell(x,y) then
                    local C=F:getCell(x,y)
                    F:setCell(false,x,y)
                    F:setCell(C,x,y-1)
                    P:setCellBias(x,y-1,{y=1,lineBack=40/P.modeData.cascadeDelay})
                end
            end
        end
        F:fresh()
    end
    function misc.cascade_autoEvent_always(P) -- Auto added, no need to manually add it
        if P.modeData.cascading then
            P.modeData.cascadeTimer=P.modeData.cascadeTimer-1
            if P.modeData.cascadeTimer<=0 then
                if misc.cascade_check(P) then
                    misc.cascade_fall(P)
                    P.modeData.cascadeTimer=P.modeData.cascadeDelay
                else
                    local fullLines=mechLib.mino.clearRule[P.settings.clearRule].getFill(P)
                    if fullLines then
                        P:doClear(fullLines)
                    else
                        P.settings.clearDelay=P.modeData.storedClearDelay
                        if not P.finished then
                            P.spawnTimer=P.settings.spawnDelay
                        end

                        P.modeData.cascading=false
                        P.modeData.cascadeTimer=false
                        P.modeData.cascadeDelay=false
                        P.modeData.storedClearDelay=nil
                    end
                end
            end
        else
            P:delEvent('always',misc.cascade_autoEvent_always)
        end
    end
    function misc.cascade_event_afterClear(P) -- Just addresses this to enabled cascade, and need clearRule='line_float'
        if misc.cascade_check(P) and not P.modeData.cascading then
            P.modeData.cascading=true
            P.modeData.cascadeDelay=math.max(math.floor(P.settings.clearDelay^.9),62)
            P.modeData.cascadeTimer=0
            P.modeData.storedClearDelay=P.settings.clearDelay
            P.settings.clearDelay=1e99
            P:addEvent('always',misc.cascade_autoEvent_always)
        end
    end
end

do -- variabalNext
    function misc.variabalNext_stackHigh_event_afterLock(P)
        if not P.modeData.storedNextSlot then
            P.modeData.storedNextSlot=P.settings.nextSlot
        end
        P.settings.nextSlot=math.floor(
            P.modeData.storedNextSlot/6*(
                math.min(P.field:getHeight()/P.settings.spawnH,1.5)
                ^2*7+.62
            )
        )
    end
    function misc.variabalNext_stackLow_event_afterLock(P)
        if not P.modeData.storedNextSlot then
            P.modeData.storedNextSlot=P.settings.nextSlot
        end
        P.settings.nextSlot=math.floor(
            P.modeData.storedNextSlot/6*(
                math.max(1-P.field:getHeight()/P.settings.spawnH,0)
                ^2*7+.62
            )
        )
    end
end

return misc
