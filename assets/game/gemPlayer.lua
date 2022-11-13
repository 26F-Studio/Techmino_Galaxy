local gc=love.graphics

local max,min=math.max,math.min
local floor=math.floor
local ins,rem=table.insert,table.remove

local inst=SFX.playSample

local GP=setmetatable({},{__index=require'assets.game.basePlayer'})

--[[ Gem tags:
    int color <1~7>
    string type <'gem','cube'>
    boolean movable

    string appearance <'flame'|'star'|'nova'>
    function moved
    function aftermove
    table destroyed {
        string mode <'explosion'|'lightning'|'color'>
        if mode=='explosion' or 'lightning':
            int radius <0|1|2|...>
    }

    boolean immediately
    int clearTimer
    int clearDelay

    int moveTimer
    int moveDelay
    float dx
    float dy
    boolean fall

    int lrCnt
    int udCnt
    int riseCnt
    int dropCnt
]]

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
    move=           function() SFX.play('move')          end,
    move_failed=    function() SFX.play('move_failed')   end,
    swap=           function() SFX.play('rotate')        end,
    swap_failed=    function() SFX.play('tuck')          end,
    twist=          function() SFX.play('rotate')        end,
    twist_failed=   function() SFX.play('tuck')          end,
    move_back=      function() SFX.play('rotate_failed') end,
    touch=          function() SFX.play('lock')          end,
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
    combo=       function() end,
    chain=       function() end,
    win=         function() SFX.play('win')         end,
    fail=        function() SFX.play('fail')        end,
}
GP.scriptCmd={
    -- TODO
}
--------------------------------------------------------------
-- Actions
local actions={}

function actions.swapLeft(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap('action',P.swapX,P.swapY,-1,0)
    end
end
function actions.swapRight(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap('action',P.swapX,P.swapY,1,0)
    end
end
function actions.swapUp(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap('action',P.swapX,P.swapY,0,1)
    end
end
function actions.swapDown(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap('action',P.swapX,P.swapY,0,-1)
    end
end
function actions.twistCW(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistR then
        P:twist('action',P.twistX,P.twistY,'R')
    end
end
function actions.twistCCW(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistL then
        P:twist('action',P.twistX,P.twistY,'L')
    end
end
function actions.twist180(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistF then
        P:twist('action',P.twistX,P.twistY,'F')
    end
end
function actions.moveLeft(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirH=-1
    P.moveChargeH=0

    if P.swapX>1 then
        P.swapX=P.swapX-1
        if P.twistX>1 then
            P.twistX=P.twistX-1
        end
        P:playSound('move')
    elseif P.twistX>1 then
        P.twistX=P.twistX-1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveRight(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirH=1
    P.moveChargeH=0

    if P.swapX<P.settings.fieldSize then
        P.swapX=P.swapX+1
        if P.twistX<P.settings.fieldSize-1 then
            P.twistX=P.twistX+1
        end
        P:playSound('move')
    elseif P.twistX<P.settings.fieldSize-1 then
        P.twistX=P.twistX+1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveUp(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirV=1
    P.moveChargeV=0

    if P.swapY<P.settings.fieldSize then
        P.swapY=P.swapY+1
        if P.twistY<P.settings.fieldSize-1 then
            P.twistY=P.twistY+1
        end
        P:playSound('move')
    elseif P.twistY<P.settings.fieldSize-1 then
        P.twistY=P.twistY+1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveDown(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirV=-1
    P.moveChargeV=0

    if P.swapY>1 then
        P.swapY=P.swapY-1
        if P.twistY>1 then
            P.twistY=P.twistY-1
        end
        P:playSound('move')
    elseif P.twistY>1 then
        P.twistY=P.twistY-1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
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
--------------------------------------------------------------
-- Effects
--------------------------------------------------------------
-- Game methods
function GP:printField()-- For debugging
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
function GP:isMovable(x,y)
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
function GP:getGem(data)
    local G={
        type='gem',
        movable=true,
    }
    if data then TABLE.cover(data,G) end
    return G
end
function GP:setMoveBias(mode,C,dx,dy)
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
function GP:erasePosition(x,y,src)
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
                    error('Wrong destroy event mode')
                end
            end
            if g.generate then
                ins(self.generateBuffer,{
                    x=x,y=y,
                    gem=g.generate,
                })
            end
        end
    end
end
function GP:swap(mode,x,y,dx,dy)
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
function GP:twist(mode,x,y,dir)
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
function GP:psedoCheckPos(x,y)
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
function GP:setClear(g,linkMode,len)
    g.movable=false
    g.clearTimer=g.immediately and 0 or self.settings.clearDelay
    g.clearDelay=self.settings.clearDelay
    g[linkMode]=len
end
function GP:setGenerate(g,gen)
    g.immediately=true
    g.clearTimer=0
    g.generate=self:getGem(gen)
end
function GP:checkPosition(x,y)
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
function GP:freshGems()
    local newGems={}
    local F=self.field
    for x=1,self.settings.fieldSize do
        -- Drag gems down
        for y=1,self.settings.fieldSize do
            -- F[y][x] is a hole
            if not F[y][x] then
                -- Find a gem above the hole
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

        -- Fill holes with new gems
        local lowestHole=9
        for y=1,self.settings.fieldSize do
            if not F[y][x] then
                lowestHole=y
                break
            end
        end
        for y=lowestHole,self.settings.fieldSize do
            local g=self:getGem()
            self:setMoveBias('fall',g,0,9-lowestHole)
            ins(newGems,g)
            F[y][x]=g
        end
    end
    local freshTimes=0
    repeat
        for i=1,#newGems do
            local g=newGems[i]
            g.color=self.seqRND:random(self.settings.colors)
        end
        freshTimes=freshTimes+1
    until freshTimes>=self.settings.refreshCount or self:hasMove()
end
function GP:hasMove()
    return true
end
function GP:changeFieldSize(w,h,origX,origY)
end
function GP:receive(data)
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
function GP:getScriptValue(arg)
    return
        arg.d=='field_size' and self.settings.fieldSize or
        arg.d=='cell' and (self.field[arg.y][arg.x] and 1 or 0)
end
--------------------------------------------------------------
-- Press & Release & Update & Render
function GP:getMousePos(x,y)
    local pos=self.pos
    x,y=((x-pos.x)/pos.k/360+1)/2,((pos.y-y)/pos.k/360+1)/2
    if x>=0 and x<1 and y>=0 and y<1 then
        return x,y
    else
        return false,false
    end
end
function GP:getSwapPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+1),floor(y*size+1)
    if x>=1 and x<=size and y>=1 and y<=size then return x,y end
end
function GP:freshSwapCursor()
    self.swapLock=false
    if self.mouseX then
        local sx,sy=self:getSwapPos(self.mouseX,self.mouseY)
        if sx and (self.swapX~=sx or self.swapY~=sy) then
            self.swapX,self.swapY=sx,sy
        end
    end
end
function GP:getTwistPos(x,y)
    local size=self.settings.fieldSize
    x,y=floor(x*size+.5),floor(y*size+.5)
    if x>=1 and x<=size-1 and y>=1 and y<=size-1 then return x,y end
end
function GP:freshTwistCursor()
    if self.mouseX then
        local tx,ty=self:getTwistPos(self.mouseX,self.mouseY)
        if tx and (self.twistX~=tx or self.twistY~=ty) then
            self.twistX,self.twistY=tx,ty
        end
    end
end
function GP:mouseDown(x,y,id)
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
function GP:mouseMove(x,y,_,_,_)
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
function GP:mouseUp(_,_,_)
    self.mousePressed=false
end
function GP:updateFrame()
    local SET=self.settings

    -- Auto shift
    if self.moveDirH and (self.moveDirH==-1 and self.keyState.moveLeft or self.moveDirH==1 and self.keyState.moveRight) then
        if self.swapX~=MATH.clamp(self.swapX+self.moveDirH,1,self.settings.fieldSize) then
            local c0=self.moveChargeH
            local c1=c0+1
            self.moveChargeH=c1
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
            self.moveChargeH=SET.das
            self:shakeBoard(self.moveDirH>0 and '-right' or '-left')
        end
    else
        self.moveDirH=self.keyState.moveLeft and -1 or self.keyState.moveRight and 1 or false
        self.moveChargeH=0
    end
    if self.moveDirV and (self.moveDirV==-1 and self.keyState.moveDown or self.moveDirV==1 and self.keyState.moveUp) then
        if self.swapY~=MATH.clamp(self.swapY+self.moveDirV,1,self.settings.fieldSize) then
            local c0=self.moveChargeV
            local c1=c0+1
            self.moveChargeV=c1
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
            self.moveChargeV=SET.das
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
        F[gen.y][gen.x]=gen.gem
    end

    if needFresh then
        self:freshGems()
    end

    -- Update garbage
    for i=1,#self.garbageBuffer do
        local g=self.garbageBuffer[i]
        if g.mode==0 and g.time<g.time0 then
            g.time=g.time+1
        end
    end
end
function GP:render()
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
    gc.translate(-360,360)

    -- startFieldStencil
    GC.stc_setComp()
    GC.stc_rect(0,0,720,-720)
    gc.scale(16/settings.fieldSize)


        self:triggerEvent('drawBelowField')


        -- Grid & Cells
        skin.drawFieldBackground(settings.fieldSize)
        skin.drawFieldCells(self.field)


        self:triggerEvent('drawInField')


    -- stopFieldStencil
    GC.stc_stop()

    -- Particles
    gc.setColor(1,1,1)
    gc.draw(self.particles.star)
    gc.draw(self.particles.trail)

    -- Cursor(s)
    if self.settings.swap then
        skin.drawSwapCursor(self.swapX,self.swapY,self.swapLock)
    end
    if self.settings.twistR then
        skin.drawTwistCursor(self.twistX,self.twistY)
    end

    -- popFieldTransform
    gc.pop()

    -- Field border
    skin.drawFieldBorder()

    -- Garbage buffer
    skin.drawGarbageBuffer(self.garbageBuffer)

    -- Timer
    skin.drawTime(self.gameTime)

    -- Texts
    self.texts:draw()


    self:triggerEvent('drawOnPlayer')


    -- Starting counter
    if self.time<settings.readyDelay then
        skin.drawStartingCounter(settings.readyDelay)
    end

    gc.pop()
end
--------------------------------------------------------------
-- Other
function GP:decodeScript(line,errMsg)
    -- TODO
    -- error(errMsg.."No string command '"..cmd.."'")
end
function GP:checkScriptSyntax(cmd,arg,errMsg)
    -- TODO
end
--------------------------------------------------------------
-- Builder
local baseEnv={
    fieldSize=8,

    readyDelay=3000,
    moveDelay=300,
    clearDelay=500,
    fallDelay=200,

    atkSys='none',

    colors=7,
    linkLen=3,
    diagonalLinkLen=false,
    refreshCount=0,

    multiMove=true,
    swap=true,
    swapForce=true,
    twistR=false,twistL=false,twistF=false,
    twistForce=false,
    script=false,

    -- Will be overrode with user setting
    skin='gem_default',

    shakeness=.26,
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
function GP.new()
    local self=setmetatable({},{__index=GP,__metatable=true})
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

    return self
end
function GP:initialize()
    self.soundEvent=setmetatable({},soundEventMeta)
    self.modeData=setmetatable({},modeDataMeta)
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

    self.field={}
    for y=1,self.settings.fieldSize do
        self.field[y]=TABLE.new(false,self.settings.fieldSize)
    end
    self:freshGems()

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

    self.actionHistory={}
    self.texts=TEXT.new()

    -- Generate available actions
    do
        self.actions={}
        for k in next,actions do
            self.actions[k]=_getActionObj(k)
        end

        self.keyState={}
        for k in next,self.actions do
            self.keyState[k]=false
        end
    end

    self:loadScript(self.settings.script)

    self.particles={}
    for k,v in next,particleTemplate do
        self.particles[k]=v:clone()
    end
end
--------------------------------------------------------------

return GP
