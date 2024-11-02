local max,min=math.max,math.min
local abs,floor,ceil=math.abs,math.floor,math.ceil
local ins,rem=table.insert,table.remove
local gc=love.graphics

---@type Map<Techmino.Event.Brik>
local misc={}

function misc.skipReadyWithHardDrop_beforePress(P,act)
    if P.timing then return true end
    if act=='hardDrop' and P.spawnTimer>1000 and P.finished==false then
        P.settings.readyDelay=P.time+1000
        P.spawnTimer=1000
        return true
    end
end

function misc.interior_soundEvent_countDown(num)
    playSample('square',{num>0 and 'E4' or 'E5'})
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
    P:brikDropped()
    if clearCount==#P.clearHistory then
        P:finish('suffocate')
    end
end

do -- Line Clear
    function misc.lineClear_event_afterClear(P)
        if P.stat.line>=P.modeData.target.line then
            P:finish('win')
        end
    end
    function misc.lineClear_event_drawInField(P)
        gc.setColor(1,1,1,.26)
        gc.rectangle('fill',0,(P.stat.line-P.modeData.target.line)*40-2,P.settings.fieldW*40,4)
    end
    function misc.lineClear_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.target.line-P.stat.line,-300,-70)
        FONT.set(30) GC.mStr(Text.target_line,-300,15)
    end
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

do -- Control Limit
    function misc.noRotate_event_playerInit(P)
        P:switchAction('rotateCW',false)
        P:switchAction('rotateCCW',false)
        P:switchAction('rotate180',false)
    end
    function misc.noMove_event_playerInit(P)
        P:switchAction('moveLeft',false)
        P:switchAction('moveRight',false)
    end
end

do -- Swap Direction
    function misc.swapDirection_event_playerInit(P)
        P.modeData.flipControlFlag=false
    end
    function misc.swapDirection_event_key(P)
        if P.modeData.flipControlFlag then
            P.keyState.rotateCW,P.keyState.rotateCCW=P.keyState.rotateCCW,P.keyState.rotateCW
            P.keyState.moveLeft,P.keyState.moveRight=P.keyState.moveRight,P.keyState.moveLeft
        end
    end
    function misc.swapDirection_event_afterLock(P)
        P.modeData.flipControlFlag=not P.modeData.flipControlFlag
        P.actions.rotateCW,P.actions.rotateCCW=P.actions.rotateCCW,P.actions.rotateCW
        P.actions.moveLeft,P.actions.moveRight=P.actions.moveRight,P.actions.moveLeft
    end
end

do -- Board Transition
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
        for _=1,abs(dx) do
            for y=1,P.field:getHeight() do
                local line=P.field._matrix[y]
                ins(line,ip,rem(line,rp))
            end
        end
        P:freshGhost()
    end
end

do -- Random Press
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
        if P.modeData.randomPressTimer<=0 then
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

do -- Symmetery
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

do -- Wind
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
        md.windCounter=md.windCounter+abs(md._windStrength)
        if md.windCounter>=62e3 then
            if P.hand then
                P[md._windStrength<0 and 'moveLeft' or 'moveRight'](P)
            end
            md.windCounter=md.windCounter-62e3
        end
    end
    function misc.wind_event_afterClear(P)
        local md=P.modeData
        if md.invertPoints[1] and P.stat.line>md.invertPoints[1] then
            while md.invertPoints[1] and P.stat.line>md.invertPoints[1] do
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

do -- Obstacle
    local minDist=3
    local maxHeight=3
    local extraCount=3

    function misc.obstacle_generateField(P)
        local F=P.field
        local w=P.settings.fieldW
        local r0,r1=0
        TABLE.clear(F._matrix)
        for y=1,maxHeight do
            F._matrix[y]=TABLE.new(false,w)
            repeat
                r1=P:random(1,w)
            until abs(r1-r0)>=minDist;
            F._matrix[y][r1]=P:newCell(777)
            r0=r1
        end
        for _=1,extraCount do
            local x,y
            repeat
                x=P:random(1,w)
                y=floor(P:random()^2.6*(maxHeight-1))+1
            until not F._matrix[y][x]
            F._matrix[y][x]=P:newCell(777)
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

    function misc.obstacle_event_afterClear(P,clear)
        local score=ceil((clear.line+1)/2)
        P.modeData.score=min(P.modeData.score+score,P.modeData.target.line)
        P.texts:add{
            text="+"..score,
            fontSize=80,
            a=.626,
            duration=.626,
            inPoint=0,
            outPoint=1,
        }
        if P.modeData.score>=P.modeData.target.line then
            P:finish('win')
        else
            misc.obstacle_generateField(P)
        end
    end
    function misc.obstacle_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(P.modeData.target.line-P.modeData.score,-300,-70)
        FONT.set(30) GC.mStr(Text.target_line,-300,15)
    end
end

do -- Chain
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
    ---Check floating blocks
    function misc.chain_check(P)
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
    function misc.chain_fall(P)
        local F=P.field
        local solidMat=getSolidMat(P)

        for y=1,#solidMat do
            for x=1,F._width do
                if not solidMat[y][x] and F:getCell(x,y) then
                    local C=F:getCell(x,y)
                    F:setCell(false,x,y)
                    F:setCell(C,x,y-1)
                    P:setCellBias(x,y-1,{y=1,lineBack=40/P.modeData.chainDelay})
                end
            end
        end
        F:fresh()
    end
    ---Will be automatically added
    function misc.chain_autoEvent_always(P)
        P.modeData.chainTimer=P.modeData.chainTimer-1
        if P.modeData.chainTimer>0 then return end

        if misc.chain_check(P) then
            misc.chain_fall(P)
            P.modeData.chainTimer=P.modeData.chainDelay
        else
            local fullLines=mechLib.brik.clearRule[P.settings.clearRule].getFill(P)
            if fullLines then
                P:doClear(fullLines)
            else
                P.settings.clearDelay=P.modeData.storedClearDelay
                if not P.finished then
                    P.spawnTimer=P.settings.spawnDelay
                end

                P.modeData.cascading=false
                P.modeData.chainTimer=false
                P.modeData.chainDelay=false
                P.modeData.storedClearDelay=nil
                return true
            end
        end
    end
    ---Add this to enabled chain, clearRule='line_float' needed
    function misc.chain_event_afterClear(P)
        if misc.chain_check(P) and not P.modeData.cascading then
            P.modeData.cascading=true
            P.modeData.chainDelay=max(floor(P.settings.clearDelay^.9),62)
            P.modeData.chainTimer=0
            P.modeData.storedClearDelay=P.settings.clearDelay
            P.settings.clearDelay=1e99
            P:addEvent('always',misc.chain_autoEvent_always)
        end
    end
end

do -- Variabal Next
    function misc.variabalNext_stackHigh_event_afterLock(P)
        if not P.modeData.storedNextSlot then
            P.modeData.storedNextSlot=P.settings.nextSlot
        end
        P.settings.nextSlot=floor(
            P.modeData.storedNextSlot/6*(
                min(P.field:getHeight()/P.settings.spawnH,1.5)
                ^2*7+.62
            )
        )
    end
    function misc.variabalNext_stackLow_event_afterLock(P)
        if not P.modeData.storedNextSlot then
            P.modeData.storedNextSlot=P.settings.nextSlot
        end
        P.settings.nextSlot=floor(
            P.modeData.storedNextSlot/6*(
                max(1-P.field:getHeight()/P.settings.spawnH,0)
                ^2*7+.62
            )
        )
    end
end

do -- Haunted
    local default_lightVisTimer=1000
    local default_lightFadeTime=800
    local default_spreadTime=50
    local default_lifeTime=1000

    ---@class Techmino.Mech.Brik.HauntedLight
    ---@field x integer
    ---@field y integer
    ---@field power integer
    ---@field spreadTimer number
    ---@field lifeTimer number
    ---@field listKey number
    ---@field mapKey string

    local function newLight(P,x,y,power)
        local md=P.modeData
        if not (x>=1 and x<=P.settings.fieldW and y>=1 and y<=P.field:getHeight()) then return end
        ---@type Techmino.Mech.Brik.HauntedLight[]
        local list=md.ghostLight_List
        ---@type Map<Techmino.Mech.Brik.HauntedLight>
        local map=md.ghostLight_Map
        local c0=map[x..','..y]
        if c0 then
            -- print("detected",x,y,power..">"..c0.power)
            if power<=c0.power then return end
            -- print("override",x,y)
            delLight(P,c0)
        end
        ---@type Techmino.Brik.Cell
        local c=P.field:getCell(x,y)
        if not c then return end

        c.visTimer=md.ghostLight_lightVisTimer
        c.fadeTime=md.ghostLight_lightFadeTime

        ---@type Techmino.Mech.Brik.HauntedLight
        local l={
            x=x,y=y,
            power=power,
            spreadTimer=md.ghostLight_spreadTime,
            lifeTimer=md.ghostLight_lifeTime,
            listKey=#list+1,
            mapKey=x..','..y,
        }
        list[l.listKey],map[x..','..y]=l,l
    end
    local function delLight(P,c0)
        local md=P.modeData
        ---@type Techmino.Mech.Brik.HauntedLight[]
        local list=md.ghostLight_List
        ---@type Map<Techmino.Mech.Brik.HauntedLight>
        local map=md.ghostLight_Map

        map[c0.mapKey]=nil
        if c0.listKey==#list then
            list[c0.listKey]=nil
        else
            list[#list].listKey=c0.listKey
            list[c0.listKey],list[#list]=list[#list],nil
        end
    end
    misc.haunted_newLight=newLight
    misc.haunted_delLight=delLight
    function misc.haunted_turnOn(P,spreadTime,lifeTime,visTime,fadeTime)
        if not P.modeData.ghostLight_powerID then
            P.modeData.ghostLight_powerID=0
            P.modeData.ghostLight_List={}
            P.modeData.ghostLight_Map={}
            P:addEvent('always',mechLib.brik.misc.haunted_always)
            P:addEvent('afterLock',mechLib.brik.misc.haunted_afterLock)
            -- P:addEvent('drawInField',mechLib.brik.misc.haunted_drawInField)
        end
        P.modeData.ghostLight_lightVisTimer=visTime or P.modeData.ghostLight_lightVisTimer or default_lightVisTimer
        P.modeData.ghostLight_lightFadeTime=fadeTime or P.modeData.ghostLight_lightFadeTime or default_lightFadeTime
        P.modeData.ghostLight_spreadTime=spreadTime or P.modeData.ghostLight_spreadTime or default_spreadTime
        P.modeData.ghostLight_lifeTime=lifeTime or P.modeData.ghostLight_lifeTime or default_lifeTime
    end
    function misc.haunted_always(P)
        local list=P.modeData.ghostLight_List
        for i=#list,1,-1 do
            ---@type Techmino.Mech.Brik.HauntedLight
            local c=list[i]
            local x,y=c.x,c.y
            if c.spreadTimer then
                c.spreadTimer=c.spreadTimer-1
                if c.spreadTimer<=0 then
                    newLight(P,x-1,y,c.power)
                    newLight(P,x+1,y,c.power)
                    newLight(P,x,y-1,c.power)
                    newLight(P,x,y+1,c.power)
                    c.spreadTimer=nil
                end
            end
            c.lifeTimer=c.lifeTimer-1
            if c.lifeTimer<=0 or not P.field:getCell(x,y) then
                delLight(P,c)
            end
        end
    end
    function misc.haunted_afterLock(P)
        P.modeData.ghostLight_powerID=P.modeData.ghostLight_powerID+1
        newLight(P,P.handX,P.handY,P.modeData.ghostLight_powerID)
    end
    function misc.haunted_drawInField(P)
        -- Debugging use
        local list=P.modeData.ghostLight_List
        gc.setColor(1,1,1,.26)
        for i=1,#list do
            ---@type Techmino.Mech.Brik.HauntedLight
            local c=list[i]
            gc.print(c.lifeTimer,40*(c.x-1),-40*c.y+15)
            if c.spreadTimer then
                gc.rectangle('fill',40*(c.x-1),-40*c.y,10,10)
            end
        end
    end
end

return misc
