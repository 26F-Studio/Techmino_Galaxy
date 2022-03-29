local gc=love.graphics
local rnd=math.random
local int,ceil=math.floor,math.ceil
local char=string.char

local timing,time

local function b2(i)
    if i==0 then return 0 end
    local s=""
    while i>0 do
        s=(i%2)..s
        i=int(i/2)
    end
    return '0b'..s
end
local function b8(i)
    if i==0 then return 0 end
    local s=""
    while i>0 do
        s=(i%8)..s
        i=int(i/8)
    end
    return '0o'..s
end
local function b16(i)
    if i==0 then return 0 end
    local s=""
    while i>0 do
        s=char((i%16<10 and 48 or 55)+i%16)..s
        i=int(i/16)
    end
    return '0x'..s
end

local levels={
    function() -- <+> [,10]
        local s=rnd(2,9)
        local a=rnd(1,s)
        return a.."+"..s-a,s
    end,nil,nil,
    function() -- <+> [,20]
        local s=rnd(10,18)
        local a=rnd(s-9,int(s/2))
        return a.."+"..s-a,s
    end,nil,nil,
    function() -- <+> [,100]
        local s=rnd(22,99)
        local a=rnd(11,int(s/2))
        return a.."+"..s-a,s
    end,nil,nil,
    function() -- <-> [,10]
        local s=rnd(2,9)
        local a=rnd(1,s)
        return s.."-"..a,s-a
    end,nil,nil,
    function() -- <-> [,100]
        local s=rnd(22,99)
        local a=rnd(11,int(s/2))
        return s.."-"..a,s-a
    end,nil,nil,
    function() -- <-> [-10,]
        local s=rnd(-8,-1)
        local a=rnd(1,8)
        return a.."-"..a-s,s
    end,nil,nil,nil,nil,
    function() -- <*> [,100]
        local b=rnd(21,89)
        local a=rnd(ceil(b/10),9)
        b=int(b/a)
        return a.."*"..b,a*b
    end,nil,nil,nil,nil,
    function() -- <*> [,1000]
        local a,b=rnd(4,8),rnd(42,96)
        return a.."*"..b,a*b
    end,nil,nil,
    function() -- </> [,100]
        local b=rnd(21,89)
        local a=rnd(ceil(b/10),9)
        b=int(b/a)
        return a*b.."/"..a,b
    end,nil,nil,nil,nil,
    function() -- <%3>
        local s=rnd(5,17)
        return s.."%3",s%3
    end,nil,nil,
    function() -- <%> [,10]
        local s=rnd(21,62)
        local a=rnd(3,9)
        return s.."%"..a,s%a
    end,nil,nil,nil,nil,
    function() -- <b> [,10]
        local a=rnd(2,9)
        return{COLOR.N,b2(a)},a
    end,nil,nil,nil,nil,
    function() -- <o>
        local a=rnd(9,63)
        return{COLOR.lR,b8(a)},a
    end,nil,nil,nil,
    function() -- <h>
        local a=rnd(17,255)
        return{COLOR.J,b16(a)},a
    end,nil,nil,
    function() -- <b+>
        local s=rnd(9,31)
        local a=rnd(5,int(s/2))
        return{COLOR.N,b2(a),COLOR.L,"+",COLOR.N,b2(s-a)},s
    end,nil,nil,nil,nil,
    function() -- <o+>
        local s=rnd(18,63)
        local a=rnd(9,int(s/2))
        return{COLOR.lR,b8(a),COLOR.L,"+",COLOR.lR,b8(s-a)},s
    end,nil,nil,nil,
    function() -- <h+>
        local s=rnd(34,255)
        local a=rnd(17,int(s/2))
        return{COLOR.J,b16(a),COLOR.L,"+",COLOR.J,b16(s-a)},s
    end,nil,nil,
    function() timing=false return "Coming S∞n"..(rnd()<.5 and "" or " "),1e99 end,
}setmetatable(levels,{__index=function(self,k) return self[k-1] end})

local level

local input,inputTime=0,0
local question,answer

local function newQuestion(lv)
    return levels[lv]()
end

local function reset()
    timing=true
    time=0
    input=""
    inputTime=0
    level=1
    question,answer=newQuestion(1)
end

local function check(val)
    if val==answer then
        level=level+1
        input=""
        inputTime=0
        local newQ
        repeat
            newQ,answer=newQuestion(level)
        until newQ~=question
        question=newQ
        SFX.play('reach')
    end
end

local scene={}

function scene.enter()
    reset()
    BGM.play('truth')
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key:sub(1,2)=="kp" then key=key:sub(3) end
    if #key==1 and ("0123456789"):find(key,nil,true) then
        if #input<8 then
            input=input..key
            inputTime=1
            check(tonumber(input))
            SFX.play('touch')
        end
    elseif key=='-' then
        if #input<8 then
            if input:find("-") then
                input=input:sub(2)
            else
                input="-"..input
            end
            inputTime=1
            check(tonumber(input))
            SFX.play('hold')
        end
    elseif key=='backspace' then
        input=""
        inputTime=0
    elseif key=='r' then
        reset()
    elseif key=='escape' then
        tryBack()
    end
end

function scene.update(dt)
    if timing then time=time+dt end
    if inputTime>0 then
        inputTime=inputTime-dt
        if inputTime<=0 then
            input=""
        end
    end
end
function scene.draw()
    gc.setColor(COLOR.L)
    FONT.set(45)
    gc.print(("%.3f"):format(time),1026,70)

    FONT.set(35)
    GC.mStr("["..level.."]",800,30)

    FONT.set(80)
    if type(question)=='table' then gc.setColor(1,1,1) end
    GC.mStr(question,800,60)

    FONT.set(80)
    gc.setColor(1,1,1,inputTime)
    GC.mStr(input,800,160)
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},x=160,y=100,w=180,h=100,color='lG',fontSize=60,text=CHAR.icon.retry_spin,code=WIDGET.c_pressKey'r'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-100,w=90,fontSize=60,text=CHAR.key.clear,code=WIDGET.c_pressKey'backspace'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-100,w=90,fontSize=60,text="0",code=WIDGET.c_pressKey'0'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-100,w=90,fontSize=60,text="-",code=WIDGET.c_pressKey'-'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-200,w=90,fontSize=60,text="1",code=WIDGET.c_pressKey'1'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-200,w=90,fontSize=60,text="2",code=WIDGET.c_pressKey'2'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-200,w=90,fontSize=60,text="3",code=WIDGET.c_pressKey'3'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-300,w=90,fontSize=60,text="4",code=WIDGET.c_pressKey'4'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-300,w=90,fontSize=60,text="5",code=WIDGET.c_pressKey'5'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-300,w=90,fontSize=60,text="6",code=WIDGET.c_pressKey'6'},
    WIDGET.new{type='button',pos={0.5,0.95},x=-100,y=-400,w=90,fontSize=60,text="7",code=WIDGET.c_pressKey'7'},
    WIDGET.new{type='button',pos={0.5,0.95},x=0,   y=-400,w=90,fontSize=60,text="8",code=WIDGET.c_pressKey'8'},
    WIDGET.new{type='button',pos={0.5,0.95},x=100, y=-400,w=90,fontSize=60,text="9",code=WIDGET.c_pressKey'9'},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
