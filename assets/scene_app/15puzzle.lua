local gc=love.graphics

local floor,rnd=math.floor,math.random

---@type Zenitha.Scene
local scene={}

local scale=1.4
local board,cx,cy
local startTime,time
local move,push,state

local color,invis='color1'
local slide,pathVis,revKB

local function notGaming( ) return state~=1 end
local colorSelector=WIDGET.new{type='selector',pos={0,0},x=150,y=240,w=200,text="Color",labelPos='top',labelDistance=20,list={'color1','rainbow','color2','gray','black'},disp=function() return color end,code=function(v) if state~=1 then color=v end end,visibleTick=notGaming}

function scene.load()
    BG.set('space')
    board={{1,2,3,4},{5,6,7,8},{9,10,11,12},{13,14,15,16}}
    cx,cy=4,4
    startTime=0
    time=0
    move,push=0,0
    state=2

    color='color1'
    invis=false
    slide=true
    pathVis=true
    revKB=false
end

local function moveU(x,y)
    if y<4 then
        board[y][x],board[y+1][x]=board[y+1][x],board[y][x]
        cy=cy+1
    end
end
local function moveD(x,y)
    if y>1 then
        board[y][x],board[y-1][x]=board[y-1][x],board[y][x]
        cy=cy-1
    end
end
local function moveL(x,y)
    if x<4 then
        board[y][x],board[y][x+1]=board[y][x+1],board[y][x]
        cx=cx+1
    end
end
local function moveR(x,y)
    if x>1 then
        board[y][x],board[y][x-1]=board[y][x-1],board[y][x]
        cx=cx-1
    end
end
local function shuffleBoard()
    for i=1,300 do
        i=rnd()
        if i<.25 then moveU(cx,cy)
        elseif i<.5 then moveD(cx,cy)
        elseif i<.75 then moveL(cx,cy)
        else moveR(cx,cy)
        end
    end
end
local function checkBoard(b)
    for i=4,1,-1 do
        for j=1,4 do
            if b[i][j]~=4*i+j-4 then
                return false
            end
        end
    end
    return true
end
local function tapBoard(x,y,key)
    if state<2 then
        if not key then
            if pathVis then
                SYSFX.rect(.16,x-5,y-5,11,11,1,1,1)
            end
            x,y=floor((x-SCR.w0/2)/160/scale)+3,floor((y-SCR.h0/2)/160/scale)+3
        end
        local b=board
        local moves=0
        if cx==x then
            if y>cy and y<5 then
                for i=cy,y-1 do
                    moveU(x,i)
                    moves=moves+1
                end
            elseif y<cy and y>0 then
                for i=cy,y+1,-1 do
                    moveD(x,i)
                    moves=moves+1
                end
            end
        elseif cy==y then
            if x>cx and x<5 then
                for i=cx,x-1 do
                    moveL(i,y)
                    moves=moves+1
                end
            elseif x<cx and x>0 then
                for i=cx,x+1,-1 do
                    moveR(i,y)
                    moves=moves+1
                end
            end
        end
        if moves>0 then
            push=push+1
            move=move+moves
            if state==0 then
                state=1
                startTime=love.timer.getTime()
            end
            if checkBoard(b) then
                state=2
                time=love.timer.getTime()-startTime
                FMOD.effect('finish_win')
                return
            end
            FMOD.effect('touch')
        end
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='up' then
        tapBoard(cx,cy-(revKB and 1 or -1),true)
    elseif key=='down' then
        tapBoard(cx,cy+(revKB and 1 or -1),true)
    elseif key=='left' then
        tapBoard(cx-(revKB and 1 or -1),cy,true)
    elseif key=='right' then
        tapBoard(cx+(revKB and 1 or -1),cy,true)
    elseif key=='space' then
        shuffleBoard()
        state=0
        time=0
        move,push=0,0
    elseif key=='q' then
        if state~=1 then
            colorSelector:scroll(isKeyDown('lshift','rshift') and -1 or 1)
        end
    elseif key=='w' then
        if state==0 then
            invis=not invis
        end
    elseif key=='e' then
        if state==0 then
            slide=not slide
            if not slide then
                pathVis=false
            end
        end
    elseif key=='r' then
        if state==0 and slide then
            pathVis=not pathVis
        end
    elseif key=='t' then
        if state==0 then
            revKB=not revKB
        end
    elseif key=='escape' then
        if sureCheck('back') then SCN.back() end
    end
    return true
end
function scene.mouseDown(x,y)
    tapBoard(x,y)
end
function scene.mouseMove(x,y)
    if slide then
        tapBoard(x,y)
    end
end
function scene.touchDown(x,y)
    tapBoard(x,y)
end
function scene.touchMove(x,y)
    if slide then
        tapBoard(x,y)
    end
end

function scene.update()
    if state==1 then
        time=love.timer.getTime()-startTime
    end
end

local frontColor={
    color1={
        COLOR.lR,COLOR.lR,COLOR.lR,COLOR.lR,
        COLOR.lG,COLOR.lB,COLOR.lB,COLOR.lB,
        COLOR.lG,COLOR.lY,COLOR.lV,COLOR.lV,
        COLOR.lG,COLOR.lY,COLOR.lV,COLOR.lV,
    }, -- Colored(rank)
    rainbow={
        COLOR.lR,COLOR.lR,COLOR.lR,COLOR.lR,
        COLOR.lO,COLOR.lY,COLOR.lY,COLOR.lY,
        COLOR.lO,COLOR.lG,COLOR.lB,COLOR.lB,
        COLOR.lO,COLOR.lG,COLOR.lB,COLOR.lB,
    }, -- Rainbow(rank)
    color2={
        COLOR.lR,COLOR.lR,COLOR.lR,COLOR.lR,
        COLOR.lB,COLOR.lB,COLOR.lB,COLOR.lB,
        COLOR.lG,COLOR.lY,COLOR.lV,COLOR.lV,
        COLOR.lG,COLOR.lY,COLOR.lV,COLOR.lV,
    }, -- Colored(row)
    gray={
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
    }, -- Gray
    black={
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
        COLOR.L,COLOR.L,COLOR.L,COLOR.L,
    }, -- Black
}
local backColor={
    color1={
        COLOR.dR,COLOR.dR,COLOR.dR,COLOR.dR,
        COLOR.dG,COLOR.dB,COLOR.dB,COLOR.dB,
        COLOR.dG,COLOR.dY,COLOR.dP,COLOR.dP,
        COLOR.dG,COLOR.dY,COLOR.dP,COLOR.dP,
    }, -- Colored(rank)
    rainbow={
        COLOR.dR,COLOR.dR,COLOR.dR,COLOR.dR,
        COLOR.dO,COLOR.dY,COLOR.dY,COLOR.dY,
        COLOR.dO,COLOR.dG,COLOR.dB,COLOR.dB,
        COLOR.dO,COLOR.dG,COLOR.dB,COLOR.dB,
    }, -- Rainbow(rank)
    color2={
        COLOR.dR,COLOR.dR,COLOR.dR,COLOR.dR,
        COLOR.dB,COLOR.dB,COLOR.dB,COLOR.dB,
        COLOR.dG,COLOR.dY,COLOR.dP,COLOR.dP,
        COLOR.dG,COLOR.dY,COLOR.dP,COLOR.dP,
    }, -- Colored(row)
    gray={
        COLOR.dL,COLOR.dL,COLOR.dL,COLOR.dL,
        COLOR.dL,COLOR.dL,COLOR.dL,COLOR.dL,
        COLOR.dL,COLOR.dL,COLOR.dL,COLOR.dL,
        COLOR.dL,COLOR.dL,COLOR.dL,COLOR.dL,
    }, -- Gray
    black={
        COLOR.D,COLOR.D,COLOR.D,COLOR.D,
        COLOR.D,COLOR.D,COLOR.D,COLOR.D,
        COLOR.D,COLOR.D,COLOR.D,COLOR.D,
        COLOR.D,COLOR.D,COLOR.D,COLOR.D,
    }, -- Black
}
function scene.draw()
    gc.replaceTransform(SCR.xOy_l)
    if state==2 then
        -- Draw no-setting area
        gc.setColor(1,0,0,.3)
        gc.rectangle('fill',15,-200,285,400)

        gc.setColor(.9,.9,0)-- win
    elseif state==1 then
        gc.setColor(.9,.9,.9)-- game
    elseif state==0 then
        gc.setColor(.2,.8,.2)-- ready
    end

    gc.setLineWidth(10)
    gc.replaceTransform(SCR.xOy_m)
    gc.scale(scale)
    gc.rectangle('line',-327,-327,654,654,18)

    gc.setLineWidth(4)
    local mono=invis and state==1
    FONT.set(80)
    for i=1,4 do
        for j=1,4 do
            if cx~=j or cy~=i then
                local N=board[i][j]
                local C=mono and 'gray' or color

                gc.setColor(backColor[C][N])
                gc.rectangle('fill',j*160-477,i*160-477,154,154,8)
                gc.setColor(frontColor[C][N])
                gc.rectangle('line',j*160-477,i*160-477,154,154,8)
                if not mono then
                    gc.setColor(.1,.1,.1)
                    GC.mStr(N,j*160-400,i*160-456)
                    GC.mStr(N,j*160-398,i*160-458)
                    gc.setColor(COLOR.L)
                    GC.mStr(N,j*160-397,i*160-455)
                end
            end
        end
    end
    gc.setColor(COLOR.dT)
    gc.setLineWidth(10)
    gc.rectangle('line',cx*160-467,cy*160-467,134,134,50)

    FONT.set(40)
    gc.setColor(COLOR.L)
    gc.print(("%.3f"):format(time),360,-320)
    gc.setColor(.8,.9,1)
    gc.print(("%s(%s)"):format(move,push),360,-270)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=160, y=100,w=180,h=100,fillColor='lG',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'space'},
    colorSelector,
    WIDGET.new{type='checkBox',   pos={0,.5},x=240, y=-150,text="Invis",widthLimit=200,fontSize=40,disp=function() return invis end,  code=WIDGET.c_pressKey'w',visibleTick=notGaming},
    WIDGET.new{type='checkBox',   pos={0,.5},x=240, y=-50, text="Slide",widthLimit=200,fontSize=40,disp=function() return slide end,  code=WIDGET.c_pressKey'e',visibleTick=notGaming},
    WIDGET.new{type='checkBox',   pos={0,.5},x=240, y=50,  text="Path", widthLimit=200,fontSize=40,disp=function() return pathVis end,code=WIDGET.c_pressKey'r',visibleTick=function() return state~=1 and slide end},
    WIDGET.new{type='checkBox',   pos={0,.5},x=240, y=150, text="RevKB",widthLimit=200,fontSize=40,disp=function() return revKB end,  code=WIDGET.c_pressKey't',visibleTick=notGaming},
    WIDGET.new{type='button_fill',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
