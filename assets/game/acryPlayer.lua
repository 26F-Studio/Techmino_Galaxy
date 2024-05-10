local require=simpRequire('assets.game.')

local gc=love.graphics
local gc_push,gc_pop=gc.push,gc.pop
local gc_translate,gc_scale,gc_rotate=gc.translate,gc.scale,gc.rotate
local gc_setColor=gc.setColor
local gc_draw=gc.draw


local max,min=math.max,math.min
local floor=math.floor
local ins,rem=table.insert,table.remove

---@class Techmino.Player.Acry: Techmino.Player
---@field field (Techmino.Acry.Cell|false)[][]
local AP=setmetatable({},{__index=require'basePlayer',__metatable=true})

---@class Techmino.Acry.Cell
---@field color number 1~7
---@field type 'acry'|'cube'
---@field appearance 'flame'|'star'|'nova'
---@field destroyed {mode:'explosion'|'lightning'|'color', radius:number}
---@field movable boolean
---
---@field needCheck boolean
---@field clearTimer number
---@field clearDelay number Set when enter clearing state
---@field moveTimer number
---@field moveDelay number
---@field dx number
---@field dy number
---@field fall boolean
---
---@field lrCnt number Left/Right connecting length
---@field udCnt number Up/Down connecting length
---@field riseCnt number BL/UR (rising diagonal) connecting length (when enabled)
---@field dropCnt number UL/BR (dropping diagonal) connecting length (when enabled)
---
---@field moved function
---@field aftermove function
---@field generate? Techmino.Acry.Cell

--------------------------------------------------------------
-- Function tables

local defaultSoundFunc={
    countDown=      countDownSound,
    move=           function() FMOD.effect('move')          end,
    move_failed=    function() FMOD.effect('move_failed')   end,
    swap=           function() FMOD.effect('rotate')        end,
    swap_failed=    function() FMOD.effect('tuck')          end,
    twist=          function() FMOD.effect('rotate')        end,
    twist_failed=   function() FMOD.effect('tuck')          end,
    move_back=      function() FMOD.effect('rotate_failed') end,
    touch=          function() FMOD.effect('lock')          end,
    clear=function(lines)
        FMOD.effect(
            lines==1 and 'clear_1' or
            lines==2 and 'clear_2' or
            lines==3 and 'clear_3' or
            lines==4 and 'clear_4' or
            'clear_5'
        )
    end,
    combo=       function() end,
    chain=       function() end,
    win=         function() FMOD.effect('win')         end,
    fail=        function() FMOD.effect('fail')        end,
}
---@type Map<fun(P:Techmino.Player.Acry):any>
AP.scriptCmd={
}

--------------------------------------------------------------
-- Actions

AP._actions={}
for k,v in next,mechLib.acry.actions do AP._actions[k]=AP:_getActionObj(v) end

--------------------------------------------------------------
-- Effects

--------------------------------------------------------------
-- Game methods

function AP:printField() -- For debugging
    local F=self.field
    print('----------')
    for y=self.settings.fieldSize,1,-1 do
        local s="|"
        for x=1,self.settings.fieldSize do
            s=s..(F[y][x] and 'X' or '.')
        end
        print(s.."|")
    end
end
function AP:isMovable(x,y)
    if x>=1 and x<=self.settings.fieldSize and y>=1 and y<=self.settings.fieldSize then
        local F=self.field
        if F[y][x] then
            return F[y][x].movable
        else
            return true
        end
    else
        return false
    end
end
function AP:getAcry(data)
    local G={
        type='acry',
        movable=true,
    }
    if data then TABLE.cover(data,G) end
    return G
end
function AP:setMoveBias(mode,C,dx,dy)
    if not C then return end
    C.needCheck=nil
    C.movable=false
    C.dx=(C.dx or 0)+dx
    C.dy=(C.dy or 0)+dy
    if mode=='fall' then
        C.fall=true
        C.moveTimer=(C.moveTimer or 0)+floor(self.settings.fallDelay*dy^.5)
        C.moveDelay=(C.moveDelay or 0)+floor(self.settings.fallDelay*dy^.5)
    else
        C.moveTimer=self.settings.moveDelay
        C.moveDelay=self.settings.moveDelay
    end
end
function AP:erasePosition(x,y,src)
    local F=self.field
    if F[y] then
        local g=F[y][x]
        if g then
            F[y][x]=false
            if g.destroyed then
                local D=g.destroyed
                if D.mode=='explosion' then
                    for ey=y-D.radius,y+D.radius do for ex=x-D.radius,x+D.radius do
                        self:erasePosition(ex,ey,g)
                    end end
                elseif D.mode=='lightning' then
                    for ey=y-D.radius,y+D.radius do for ex=1,self.settings.fieldSize do
                        self:erasePosition(ex,ey,g)
                    end end
                    for ey=1,self.settings.fieldSize do for ex=x-D.radius,x+D.radius do
                        self:erasePosition(ex,ey,g)
                    end end
                elseif D.mode=='color' then
                    for ey=1,self.settings.fieldSize do for ex=1,self.settings.fieldSize do
                        if not src.color or F[ey][ex] and F[ey][ex].color==src.color then
                            self:erasePosition(ex,ey,g)
                        end
                    end end
                else
                    error("Wrong destroy event mode")
                end
            end
            if g.generate then
                ins(self.generateBuffer,{
                    x=x,y=y,
                    acry=g.generate,
                })
            end
        end
    end
end
function AP:swap(mode,x,y,dx,dy)
    local F=self.field
    if
        self:isMovable(x,y) and self:isMovable(x+dx,y+dy)
    then
        self:setMoveBias('swap',F[y][x],-dx,-dy)
        self:setMoveBias('swap',F[y+dy][x+dx],dx,dy)
        F[y][x],F[y+dy][x+dx]=F[y+dy][x+dx],F[y][x]
        if mode=='action' then
            ins(self.movingGroups,{
                mode='swap',
                force=self.settings.swapForce,
                args={x,y,dx,dy},
                positions={x,y,x+dx,y+dy},
            })

            self:triggerEvent('legalMove','swap')

            self:playSound('swap')
        elseif mode=='auto' then
            self:playSound('move_back')
        end
    else
        self:playSound('swap_failed')
    end
    self:freshSwapCursor()
end
function AP:twist(mode,x,y,dir)
    local F=self.field
    if
        self:isMovable(x,y) and
        self:isMovable(x,y+1) and
        self:isMovable(x+1,y+1) and
        self:isMovable(x+1,y)
    then
        if dir=='R' then
            self:setMoveBias('twist',F[y][x],0,-1)
            self:setMoveBias('twist',F[y][x+1],1,0)
            self:setMoveBias('twist',F[y+1][x+1],0,1)
            self:setMoveBias('twist',F[y+1][x],-1,0)
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y][x+1],F[y+1][x+1],F[y+1][x],F[y][x]
        elseif dir=='L' then
            self:setMoveBias('twist',F[y][x],-1,0)
            self:setMoveBias('twist',F[y][x+1],0,-1)
            self:setMoveBias('twist',F[y+1][x+1],1,0)
            self:setMoveBias('twist',F[y+1][x],0,1)
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y+1][x],F[y][x],F[y][x+1],F[y+1][x+1]
        elseif dir=='F' then
            self:setMoveBias('twist',F[y][x],-1,-1)
            self:setMoveBias('twist',F[y][x+1],1,-1)
            self:setMoveBias('twist',F[y+1][x+1],1,1)
            self:setMoveBias('twist',F[y+1][x],-1,1)
            F[y][x],F[y][x+1],F[y+1][x+1],F[y+1][x]=F[y+1][x+1],F[y+1][x],F[y][x],F[y][x+1]
        end
        if mode=='action' then
            ins(self.movingGroups,{
                mode='twist',
                force=self.settings.twistForce,
                args={x,y,dir=='R' and 'L' or dir=='L' and 'R' or 'F'},
                positions={x,y,x+1,y,x+1,y+1,x,y+1},
            })
            self:playSound('twist')

            self:triggerEvent('legalMove','twist')

        elseif mode=='auto' then
            self:playSound('move_back')
        end
    else
        self:playSound('twist_failed')
    end
end
local function linkLen(F,color,x,y,dx,dy)
    local cnt=0
    x,y=x+dx,y+dy
    while true do
        local G=F[y] and F[y][x]
        if G and G.color and G.color==color and G.movable then
            x,y=x+dx,y+dy
            cnt=cnt+1
        else
            break
        end
    end
    return cnt
end
---Check if a position can be activated
function AP:psedoCheckPos(x,y)
    local F=self.field
    if not F[y][x] then return end
    local color=F[y][x].color
    if not F[y][x].lrCnt   and 1+linkLen(F,color,x,y,-1,0)+ linkLen(F,color,x,y,1,0) >=self.settings.linkLen then return true end
    if not F[y][x].udCnt   and 1+linkLen(F,color,x,y,0,-1)+ linkLen(F,color,x,y,0,1) >=self.settings.linkLen then return true end
    if not self.settings.diagonalLinkLen then return false end
    if not F[y][x].riseCnt and 1+linkLen(F,color,x,y,-1,-1)+linkLen(F,color,x,y,1,1) >=self.settings.diagonalLinkLen then return true end
    if not F[y][x].dropCnt and 1+linkLen(F,color,x,y,-1,1)+ linkLen(F,color,x,y,1,-1)>=self.settings.diagonalLinkLen then return true end
    return false
end
function AP:setClear(g,linkMode,len)
    g.movable=false
    g.clearTimer=g.immediately and 0 or self.settings.clearDelay
    g.clearDelay=self.settings.clearDelay
    g[linkMode]=len
end
function AP:setGenerate(g,gen)
    g.immediately=true
    g.clearTimer=0
    g.generate=self:getAcry(gen)
end
function AP:checkPosition(x,y)
    local F=self.field
    if not F[y][x] then return end

    local g=F[y][x]
    local color=g.color

    local line=0

    if not g.lrCnt then
        local stepX,stepY=1,0
        local l=linkLen(F,color,x,y,-stepX,-stepY)
        local r=linkLen(F,color,x,y,stepX,stepY)
        local len=1+l+r
        if len>=self.settings.linkLen then
            for i=-l,r do
                local cx,cy=x+stepX*i,y+stepY*i
                local gi=F[cy] and F[cy][cx]
                if gi then
                    self:setClear(gi,'lrCnt',len)
                end
            end
            line=line+1
        end
    end
    if not g.udCnt then
        local stepX,stepY=0,1
        local l=linkLen(F,color,x,y,-stepX,-stepY)
        local r=linkLen(F,color,x,y,stepX,stepY)
        local len=1+l+r
        if len>=self.settings.linkLen then
            for i=-l,r do
                local cx,cy=x+stepX*i,y+stepY*i
                local gi=F[cy] and F[cy][cx]
                if gi then
                    self:setClear(gi,'udCnt',len)
                end
            end
            line=line+1
        end
    end
    if self.settings.diagonalLinkLen then
        if not g.riseCnt then
            local stepX,stepY=1,1
            local l=linkLen(F,color,x,y,-stepX,-stepY)
            local r=linkLen(F,color,x,y,stepX,stepY)
            local len=1+l+r
            if len>=self.settings.diagonalLinkLen then
                for i=-l,r do
                    local cx,cy=x+stepX*i,y+stepY*i
                    local gi=F[cy] and F[cy][cx]
                    if gi then
                        self:setClear(gi,'riseCnt',len)
                    end
                end
                line=line+1
            end
        end
        if not g.dropCnt then
            local stepX,stepY=1,-1
            local l=linkLen(F,color,x,y,-stepX,-stepY)
            local r=linkLen(F,color,x,y,stepX,stepY)
            local len=1+l+r
            if len>=self.settings.diagonalLinkLen then
                for i=-l,r do
                    local cx,cy=x+stepX*i,y+stepY*i
                    local gi=F[cy] and F[cy][cx]
                    if gi then
                        self:setClear(gi,'dropCnt',len)
                    end
                end
                line=line+1
            end
        end
    end

    if g.clearTimer then
        local lineCount=0
        local maxLen=0
        if g.lrCnt   then lineCount=lineCount+1 maxLen=max(maxLen,g.lrCnt)   end
        if g.udCnt   then lineCount=lineCount+1 maxLen=max(maxLen,g.udCnt)   end
        if g.riseCnt then lineCount=lineCount+1 maxLen=max(maxLen,g.riseCnt) end
        if g.dropCnt then lineCount=lineCount+1 maxLen=max(maxLen,g.dropCnt) end
        if maxLen>3 then
            if maxLen==4 then
                self:setGenerate(g,{
                    color=g.color,
                    appearance='flame',
                    immediately=true,
                    destroyed={
                        mode='explosion',
                        radius=1,
                    }
                })
            elseif maxLen==5 then
                self:setGenerate(g,{
                    type='cube',
                    moved='destroy',
                    destroyed={
                        mode='color',
                    }
                })
            else
                self:setGenerate(g,{
                    color=g.color,
                    appearance='nova',
                    destroyed={
                        mode='lightning',
                        radius=1,
                    }
                })
            end
        else
            if lineCount>1 then
                self:setGenerate(g,{
                    color=g.color,
                    appearance='star',
                    destroyed={
                        mode='lightning',
                        radius=0,
                    }
                })
            end
        end
    end

    if line>0 then
        self:playSound('clear',line)
    end
end
function AP:freshAcry()
    local newAcry={}
    local F=self.field
    for x=1,self.settings.fieldSize do
        -- Drag acry down
        for y=1,self.settings.fieldSize do
            -- F[y][x] is a hole
            if not F[y][x] then
                -- Find a acry above the hole
                for gY=y+1,self.settings.fieldSize do
                    if F[gY][x] then
                        -- Move it if it's movable
                        if self:isMovable(x,gY) then
                            F[y][x],F[gY][x]=F[gY][x],false
                            self:setMoveBias('fall',F[y][x],0,gY-y)
                        end
                        break
                    end
                end
            end
        end

        -- Fill holes with new acry
        local lowestHole=9
        for y=1,self.settings.fieldSize do
            if not F[y][x] then
                lowestHole=y
                break
            end
        end
        for y=lowestHole,self.settings.fieldSize do
            local g=self:getAcry()
            self:setMoveBias('fall',g,0,9-lowestHole)
            ins(newAcry,g)
            F[y][x]=g
        end
    end
    local freshTimes=0
    repeat
        for i=1,#newAcry do
            local g=newAcry[i]
            g.color=self:random(self.settings.colors)
        end
        freshTimes=freshTimes+1
    until freshTimes>=self.settings.refreshCount or self:hasMove()
end
function AP:hasMove()
    return true
end
function AP:changeFieldSize(w,h,origX,origY)
end
function AP:receive(data)
    local B={
        power=data.power,
        cancelRate=data.cancelRate,
        defendRate=data.defendRate,
        mode=data.mode,
        time=floor(data.time+.5),
        _time=0,
        fatal=data.fatal,
        speed=data.speed,
    }
    ins(self.garbageBuffer,B)
end
function AP:getScriptValue(arg)
    return
        arg.d=='field_size' and self.settings.fieldSize or
        arg.d=='cell' and (self.field[arg.y][arg.x] and 1 or 0)
end

--------------------------------------------------------------
-- Press & Release & Update & Render

function AP:getMousePos(x,y)
    local pos=self.pos
    x,y=((x-pos.x)/pos.k/360+1)/2,((pos.y-y)/pos.k/360+1)/2
    if x>=0 and x<1 and y>=0 and y<1 then
        return x,y
    else
        return false,false
    end
end
function AP:getSwapPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+1),floor(y*size+1)
    if x>=1 and x<=size and y>=1 and y<=size then return x,y end
end
function AP:freshSwapCursor()
    self.swapLock=false
    if self.mouseX then
        local sx,sy=self:getSwapPos(self.mouseX,self.mouseY)
        if sx and (self.swapX~=sx or self.swapY~=sy) then
            self.swapX,self.swapY=sx,sy
        end
    end
end
function AP:getTwistPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+.5),floor(y*size+.5)
    if x>=1 and x<=size-1 and y>=1 and y<=size-1 then return x,y end
end
function AP:freshTwistCursor()
    if self.mouseX then
        local tx,ty=self:getTwistPos(self.mouseX,self.mouseY)
        if tx and (self.twistX~=tx or self.twistY~=ty) then
            self.twistX,self.twistY=tx,ty
        end
    end
end
function AP:mouseDown(x,y,id)
    if id==2 then
        if self.swapLock then
            self:freshSwapCursor()
        end
    else
        self:mouseMove(x,y,0,0,id)
        self.mousePressed=true
        if self.swapLock then
            local mx,my=self:getMousePos(x,y)
            if mx then
                local sx,sy=self:getSwapPos(mx,my)
                if sx==self.swapX and math.abs(sy-self.swapY)==1 or sy==self.swapY and math.abs(sx-self.swapX)==1 then
                    if self.settings.multiMove or #self.movingGroups==0 then
                        self:swap('action',self.swapX,self.swapY,sx-self.swapX,sy-self.swapY)
                    end
                else
                    if sx==self.swapX and sy==self.swapY then
                        self.swapLock=false
                    else
                        self.swapX,self.swapY=sx,sy
                    end
                end
            end
        else
            self.swapLock=true
        end
    end
end
function AP:mouseMove(x,y,_,_,_)
    self.mouseX,self.mouseY=self:getMousePos(x,y)

    if self.mouseX then
        if self.swapLock then
            if self.mousePressed then
                local sx,sy=self:getSwapPos(self.mouseX,self.mouseY)
                if not (sx==self.swapX and sy==self.swapY) then
                    if
                        (
                            sx==self.swapX and math.abs(sy-self.swapY)==1 or
                            sy==self.swapY and math.abs(sx-self.swapX)==1
                        ) and (self.settings.multiMove or #self.movingGroups==0) then
                        self:swap('action',self.swapX,self.swapY,sx-self.swapX,sy-self.swapY)
                    else
                        self:freshSwapCursor()
                    end
                end
            end
        else
            self:freshSwapCursor()
        end
        self:freshTwistCursor()
    end
end
function AP:mouseUp(_,_,_)
    self.mousePressed=false
end
function AP:updateFrame()
    local SET=self.settings

    -- Auto shift
    if self.moveDirH and (self.moveDirH==-1 and self.keyState.moveLeft or self.moveDirH==1 and self.keyState.moveRight) then
        if self.swapX~=MATH.clamp(self.swapX+self.moveDirH,1,self.settings.fieldSize) then
            self.moveChargeH=self.moveChargeH+1
            local dist=0
            if self.moveChargeH>=SET.asd then
                if SET.asp==0 then
                    dist=1e99
                elseif (self.moveChargeH-SET.asd)%SET.asp==0 then
                    dist=1
                end
            end
            if dist>0 then
                local moved
                local x0=self.swapX
                self.swapX=MATH.clamp(self.swapX+self.moveDirH*dist,1,self.settings.fieldSize)
                if self.swapX~=x0 then moved=true end
                x0=self.twistX
                self.twistX=MATH.clamp(self.twistX+self.moveDirH*dist,1,self.settings.fieldSize-1)
                if self.twistX~=x0 then moved=true end
                if moved then self:playSound('move') end
            end
        else
            self.moveChargeH=SET.asd
            self:shakeBoard(self.moveDirH>0 and '-right' or '-left')
        end
    else
        self.moveDirH=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
        self.moveChargeH=0
    end
    if self.moveDirV and (self.moveDirV==-1 and self.keyState.moveDown or self.moveDirV==1 and self.keyState.moveUp) then
        if self.swapY~=MATH.clamp(self.swapY+self.moveDirV,1,self.settings.fieldSize) then
            self.moveChargeV=self.moveChargeV+1
            local dist=0
            if self.moveChargeV>=SET.asd then
                if SET.asp==0 then
                    dist=1e99
                elseif (self.moveChargeV-SET.asd)%SET.asp==0 then
                    dist=1
                end
            end
            if dist>0 then
                local moved
                local x0=self.swapY
                self.swapY=MATH.clamp(self.swapY+self.moveDirV*dist,1,self.settings.fieldSize)
                if self.swapY~=x0 then moved=true end
                x0=self.twistY
                self.twistY=MATH.clamp(self.twistY+self.moveDirV*dist,1,self.settings.fieldSize-1)
                if self.twistY~=x0 then moved=true end
                if moved then self:playSound('move') end
            end
        else
            self.moveChargeV=SET.asd
            self:shakeBoard(self.moveDirV>0 and '-up' or '-down')
        end
    else
        self.moveDirV=self.keyState.moveDown and -1 or self.keyState.moveUp and 1 or false
        self.moveChargeV=0
    end

    local F=self.field
    local size=self.settings.fieldSize
    local needFresh=false
    local touch

    -- Update moveTimer
    for y=1,size do for x=1,size do local g=F[y][x] if g and g.moveTimer then
        g.moveTimer=g.moveTimer-1
        if g.moveTimer<=0 then
            g.moveTimer,g.moveDelay=nil
            g.dx,g.dy=nil
            g.movable=true
            g.needCheck=true
            needFresh=true
            if g.fall then
                g.fall=nil
                touch=true
            end
        end
    end end end

    -- Update movingGroups (check auto-move-back)
    for i=#self.movingGroups,1,-1 do
        local group=self.movingGroups[i]
        local fin
        local leagl=false
        local posList=group.positions
        for n=1,#posList,2 do
            ---@type Techmino.Acry.Cell
            local g=F[posList[n+1]][posList[n]]
            if g.movable then
                fin=true
                if self:psedoCheckPos(posList[n],posList[n+1]) then
                    leagl=true
                end
            end
        end
        if fin then
            if group.force and not leagl then
                self[group.mode](self,'auto',unpack(group.args))

                self:triggerEvent('illegalMove',group.mode)

            elseif leagl then

                self:triggerEvent('legalMove',group.mode)

            end
            rem(self.movingGroups,i)
        end
    end

    if touch then self:playSound('touch') end

    -- Update needCheck
    for y=1,size do for x=1,size do local g=F[y][x] if g and g.needCheck then
        g.needCheck=nil
        self:checkPosition(x,y)
    end end end

    -- Update clearTimer
    for y=1,size do for x=1,size do local g=F[y][x] if g and g.clearTimer then
        g.clearTimer=g.clearTimer-1
        if g.clearTimer<=0 then
            g.clearTimer=nil
            self:erasePosition(x,y,g)
            needFresh=true
        end
    end end end

    -- Update movingGroups (check deestroyed)
    for i=#self.movingGroups,1,-1 do
        local group=self.movingGroups[i]
        local posList=group.positions
        for n=1,#posList,2 do
            local g=F[posList[n+1]][posList[n]]
            if not g then
                for n2=1,#posList,2 do
                    local g2=F[posList[n2+1]][posList[n2]]
                    if g2 then
                        g2.moveTimer=0
                    end
                end
                break
            end
        end
    end

    -- Check generations
    while #self.generateBuffer>0 do
        local gen=rem(self.generateBuffer,1)
        F[gen.y][gen.x]=gen.acry
    end

    if needFresh then
        self:freshAcry()
    end

    -- Update garbage
    for i=1,#self.garbageBuffer do
        local g=self.garbageBuffer[i]
        if g.mode==0 and g._time<g.time then
            g._time=g._time+1
        end
    end
end
function AP:render()
    local SET=self.settings
    local skin=SKIN.get(SET.skin)
    SKIN.time=self.time

    gc_push('transform')

    -- Player's transform
    local pos=self.pos
    gc_translate(pos.x,pos.y)
    gc_scale(pos.k*(1+pos.dk))
    gc_translate(pos.dx,pos.dy)
    gc_rotate(pos.a+pos.da)

    -- Field's transform
    gc_push('transform')

        gc_translate(-360,360)

        -- Start field stencil
        GC.stc_setComp()
        GC.stc_rect(0,0,720,-720)
        gc_scale(16/SET.fieldSize)

            self:triggerEvent('drawBelowField') -- From frame's bottom-left, 40px a cell

            -- Grid & Cells
            skin.drawFieldBackground(SET.fieldSize)
            local F=self.field
            for y=1,#F do for x=1,#F[1] do
                local C=F[y][x]
                if C then
                    skin.drawFieldCell(C,F,(x-1)*40+2,-y*40+2)
                end
            end end

            self:triggerEvent('drawInField') -- From frame's bottom-left, 40px a cell

        -- Stop field stencil
        GC.stc_stop()

        -- Particles
        gc_setColor(1,1,1)
        gc_draw(self.particles.star)
        gc_draw(self.particles.trail)

        -- Cursor(s)
        if self.settings.swap then
            skin.drawSwapCursor(self.swapX,self.swapY,self.swapLock)
        end
        if self.settings.twistR then
            skin.drawTwistCursor(self.twistX,self.twistY)
        end

    gc_pop()

    -- Field border
    skin.drawFieldBorder()

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()

    self:triggerEvent('drawOnPlayer') -- From player's center

    -- Starting counter
    if self.time<SET.readyDelay then
        skin.drawStartingCounter(SET.readyDelay)
    end

    gc_pop()
end

--------------------------------------------------------------
-- Other

function AP:decodeScript(line,errMsg)
    -- TODO
    -- error(errMsg.."No string command '"..cmd.."'")
end
function AP:checkScriptSyntax(cmd,arg,errMsg)
    -- TODO
end

--------------------------------------------------------------
-- Builder

---@class Techmino.Mode.Setting.Acry
local baseEnv={
    -- Size
    fieldSize=8,

    -- "Sequence"
    colors=7,
    linkLen=3,
    diagonalLinkLen=false,
    refreshCount=0,

    -- Delay
    readyDelay=3000,
    moveDelay=300,
    clearDelay=500,
    fallDelay=200,

    -- Attack
    atkSys='none',
    multiMove=true,
    swap=true,
    swapForce=true,
    twistR=false,twistL=false,twistF=false,
    twistForce=false,

    -- Other
    script=false,

    -- May be overrode with user setting
    skin='acry_template',
    shakeness=.26,
    inputDelay=0,
}
local soundEventMeta={
    __index=defaultSoundFunc,
    __metatable=true,
}
function AP.new()
    local self=setmetatable(require'basePlayer'.new(),{__index=AP,__metatable=true})
    ---@type Techmino.Mode.Setting.Acry
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
        legalMove={},
        illegalMove={},

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
function AP:initialize()
    require'basePlayer'.initialize(self)

    self.field={}
    for y=1,self.settings.fieldSize do
        self.field[y]=TABLE.new(false,self.settings.fieldSize)
    end
    self:freshAcry()

    self.movingGroups={}
    self.generateBuffer={}

    self.mouseX,self.mouseY=false,false
    self.mousePressed=false
    self.swapX,self.swapY=1,1
    self.swapLock=false
    self.twistX,self.twistY=1,1

    self.moveDirH=-1
    self.moveChargeH=0
    self.moveDirV=1
    self.moveChargeV=0

    self.garbageBuffer={}

    self:loadScript(self.settings.script)
end
--------------------------------------------------------------

return AP
