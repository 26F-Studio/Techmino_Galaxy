local gc=love.graphics

local max,min=math.max,math.min
local floor,ceil=math.floor,math.ceil
local abs=math.abs
local ins,rem=table.insert,table.remove

local sign,expApproach=MATH.sign,MATH.expApproach
local inst=SFX.playSample
local particleTemplates do
    local p={}
    p.star=gc.newParticleSystem(GC.load{7,7,
        {'setLW',1},
        {'line',0,3.5,6.5,3.5},
        {'line',3.5,0,3.5,6.5},
        {'fRect',2,2,3,3},
    },2600)
    p.star:setSizes(.26,1,.8,.6,.4,.2,0)
    p.star:setSpread(6.2832)
    p.star:setSpeed(0,20)

    local width=80
    local height=240
    local fadeLength=40
    p.trail=gc.newParticleSystem((function()
        local L={width,height}
        for i=1,width/2 do
            ins(L,{'setCL',1,1,1,i/(width/2)})
            ins(L,{'fRect',i,0,1,height})
            ins(L,{'fRect',width-i,0,1,height})
        end
        ins(L,{'setBM','multiply','premultiplied'})
        ins(L,{'setCM',false,false,false,true})
        for i=0,height-1 do
            if i<height-fadeLength then
                ins(L,{'setCL',0,0,0,i/(height-fadeLength)})
            else
                ins(L,{'setCL',0,0,0,(height-i)/fadeLength})
            end
            ins(L,{'fRect',0,i,width,1})
        end
        return GC.load(L)
    end)(),12)
    p.trail:setOffset(width/2,height)
    p.trail:setParticleLifetime(.32)
    p.trail:setColors(
        1,1,1,0.0,
        1,1,1,1.0,
        1,1,1,0.8,
        1,1,1,0.6,
        1,1,1,0.4,
        1,1,1,0.2,
        1,1,1,0.0
    )
    particleTemplates=p
end

local MP={}

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

actions.function1=NULL
actions.function2=NULL
actions.function3=NULL
actions.function4=NULL
actions.function5=NULL
actions.function6=NULL

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
        assert(type(a.press)=='function' and type(a.release)=='function',"wtf why action do not contain func press() & func release()")
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
    classic={
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'softDrop',
    },
    modern={
        'dropLeft',
        'dropRight',
        'zangiLeft',
        'zangiRight',
        'moveLeft',
        'moveRight',
        'rotateCW',
        'rotateCCW',
        'rotate180',
        'softDrop',
        'sonicDrop',
        'hardDrop',
        'holdPiece',
    },
}
--------------------------------------------------------------
-- Effects
function MP:shakeBoard(args,v)
    local shake=self.settings.shakeness
    if args:sArg('-drop') then
        self.pos.vy=self.pos.vy+.2*shake
    elseif args:sArg('-down') then
        self.pos.dy=self.pos.dy+.1*shake
    elseif args:sArg('-right') then
        self.pos.dx=self.pos.dx+.1*shake
    elseif args:sArg('-left') then
        self.pos.dx=self.pos.dx-.1*shake
    elseif args:sArg('-cw') then
        self.pos.va=self.pos.va+.002*shake
    elseif args:sArg('-ccw') then
        self.pos.va=self.pos.va-.002*shake
    elseif args:sArg('-180') then
        self.pos.vy=self.pos.vy+.1*shake
        self.pos.va=self.pos.va+((self.handX+#self.hand.matrix[1]/2-1)/self.settings.fieldW-.5)*.0026*shake
    elseif args:sArg('-clear') then
        self.pos.dk=self.pos.dk*(1+shake)
        self.pos.vk=self.pos.vk+.0002*shake*min(v^1.6,26)
    end
end
--------------------------------------------------------------
-- Game methods
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
    move=               function() SFX.play('move')             end,
    move_failed=        function() SFX.play('move_failed')      end,
    tuck=               function() SFX.play('tuck')             end,
    rotate=             function() SFX.play('rotate')           end,
    initrotate=         function() SFX.play('initrotate')       end,
    rotate_locked=      function() SFX.play('rotate_locked')    end,
    rotate_corners=     function() SFX.play('rotate_corners')   end,
    rotate_failed=      function() SFX.play('rotate_failed')    end,
    rotate_special=     function() SFX.play('rotate_special')   end,
    hold=               function() SFX.play('hold')             end,
    inithold=           function() SFX.play('inithold')         end,
    touch=              function() SFX.play('touch')            end,
    drop=               function() SFX.play('drop')             end,
    lock=               function() SFX.play('lock')             end,
    clear=function(clearHis)
        SFX.play(
            clearHis.line==1 and 'clear_1' or
            clearHis.line==2 and 'clear_2' or
            clearHis.line==3 and 'clear_3' or
            clearHis.line==4 and 'clear_4' or
            'clear_5'
        )
        if clearHis.line>=3 then
            BGM.set('all','highgain',1/clearHis.line,0)
            BGM.set('all','highgain',1,min((clearHis.line)^1.5/5,2.6))
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
        function() inst('bass',.20,'A4') inst('lead','A3') end,-- 11 combo
        function() inst('bass',.40,'A4') inst('lead','C4') end,-- 12 combo
        function() inst('bass',.60,'A4') inst('lead','D4') end,-- 13 combo
        function() inst('bass',.75,'A4') inst('lead','E4') end,-- 14 combo
        function() inst('bass',.90,'A4') inst('lead','G4') end,-- 15 combo
        function() inst('bass',.90,'A4') inst('bass',.90,'E5') inst('lead','A4') end,-- 16 combo
        function() inst('bass',.85,'A4') inst('bass',.85,'E5') inst('lead','C5') end,-- 17 combo
        function() inst('bass',.80,'A4') inst('bass',.80,'E5') inst('lead','D5') end,-- 18 combo
        function() inst('bass',.75,'A4') inst('bass',.75,'E5') inst('lead','E5') end,-- 19 combo
        function() inst('bass',.70,'A4') inst('bass',.70,'E5') inst('lead','G5') end,-- 20 combo
    },{__call=function(self,clearHis)
        local cmb=clearHis.combo
        if self[cmb] then
            self[cmb]()
        else
            inst('bass',.626,'A4')
            local phase=(cmb-21)%12
            inst('lead',1-((11-phase)/12)^2,41+phase)-- E4+
            inst('lead',1-((11-phase)/12)^2,46+phase)-- A4+
            inst('lead',1-(phase/12)^2,     53+phase)-- E5+
            inst('lead',1-(phase/12)^2,     58+phase)-- A5+
        end
    end,__metatable=true}),
    frenzy=             function() SFX.play('frenzy')           end,
    allClear=           function() SFX.play('all_clear')        end,
    halfClear=          function() SFX.play('half_clear')       end,
    suffocate=          function() SFX.play('suffocate')        end,
    desuffocate=        function() SFX.play('desuffocate')      end,
    reach=              function() SFX.play('beep1')            end,
    win=                function() SFX.play('beep1')            end,
    lose=               function() SFX.play('beep2')            end,
}
function MP:playSound(event,...)
    if not self.sound then return end
    if self.time-self.soundTimeHistory[event]>=15 then
        self.soundTimeHistory[event]=self.time
        if self.soundEvent[event] then
            self.soundEvent[event](...)
        else
            MES.new('warn',"Unknown sound event: "..event)
        end
    end
end

function MP:createMoveParticle(x1,y1,x2,y2)
    local p=self.particles.star
    p:setParticleLifetime(.26,.5)
    p:setEmissionArea('none')
    for x=x1,x2,x2>x1 and 1 or -1 do for y=y1,y2,y2>y1 and 1 or -1 do
        p:setPosition(
            -200+(x+math.random()*#self.hand.matrix[1]-1)*40,
            400-(y+math.random()*#self.hand.matrix-1)*40
        )
        p:emit(1)
    end end
end
function MP:createFrenzyParticle(amount)
    local p=self.particles.star
    p:setParticleLifetime(.626,1.6)
    p:setEmissionArea('uniform',200,400,0,true)
    p:setPosition(0,0)
    p:emit(amount)
end
function MP:createLockParticle(x,y)
    local p=self.particles.trail
    p:setPosition(
        -200+(x+#self.hand.matrix[1]/2-1)*40,
        400-(y+#self.hand.matrix/2-1)*40
    )
    p:emit(1)
end

function MP:triggerEvent(name,...)
    local L=self.event[name]
    if L then for i=1,#L do L[i](self,...) end end
end
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
        error('wtf why action is '..tostring(action))
    end

    if self.handX%1~=0 or self.handY%1~=0 then error('EUREKA! Please report this error to developer.') end

    local movement={
        action=action,
        mino=self.hand,
        x=self.handX,y=self.handY,
    }

    if action=='moveX' then
        if
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
            local minoData=RotationSys[self.settings.rotSys][self.hand.shape]
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
        self.deathTimer=false
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
    self:moveHand('reset',floor(self.field:getWidth()/2-#self.hand.matrix[1]/2+1),self.settings.spawnH+1)
    self.minY=self.handY
    self:resetPosCheck()
end
function MP:resetPosCheck()
    local suffocated-- Cancel deathTimer temporarily, or we cannot apply IMS when hold in suffcating
    if self.deathTimer then
        local bufferedDeathTimer=self.deathTimer
        self.deathTimer=false
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
            self:gameover('WA')
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

        self:freshGhost(true)
        self:freshDelay('spawn')
    end

    if self.keyBuffer.rotate then-- IRS
        self:rotate(self.keyBuffer.rotate,true)
        self.keyBuffer.rotate=false
    end
end
function MP:freshGhost(justFreshGhost)
    if self.hand then
        self.ghostY=min(self.field:getHeight()+1,self.handY)

        -- Move ghost to bottom
        while not self:ifoverlap(self.hand.matrix,self.handX,self.ghostY-1) do
            self.ghostY=self.ghostY-1
        end

        if not justFreshGhost then
            if (self.settings.dropDelay<=0 or self.downCharge and self.settings.sdarr==0) and self.ghostY<self.handY then-- if (temp) 20G on
                self:moveHand('drop',self.ghostY-self.handY)
                self:freshDelay('drop')
                self:shakeBoard('-drop')
            else
                self:freshDelay('move')
            end
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
        error("wtf why settings.freshCondition is "..tostring(self.settings.freshCondition))
    end
end
function MP:freshNextQueue()
    while #self.nextQueue<max(self.settings.nextSlot,1) do
        local shapeID=self:seqGen()
        if shapeID and type(shapeID)=='number' then
            self:getMino(shapeID)
        else
            break
        end
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
        self:gameover('ILE')
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
    self.minoCount=self.minoCount+1
    local shape=TABLE.shift(Minos[shapeID].shape)

    -- Generate matrix
    for y=1,#shape do for x=1,#shape[1] do
        if shape[y][x] then
            shape[y][x]={
                minoID=self.minoCount,
                color=defaultMinoColor[shapeID],
                nearby={},
            }-- Should be player's color setting
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
        id=self.minoCount,
        shape=shapeID,
        direction=0,
        name=Minos[shapeID].name,
        matrix=shape,
    }
    mino._origin=TABLE.copy(mino,0)
    ins(self.nextQueue,mino)
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
        self:freshGhost()
        return true
    end
end
function MP:moveRight()
    if not self:ifoverlap(self.hand.matrix,self.handX+1,self.handY) then
        self:moveHand('moveX',1)
        self:freshGhost()
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
    local minoData=RotationSys[self.settings.rotSys][self.hand.shape]
    if dir~='R' and dir~='L' and dir~='F' then error("wtf why dir isn't R/L/F ("..tostring(dir)..")") end

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
                error('cannot get baseX/Y')
            end

            for n=1,#kick.test do
                local ix,iy=self.handX+baseX+kick.test[n][1],self.handY+baseY+kick.test[n][2]
                if not self:ifoverlap(icb,ix,iy) then
                    self.hand.matrix=icb
                    self.hand.direction=kick.target
                    self:moveHand('rotate',ix,iy,dir,ifInit)
                    self:freshGhost()
                    return
                end
            end
            self:freshDelay('rotate')
            self:playSound('rotate_failed')
        else
            error("wtf why no state in minoData")
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
        error("wtf why hold mode is "..tostring(mode))
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
    -- Move down
    if self.handY>self.ghostY then
        self:moveHand('drop',self.ghostY-self.handY)
        self:shakeBoard('-drop')
        self:playSound('drop')
    end
    self:createLockParticle(self.handX,self.handY)
    self:triggerEvent('afterDrop')

    -- Lock to field
    self:lock()
    if self.handY+#self.hand.matrix-1>self.settings.deathH then
        self:gameover('MLE')
        return
    end
    self:playSound('lock')
    self:triggerEvent('afterLock')

    -- Check field
    do
        local M=self.lastMovement
        local text=''
        local spin=M.action=='rotate' and (M.immobile or M.corners)
        M.clear=self:checkField()
        if M.clear then
            self:createFrenzyParticle(M.clear.line*26)
            GAME._addHitWave(.5,.5,M.clear.line)
            local textDuration=M.clear.line/3
            if spin then
                text=Text.spin:repD(M.mino.name).." "
                textDuration=textDuration+.6
            end

            if M.clear.line>=4 and M.clear.combo>1 then
                local lastClear=self.clearHistory[#self.clearHistory-1]
                if lastClear and M.clear.line==lastClear.line then
                    text=text.."M-"
                    textDuration=textDuration+.6
                    self:playSound('frenzy')
                end
            end

            text=text..(Text.clearName[M.clear.line] or ('['..M.clear.line..']'))
            self.texts:add{
                text=text,
                a=.626,
                fontSize=min(M.clear.line-3,0)*10+(spin and 60 or 70),
                style=M.clear.line>=4 and 'stretch' or spin and 'spin' or 'appear',
                duration=textDuration,
            }
            if M.clear.combo>1 then
                self.texts:add{
                    text=Text.combo(M.clear.combo-1),
                    a=.7-.3/(2+M.clear.combo),
                    y=60,
                    fontSize=15+min(M.clear.combo,15)*5,
                }
            end
            if self.field:getHeight()==0 then
                self.texts:add{
                    text=Text.allClear,
                    y=-80,
                    a=.626,
                    fontSize=75,
                    style='flicker',
                    duration=2.5,
                }
                self:playSound('allClear')
            elseif M.y>self.field:getHeight() then
                self.texts:add{
                    text=Text.halfClear,
                    y=-80,
                    a=.8,
                    fontSize=65,
                    style='fly',
                    duration=1.6,
                }
                self:playSound('halfClear')
            end

            self:playSound('combo',M.clear)
            self:playSound('clear',M.clear)

            self:triggerEvent('afterClear',M)
        else
            if M.tuck then
                text=Text.tuck
            elseif spin then
                text=Text.spin:repD(M.mino.name)
            end
            if #text>0 then
                self.texts:add{
                    text=text,
                    y=60,
                    a=.4,
                    duration=.8,
                }
            end
        end
    end

    -- Discard hand
    self.hand=false
    if self.finished then return end

    -- Fresh hand
    self.spawnTimer=self.settings.spawnDelay
    if self.clearTimer<=0 and self.spawnTimer<=0 then
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
        x=self.handX,
        y=self.handY,
    })
end
function MP:checkField()-- Check line clear, top out checking, etc.
    local lineClear={}
    local F=self.field
    for y=F:getHeight(),1,-1 do
        local hasHole
        for x=1,F:getWidth() do
            if not F:getCell(x,y) then
                hasHole=true
                break
            end
        end
        if not hasHole then
            F:removeLine(y)
            ins(lineClear,y)
        end
    end
    if #lineClear>0 then
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
        return h
    else
        self.combo=0
        if self.settings.lockout and self.handY>self.settings.lockoutH then
            self:gameover('CE')
        end
    end
    return false
end
function MP:gameover(reason)
    if self.finished then return end
    self.timing=false
    self.finished=true
    self.hand=false
    self.spawnTimer=1e99

    --[[
        Reason can be:
        AC:  Win
        WA:  Block out
        CE:  Lock out
        MLE: Top out
        TLE: Time out
        OLE: Finesse fault
        ILE: Ran out pieces
        PE:  Mission failed
        RE:  Other reason
    ]]
    self:triggerEvent('gameOver',reason)

    -- <Temporarily>
    MES.new(reason=='AC' and 'check' or 'error',reason,6.26)
    self:playSound(reason=='AC' and 'win' or 'lose')
    -- </Temporarily>
end
--------------------------------------------------------------
-- Press & Release
function MP:press(act)
    self:triggerEvent('beforePress',act)

    if not self.actions[act] or self.keyState[act] then return end
    self.keyState[act]=true
    ins(self.actionHistory,{0,self.time,act})
    self.actions[act].press(self)

    self:triggerEvent('afterPress',act)
end
function MP:release(act)
    self:triggerEvent('beforeRelease',act)
    if not self.actions[act] or not self.keyState[act] then return end
    self.keyState[act]=false
    ins(self.actionHistory,{1,self.time,act})
    self.actions[act].release(self)
    self:triggerEvent('afterRelease',act)
end
--------------------------------------------------------------
-- Update & Render
function MP:update(dt)
    local df=floor((self.realTime+dt)*1000)-floor(self.realTime*1000)
    self.realTime=self.realTime+dt
    local SET=self.settings

    for _=1,df do
        -- Step game time
        if self.timing then self.gameTime=self.gameTime+1--[[df]] end

        -- Calculate board animation
        local O=self.pos
        --                     sticky           force          soft
        O.vx=expApproach(O.vx,0,.02)-sign(O.dx)*.0001*abs(O.dx)^1.2
        O.vy=expApproach(O.vy,0,.02)-sign(O.dy)*.0001*abs(O.dy)^1.1
        O.va=expApproach(O.va,0,.02)-sign(O.da)*.0001*abs(O.da)^1.0
        O.vk=expApproach(O.vk,0,.01)-sign(O.dk)*.0001*abs(O.dk)^1.0
        O.dx=O.dx+O.vx
        O.dy=O.dy+O.vy
        O.da=O.da+O.va
        O.dk=O.dk+O.vk

        -- Step main time & Starting counter
        if self.time<SET.readyDelay then
            self.time=self.time+1--[[df]]
            local d=SET.readyDelay-self.time
            if floor((d+1--[[df]])/1000)~=floor(d/1000) then
                self:playSound('countDown',ceil(d/1000))
            end
            if d==0 then
                self:playSound('countDown',0)
                self:triggerEvent('gameStart')
                self.timing=true
            end
        else
            self.time=self.time+1--[[df]]
        end

        if not self.deathTimer then
            -- Auto shift
            if self.moveDir and (self.moveDir==-1 and self.keyState.moveLeft or self.moveDir==1 and self.keyState.moveRight) then
                if self.hand and not self:ifoverlap(self.hand.matrix,self.handX+self.moveDir,self.handY) then
                    local c0=self.moveCharge
                    local c1=c0+1--[[df]]
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
                    local c1=c0+1--[[df]]
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
                    self.clearTimer=self.clearTimer-1--[[df]]
                    break
                end

                -- Try spawn mino if don't have one
                if self.spawnTimer>0 then
                    self.spawnTimer=self.spawnTimer-1--[[df]]
                    if self.spawnTimer<=0 then
                        self:popNext()
                    end
                    break
                elseif not self.hand then
                    self:popNext()
                end

                -- Try lock/drop mino
                if self.handY==self.ghostY then
                    self.lockTimer=self.lockTimer-1--[[df]]
                    if self.lockTimer<=0 then
                        self:minoDropped()
                    end
                    break
                else
                    if self.dropDelay~=0 then
                        self.dropTimer=self.dropTimer-1--[[df]]
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
                self:gameover('WA')
            end
        end

        self:triggerEvent('always',1--[[df]])
    end
    for _,v in next,self.particles do v:update(dt) end
    self.texts:update(dt)
end
function MP:render()
    local settings=self.settings
    local skin=SKIN.get(settings.skin)
    skin.setTime(self.time)

    gc.push('transform')

    -- applyPlayerTransform
    gc.setCanvas({Zenitha.getBigCanvas('player'),stencil=true})
    gc.clear(1,1,1,0)
    gc.translate(self.pos.x+self.pos.dx,self.pos.y+self.pos.dy)
    gc.scale(self.pos.k*(1+self.pos.dk))
    gc.rotate(self.pos.a+self.pos.da)

    -- applyFieldTransform
    gc.push('transform')
    gc.translate(-200,400)
    GC.stc_setComp('equal',1)
    GC.stc_rect(0,0,400,-920)
    gc.scale(10/settings.fieldW)


    self:triggerEvent('drawBelowField')


    -- Grid & Cells
    skin.drawFieldGrid(settings.fieldW,min(max(settings.spawnH,settings.lockoutH,settings.deathH),2*settings.fieldW))
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
            local droppingY
            if self.handY>self.ghostY then
                droppingY=40*(max(1-self.dropTimer/settings.dropDelay*2.6,0))^2.6
                gc.translate(0,droppingY)
            end

            skin.drawHand(CB,self.handX,self.handY)

            local RS=RotationSys[settings.rotSys]
            local minoData=RS[self.hand.shape]
            local state=minoData[self.hand.direction]
            local centerPos=state and state.center or type(minoData.center)=='function' and minoData.center(self)
            if centerPos then
                gc.setColor(1,1,1)
                GC.draw(RS.centerTex,(self.handX+centerPos[1]-1)*40,-(self.handY+centerPos[2]-1)*40)
            end
            if droppingY then gc.translate(0,-droppingY) end
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


    -- Height lines
    skin.drawHeightLines(
        settings.fieldW*40,  -- (pixels) Field Width
        settings.spawnH*40,  -- (pixels) Spawning height
        settings.lockoutH*40,-- (pixels) lock-out height
        settings.deathH*40,  -- (pixels) Death height
        1260                 -- (pixels) Void height
    )


    self:triggerEvent('drawInField')


    -- popFieldTransform
    GC.stc_stop()
    gc.pop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- Field border
    skin.drawFieldBorder()

    -- Delay indicator
    if not self.hand then
        skin.drawDelayIndicator('spawn',self.spawnTimer/settings.spawnDelay)
    elseif self.deathTimer then
        skin.drawDelayIndicator('death',self.deathTimer/settings.deathDelay)
    elseif self.handY~=self.ghostY then
        skin.drawDelayIndicator('drop',self.dropTimer/settings.dropDelay)
    else
        skin.drawDelayIndicator('lock',self.lockTimer/settings.lockDelay)
    end

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
    gc.setCanvas()

    gc.pop()
end
--------------------------------------------------------------
-- Other methods
function MP:setPosition(x,y,k,a)
    self.pos.x=x or self.pos.x
    self.pos.y=y or self.pos.y
    self.pos.k=k or self.pos.k
    self.pos.a=a or self.pos.a
end
function MP:movePosition(dx,dy,k,da)
    self.pos.x=self.pos.x+(dx or 0)
    self.pos.y=self.pos.y+(dy or 0)
    self.pos.k=self.pos.k*(k or 1)
    self.pos.a=self.pos.a+(da or 0)
end
--------------------------------------------------------------
-- Builder
local baseEnv={-- Generate from template in future
    fieldW=10,-- [WARNING] This is not the real field width, just for generate field object. If really want change it, you need change both 'self.field._width' and 'self.field._matrix'
    spawnH=20,-- [WARNING] This can be changed anytime. Field object actually do not contain height information
    lockoutH=1e99,
    deathH=1e99,
    barrierL=18,
    barrierH=21,

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

    actionPack='modern',
    seqType='bag7',
    rotSys='TRS',
    spin_immobile=true,
    spin_corners=3,

    freshCondition='any',
    freshCount=15,
    maxFreshTime=6200,

    -- Will be overrode with user setting
    das=162,
    arr=26,
    sdarr=12,
    skin='default',

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
local modeDataMeta={
    __index=function(self,k) rawset(self,k,0) return 0 end,
    __newindex=function(self,k,v) rawset(self,k,v) end,
    __metatable=true,
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

    return self
end
function MP:loadSettings(settings)
    -- Load data & events from mode settings
    for k,v in next,settings do
        if k=='event' then
            for name,E in next,v do
                assert(self.event[name],"Wrong event key: '"..tostring(name).."'")
                if type(E)=='table' then
                    for i=1,#E do
                        ins(self.event[name],E[i])
                    end
                elseif type(E)=='function' then
                    ins(self.event[name],E)
                end
            end
        elseif k=='soundEvent' then
            for name,E in next,v do
                if type(E)=='function' then
                    self.soundEvent[name]=E
                else
                    error("soundEvent must be function")
                end
            end
        else
            if type(v)=='table' then
                self.settings[k]=TABLE.copy(v)
            elseif v~=nil then
                self.settings[k]=v
            end
        end
    end
end
function MP:initialize()
    self.soundEvent=setmetatable({},soundEventMeta)
    self.modeData=setmetatable({},modeDataMeta)
    self.soundTimeHistory=setmetatable({},soundTimeMeta)

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

    self.field=require'assets.game.minoField'.new(self.settings.fieldW,self.settings.spawnH)

    self.minoCount=0
    self.combo=0

    self.garbageBuffer={}

    self.nextQueue={}
    self.seqRND=love.math.newRandomGenerator(GAME.seed)
    self.seqGen=coroutine.wrap(seqGenerators[self.settings.seqType])
    self:freshNextQueue()

    self.holdQueue={}
    self.holdTime=0
    self.floatHolds={}

    self.energy=0
    self.energyShow=0

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
            pack=actionPacks[pack]
            assert(pack,STRING.repD("Invalid actionPack '$1'",pack))
            for i=1,#pack do
                self.actions[pack[i]]=_getActionObj(pack[i])
            end
        elseif type(pack)=='table' then
            for k,v in next,pack do
                if type(k)=='number' then
                    self.actions[v]=_getActionObj(v)
                elseif type(k)=='string' then
                    assert(actions[k],STRING.repD("newMinoPlayer: no action called '$1'",k))
                    self.actions[k]=_getActionObj(v)
                else
                    error(STRING.repD("newMinoPlayer: wrong actionPack table format (type $1)",type(k)))
                end
            end
        else
            error("newMinoPlayer: actionPack must be string or table")
        end

        self.keyState={}
        for k in next,self.actions do
            self.keyState[k]=false
        end
    end

    self.particles={}
    for k,v in next,particleTemplates do
        self.particles[k]=v:clone()
    end
end
--------------------------------------------------------------

return MP
