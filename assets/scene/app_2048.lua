local gc,kb=love.graphics,love.keyboard
local setColor,rectangle=gc.setColor,gc.rectangle

local int,abs=math.floor,math.abs
local rnd,min=math.random,math.min
local ins=table.insert
local setFont=FONT.set

local scene={}

local invis,tapControl

local field={
    x=340,y=40,
    w=920,
}
field.mx=field.x+field.w/2
field.my=field.y+field.w/2
field.r=field.w/4

local startTime,time
local state,progress
local move

local autoPressing
local nextTile,nextCD
local nextPos,prevPos
local prevSpawnTime=0
local maxTile

local skipper={
    used=false,
    cd=0,
}
local repeater={
    focus=false,
    seq={"",""},last={"X","X"},
}
local score

--[[Tiles' value:
    -1: black tile, cannot move
    0: X tile, cannot merge
    1/2/3/...: 2/4/8/... tile
]]
local tileColor={
    [-1]=COLOR.D,
    [0]={.5,.3,.3},
    {.93,.89,.85},
    {.93,.88,.78},
    {.95,.69,.47},
    {.96,.58,.39},
    {.96,.49,.37},
    {.96,.37,.23},
    {.93,.81,.45},
    {.93,.80,.38},
    {.93,.78,.31},
    {.93,.77,.25},
    {.93,.76,.18},
    {.40,.37,.33},
    {.22,.19,.17},
}
local tileName={[0]="X","2","4","8","16","32","64","128","256","512","1024","2048","4096","8192","16384","32768","65536","131072","262144","524288","2^20"}
local tileText={}
local function airExist()
    for i=1,16 do
        if not field[i] then
            return true
        end
    end
end
local function newTile()
    -- Select position & generate number
    nextPos=(nextPos+6)%16+1
    while field[nextPos] do
        nextPos=(nextPos-4)%16+1
    end
    field[nextPos]=nextTile
    prevPos=nextPos
    prevSpawnTime=0

    -- Fresh score
    score=score+2^nextTile
    TEXT.show("+"..2^nextTile,field.x+field.w+180+rnd(-90,90),770+rnd(-40,40),40,'score',1.5)

    -- Generate next number
    nextCD=nextCD-1
    if nextCD>0 then
        nextTile=1
    else
        nextTile=MATH.roll(.9) and 2 or MATH.roll(.9) and 3 or 4
        nextCD=rnd(8,12)
    end

    -- Check if board is full
    if airExist() then return end

    -- Check if board is locked in all-directions
    for i=1,12 do
        if field[i]==field[i+4] then
            return
        end
    end
    for i=1,13,4 do
        if
            field[i+0]==field[i+1] or
            field[i+1]==field[i+2] or
            field[i+2]==field[i+3]
        then
            return
        end
    end

    -- Die.
    state=2
    SFX.play(maxTile>=10 and 'win' or 'fail')
end
local function freshMaxTile()
    maxTile=maxTile+1
    if maxTile==12 then
        skipper.cd=0
    end
    SFX.play('reach')
    ins(progress,("%s - %.3fs"):format(tileName[maxTile],love.timer.getTime()-startTime))
end
local function squash(L)
    local p1,p2=1
    local moved=false
    while true do
        p2=p1+1
        while not L[p2] and p2<5 do
            p2=p2+1
        end
        if p2==5 then
            if p1==4 then
                return L[1],L[2],L[3],L[4],moved
            else
                p1=p1+1
            end
        else
            if not L[p1] then-- air←2
                L[p1],L[p2]=L[p2],false
                moved=true
            elseif L[p1]==L[p2] then-- 2←2
                L[p1],L[p2]=L[p1]+1,false
                if L[p1]>maxTile then
                    freshMaxTile()
                end
                L[p2]=false
                p1=p1+1
                moved=true
            elseif p1+1~=p2 then-- 2←4
                L[p1+1],L[p2]=L[p2],false
                p1=p1+1
                moved=true
            else-- 2,4
                p1=p1+1
            end
        end
    end
end
local function reset()
    for i=1,16 do field[i]=false end
    progress={}
    state=0
    score=0
    time=0
    move=0
    maxTile=6
    nextTile,nextPos=1,rnd(16)
    nextCD=32
    skipper.cd,skipper.used=false,false
    repeater.seq[1],repeater.seq[2]="",""
    repeater.last[1],repeater.last[2]="X","X"
    newTile()
end

local function moveUp()
    local moved
    for i=1,4 do
        local m
        field[i],field[i+4],field[i+8],field[i+12],m=squash({field[i],field[i+4],field[i+8],field[i+12]})
        if m then moved=true end
    end
    return moved
end
local function moveDown()
    local moved
    for i=1,4 do
        local m
        field[i+12],field[i+8],field[i+4],field[i],m=squash({field[i+12],field[i+8],field[i+4],field[i]})
        if m then moved=true end
    end
    return moved
end
local function moveLeft()
    local moved
    for i=1,13,4 do
        local m
        field[i],field[i+1],field[i+2],field[i+3],m=squash({field[i],field[i+1],field[i+2],field[i+3]})
        if m then moved=true end
    end
    return moved
end
local function moveRight()
    local moved
    for i=1,13,4 do
        local m
        field[i+3],field[i+2],field[i+1],field[i],m=squash({field[i+3],field[i+2],field[i+1],field[i]})
        if m then moved=true end
    end
    return moved
end
local function skip()
    if state==1 and skipper.cd==0 then
        if airExist() then
            skipper.cd=1024
            skipper.used=true
            newTile()
            SFX.play('hold')
        else
            SFX.play('finesseError')
        end
    end
end

function scene.enter()
    for i=1,#tileName do
        tileText[i]=gc.newText(FONT.get(80,'_basic'),tileName[i])
    end
    BG.set('cubes')
    BGM.play('truth')

    invis=false
    tapControl=false
    startTime=0
    reset()
end

function scene.mouseDown(x,y,k)
    if tapControl then
        if k==2 then
            skip()
        else
            local dx,dy=x-(field.mx),y-(field.my)
            if abs(dx)<field.w/2 and abs(dy)<field.w/2 and (abs(dx)>field.w*.1 or abs(dy)>field.w*.1) then
                scene.keyDown(abs(dx)-abs(dy)>0 and
                    (dx>0 and 'right' or 'left') or
                    (dy>0 and 'down' or 'up')
                )
            end
        end
    end
end
scene.touchDown=scene.mouseDown

local moveFunc={
    up=moveUp,
    down=moveDown,
    left=moveLeft,
    right=moveRight,
}
local arrows={
    up='↑',down='↓',left='←',right='→',
    ['↑']='up',['↓']='down',['←']='left',['→']='right',
}
local function setFocus(n)
    if state~=2 then
        repeater.focus=n
        repeater.seq[n]=""
    end
end
local function playRep(n)
    if state~=2 and #repeater.seq[n]>0 then
        repeater.focus=false
        local move0=move
        for i=1,#repeater.seq[n],3 do
            autoPressing=true
            scene.keyDown(arrows[repeater.seq[n]:sub(i,i+2)])
            autoPressing=false
        end
        if move~=move0 then
            if repeater.seq[n]~=repeater.last[n] then
                repeater.last[n]=repeater.seq[n]
                move=move0+#repeater.seq[n]/3+1
            else
                move=move0+1
            end
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='up' or key=='down' or key=='left' or key=='right' then
        if repeater.focus then
            local f=repeater.focus
            if #repeater.seq[f]<24 then
                repeater.seq[f]=repeater.seq[f]..arrows[key]
            end
        else
            if moveFunc[key]() then
                if state==0 then
                    startTime=love.timer.getTime()
                    state=1
                end
                if skipper.cd and skipper.cd>0 then
                    skipper.cd=skipper.cd-1
                    if skipper.cd==0 then
                        SFX.play('spin_0')
                    end
                end
                newTile()
                TEXT.show(arrows[key],field.mx,field.my,100,'beat',3)
                move=move+1
                if not autoPressing then
                    SFX.play('touch')
                end
            end
        end
    elseif key=='space' then skip()
    elseif key=='r' then reset()
    elseif key=='q' then if state==0 then invis=not invis end
    elseif key=='w' then if state==0 then tapControl=not tapControl end
    elseif key=='1' or key=='2' then(kb.isDown('lshift','lctrl','lalt') and playRep or setFocus)(key=='1' and 1 or 2)
    elseif key=='c1' then playRep(1)
    elseif key=='c2' then playRep(2)
    elseif key=='return' then
        if repeater.focus then
            repeater.focus=false
        end
    elseif key=='escape' then
        if repeater.focus then
            repeater.focus=false
        else
            tryBack()
        end
    end
end

function scene.update(dt)
    if state==1 then
        time=love.timer.getTime()-startTime
    end
    if prevSpawnTime<1 then
        prevSpawnTime=min(prevSpawnTime+3*dt,1)
    end
end

function scene.draw()
    -- Field
    gc.setLineWidth(10)
    if state==2 then
        setColor(.9,.9,0)-- win
    elseif state==1 then
        setColor(.9,.9,.9)-- game
    elseif state==0 then
        setColor(.2,.8,.2)-- ready
    end
    rectangle('line',field.x-10,field.y-10,field.w+20,field.w+20,25)

    for i=1,16 do
        if field[i] then
            local r=field.r
            local x,y=field.x+r*((i-1)%4)+3,field.y+r*(int((i-1)/4))+3
            local N=field[i]
            local textScale=min(field.r/tileText[N]:getWidth(),field.r/tileText[N]:getHeight())/1.26
            if i~=prevPos or prevSpawnTime==1 then
                if not invis or i==prevPos then
                    setColor(tileColor[N] or COLOR.D)
                    rectangle('fill',x,y,r-6,r-6,15)
                    if N>=0 then
                        setColor(N<3 and COLOR.D or COLOR.L)
                        GC.draw(tileText[N],x+r/2,y+r/2,nil,textScale)
                    end
                else
                    setColor(COLOR.DL)
                    rectangle('fill',x,y,r-6,r-6,15)
                end
            else
                local c=tileColor[N]
                setColor(c[1],c[2],c[3],prevSpawnTime)
                rectangle('fill',x,y,r-6,r-6,15)
                c=N<3 and 0 or 1
                setColor(c,c,c,prevSpawnTime)
                GC.draw(tileText[N],x+r/2,y+r/2,nil,textScale)
            end
        end
    end

    -- New tile position
    local x,y=1+(prevPos-1)%4,int((prevPos+3)/4)
    gc.setLineWidth(8)
    setColor(.2,.8,0,prevSpawnTime)
    local d=25-prevSpawnTime*25
    rectangle('line',field.x+field.r*(x-1)+3-d,field.y+field.r*(y-1)+3-d,field.r-6+2*d,field.r-6+2*d,15)

    -- Time and moves
    setFont(50)
    setColor(1,1,1)
    gc.print(("%.3f"):format(time),1300,10)
    gc.print(move,1300,60)

    -- Progress time list
    setFont(20)
    setColor(.6,.6,.6)
    for i=1,#progress do
        gc.print(progress[i],1300,120+20*i)
    end

    -- Score
    setFont(40)
    setColor(1,.7,.7)
    GC.mStr(score,field.x+field.w+180,700)

    -- Touch control border line
    if tapControl then
        gc.setLineWidth(6)
        setColor(1,1,1,.2)
        local r=field.w*.4
        gc.line(field.x,field.y,field.x+r,field.y+r)
        gc.line(field.x+field.w,field.y,field.x+field.w-r,field.y+r)
        gc.line(field.x,field.y+field.w,field.x+r,field.y+field.w-r)
        gc.line(field.x+field.w,field.y+field.w,field.x+field.w-r,field.y+field.w-r)
        rectangle('line',field.x+r,field.y+r,field.w*.2,field.w*.2,10)
    end

    -- Skip mark
    if skipper.used then
        gc.circle('fill',field.x-35,field.y+field.w-20,10)
    end

    -- Skip cooldown
    gc.replaceTransform(SCR.xOy_dl)
    setColor(1,1,.5)
    if skipper.cd and skipper.cd>0 then
        setFont(50)
        GC.mStr(skipper.cd,180,-420)
    end

    -- Repeater
    gc.replaceTransform(SCR.xOy_r)
    gc.setLineWidth(6)
    setFont(30)
    for i=1,2 do
        setColor(COLOR[
            repeater.focus==i and(
                love.timer.getTime()%.5>.25 and
                'R' or 'Y'
            ) or(
                repeater.seq[i]==repeater.last[i] and
                'DL' or 'L'
            )
        ])
        rectangle('line',-265,-115+60*i,250,50,5)
        gc.print(repeater.seq[i],-260,-150+100*i)
    end

    -- Next & Next indicator
    gc.replaceTransform(SCR.xOy_l)
    setFont(60)
    gc.print("Next",50,-35)
    if nextTile>1 then setColor(1,.5,.4) end
    setFont(100)
    GC.mStr(tileName[nextTile],270,-65)

    if nextCD<=12 then
        setColor(1,1,1)
        for i=1,nextCD do
            rectangle('fill',130+i*20-nextCD*8,-70,16,16)
        end
    end

    -- Draw no-setting area
    gc.replaceTransform(SCR.xOy_ul)
    if state==2 then
        setColor(1,0,0,.3)
        rectangle('fill',30,190,300,140)
    end
end

scene.widgetList={
    WIDGET.new{type='button',     pos={0,0},x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry_spin,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='checkBox',   pos={0,0},x=300,y=220,widthLimit=270,fontSize=40,disp=function() return invis end,code=WIDGET.c_pressKey'q',visibleFunc=function() return state~=1 end},
    WIDGET.new{type='checkBox',   pos={0,0},x=300,y=300,widthLimit=270,fontSize=40,disp=function() return tapControl end,code=WIDGET.c_pressKey'w',visibleFunc=function() return state~=1 end},

    WIDGET.new{type='button',     pos={0,1},x=180,y=-280,w=100,      text="↑",fontSize=50,color='Y',code=WIDGET.c_pressKey'up',   visibleFunc=function() return not tapControl end},
    WIDGET.new{type='button',     pos={0,1},x=180,y=-80, w=100,      text="↓",fontSize=50,color='Y',code=WIDGET.c_pressKey'down', visibleFunc=function() return not tapControl end},
    WIDGET.new{type='button',     pos={0,1},x=80, y=-180,w=100,      text="←",fontSize=50,color='Y',code=WIDGET.c_pressKey'left', visibleFunc=function() return not tapControl end},
    WIDGET.new{type='button',     pos={0,1},x=280,y=-180,w=100,      text="→",fontSize=50,color='Y',code=WIDGET.c_pressKey'right',visibleFunc=function() return not tapControl end},
    WIDGET.new{type='button',     pos={0,1},x=180,y=-390,w=100,      text="S",fontSize=50,color='Y',code=WIDGET.c_pressKey'space',visibleFunc=function() return state==1 and skipper.cd==0 end},
    WIDGET.new{type='button',     pos={1,.5},x=-140,y=-30,w=250,h=50,                     color='lX',code=WIDGET.c_pressKey'1',   visibleFunc=function() return state~=2 end},
    WIDGET.new{type='button',     pos={1,.5},x=-140,y=30,w=250,h=50,                      color='lX',code=WIDGET.c_pressKey'2',   visibleFunc=function() return state~=2 end},
    WIDGET.new{type='button_fill',pos={1,.5},x=-300,y=-30,w=50,      text="!",fontSize=50,color='R',code=WIDGET.c_pressKey'c1',   visibleFunc=function() return state~=2 and #repeater.seq[1]~=0 end},
    WIDGET.new{type='button_fill',pos={1,.5},x=-300,y=30,w=50,       text="!",fontSize=50,color='R',code=WIDGET.c_pressKey'c2',   visibleFunc=function() return state~=2 and #repeater.seq[2]~=0 end},
    WIDGET.new{type='button',     pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
