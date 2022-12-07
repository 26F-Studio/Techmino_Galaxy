local gc=love.graphics

local max,min=math.max,math.min
local floor,ceil=math.floor,math.ceil
local rnd=math.random
local ins,rem=table.insert,table.remove

local inst=SFX.playSample

local MP=setmetatable({},{__index=require'assets.game.basePlayer'})
local minoAtkSys=require'assets.game.atksys_mino'

--------------------------------------------------------------
-- Function tables
local defaultSoundFunc={
    countDown=function(num)
        if num==0 then-- 6, 3+6+6
            inst('bass',.8,'A3')
            inst('lead',.9,'A4','E5','A5')
        elseif num==1 then-- 5, 3+7
            inst('bass',.9,'G3')
            inst('lead',.9,'B4','E5')
        elseif num==2 then-- 4, 6+2
            inst('bass','F3')
            inst('lead',.8,'A4','D5')
        elseif num==3 then-- 6+6
            inst('bass',.9,'A3','E4')
            inst('lead',.8,'A4')
        elseif num==4 then-- 5+7, 5
            inst('bass',.9,'G3','B3')
            inst('lead',.6,'G4')
        elseif num==5 then-- 4+6, 4
            inst('bass',.8,'F3','A3')
            inst('lead',.3,'F4')
        elseif num<=10 then
            inst('bass',2.2-num/5,'A2','E3')
        end
    end,
    move=           function() SFX.play('move')             end,
    move_failed=    function() SFX.play('move_failed')      end,
    tuck=           function() SFX.play('tuck')             end,
    rotate=         function() SFX.play('rotate')           end,
    initrotate=     function() SFX.play('initrotate')       end,
    rotate_locked=  function() SFX.play('rotate_locked')    end,
    rotate_corners= function() SFX.play('rotate_corners')   end,
    rotate_failed=  function() SFX.play('rotate_failed')    end,
    rotate_special= function() SFX.play('rotate_special')   end,
    hold=           function() SFX.play('hold')             end,
    inithold=       function() SFX.play('inithold')         end,
    touch=          function() SFX.play('touch',.5)         end,
    drop=           function() SFX.play('drop')             end,
    lock=           function() SFX.play('lock')             end,
    b2b=            function(lv) SFX.play('b2b_'..min(lv,10)) end,
    b2b_break=      function() SFX.play('b2b_break') end,
    clear=function(lines)
        SFX.play(
            lines==1 and 'clear_1' or
            lines==2 and 'clear_2' or
            lines==3 and 'clear_3' or
            lines==4 and 'clear_4' or
            'clear_5'
        )
        if lines>=3 then
            BGM.set('all','highgain',.26+1/lines,0)
            BGM.set('all','highgain',1,min((lines)^1.5/5,2.6))
        end
    end,
    spin=function(lines)
        if lines==0 then     SFX.play('spin_0')
        elseif lines==1 then SFX.play('spin_1')
        elseif lines==2 then SFX.play('spin_2')
        elseif lines==3 then SFX.play('spin_3')
        elseif lines==4 then SFX.play('spin_4')
        else                 SFX.play('spin_mega')
        end
    end,
    combo=setmetatable({
        function() inst('bass',.70,'A2') end,-- 1 combo
        function() inst('bass',.75,'C3') end,-- 2 combo
        function() inst('bass',.80,'D3') end,-- 3 combo
        function() inst('bass',.85,'E3') end,-- 4 combo
        function() inst('bass',.90,'G3') end,-- 5 combo
        function() inst('bass',.90,'A3') inst('lead',.20,'A2') end,-- 6 combo
        function() inst('bass',.75,'C4') inst('lead',.40,'C3') end,-- 7 combo
        function() inst('bass',.60,'D4') inst('lead',.60,'D3') end,-- 8 combo
        function() inst('bass',.40,'E4') inst('lead',.75,'E3') end,-- 9 combo
        function() inst('bass',.20,'G4') inst('lead',.90,'G3') end,-- 10 combo
        function() inst('bass',.20,'A4') inst('lead',.85,'A3') end,-- 11 combo
        function() inst('bass',.40,'A4') inst('lead',.80,'C4') end,-- 12 combo
        function() inst('bass',.60,'A4') inst('lead',.75,'D4') end,-- 13 combo
        function() inst('bass',.75,'A4') inst('lead',.70,'E4') end,-- 14 combo
        function() inst('bass',.90,'A4') inst('lead',.65,'G4') end,-- 15 combo
        function() inst('bass',.90,'A4') inst('bass',.70,'E5') inst('lead','A4') end,-- 16 combo
        function() inst('bass',.85,'A4') inst('bass',.75,'E5') inst('lead','C5') end,-- 17 combo
        function() inst('bass',.80,'A4') inst('bass',.80,'E5') inst('lead','D5') end,-- 18 combo
        function() inst('bass',.75,'A4') inst('bass',.85,'E5') inst('lead','E5') end,-- 19 combo
        function() inst('bass',.70,'A4') inst('bass',.90,'E5') inst('lead','G5') end,-- 20 combo
    },{__call=function(self,combo)
        if self[combo] then
            self[combo]()
        else
            inst('bass',.626,'A4')
            local phase=(combo-21)%12
            inst('lead',1-((11-phase)/12)^2,41+phase)-- E4+
            inst('lead',1-((11-phase)/12)^2,46+phase)-- A4+
            inst('lead',1-(phase/12)^2,     53+phase)-- E5+
            inst('lead',1-(phase/12)^2,     58+phase)-- A5+
        end
    end,__metatable=true}),
    frenzy=      function() SFX.play('frenzy')      end,
    allClear=    function() SFX.play('all_clear')   end,
    halfClear=   function() SFX.play('half_clear')  end,
    suffocate=   function() SFX.play('suffocate')   end,
    desuffocate= function() SFX.play('desuffocate') end,
    reach=       function() SFX.play('beep_1')      end,
    win=         function() SFX.play('win')         end,
    fail=        function() SFX.play('fail')        end,
}
MP.scriptCmd={
    clearHold=function(P) P:clearHold() end,
    clearNext=function(P) P:clearNext() end,
    pushNext=function(P,arg) P:pushNext(arg) end,
    setField=function(P,arg) P:setField(arg) end,
    switchAction=function(P,arg) P:switchAction(arg) end,
}
--------------------------------------------------------------
-- Actions
local actions={}
actions.moveLeft={
    press=function(P)
        P.moveDir=-1
        P.moveCharge=0
        if P.hand then
            if P:moveLeft() then
                P:playSound('move')
                if P.handY==P.ghostY then
                    P:playSound('touch')
                end
            else
                P:playSound('move_failed')
            end
        else
            P.keyBuffer.move='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='L' then P.keyBuffer.move=false end
        if P.deathTimer then P:moveRight() end
    end
}
actions.moveRight={
    press=function(P)
        P.moveDir=1
        P.moveCharge=0
        if P.hand then
            if P:moveRight() then
                P:playSound('move')
                if P.handY==P.ghostY then
                    P:playSound('touch')
                end
            else
                P:playSound('move_failed')
            end
        else
            P.keyBuffer.move='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='R' then P.keyBuffer.move=false end
        if P.deathTimer then P:moveLeft() end
    end
}
actions.rotateCW={
    press=function(P)
        if P.hand then
            P:rotate('R')
        else
            P.keyBuffer.rotate='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='R' then P.keyBuffer.rotate=false end
    end
}
actions.rotateCCW={
    press=function(P)
        if P.hand then
            P:rotate('L')
        else
            P.keyBuffer.rotate='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='L' then P.keyBuffer.rotate=false end
    end
}
actions.rotate180={
    press=function(P)
        if P.hand then
            P:rotate('F')
        else
            P.keyBuffer.rotate='F'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='F' then P.keyBuffer.rotate=false end
    end
}
function actions.softDrop(P)
    P.downCharge=0
    if not P.hand or P.deathTimer then return end
    if P.handY>P.ghostY then
        if P:moveDown() then
            P:playSound('move')
        end
    end
end
actions.hardDrop={
    press=function(P)
        if P.hand and not P.deathTimer then
            P:minoDropped()
        else
            P.keyBuffer.hardDrop=true
        end
    end,
    release=function(P)
        P.keyBuffer.hardDrop=false
    end
}
actions.holdPiece={
    press=function(P)
        if P.hand then
            P:hold()
        else
            P.keyBuffer.hold=true
        end
    end,
    release=function(P)
        P.keyBuffer.hold=false
    end
}
function actions.sonicDrop(P)
    if not P.hand or P.deathTimer then return end
    if P.handY>P.ghostY then
        P:moveHand('moveY',P.ghostY-P.handY)
        P:freshDelay('drop')
        P:playSound('move')
        P:playSound('touch')
    end
end
function actions.sonicLeft(P)
    local moved
    while P.hand and not P:ifoverlap(P.hand.matrix,P.handX-1,P.handY) do
        moved=true
        P:moveHand('moveX',-1)
        P:freshGhost()
    end
    if not moved then
        P:playSound('move_failed')
    elseif P.handY==P.ghostY then
        P:playSound('touch')
    end
    return moved
end
function actions.sonicRight(P)
    local moved
    while P.hand and not P:ifoverlap(P.hand.matrix,P.handX+1,P.handY) do
        moved=true
        P:moveHand('moveX',1)
        P:freshGhost()
    end
    if not moved then
        P:playSound('move_failed')
    elseif P.handY==P.ghostY then
        P:playSound('touch')
    end
    return moved
end

actions.func1=NULL
actions.func2=NULL
actions.func3=NULL
actions.func4=NULL
actions.func5=NULL
actions.func6=NULL

local function _getActionObj(a)
    if type(a)=='string' then
        return actions[a]
    elseif type(a)=='function' then
        return setmetatable({
            press=a,
            release=NULL,
        },{__call=function(self,P)
            self.press(P)
        end})
    elseif type(a)=='table' then
        if not (type(a.press)=='function' and type(a.release)=='function') then error("WTF why action do not contain func press() & func release()") end
        return setmetatable({
            press=a.press,
            release=a.release,
        },{__call=function(self,P)
            self.press(P)
            self.release(P)
        end})
    else
        error("Invalid action: should be function or table contain 'press' and 'release' fields")
    end
end
for k,v in next,actions do actions[k]=_getActionObj(v) end
local actionPacks={
    Classic={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'softDrop',
    },
    Normal={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'rotate180',
        'softDrop',
        'hardDrop',
        'holdPiece',
        'sonicDrop',
    },
}
--------------------------------------------------------------
-- Effects
function MP:createMoveParticle(x1,y1,x2,y2)
    local p=self.particles.star
    p:setParticleLifetime(.26,.5)
    p:setEmissionArea('none')
    for x=x1,x2,x2>x1 and 1 or -1 do for y=y1,y2,y2>y1 and 1 or -1 do
        p:setPosition(
            (x+rnd()*#self.hand.matrix[1]-1)*40,
            -(y+rnd()*#self.hand.matrix-1)*40
        )
        p:emit(1)
    end end
end
function MP:createFrenzyParticle(amount)
    local p=self.particles.star
    p:setParticleLifetime(.626,1.6)
    p:setEmissionArea('uniform',200,400,0,true)
    p:setPosition(200,-400)
    p:emit(amount)
end
function MP:createLockParticle(x,y)
    local p=self.particles.trail
    p:setPosition(
        (x+#self.hand.matrix[1]/2-1)*40,
        -(y+#self.hand.matrix/2-1)*40
    )
    p:emit(1)
end
--------------------------------------------------------------
-- Game methods
function MP:moveHand(action,a,b,c,d)
    if action=='moveX' then
        self:createMoveParticle(self.handX,self.handY,self.handX+a,self.handY)
        self.handX=self.handX+a
    elseif action=='drop' or action=='moveY' then
        self:createMoveParticle(self.handX,self.handY,self.handX,self.handY+a)
        self.handY=self.handY+a
    elseif action=='rotate' or action=='reset' then
        self.handX,self.handY=a,b
    else
        error('WTF why action is '..tostring(action))
    end

    if self.handX%1~=0 or self.handY%1~=0 then error('EUREKA! Decimal position.') end

    local movement={
        action=action,
        mino=self.hand,
        x=self.handX,y=self.handY,
    }

    if action=='moveX' then
        if
            self.settings.tuck and
            self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) and
            self:ifoverlap(self.hand.matrix,self.handX,self.handY+1)
        then
            movement.tuck=true
            self:playSound('tuck')
        end
    elseif action=='rotate' then
        if
            self.settings.spin_immobile and
            self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) and
            self:ifoverlap(self.hand.matrix,self.handX,self.handY+1) and
            self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) and
            self:ifoverlap(self.hand.matrix,self.handX+1,self.handY)
        then
            movement.immobile=true
            self:shakeBoard(c=='L' and '-ccw' or c=='R' and '-cw' or '-180')
            self:playSound('rotate_locked')
        end
        if self.settings.spin_corners then
            local minoData=minoRotSys[self.settings.rotSys][self.hand.shape]
            local state=minoData[self.hand.direction]
            local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(self)
            if centerPos then
                local cx=self.handX+centerPos[1]-.5
                if floor(cx)==cx then
                    local cy=self.handY+centerPos[2]-.5
                    if floor(cy)==cy then
                        local corners=0
                        if self:isSolidCell(cx-1,cy-1) then corners=corners+1 end
                        if self:isSolidCell(cx+1,cy-1) then corners=corners+1 end
                        if self:isSolidCell(cx-1,cy+1) then corners=corners+1 end
                        if self:isSolidCell(cx+1,cy+1) then corners=corners+1 end
                        if corners>=self.settings.spin_corners then
                            movement.corners=true
                            self:playSound('rotate_corners')
                        end
                    end
                end
            end
        end
        self:playSound(d and 'initrotate' or 'rotate')
        if self.handY==self.ghostY then
            self:playSound('touch')
        end
    end
    self.lastMovement=movement

    if self.deathTimer then
        local t=self.deathTimer
        self.deathTimer=false-- Cancel deathTimer temporarily, prevent ifoverlap method treat anything as air
        if self:ifoverlap(self.hand.matrix,self.handX,self.handY) then
            self.deathTimer=t
        else
            self:playSound('desuffocate')
        end
    end
end
function MP:restoreMinoState(mino)-- Restore a mino object's state (only inside, like shape, name, direction)
    if mino._origin then
        for k,v in next,mino._origin do
            mino[k]=v
        end
    end
    return mino
end
function MP:resetPos()-- Move hand piece to the normal spawn position
    self:moveHand('reset',floor(self.field:getWidth()/2-#self.hand.matrix[1]/2+1),self.settings.spawnH+1+ceil(self.fieldDived/40))
    while self:ifoverlap(self.hand.matrix,self.handX,self.handY) and self.handY<(self.settings.maxSpawnH or self.settings.spawnH)+1 do self.handY=self.handY+1 end
    self.minY=self.handY
    self.ghostY=self.handY
    self:resetPosCheck()
    self:triggerEvent('afterResetPos')
end
function MP:resetPosCheck()
    local suffocated
    if self.deathTimer then
        local bufferedDeathTimer=self.deathTimer
        self.deathTimer=false-- Cancel deathTimer temporarily, or we cannot apply IMS when hold in suffcating
        suffocated=self:ifoverlap(self.hand.matrix,self.handX,self.handY)
        self.deathTimer=bufferedDeathTimer
    else
        suffocated=self:ifoverlap(self.hand.matrix,self.handX,self.handY)
    end

    if suffocated then
        if self.settings.deathDelay>0 then
            self.deathTimer=self.settings.deathDelay
            self:playSound('suffocate')

            -- Suffocate IMS, trigger when key pressed, not buffered
            if self.keyState.moveLeft then self:moveLeft() end
            if self.keyState.moveRight then self:moveRight() end
        else
            self:lock()
            self:finish('WA')
            return
        end
    else
        if self.keyBuffer.move then-- IMS
            if self.keyBuffer.move=='L' then
                self:moveLeft()
            elseif self.keyBuffer.move=='R' then
                self:moveRight()
            end
            self.keyBuffer.move=false
        end

        self:freshGhost()
        self:freshDelay('spawn')
    end

    if self.keyBuffer.rotate then-- IRS
        self:rotate(self.keyBuffer.rotate,true)
        self.keyBuffer.rotate=false
    end

    if self.settings.dascut>0 then--DAS cut
        self.moveCharge=self.moveCharge-self.settings.dascut
    end
end
function MP:freshGhost()
    if self.hand then
        self.ghostY=min(self.field:getHeight()+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        -- 20G check
        if (self.settings.dropDelay<=0 or self.downCharge and self.settings.sdarr==0) and self.ghostY<self.handY then
            self:moveHand('drop',self.ghostY-self.handY)
            self:freshDelay('drop')
            self:shakeBoard('-drop')
        else
            self:freshDelay('move')
        end
    end
end
function MP:freshDelay(reason)-- reason can be 'move' or 'drop' or 'spawn'
    local fell
    if self.handY<self.minY then
        self.minY=self.handY
        fell=true
    end
    local maxLockDelayAdded=min(self.settings.lockDelay-self.lockTimer,self.freshTimeRemain)
    if self.settings.freshCondition=='any' then
        if reason=='move' or reason=='rotate' then
            if self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='drop' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.lockTimer+maxLockDelayAdded
            self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    elseif self.settings.freshCondition=='fall' then
        if reason=='move' or reason=='rotate' then
            if fell and self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='drop' then
            self.dropTimer=self.settings.dropDelay
            if self.lockTimer<self.settings.lockDelay and self.freshChance>0 then
                self.lockTimer=self.lockTimer+maxLockDelayAdded
                self.freshTimeRemain=self.freshTimeRemain-maxLockDelayAdded
                self.freshChance=self.freshChance-1
            end
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    elseif self.settings.freshCondition=='never' then
        if reason=='move' or reason=='rotate' or reason=='drop' then
            -- Do nothing
        elseif reason=='spawn' then
            self.dropTimer=self.settings.dropDelay
            self.lockTimer=self.settings.lockDelay
            self.freshChance=self.settings.freshCount
            self.freshTimeRemain=self.settings.maxFreshTime
        end
    else
        error("WTF why settings.freshCondition is "..tostring(self.settings.freshCondition))
    end
end
function MP:freshNextQueue()
    while #self.nextQueue<max(self.settings.nextSlot,1) do
        local shapeID=self:seqGen()
        if shapeID then
            if type(shapeID)=='number' then
                self:pushNext(shapeID)
            else
                break
            end
        else
            break
        end
    end
end
function MP:clearHold()
    TABLE.cut(self.holdQueue)
end
function MP:clearNext()
    TABLE.cut(self.nextQueue)
end
function MP:pushNext(arg)
    if type(arg)=='number' then
        ins(self.nextQueue,self:getMino(assert(
            Minoes[arg],
            "Invalid mino name '"..arg.."'"
        ) and arg))
    elseif type(arg)=='string' then
        for i=1,#arg do
            ins(self.nextQueue,self:getMino(assert(
                Minoes[arg:sub(i,i)],
                "Invalid mino name '"..arg:sub(i,i).."'"
            ).id))
        end
    elseif type(arg)=='table' then
        for i=1,#arg do
            assert(type(arg[i])=='number' or type(arg[i])=='string',"Must be simple table")
            self:pushNext(arg[i])
        end
    else
        error("arg must be string or table")
    end
end
function MP:popNext()
    if self.nextQueue[1] then-- Most cases there is pieces in next queue
        self.hand=rem(self.nextQueue,1)
        self:freshNextQueue()
        self.holdTime=0
    elseif self.holdQueue[1] then-- If no nexts, force using hold
        ins(self.nextQueue,rem(self.holdQueue,1))
        self:popNext()
    else-- If no piece to use, both Next and Hold queue are empty, game over
        self:finish('ILE')
        return
    end

    if self.keyBuffer.hold then-- IHS
        self.keyBuffer.hold=false
        self:hold(true)
    else
        self:resetPos()
    end

    self:triggerEvent('afterSpawn')

    if self.keyBuffer.hardDrop then-- IHdS
        self.keyBuffer.hardDrop=false
        self:minoDropped()
    end
end
function MP:getMino(shapeID)
    assert(type(shapeID)=='number',"shapeID must be number")
    self.pieceCount=self.pieceCount+1
    local shape=TABLE.shift(Minoes[shapeID].shape)

    -- Generate matrix
    for y=1,#shape do for x=1,#shape[1] do
        if shape[y][x] then
            shape[y][x]={
                id=self.pieceCount,
                color=defaultMinoColor[shapeID],
                nearby={},
            }
        end
    end end

    -- Connect nearby cells
    for y=1,#shape do for x=1,#shape[1] do
        if shape[y][x] then
            local L=shape[y][x].nearby
            local b
            b=shape[y]   if b and b[x-1] then L[b[x-1]]=true end
            b=shape[y]   if b and b[x+1] then L[b[x+1]]=true end
            b=shape[y-1] if b and b[x]   then L[b[x]  ]=true end
            b=shape[y+1] if b and b[x]   then L[b[x]  ]=true end
            b=shape[y-1] if b and b[x-1] then L[b[x-1]]=true end
            b=shape[y-1] if b and b[x+1] then L[b[x+1]]=true end
            b=shape[y+1] if b and b[x-1] then L[b[x-1]]=true end
            b=shape[y+1] if b and b[x+1] then L[b[x+1]]=true end
        end
    end end

    local mino={
        id=self.pieceCount,
        shape=shapeID,
        direction=0,
        name=Minoes[shapeID].name,
        matrix=shape,
    }
    mino._origin=TABLE.copy(mino,0)
    return mino
end
function MP:ifoverlap(CB,cx,cy)
    local F=self.field

    -- Must in wall
    if cx<=0 or cx+#CB[1]-1>F:getWidth() or cy<=0 then return true end

    -- Must in air
    if cy>F:getHeight() then return false end

    -- Check field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] and self:isSolidCell(cx+x-1,cy+y-1) then
            return true
        end
    end end

    -- No collision
    return false
end
function MP:isSolidCell(x,y)
    return not self.deathTimer and self.field:getCell(x,y) and true or false
end
function MP:moveLeft()
    if not self:ifoverlap(self.hand.matrix,self.handX-1,self.handY) then
        self:moveHand('moveX',-1)
        self:freshGhost(self.deathTimer)
        return true
    end
end
function MP:moveRight()
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self:moveHand('moveX',1)
        self:freshGhost(self.deathTimer)
        return true
    end
end
function MP:moveDown()
    if not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
        self:moveHand('moveY',-1)
        self:freshDelay('drop')
        if self.handY==self.ghostY then
            self:playSound('touch')
        end
        return true
    end
end
function MP:rotate(dir,ifInit)
    if not self.hand then return end
    local minoData=minoRotSys[self.settings.rotSys][self.hand.shape]
    if dir~='R' and dir~='L' and dir~='F' then error("WTF why dir isn't R/L/F ("..tostring(dir)..")") end

    if minoData.rotate then-- Custom rotate function
        minoData.rotate(self,dir,ifInit)
    else-- Normal rotate procedure
        local preState=minoData[self.hand.direction]
        if preState then
            -- Rotate matrix
            local kick=preState[dir]
            if not kick then return end-- This RS doesn't define this rotation

            local cb=self.hand.matrix
            local icb=TABLE.rotate(cb,dir)
            local baseX,baseY

            local afterState=minoData[kick.target]
            if kick.base then
                baseX=kick.base[1]
                baseY=kick.base[2]
            elseif preState.center and afterState.center then
                baseX=preState.center[1]-afterState.center[1]
                baseY=preState.center[2]-afterState.center[2]
            else
                error('Cannot get baseX/Y')
            end

            for n=1,#kick.test do
                local ix,iy=self.handX+baseX+kick.test[n][1],self.handY+baseY+kick.test[n][2]
                if not self:ifoverlap(icb,ix,iy) then
                    self.hand.matrix=icb
                    self.hand.direction=kick.target
                    self:moveHand('rotate',ix,iy,dir,ifInit)
                    self:freshGhost(self.deathTimer)
                    return
                end
            end
            self:freshDelay('rotate')
            self:playSound('rotate_failed')
        else
            error("WTF why no state in minoData")
        end
    end
end
function MP:hold(ifInit)
    if self.holdTime>=self.settings.holdSlot and not self.settings.infHold then return end
    local mode=self.settings.holdMode

    -- These data may changed during hold, so we store them and recover them later
    local freshChance,freshTimeRemain=self.freshChance,self.freshTimeRemain
    local holdTime=self.holdTime

    self[
        mode=='hold' and 'hold_hold' or
        mode=='swap' and 'hold_swap' or
        mode=='float' and 'hold_float' or
        error("WTF why hold mode is "..tostring(mode))
    ](self)

    -- Recover data
    self.freshChance,self.freshTimeRemain=freshChance,freshTimeRemain
    self.holdTime=holdTime+1

    self:playSound(ifInit and 'inithold' or 'hold')
end
function MP:hold_hold()
    if not self.settings.holdKeepState then
        self.hand=self:restoreMinoState(self.hand)
    end

    -- Swap hand and hold
    local swapN=self.holdTime%self.settings.holdSlot+1
    self.hand,self.holdQueue[swapN]=self.holdQueue[swapN],self.hand

    -- Reset position or pop next out
    if self.hand then
        self:resetPos()
    else
        self:popNext()
    end
end
function MP:hold_swap()
    local swapN=self.holdTime%self.settings.holdSlot+1
    if self.nextQueue[swapN] then
        if not self.settings.holdKeepState then
            self.hand=self:restoreMinoState(self.hand)
        end
        self.hand,self.nextQueue[swapN]=self.nextQueue[swapN],self.hand
        self:resetPos()
    end
end
function MP:hold_float()
    local swapN=self.holdTime%self.settings.holdSlot+1
    if self.floatHolds[swapN] then
        local h=self.floatHolds[swapN]
        h.hand,self.hand=self.hand,h.hand
        h.handX,self.handX=self.handX,h.handX
        h.handY,self.handY=self.handY,h.handY
        h.lastMovement,self.lastMovement=self.lastMovement,h.lastMovement
        h.minY,self.minY=self.minY,h.minY
        while self:ifoverlap(self.hand.matrix,self.handX,self.handY) and self.handY<(self.settings.maxSpawnH or self.settings.spawnH)+1 do self.handY=self.handY+1 end
        self:resetPosCheck()
    else
        self.floatHolds[swapN]={
            hand=self.hand,
            handX=self.handX,
            handY=self.handY,
            lastMovement=self.lastMovement,
            minY=self.minY,
        }
        self.hand=false
        self:popNext()
    end
end
function MP:minoDropped()-- Drop & lock mino, and trigger a lot of things
    if not self.hand or self.deathTimer then return end

    -- Move down
    if self.handY>self.ghostY then
        self:moveHand('drop',self.ghostY-self.handY)
        self:shakeBoard('-drop')
        self:playSound('drop')
    end
    self:triggerEvent('afterDrop')
    if not self.hand then return end
    self:createLockParticle(self.handX,self.handY)

    -- Lock to field
    self:lock()
    if self.handY+#self.hand.matrix-1>self.settings.deathH then
        self:finish('MLE')
        return
    end
    self:playSound('lock')
    self:triggerEvent('afterLock')

    -- Clear
    local lineClear=self:checkField()

    if lineClear then
        self.lastMovement.clear=lineClear
        self.combo=self.combo+1
        self.clearTimer=self.settings.clearDelay
        local h={
            combo=self.combo,
            line=#lineClear,
            lines=lineClear,
            time=self.time,
        }
        ins(self.clearHistory,h)
        self:shakeBoard('-clear',#lineClear)
        self:playSound('clear',#lineClear)
        self:createFrenzyParticle(#lineClear*26)
        self:triggerEvent('afterClear',self.lastMovement)
    else
        self.combo=0
    end

    -- Lockout check
    if self.handY>self.settings.lockoutH and (self.settings.strictLockout or not lineClear)  then
        self:finish('CE')
    end

    -- Attack
    local atk=minoAtkSys[self.settings.atkSys].drop(self)
    if atk then GAME.send(self,atk) end

    -- Discard hand
    self.hand=false
    if self.finished then return end

    -- Update & Release garbage
    local i=1
    while true do
        local g=self.garbageBuffer[i]
        if not g then break end
        if g.time==g.time0 then
            local r=self.rcvRND:random(10)
            for _=1,g.power do
                self:riseGarbage(r)
            end
            rem(self.garbageBuffer,i)
            i=i-1-- Avoid index error
        elseif g.mode==1 then
            g.time=g.time+1
        end
        i=i+1
    end

    self.spawnTimer=self.settings.spawnDelay

    -- Fresh hand
    if self.spawnTimer<=0 and self.clearTimer<=0 then
        self:popNext()
    end
end
function MP:lock()-- Put mino into field
    local CB=self.hand.matrix
    local F=self.field
    for y=1,#CB do for x=1,#CB[1] do
        if CB[y][x] then
            F:setCell(CB[y][x],self.handX+x-1,self.handY+y-1)
        end
    end end
    ins(self.dropHistory,{
        id=self.hand.id,
        direction=self.hand.direction,
        x=self.handX,
        y=self.handY,
        time=self.time,
    })
end
function MP:diveDown(cells)
    if self.fieldDived==0 then
        self.fieldRisingSpeed=self.settings.initialRisingSpeed
    end
    self.fieldDived=self.fieldDived+cells*40
end
function MP:riseGarbage(holePos)
    local F=self.field
    local w=F:getWidth()
    local L={}

    -- Generate line
    for x=1,w do
        L[x]={
            color=0,
            nearby={},
        }
    end

    -- Generate hole
    if L[holePos] then
        L[holePos]=false
    else
        L[rnd(w)]=false
    end

    -- Add nearby
    for x=1,w do
        if L[x] then
            if L[x-1] then L[x].nearby[L[x-1]]=true end
            if L[x+1] then L[x].nearby[L[x+1]]=true end
        end
    end
    ins(F._matrix,1,L)

    -- Update buried depth and rising speed
    self:diveDown(1)

    -- Update hand position (if exist)
    if self.hand then
        self.handY=self.handY+1
        self.ghostY=self.ghostY+1
        self.minY=self.minY+1
    end
end
--[[ arg table={
    string? color <'template'|'absolute'>,
    boolean? resetHand
    boolean? sudden

    -- map matrix (will display as you see, any height)
    {7,7,7,7,0,0,0,0,1,1},
    {4,6,6,3,0,0,0,1,1,5},
    {4,6,6,3,0,0,2,2,5,5},
    {4,4,3,3,0,0,0,2,2,5},
}]]
function MP:switchAction(act,state)
    assert(actions[act],"Invalid action name '"..act.."'")
    if state==nil or state==not self.actions[act] then
        if self.actions[act] then
            self:release(act)
            self.keyState[act]=nil
            self.actions[act]=nil
        else
            self.actions[act]=_getActionObj(act)
            self.keyState[act]=false
        end
    end
end
function MP:setField(arg)
    local F=self.field
    local w=F:getWidth()
    local f={}

    local color=arg.color
    if color==nil then color='template' end
    assert(color=='template' or color=='absolute',"arg.color must be <'template'|'absolute'>")

    local sudden=arg.sudden
    if sudden==nil then sudden=true end
    assert(type(sudden)=='boolean' ,"arg.sudden must be boolean")

    local resetHand=arg.resetHand
    if resetHand==nil then resetHand=true end
    assert(type(resetHand)=='boolean' ,"arg.resetHand must be boolean")

    -- Translate field matrix
    for y=1,#arg do
        f[y]={}
        for x=1,w do
            local c=arg[y][x]
            if type(c)=='number' then
                if color=='template' then
                    if c%1==0 and c>=1 and c<=7 then
                        c=defaultMinoColor[c]
                    elseif c==8 then
                        c=0
                    else
                        c=false
                    end
                end
                if c and c%1==0 and c>=0 and c<=64 then
                    f[y][x]={color=c,nearby={}}
                else
                    f[y][x]=false
                end
            end
        end
    end

    -- Create connection
    for y=1,#arg do
        for x=1,w do
            if f[y][x] then
                if f[y]   and f[y][x-1] then f[y][x].nearby[f[y][x-1]]=true end
                if f[y]   and f[y][x+1] then f[y][x].nearby[f[y][x+1]]=true end
                if f[y-1] and f[y-1][x] then f[y][x].nearby[f[y-1][x]]=true end
                if f[y+1] and f[y+1][x] then f[y][x].nearby[f[y+1][x]]=true end
            end
        end
    end

    -- Apply field
    TABLE.cut(F._matrix)
    for y=1,#arg do
        F._matrix[y]=f[#arg+1-y]
    end

    -- Field rising animation
    self.fieldRisingSpeed=0
    self.fieldDived=0
    if not sudden then self:diveDown(#arg) end

    -- Reset current block
    if self.hand and (resetHand==true or self:ifoverlap(self.hand.matrix,self.handX,self.handY)) then
        self:resetPos()
    end
    self:freshGhost()
end
function MP:checkLineFull(y)
    local F=self.field
    for x=1,F:getWidth() do
        if not F:getCell(x,y) then
            return false
        end
    end
    return true
end
function MP:checkField()
    local lineClear={}
    local F=self.field
    for y=F:getHeight(),1,-1 do
        if self:checkLineFull(y) then
            F:removeLine(y)
            ins(lineClear,y)
        end
    end
    if #lineClear >0 then
        return lineClear
    end
end
function MP:changeFieldWidth(w,origPos)
    if w>0 and w%1==0 then
        if not origPos then origPos=1 end
        local w0=self.settings.fieldW
        for y=1,#self.field:getHeight() do
            local L=TABLE.new(false,w)
            for x=1,w0 do
                local newX=origPos+x-1
                if newX>=1 and newX<=w then
                    L[newX]=self.field._matrix[y][x]
                end
            end
        end
        self.settings.fieldW=w
        self.field._width=w
        self.field:fresh()
    end
end
function MP:changeAtkSys(sys)
    self.atkSysData={}
    if minoAtkSys[sys].init then minoAtkSys[sys].init(self) end
end
function MP:receive(data)
    local B={
        power=data.power,
        mode=data.mode,
        time0=math.floor(data.time*1000+.5),
        time=0,
        fatal=data.fatal,
        speed=data.speed,
    }
    ins(self.garbageBuffer,B)
end
function MP:getScriptValue(arg)
    return
        arg.d=='field_width' and self.field:getWidth() or
        arg.d=='field_height' and self.field:getHeight() or
        arg.d=='cell' and (self.field:getCell(arg.x,arg.y) and 1 or 0)
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function MP:updateFrame()
    local SET=self.settings

    -- Controlling piece
    if not self.deathTimer then
        -- Auto shift
        if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) then
                local c0=self.moveCharge
                local c1=c0+1
                self.moveCharge=c1
                local dist=0
                if c0>=SET.das then
                    c0=c0-SET.das
                    c1=c1-SET.das
                    if SET.arr==0 then
                        dist=1e99
                    else
                        dist=floor(c1/SET.arr)-floor(c0/SET.arr)
                    end
                elseif c1>=SET.das then
                    if SET.arr==0 then
                        dist=1e99
                    else
                        dist=1
                    end
                end
                if dist>0 then
                    local ox=self.handX
                    while dist>0 and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) do
                        self:moveHand('moveX',self.moveDir)
                        self:freshGhost()
                        dist=dist-1
                    end
                    if self.handX~=ox then
                        self:playSound('move')
                        if self.handY==self.ghostY then
                            self:playSound('touch')
                        end
                    end
                end
            else
                self.moveCharge=SET.das
                if self.hand then
                    self:shakeBoard(self.moveDir>0 and '-right' or '-left')
                end
            end
        else
            self.moveDir=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
            self.moveCharge=0
        end

        -- Auto drop
        if self.downCharge and self.keyState.softDrop then
            if self.hand and not self:ifoverlap(self.hand.matrix,self.handX,self.handY-1) then
                local c0=self.downCharge
                local c1=c0+1
                self.downCharge=c1
                local dist=SET.sdarr==0 and 1e99 or floor(c1/SET.sdarr)-floor(c0/SET.sdarr)
                local oy=self.handY
                if dist>0 then
                    while dist>0 do
                        dist=dist-1
                        if not self:moveDown() then break end
                    end
                    if oy~=self.handY then
                        self:freshDelay('drop')
                        self:playSound('move')
                        if self.handY==self.ghostY then
                            self:shakeBoard('-down')
                            self:playSound('touch')
                        end
                    end
                end
            else
                self.downCharge=SET.sdarr
                if self.hand then
                    self:shakeBoard('-down')
                end
            end
        else
            self.downCharge=false
        end

        repeat-- Update hand
            -- Wait clearing animation
            if self.clearTimer>0 then
                self.clearTimer=self.clearTimer-1
                break
            end

            -- Try spawn mino if don't have one
            if self.spawnTimer>0 then
                self.spawnTimer=self.spawnTimer-1
                if self.spawnTimer<=0 then
                    self:popNext()
                end
                break
            elseif not self.hand then
                self:popNext()
            end

            -- Try lock/drop mino
            if self.handY==self.ghostY then
                self.lockTimer=self.lockTimer-1
                if self.lockTimer<=0 then
                    self:minoDropped()
                end
                break
            else
                if self.dropDelay~=0 then
                    self.dropTimer=self.dropTimer-1
                    if self.dropTimer<=0 then
                        self.dropTimer=SET.dropDelay
                        self:moveHand('drop',-1)
                        if self.handY==self.ghostY then
                            self:playSound('touch')
                        end
                    end
                elseif self.handY~=self.ghostY then-- If switch to 20G during game, mino won't dropped to bottom instantly so we force fresh it
                    self:freshDelay('drop')
                end
            end
        until true
    else
        self.deathTimer=self.deathTimer-1
        if self.deathTimer<=0 then
            self.deathTimer=false
            self:lock()
            self:finish('WA')
        end
    end

    -- Update garbage
    for i=1,#self.garbageBuffer do
        local g=self.garbageBuffer[i]
        if g.mode==0 and g.time<g.time0 then
            g.time=g.time+1
        end
    end

    -- Update field depth
    if self.fieldDived>0 then
        -- Update fieldRisingSpeed first
        if self.fieldRisingSpeed>SET.maxRisingSpeed then
            self.fieldRisingSpeed=max(self.fieldRisingSpeed-SET.risingDeceleration,SET.maxRisingSpeed)
        elseif self.fieldRisingSpeed<SET.minRisingSpeed then
            self.fieldRisingSpeed=min(self.fieldRisingSpeed+SET.risingAcceleration,SET.minRisingSpeed)
        end
        self.fieldRisingSpeed=min(self.fieldRisingSpeed,(2*self.fieldDived*SET.risingDeceleration)^.5)

        -- Change fieldDived
        self.fieldDived=self.fieldDived-self.fieldRisingSpeed
        if self.fieldDived<=0 then
            self.fieldDived=0
            self.fieldRisingSpeed=0
        end
    end
end
function MP:render()
    local settings=self.settings
    local skin=SKIN.get(settings.skin)
    SKIN.time=self.time

    gc.push('transform')

    -- applyPlayerTransform
    gc.translate(self.pos.x,self.pos.y)
    gc.scale(self.pos.k*(1+self.pos.dk))
    gc.translate(self.pos.dx,self.pos.dy)
    gc.rotate(self.pos.a+self.pos.da)

    -- applyFieldTransform
    gc.push('transform')
    gc.translate(-200,400)

    -- startFieldStencil
    GC.stc_setComp()
    GC.stc_rect(0,0,400,-920)
    gc.scale(10/settings.fieldW)


        self:triggerEvent('drawBelowField')


        -- Grid & Cells
        skin.drawFieldBackground(settings.fieldW)

        gc.translate(0,self.fieldDived)
            skin.drawFieldCells(self.field)


            self:triggerEvent('drawBelowBlock')


            if self.hand then
                local CB=self.hand.matrix

                -- Ghost
                if not self.deathTimer then
                    skin.drawGhost(CB,self.handX,self.ghostY)
                end

                -- Mino
                if not self.deathTimer or (2600/(self.deathTimer+260)-self.deathTimer/260)%1>.5 then
                    -- Smooth
                    local movingX,droppingY=0,0
                    if self.moveDir and self.moveCharge<self.settings.das then
                        movingX=15*self.moveDir*(self.moveCharge/self.settings.das-.5)
                    end
                    if self.handY>self.ghostY then
                        droppingY=40*(max(1-self.dropTimer/settings.dropDelay*2.6,0))^2.6
                    end
                    gc.translate(movingX,droppingY)

                    skin.drawHand(CB,self.handX,self.handY)

                    local RS=minoRotSys[settings.rotSys]
                    local minoData=RS[self.hand.shape]
                    local state=minoData[self.hand.direction]
                    local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(self)
                    if centerPos then
                        gc.setColor(1,1,1,.8)
                        GC.mDraw(RS.centerTex,(self.handX+centerPos[1]-1)*40,-(self.handY+centerPos[2]-1)*40,nil,1.26)
                    end
                    gc.translate(-movingX,-droppingY)
                end
            end

            -- Float hold
            if #self.floatHolds>0 then
                for n=1,#self.floatHolds do
                    local H=self.floatHolds[n]
                    skin.drawFloatHold(n,H.hand.matrix,H.handX,H.handY,settings.holdMode=='float' and not settings.infHold and n<=self.holdTime)
                end
            end


            self:triggerEvent('drawBelowMarks')


        gc.translate(0,-self.fieldDived)

        -- Height lines
        skin.drawHeightLines(-- All unit are pixel
            settings.fieldW*40,  -- Field Width
            settings.spawnH*40,  -- Spawning height
            settings.lockoutH*40,-- Lock-out height
            settings.deathH*40,  -- Death height
            settings.voidH*40    -- Void height
        )


        self:triggerEvent('drawInField')


    -- stopFieldStencil
    GC.stc_stop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- popFieldTransform
    gc.pop()

    -- Field border
    skin.drawFieldBorder()

    -- Delay indicator
    if not self.hand then-- Spawn
        skin.drawDelayIndicator(COLOR.lB,self.spawnTimer/settings.spawnDelay)
    elseif self.deathTimer then-- Death
        skin.drawDelayIndicator(COLOR.R,self.deathTimer/settings.deathDelay)
    else-- Lock
        skin.drawDelayIndicator(COLOR.lY,self.lockTimer/settings.lockDelay)
    end

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Lock delay indicator
    skin.drawLockDelayIndicator(settings.freshCondition,self.freshChance)

    -- Next (Almost same as drawing hold(s), don't forget to change both)
    gc.push('transform')
    gc.translate(200,-400)
    skin.drawNextBorder(settings.nextSlot)
    for n=1,min(#self.nextQueue,settings.nextSlot) do
        skin.drawNext(n,self.nextQueue[n].matrix,settings.holdMode=='swap' and not settings.infHold and n<=self.holdTime)
    end
    gc.pop()

    -- Hold (Almost same as drawing next(s), don't forget to change both)
    gc.push('transform')
    gc.translate(-200,-400)
    skin.drawHoldBorder(settings.holdMode,settings.holdSlot)
    if #self.holdQueue>0 then
        for n=1,#self.holdQueue do
            skin.drawHold(n,self.holdQueue[n].matrix,settings.holdMode=='hold' and not settings.infHold and n<=self.holdTime)
        end
    end
    gc.pop()

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<settings.readyDelay then
        skin.drawStartingCounter(settings.readyDelay)
    end

    -- Upside fade out
    gc.setBlendMode('multiply','premultiplied')
    gc.setColorMask(false,false,false,true)
    for i=0,99,2 do
        gc.setColor(0,0,0,(1-i/100)^2)
        gc.rectangle('fill',-200,-422-i,400,-2)
    end
    gc.setBlendMode('alpha')
    gc.setColorMask()

    gc.pop()
end
--------------------------------------------------------------
-- Other
function MP:decodeScript(line,errMsg)
    if line.cmd=='setField' then
    elseif line.cmd=='switchAction' then
    elseif line.cmd=='clearHold' then
        line.arg=nil
    elseif line.cmd=='clearNext' then
        line.arg=nil
    elseif line.cmd=='pushNext' then
        if line.arg:find(",") then
            line.arg=line.arg:split(",")
        else
            assert(not line.arg:find("[^0-9a-zA-Z]"),errMsg.."Wrong arg")
        end
    else
        error(errMsg.."No string command '"..line.cmd.."'")
    end
end
function MP:checkScriptSyntax(cmd,arg,errMsg)
    if cmd=='setField' then
        -- TODO
    elseif cmd=='switchAction' then
        assert(actions[arg],"Invalid action name '"..arg.."'")
    elseif cmd=='clearHold' then
        assert(arg==nil,errMsg.."No arg needed")
    elseif cmd=='clearNext' then
        assert(arg==nil,errMsg.."No arg needed")
    elseif cmd=='pushNext' then
        if type(arg)=='string' then
            -- TODO
        elseif type(arg)=='table' then
            for i=1,#arg do
                assert(Minoes[arg[i]],errMsg.."Invalid mino id '"..arg[i].."'")
            end
        end
    end
end
--------------------------------------------------------------
-- Builder
local baseEnv={
    fieldW=10,-- [WARNING] This is not the real field width, just for generate field object. Change real field size with 'self:changeFieldWidth'
    spawnH=20,
    maxSpawnH=21,
    lockoutH=1e99,
    deathH=1e99,
    voidH=1260,

    nextSlot=6,

    holdSlot=1,
    infHold=false,
    holdMode='hold',
    holdKeepState=false,

    readyDelay=3000,
    dropDelay=1000,
    lockDelay=1000,
    spawnDelay=0,
    clearDelay=0,
    deathDelay=260,

    initialRisingSpeed=1,
    risingAcceleration=.001,
    risingDeceleration=.003,
    maxRisingSpeed=1,
    minRisingSpeed=1,

    actionPack='Normal',
    seqType='bag7',
    rotSys='TRS',
    tuck=false,
    spin_immobile=false,
    spin_corners=false,
    atkSys='none',

    freshCondition='any',
    strictLockout=false,
    freshCount=15,
    maxFreshTime=6200,
    script=false,

    -- Will be overrode with user setting
    das=162,
    arr=26,
    sdarr=12,
    dascut=0,
    skin='mino_plastic',

    shakeness=.26,
}
local seqGenerators={
    none=function() while true do coroutine.yield() end end,
    bag7=function(P)
        local l={}
        while true do
            if not l[1] then for i=1,7 do l[i]=i end end
            coroutine.yield(rem(l,P.seqRND:random(#l)))
        end
    end,
    bag7b1=function(P)
        local l0={}
        local l={}
        while true do
            if not l[1] then
                for i=1,7 do l[i]=i end
                if not l0[1] then for i=1,7 do l0[i]=i end end
                l[8]=rem(l0,P.seqRND:random(#l0))
            end
            coroutine.yield(rem(l,P.seqRND:random(#l)))
        end
    end,
    h4r2=function(P)
        local history=TABLE.new(0,2)
        while true do
            local r
            for _=1,#history do-- Reroll up to [hisLen] times
                r=P.seqRND:random(7)
                local repeated
                for i=1,#history do
                    if r==history[i] then
                        repeated=true
                        break
                    end
                end
                if not repeated then break end-- Not repeated means success, available r value
            end
            rem(history,1)
            ins(history,r)
            if history[1]~=0 then-- Initializing, just continue generating until history is full
                coroutine.yield(r)
            end
        end
    end,
    c2=function(P)
        local weight=TABLE.new(0,7)
        while true do
            local maxK=1
            for i=1,7 do
                weight[i]=weight[i]*.5+P.seqRND:random()
                if weight[i]>weight[maxK] then
                    maxK=i
                end
            end
            weight[maxK]=weight[maxK]/3.5
            coroutine.yield(maxK)
        end
    end,
    random=function(P)
        local r,prev
        while true do
            repeat
                r=P.seqRND:random(7)
            until r~=prev
            prev=r
            coroutine.yield(r)
        end
    end,
    mess=function(P)
        while true do
            coroutine.yield(P.seqRND:random(7))
        end
    end,
}
local soundTimeMeta={
    __index=function(self,k) rawset(self,k,0) return -1e99 end,
    __metatable=true,
}
local soundEventMeta={
    __index=defaultSoundFunc,
    __metatable=true,
}
function MP.new()
    local self=setmetatable({},{__index=MP,__metatable=true})
    self.sound=false
    self.settings=TABLE.copy(baseEnv)
    self.event={
        -- Press & Release
        beforePress={},
        afterPress={},
        beforeRelease={},
        afterRelease={},

        -- Start & End
        playerInit={},
        gameStart={},
        gameOver={},

        -- Drop
        afterSpawn={},
        afterResetPos={},
        afterDrop={},
        afterLock={},
        afterClear={},

        -- Update
        always={},

        -- Graphics
        drawBelowField={},
        drawBelowBlock={},
        drawBelowMarks={},
        drawInField={},
        drawOnPlayer={},
    }
    self.soundEvent=setmetatable({},soundEventMeta)

    return self
end
function MP:initialize()
    self.modeData={}
    self.soundTimeHistory=setmetatable({},soundTimeMeta)

    self.rcvRND=love.math.newRandomGenerator(GAME.seed+434)
    self.seqRND=love.math.newRandomGenerator(GAME.seed+231)

    self.pos={
        x=0,y=0,k=1,a=0,

        dx=0,dy=0,dk=0,da=0,
        vx=0,vy=0,vk=0,va=0,
    }

    self.finished=false -- Did game finish
    self.realTime=0     -- Real time, [float] s
    self.time=0         -- Inside timer for player, [int] ms
    self.gameTime=0     -- Game time of player, [int] ms
    self.timing=false   -- Is gameTime running?

    self.field=require'assets.game.rectField'.new(self.settings.fieldW)
    self.fieldDived=0
    self.fieldRisingSpeed=0

    self.pieceCount=0
    self.combo=0

    self:changeAtkSys(self.settings.atkSys)
    self.garbageBuffer={}

    self.nextQueue={}
    self.seqGen=coroutine.wrap(seqGenerators[self.settings.seqType])
    self:freshNextQueue()

    self.holdQueue={}
    self.holdTime=0
    self.floatHolds={}

    self.dropTimer=0
    self.lockTimer=0
    self.spawnTimer=self.settings.readyDelay
    self.clearTimer=0
    self.deathTimer=false

    self.freshChance=self.settings.freshCount
    self.freshTimeRemain=0

    self.hand=false-- Controlling mino object
    self.handX=false
    self.handY=false
    self.lastMovement=false-- Controlling mino path, for spin/tuck/... checking
    self.ghostY=false
    self.minY=false

    self.moveDir=false
    self.moveCharge=0
    self.downCharge=false

    self.actionHistory={}
    self.keyBuffer={
        move=false,
        rotate=false,
        hold=false,
        hardDrop=false,
    }
    self.dropHistory={}
    self.clearHistory={}
    self.texts=TEXT.new()

    -- Generate available actions
    do
        self.actions={}
        local pack=self.settings.actionPack
        if type(pack)=='string' then
            local p=actionPacks[pack]
            assert(p,STRING.repD("Invalid actionPack '$1'",pack))
            for i=1,#p do
                self.actions[p[i]]=_getActionObj(p[i])
            end
        elseif type(pack)=='table' then
            for k,v in next,pack do
                if type(k)=='number' then
                    self.actions[v]=_getActionObj(v)
                elseif type(k)=='string' then
                    assert(actions[k],STRING.repD("No action named '$1'",k))
                    self.actions[k]=_getActionObj(v)
                else
                    error(STRING.repD("Wrong actionPack table format (type $1)",type(k)))
                end
            end
        else
            error("actionPack must be string or table")
        end

        self.keyState={}
        for k in next,self.actions do
            self.keyState[k]=false
        end
    end

    self:loadScript(self.settings.script)

    self.particles={}
    for k,v in next,particleSystemTemplate do
        self.particles[k]=v:clone()
    end
end
--------------------------------------------------------------

return MP
