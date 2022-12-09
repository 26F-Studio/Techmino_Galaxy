local gc=love.graphics

local state-- 0=playing, 1=gameover
local timeUsed
local level
local showNum
local showTime
local input
local inputTime

local scene={}

local function newNum(lv)
    local num=""
    for _=1,4+lv^.66 do num=num..math.random(0,9) end
    return num
end

local function freshLevel()
    showNum=newNum(level)
    showTime=math.max(4-level,0)+#showNum*math.max(.5-#showNum*.01,.3)
    inputTime=2+#showNum*math.max(1-#showNum*.01,.626)
    input=''
end
local function _reset()
    state=0
    timeUsed=0
    level=1
    freshLevel()
end

function scene.enter()
    state=1
    timeUsed=0
    level=0
    input=''
    showNum='memoriZe'
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        if sureCheck('back') then SCN.back() end
    elseif key=='r' then
        _reset()
    elseif state==0 then
        if key:sub(1,2)=="kp" then key=key:sub(3) end
        if #key==1 and ("0123456789"):find(key,nil,true) then
            input=input..key
            showTime=math.min(showTime,0)
            if input==showNum then
                level=level+1
                freshLevel()
                SFX.play('reach')
            end
        elseif key=='space' or key=='backspace' then
            input=""
        end
    end
end

function scene.update(dt)
    if state==0 then
        showTime=showTime-dt
        if showTime<=0 then
            timeUsed=timeUsed+dt
            inputTime=inputTime-dt
            if inputTime<=0 then
                inputTime=0
                state=1
                SFX.play('finesseError_long',.6)
            end
        end
    end
end

function scene.draw()
    gc.setColor(COLOR.L)
    FONT.set(45)
    gc.print(("%.3f"):format(timeUsed),1026,70)

    FONT.set(35)
    GC.mStr("["..level.."]",800,30)

    FONT.set(60)
    GC.mStr(input,800,160)

    if state==0 then
        if showTime<=0 then
            FONT.set(30)
            gc.setColor(1,.7,.7,-3*showTime)
            GC.mStr(("%.1f"):format(inputTime),800,230)
        end
        gc.setColor(1,1,1,showTime/1.26)
    else
        gc.setColor(1,.4,.4)
    end
    if #showNum<=10 then
        FONT.set(100)
        GC.mStr(showNum,800,60)
    else
        FONT.set(60)
        GC.mStr(showNum,800,90)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},     x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-100,w=90,fontSize=60,text=CHAR.key.mac_clear,code=WIDGET.c_pressKey'backspace'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-100,w=90,fontSize=60,text="0",code=WIDGET.c_pressKey'0'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-200,w=90,fontSize=60,text="1",code=WIDGET.c_pressKey'1'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-200,w=90,fontSize=60,text="2",code=WIDGET.c_pressKey'2'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-200,w=90,fontSize=60,text="3",code=WIDGET.c_pressKey'3'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-300,w=90,fontSize=60,text="4",code=WIDGET.c_pressKey'4'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-300,w=90,fontSize=60,text="5",code=WIDGET.c_pressKey'5'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-300,w=90,fontSize=60,text="6",code=WIDGET.c_pressKey'6'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-400,w=90,fontSize=60,text="7",code=WIDGET.c_pressKey'7'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-400,w=90,fontSize=60,text="8",code=WIDGET.c_pressKey'8'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-400,w=90,fontSize=60,text="9",code=WIDGET.c_pressKey'9'},
    WIDGET.new{type='button',pos={1,1},     x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
