local gc=love.graphics
local gc_setColor,gc_rectangle=gc.setColor,gc.rectangle

local floor,rnd=math.floor,math.random
local ins,rem=table.insert,table.remove
local setFont,mStr=FONT.set,GC.mStr

---@type Zenitha.Scene
local scene={}

local previewFont={75,65,55,45,35}
local previewX={225,166,109,58,15}
local previewY={-15,-8,-1,6,13}
local tileColor={
    {.39, 1.0, .39},
    {.39, .39, 1.0},
    {1.0, .70, .31},
    {.94, .31, .31},
    {.00, .71, .12},
    {.90, .20, .90},
    {.94, .47, .39},
    {.90, .00, .00},
    {.86, .86, .31},
    {.78, .31, .00},
    {.78, .55, .04},
    {.12, .12, .51},
}
local area={
    x=350,y=50,
    w=900,h=900,
    c=180,
}

local board,cx,cy
local preview
local failPos
local startTime,time
local maxTile,maxNew
local state
local progress
local fallingTimer
local score

local nexts
local invis
local fast

local function setState(v)
    state=v
    scene.widgetList.nexts:setVisible(state~=1)
    scene.widgetList.invis:setVisible(state~=1)
    scene.widgetList.fast:setVisible(state~=1)
end
local function reset()
    setState(0)
    TABLE.clear(progress)
    score,time=0,0
    maxTile,maxNew=2,2
    for i=1,5 do
        preview[i]=rnd(2)
    end
    for i=1,5 do for j=1,5 do
        board[i][j]=rnd(2)
    end end
    board[rnd(5)][rnd(5)]=2
    fallingTimer=false
    failPos=false
end
function scene.load()
    BG.set('space')
    TABLE.clear(preview)
    board={{},{},{},{},{}}
    cx,cy=3,3
    startTime=0
    invis=false
    nexts=true
    reset()
end

local function merge()
    if fallingTimer or state==2 or not cx then return end
    if state==0 then
        setState(1)
        startTime=love.timer.getTime()
    end
    if failPos==cy*10+cx then return end
    local chosen=board[cy][cx]
    local connected={{cy,cx}}
    local count=1
    repeat
        local c=rem(connected)
        local y,x=c[1],c[2]
        if board[y][x]~=0 then
            board[y][x]=0
            SYSFX.rect(.2,area.x+(x-1)*area.c,area.y+(y-1)*area.c,area.c,area.c)
            if x>1 and board[y][x-1]==chosen then ins(connected,{y,x-1}) count=count+1 end
            if x<5 and board[y][x+1]==chosen then ins(connected,{y,x+1}) count=count+1 end
            if y>1 and board[y-1][x]==chosen then ins(connected,{y-1,x}) count=count+1 end
            if y<5 and board[y+1][x]==chosen then ins(connected,{y+1,x}) count=count+1 end
        end
    until not connected[1]
    if count>1 then
        board[cy][cx]=chosen+1
        local getScore=3^(chosen-1)*math.min(floor(.5+count/2),4)
        score=score+getScore
        TEXT:add{text=getScore,x=area.x+area.c*(cx-.5),y=area.y+area.c*(cy-.5)-40,fontSize=60,fontType='bold',style='score'}
        SYSFX.rectRipple(.5,area.x+(cx-1)*area.c,area.y+(cy-1)*area.c,area.c,area.c)
        FMOD.effect('lock')
        if chosen==maxTile then
            maxTile=chosen+1
            if maxTile>=6 then
                ins(progress,("%s - %.3fs"):format(maxTile,love.timer.getTime()-startTime))
            end
            maxNew=
                maxTile<=4 and 2 or
                maxTile<=8 and 3 or
                maxTile<=11 and 4 or
                5
            FMOD.effect('beep_rise')
        end
        if chosen>=5 then
            FMOD.effect(
                chosen>=9 and 'spin_4' or
                chosen>=8 and 'spin_3' or
                chosen>=7 and 'spin_2' or
                chosen>=6 and 'spin_1' or
                'spin_0'
            )
        end
        fallingTimer=fast and 0.1 or 0.2
        failPos=false
    else
        board[cy][cx]=chosen
        failPos=cy*10+cx
    end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='up' or key=='down' or key=='left' or key=='right' then
        if state==2 then return true end
        if not cx then
            cx,cy=3,3
        else
            if key=='up' then
                if cy>1 then cy=cy-1 end
            elseif key=='down' then
                if cy<5 then cy=cy+1 end
            elseif key=='left' then
                if cx>1 then cx=cx-1 end
            elseif key=='right' then
                if cx<5 then cx=cx+1 end
            end
        end
    elseif key=='z' or key=='space' then
        merge()
    elseif key=='r' then
        reset()
    elseif key=='q' then
        if state==0 then
            nexts=not nexts
        end
    elseif key=='w' then
        if state==0 then
            invis=not invis
        end
    elseif key=='e' then
        if state==0 then
            fast=not fast
        end
    elseif key=='escape' then
        if SureCheck('back') then SCN.back() end
    end
    return true
end
function scene.mouseMove(x,y)
    cx,cy=floor((x-area.x)/area.c)+1,floor((y-area.y)/area.c)+1
    if not (MATH.between(cx,1,5) and MATH.between(cy,1,5)) then
        cx,cy=false
    end
end
function scene.mouseDown(x,y)
    scene.mouseMove(x,y)
    merge()
end

scene.touchMove=scene.mouseMove
scene.touchDown=scene.mouseMove
function scene.touchClick(x,y)
    scene.mouseDown(x,y)
end

function scene.update(dt)
    if state==1 then
        time=love.timer.getTime()-startTime
        if fallingTimer then
            fallingTimer=fallingTimer-dt
            if fallingTimer<=0 then
                for i=5,2,-1 do for j=1,5 do
                    if board[i][j]==0 then
                        board[i][j]=board[i-1][j]
                        board[i-1][j]=0
                    end end
                end
                local noNewTile=true
                for i=1,5 do
                    if board[1][i]==0 then
                        board[1][i]=rem(preview,1)
                        preview[5]=
                            maxTile<=4 and rnd(2) or
                            maxTile<=8 and rnd(1+rnd(2)) or
                            maxTile<=11 and rnd(2+rnd(2)) or
                            rnd(2+rnd(3))
                        noNewTile=false
                    end
                end
                if noNewTile then
                    fallingTimer=false
                    for i=1,4 do for j=1,5 do if board[i][j]==board[i+1][j] then return end end end
                    for i=1,5 do for j=1,4 do if board[i][j]==board[i][j+1] then return end end end
                    setState(2)
                    FMOD.effect('finish_suffocate')
                else
                    fallingTimer=fast and .05 or .1
                    FMOD.effect('touch')
                end
            end
        elseif fast and (
            IsMouseDown(1) or
            GetTouches()[1] or
            IsKeyDown('space')
        ) then
            merge()
        end
    end
end

function scene.draw()
    setFont(40)
    gc_setColor(COLOR.L)
    gc.print(("%.3f"):format(time),1300,50)
    gc.print(score,1300,100)

    -- Progress time list
    setFont(25)
    gc_setColor(.7,.7,.7)
    for i=1,#progress do
        gc.print(progress[i],1300,140+30*i)
    end

    -- Previews
    if nexts then
        gc.translate(30,450)
        gc.setColor(COLOR.dT)
        gc_rectangle('fill',0,0,280,75)
        gc.setLineWidth(6)
        gc_setColor(COLOR.L)
        gc_rectangle('line',0,0,280,75)
        for i=1,5 do
            setFont(previewFont[i])
            gc.setColor(tileColor[preview[i]])
            gc.print(preview[i],previewX[i],previewY[i])
        end
        gc.translate(-30,-450)
    end

    if state==2 then
        -- Draw no-setting area
        gc_setColor(1,0,0,.3)
        gc_rectangle('fill',40,200,285,210)
    end
    gc.setLineWidth(10)
    gc_setColor(COLOR[
        state==1 and (fast and 'R' or 'W') or
        state==0 and 'G' or
        state==2 and 'Y'
    ])
    gc_rectangle('line',area.x-5,area.y-5,area.w+10,area.h+10)

    gc.setLineWidth(4)
    setFont(70)
    local hide=invis and state==1
    for i=1,5 do for j=1,5 do
        local N=board[i][j]
        if N>0 then
            if hide and N>maxNew then
                gc_setColor(COLOR.lD)
                gc_rectangle('fill',area.x+(j-1)*area.c,area.y+(i-1)*area.c,area.c,area.c)
                gc_setColor(1,1,1,.3)
                mStr("?",j*area.c+256,i*area.c-75)
            else
                if N<=12 then
                    gc_setColor(tileColor[N])
                elseif N<=14 then
                    gc_setColor(COLOR.rainbow(4*love.timer.getTime()-i-j))
                else
                    gc_setColor(0,0,0,1-math.abs(love.timer.getTime()%.5-.25)*6-.25)
                end
                gc_rectangle('fill',area.x+(j-1)*area.c,area.y+(i-1)*area.c,area.c,area.c)
                gc_setColor(1,1,1,.9)
                mStr(N,j*area.c+256,i*area.c-75)
            end
        end
    end end
    if state<2 and cx then
        gc_setColor(1,1,1,.6)
        gc.setLineWidth(10)
        gc_rectangle('line',area.x+(cx-1)*area.c+5,area.y+(cy-1)*area.c+5,area.c-10,area.c-10)
    end
    setFont(50)
    gc_setColor(COLOR.L)
    mStr("Just Get Ten",170,580)
end

scene.widgetList={
    WIDGET.new{type='button',                            x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,onPress=WIDGET.c_pressKey'r'},
    WIDGET.new{type='checkBox',name='nexts',text="Nexts",x=280,y=235,widthLimit=200,fontSize=40,disp=function() return nexts end,code=WIDGET.c_pressKey'q'},
    WIDGET.new{type='checkBox',name='invis',text="Invis",x=280,y=305,widthLimit=200,fontSize=40,disp=function() return invis end,code=WIDGET.c_pressKey'w'},
    WIDGET.new{type='checkBox',name='fast', text="Fast", x=280,y=375,widthLimit=200,fontSize=40,disp=function() return fast  end,code=WIDGET.c_pressKey'e'},
    WIDGET.new{type='button',  pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,onPress=WIDGET.c_backScn()},
}

return scene
