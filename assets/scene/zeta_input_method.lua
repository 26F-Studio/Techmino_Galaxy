local gc=love.graphics
local ins,rem=table.insert,table.remove
local max,min=math.max,math.min
local floor,abs=math.floor,math.abs
local pi=math.pi

local areaX,areaY,areaR=800,400,300

local scene={}

local widgetList_ui
local widgetList_result={}
local strokeKeys={q=1,w=2,e=3,r=4,t=5}
local uiKeyHint={
    'BkSp','Del','Enter',
    'Z','X','Esc',
    'Q','W','E','R','T',
}

local prevScene
local time,quiting
local writing
local database
local inputs,cheat
local results

local charQueue={}
local function selChar(i)
    if results[i] then
        ins(charQueue,results[i].char)
        scene.keyDown('x')
    end
end

local function freshWidgetPos()
    local y0=100*(1-time)
    for i=1,#scene.widgetList do
        scene.widgetList[i]._y=scene.widgetList[i].y+y0
    end
end

local function parseStroke(input)-- 横 竖 撇 捺 折
    local w=input.weight
    local s=input.stroke

    local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
    for i=1,#s,2 do
        minX=min(minX,s[i])
        minY=min(minY,s[i+1])
        maxX=max(maxX,s[i])
        maxY=max(maxY,s[i+1])
    end

    local width,height=maxX-minX,maxY-minY
    local dx=s[#s-1]-s[1]
    local dy=s[#s]-s[2]
    local dir=math.atan2(dy,dx)

    if width<=30 and height<=30 or width>600 or height>600 then return end
    if s[1]<areaX-areaR and s[#s-1]<areaX-areaR or s[1]>areaX+areaR and s[#s-1]>areaX+areaR then return end
    if s[2]<areaY-areaR and s[#s]<areaY-areaR or s[2]>areaY+areaR and s[#s]>areaY+areaR then return end

    w[1]=-w[5]+min(MATH.interpolate(width/height,1/2.6,0,2.6,1),1)
    w[2]=-w[5]+min(MATH.interpolate(height/width,1.6,0,2.6,1),1)
    w[3]=-w[5]*.62+1-abs(dir/pi-.8)*3
    w[4]=-w[5]*.62+1-abs(dir/pi-.4)

    local angles={}
    local sample={s[1],s[2]}
    local distSum=0
    for i=3,#s,2 do
        distSum=distSum+MATH.distance(s[i],s[i+1],sample[1],sample[2])
        if distSum>30 then
            ins(angles,math.atan2(s[i+1]-sample[2],s[i]-sample[1]))
            sample={s[i],s[i+1]}
            distSum=0
        end
    end
    for i=1,#angles-1 do
        local da=pi-abs(pi-abs(angles[i]-angles[i+1]))
        w[5]=max(w[5],da/(pi/2.6))
    end

    for i=1,5 do
        w[i]=MATH.clamp(w[i],0,1)
    end

    return true
end
local function charComp(a,b)
    return a.diff<b.diff
end
local function freshResult()
    local maxStep=#inputs
    local list={{node=database,step=0,diff=0}}
    local p=1
    while list[p] do
        local state=list[p]
        if state.node[1] and state.step<maxStep then
            local input=inputs[state.step+1]
            for i=1,5 do
                ins(list,{node=state.node[i],step=state.step+1,diff=state.diff+(1-input.weight[i])})
            end
        end
        p=p+1
    end

    results={}
    for i=1,#list do
        local state=list[i]
        if state.step==maxStep and state.node[1] then
            for _,char in next,state.node.list do
                ins(results,{char=char,diff=state.diff,dispDiff=floor(state.diff*100).."%"})
            end
        end
    end
    table.sort(results,charComp)
    if #results>5 then
        local avg5=0
        for i=1,5 do
            avg5=avg5+results[i].diff/5
        end
        for i=6,#results do
            if i>=15 or results[i].diff>avg5+260 then
                results={unpack(results,1,i)}
                break
            end
        end
    end
    for i=1,15 do
        local b=widgetList_result[i]
        if results[i] then
            b.x=800+90*(i-(#results+1)*.5)
            b:setVisible(true)
            b:reset()
        else
            b:setVisible(false)
        end
    end
end

function scene.enter()
    prevScene=SCN.scenes[SCN.stack[#SCN.stack-1]] or NONE
    time,quiting=0,false
    writing=false
    inputs,cheat={},false
    results={}
    charQueue={}

    if not database then
        local data=STRING.split(FILE.load("assets/stroke_data.txt"),"\n")
        database={{},{},{},{},{},list={}}
        for i=1,#data do
            local char
            local str=data[i]
            local p=database
            local depth=0
            while true do
                p.depth=depth
                char,str=STRING.readChars(str,1)
                if char==' ' then
                    ins(p.list,str)
                    break
                else
                    local num=tonumber(char)
                    p=p[num]
                    if not p[1] then
                        p[1],p[2],p[3],p[4],p[5],p.list={},{},{},{},{},{}
                    end
                end
                depth=depth+1
            end
        end
    end

    freshWidgetPos()
    freshResult()
end

function scene.mouseDown(x,y,k)
    if k==1 and not writing then
        ins(inputs,{stroke={x,y},weight={0,0,0,0,0}})
        writing=k
    elseif k==2 then
        writing=false
        scene.keyDown('z')
    elseif k==3 then
        writing=false
        scene.keyDown('x')
    end
end
function scene.mouseMove(x,y)
    if writing then
        local s=inputs[#inputs].stroke
        if s then ins(s,x) ins(s,y) end
    end
end
function scene.mouseUp(_,_,k)
    if k==1 and writing==k then
        writing=false
        if not parseStroke(inputs[#inputs]) then rem(inputs) end
        freshResult()
    end
end

function scene.touchDown(x,y,id)
    if not writing and not WIDGET.sel then
        ins(inputs,{stroke={x,y},weight={0,0,0,0,0}})
        writing=id
    end
end
function scene.touchMove(x,y,_,_,id)
    if writing==id then
        local s=inputs[#inputs].stroke
        if s then ins(s,x) ins(s,y) end
    end
end
function scene.touchUp(_,_,id)
    if writing==id then
        writing=false
        if not parseStroke(inputs[#inputs]) then rem(inputs) end
        freshResult()
    end
end

function scene.keyDown(k)
    if k=='z' then-- Undo stroke
        rem(inputs)
        cheat=false
        for i=1,#inputs do if inputs[i].cheat then cheat=true break end end
        freshResult()
    elseif k=='x' then-- Clear strokes
        inputs,cheat={},false
        freshResult()
    elseif k=='backspace' then-- Delete a char
        rem(charQueue)
    elseif k=='delete' then-- Clear chars
        charQueue={}
    elseif k=='return' then-- Confirm text
        quiting=charQueue
    elseif k=='space' then-- Select first char
        selChar(1)
    elseif k=='escape' then-- Quit
        quiting=true
    elseif #k==1 then
        if k:match("[0-9]") then-- Select char
            selChar((k-1)%10+1)
        elseif strokeKeys[k] then-- Manual input stroke
            local input={stroke={},weight={0,0,0,0,0},cheat=true}
            input.weight[strokeKeys[k]]=1
            ins(inputs,input)
            cheat=true
            freshResult()
        end
    end
end

function scene.update(dt)
    if prevScene.update then
        prevScene.update(dt)
    end
    if quiting then
        time=math.max(time-12.6*dt,0)
        if time<=0 then
            SCN.back('none',table.concat(charQueue))
        end
        freshWidgetPos()
    elseif time<1 then
        time=math.min(time+6.26*dt,1)
        freshWidgetPos()
    end
end

function scene.draw()
    -- Previous scene's things
    if prevScene.draw then
        prevScene.draw()
    end
    if prevScene.widgetList then
        gc.replaceTransform(SCR.xOy)
        WIDGET.draw(prevScene.widgetList)
    end

    -- Dark background
    gc.replaceTransform(SCR.origin)
    gc.setColor(.1,.1,.1,time*.8)
    gc.rectangle('fill',0,0,SCR.w,SCR.h)

    gc.replaceTransform(SCR.xOy)
    gc.translate(0,100*(1-time))

    -- Writing Area
    gc.setLineWidth(4)
    gc.setColor(1,1,1,time)
    gc.rectangle('line',areaX-areaR,areaY-areaR,600,600,10)

    -- Stroke count
    FONT.set(40,'bold')
    gc.setColor(cheat and COLOR.LB or COLOR.L)
    gc.print(#inputs,areaX-areaR+10,areaY+areaR-50)

    -- Strokes
    gc.setColor(.8,.8,.8,time)
    gc.setLineJoin("bevel")
    gc.setLineWidth(10)
    for i=1,#inputs do
        if writing and i==#inputs then
            gc.setColor(1,1,1,time)
            gc.setLineWidth(4)
        end
        if inputs[i].stroke[3] then
            gc.line(inputs[i].stroke)
        end
    end

    -- Results
    for i=1,#results do
        local x=widgetList_result[i]._x
        local y=widgetList_result[i]._y
        local p=results[i].diff*.42
        gc.setColor(2*p,2-2*p,.42-p*.26,time)
        FONT.set(70)
        GC.mStr(results[i].char,x,y-50)
        gc.setColor(2*p,2-2*p,.626-p*.42,time)
        FONT.set(20,'bold')
        GC.mStr(results[i].dispDiff,x,y+40)
        if i<=10 then
            FONT.set(30,'bold')
            gc.setColor(COLOR.L)
            gc.print(i%10,x-36,y-80)
        end
    end

    -- Char queue
    FONT.set(80)
    gc.setColor(1,1,.8,time)
    gc.print(charQueue,areaX+areaR+20,areaY-130)

    -- UI key hint
    gc.replaceTransform(SCR.xOy)
    FONT.set(30,'bold')
    for i=1,#widgetList_ui do
        local w=widgetList_ui[i]
        gc.setColor(w.color)
        gc.print(uiKeyHint[i],w._x-w.w/2,w._y-w.h/2-40)
    end
end

scene.widgetList={}

widgetList_ui={
    WIDGET.new{type='button',x=areaX+areaR+70,y=areaY+areaR-250,w=100, sound_trigger='move',fontSize=80,color='LY',text=CHAR.key.backspace,code=WIDGET.c_pressKey'backspace'},
    WIDGET.new{type='button',x=areaX+areaR+190,y=areaY+areaR-250,w=100,sound_trigger='move',fontSize=80,color='LY',text=CHAR.key.mac_clear,code=WIDGET.c_pressKey'delete'},
    WIDGET.new{type='button',x=areaX+areaR+340,y=areaY+areaR-250,w=100,sound_trigger='move',fontSize=80,color='LY',text=CHAR.icon.check_circ,code=WIDGET.c_pressKey'return'},
    WIDGET.new{type='button',x=areaX+areaR+70,y=areaY+areaR-50,w=100,  sound_trigger='move',fontSize=80,text=CHAR.icon.back,code=WIDGET.c_pressKey'z'},
    WIDGET.new{type='button',x=areaX+areaR+190,y=areaY+areaR-50,w=100, sound_trigger='move',fontSize=80,text=CHAR.icon.delete,code=WIDGET.c_pressKey'x'},
    WIDGET.new{type='button',x=areaX+areaR+340,y=areaY+areaR-50,w=100, sound_trigger='move',fontSize=80,text=CHAR.icon.cross_big,code=WIDGET.c_pressKey'escape'},
}
local strokeSymbol={'一','丨','丿','丶','乚'}
for i=1,#strokeSymbol do
    local w=WIDGET.new{
        type='button',
        x=areaX-areaR+30-90*(#strokeSymbol-i+1),
        y=areaY+areaR-40,w=80,sound_trigger='move',
        fontSize=70,color='LB',
        text=strokeSymbol[i],
        code=WIDGET.c_pressKey(('qwert'):sub(i,i))
    }
    ins(widgetList_ui,w)
end

TABLE.connect(scene.widgetList,widgetList_ui)

local fwSymbols={
    {'（','）','【','】','《','》'},
    {'：','：','“','”','‘','’'},
    {'，','。','、','？','！','…'},
}
for i=1,#fwSymbols do
    for j=1,#fwSymbols[i] do
        ins(scene.widgetList,WIDGET.new{
            type='button',
            x=areaX-areaR+25-75*(#fwSymbols[i]-j+1),
            y=areaY+areaR-400+75*i,
            w=70,sound_trigger='move',
            fontSize=60,color='LR',
            text=fwSymbols[i][j],
            code=function() ins(charQueue,fwSymbols[i][j]) end
        })
    end
end

for i=1,15 do
    local w=WIDGET.new{
        type='button',
        x=-2600,y=790,w=80,sound_trigger='move',
        fontSize=80,code=function() selChar(i) end
    }
    ins(scene.widgetList,w)
    ins(widgetList_result,w)
end

return scene
