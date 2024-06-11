local gc=love.graphics
local floor=math.floor

local area={
    x=350,y=50,
    w=900,h=900,
    c=100,
}
local lines={
    {1,2,3},
    {4,5,6},
    {7,8,9},
    {1,4,7},
    {2,5,8},
    {3,6,9},
    {1,5,9},
    {3,5,7},
}

local board={{},{},{},{},{},{},{},{},{}}
local score={}

local lastX,lastx
local curX,curx
local round
local target
local placeTime
local gameover

local function restart()
    lastX,lastx=false,false
    curX,curx=nil
    round=0
    target=false
    placeTime=love.timer.getTime()
    gameover=false
    for X=1,9 do
        score[X]=false
        for x=1,9 do
            board[X][x]=false
        end
    end
end
local function checkBoard(b,p)
    for i=1,8 do
        local continue
        for j=1,3 do
            if b[lines[i][j]]~=p then
                continue=true
                break
            end
        end
        if not continue then return true end
    end
end
local function full(L)
    for i=1,9 do
        if not L[i] then
            return false
        end
    end
    return true
end
local function place(X,x)
    board[X][x]=round
    FMOD.effect('move')
    lastX,lastx=X,x
    curX,curx=nil
    placeTime=love.timer.getTime()
    if checkBoard(board[X],round) then
        score[X]=round
        if checkBoard(score,round) then
            gameover=round
            FMOD.effect('win')
            return
        else
            if full(score) then
                gameover=true
                return
            end
        end
        FMOD.effect('beep_rise')
    else
        if full(board[X]) then
            FMOD.effect('beep_drop')
            score[X]=true
            if full(score) then
                gameover=true
                return
            end
        end
    end
    if score[x] then
        target=false
    else
        target=x
    end
    round=1-round
end

---@type Zenitha.Scene
local scene={}

function scene.enter()
    restart()
    BG.set('space')
end

function scene.mouseMove(x,y)
    x,y=floor((x-area.x)/area.c),floor((y-area.y)/area.c)
    curX,curx=floor(x/3)+floor(y/3)*3+1,x%3+y%3*3+1
    if
        x<0 or x>8 or
        y<0 or y>8 or
        curX<1 or curX>9 or
        curx<1 or curx>9 or
        score[curX] or
        not (target==curX or not target) or
        board[curX][curx] or
        gameover
    then
        curX,curx=nil
    end
end

function scene.mouseDown(x,y)
    scene.mouseMove(x,y)
    if curX then
        place(curX,curx)
    end
end

scene.touchDown=scene.mouseMove
scene.touchMove=scene.mouseMove
scene.touchUp=scene.mouseDown

local redDraw={
    {'setCL',1,.2,.2},
    {'dRect',area.c*.2,area.c*.2,area.c*.6,area.c*.6},
}
local blueDraw={
    {'setCL',.3,.3,1},
    {'line',area.c*.2,area.c*.2,area.c*.8,area.c*.8},
    {'line',area.c*.2,area.c*.8,area.c*.8,area.c*.2},
}
function scene.draw()
    gc.push('transform')
    gc.translate(area.x,area.y)

    -- Draw board
    gc.setColor(COLOR.dT)
    gc.rectangle('fill',0,0,area.w,area.h)

    -- Draw target area
    gc.setColor(1,1,1,math.sin((love.timer.getTime()-placeTime)*5)*.1+.15)
    if target then
        gc.rectangle('fill',(target-1)%3*area.c*3,floor((target-1)/3)*area.c*3,area.c*3,area.c*3)
    elseif not gameover then
        gc.rectangle('fill',0,0,area.w,area.h)
    end

    -- Draw cursor
    if curX then
        gc.setColor(1,1,1,.3)
        gc.rectangle('fill',(curX-1)%3*area.c*3+(curx-1)%3*area.c-.5,floor((curX-1)/3)*area.c*3+floor((curx-1)/3)*area.c-.5,area.c,area.c)
    end

    gc.setLineWidth(6)
    for X=1,9 do
        if score[X] then
            gc.setColor(
                score[X]==0 and COLOR.dR or
                score[X]==1 and COLOR.dB or
                COLOR.D
            )
            gc.rectangle('fill',(X-1)%3*area.c*3,floor((X-1)/3)*area.c*3,area.c*3,area.c*3)
        end
        for x=1,9 do
            local c=board[X][x]
            if c then
                local dx=(X-1)%3*area.c*3+(x-1)%3*area.c
                local dy=floor((X-1)/3)*area.c*3+floor((x-1)/3)*area.c
                gc.translate(dx,dy)
                GC.execute(c==0 and redDraw or blueDraw)
                gc.translate(-dx,-dy)
            end
        end
    end

    -- Draw board line
    gc.setLineWidth(6)
    for x=0,9 do
        gc.setColor(1,1,1,x%3==0 and 1 or .3)
        gc.line(area.c*x,0,area.c*x,area.h)
        gc.line(0,area.c*x,area.w,area.c*x)
    end

    -- Draw last pos
    if lastX then
        gc.setColor(.5,1,.4,.8)
        local r=0.042*area.c*(math.sin(love.timer.getTime()*6.26)+1)
        gc.rectangle('line',(lastX-1)%3*area.c*3+(lastx-1)%3*area.c-r,floor((lastX-1)/3)*area.c*3+floor((lastx-1)/3)*area.c-r,area.c+2*r,area.c+2*r)
    end
    gc.pop()

    gc.translate(120,80)
    -- Draw current round mark
    gc.setColor(COLOR.T)
    gc.rectangle('fill',0,0,160,160)
    gc.setColor(COLOR.L)
    gc.setLineWidth(6)
    gc.rectangle('line',0,0,160,160)

    gc.setLineWidth(10)
    if round==0 then
        gc.setColor(1,0,0)
        gc.rectangle('line',40,40,80,80)
    else
        gc.setColor(0,0,1)
        gc.line(80-45,80-45,80+45,80+45)
        gc.line(80-45,80+45,80+45,80-45)
    end
    gc.translate(-120,-80)

    if gameover then
        -- Draw result
        FONT.set(55)
        if gameover==0 then
            gc.setColor(1,.6,.6)
            GC.mStr("RED\nWON",200,260)
        elseif gameover==1 then
            gc.setColor(.6,.6,1)
            GC.mStr("BLUE\nWON",200,260)
        else
            gc.setColor(.8,.8,.8)
            GC.mStr("TIE",200,260)
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-180,w=160,h=80,fontSize=60,text=CHAR.icon.retry,color='lG',code=restart},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
