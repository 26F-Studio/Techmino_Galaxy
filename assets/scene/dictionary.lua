local ins=table.insert
local gc,GC=love.graphics,GC
local scene={}

local categoryColor={
    intro= {index=COLOR.F, content=COLOR.lF},-- Instruction for current scene
    guide= {index=COLOR.Y, content=COLOR.lY},-- Practice methods
    term=  {index=COLOR.lB,content=COLOR.LB},-- Concept in game
    tech=  {index=COLOR.G, content=COLOR.lG},-- General technics
    other= {index=COLOR.M, content=COLOR.lM},-- Other
}

local prevScene
local time,quiting
local selected

-- Base dict data, not formatted
local baseDict do
    baseDict=require('assets/basedictionary')
    local dictObjMeta={__index=function(obj,k)
        if k=='titleText' then
            obj.titleText=love.graphics.newText(FONT.get(obj.titleSize,'bold'),obj.title)
            return obj.titleText
        end
    end}
    for _,obj in next,baseDict do
        local list=STRING.split(obj[1],':')
        obj[1]=nil
        obj.cat,obj.id=list[1]:trim(),list[2]:trim()
        setmetatable(obj,dictObjMeta)
    end
end

local dispDict={}
-- Dict data of current language
local currentDict={locale=false}
-- Dict data of English
local enDict=FILE.load('assets/language/dict_en.lua','-lua -canskip')

local function back()
    quiting=true
    SFX.play('dict_close')
end
local listBox do-- Widgets
    listBox={
        type='listBox',pos={.5,.5},x=-630,y=-300,w=240,h=600,
        lineHeight=40,cornerR=5,
        scrollBarWidth=5,
        scrollBarDist=12,
        scrollBarColor=COLOR.lY,
        activeColor={0,0,0,0},idleColor={0,0,0,0},
    }
    function listBox.drawFunc(obj,_,sel)
        if sel then
            gc.setColor(1,1,1,.26)
            gc.rectangle('fill',0,0,240,40)
        end
        FONT.set(30,'norm')
        GC.stc_reset()
        GC.stc_rect(0,0,240,40)
        gc.setColor(categoryColor[obj.cat].index)
        gc.print(obj.title,5,0)
        if obj==selected then
            gc.setColor(1,1,1,.62+.355*math.sin(love.timer.getTime()*12.6))
            gc.print(obj.title,5,0)
        end
        GC.stc_stop()
    end
    function listBox.code()
        if selected~=listBox:getItem() then
            selected=listBox:getItem()
        end
    end
    listBox=WIDGET.new(listBox)
end
local inputBox do
    inputBox={
        type='inputBox',pos={.5,.5},x=-380,y=280,w=900,h=70,
        cornerR=5,
        frameColor={0,0,0,0},
    }
    inputBox=WIDGET.new(inputBox)
end

local function freshWidgetPos()
    local y0=SCR.h0/2+50*(1-time)
    for i=1,#scene.widgetList do
        scene.widgetList[i]._y=scene.widgetList[i].y+y0
    end
end

function scene.enter()
    local target=SCN.args[1] or 'aboutDict'

    time=0
    freshWidgetPos()

    quiting=false
    prevScene=SCN.scenes[SCN.stack[#SCN.stack-1]] or NONE
    selected=false

    -- Initialize dictionary for current language (if need)
    if currentDict.locale~=SETTINGS.system.locale then
        currentDict=FILE.load('assets/language/dict_'..SETTINGS.system.locale..'.lua','-lua -canskip')
        if not currentDict then
            currentDict={aboutDict={title="[No Dict Data]",content="No dictionary file detected."}}
        end
        currentDict.locale=SETTINGS.system.locale
    end

    -- Refresh items
    local selectedNum
    TABLE.cut(dispDict)
    for _,obj in next,baseDict do
        if not obj.hidden or type(obj.hidden)=='function' and obj.hidden() or target==obj.id then
            local curObj=currentDict[obj.id] or NONE
            local enObj=enDict[obj.id] or NONE

            obj.title=curObj.title_full or curObj.title
            if obj.title then
                obj.titleSize=curObj.titleSize or 50
            else
                obj.title=enObj.title_full or enObj.title
                if obj.title then
                    obj.titleSize=enObj.titleSize or 50
                else
                    obj.title='['..obj.id..']';
                    obj.titleSize=50
                end
            end
            obj.content=curObj.content
            if obj.content then
                obj.contentSize=curObj.contentSize or 30
            else
                obj.content=enObj.content
                if obj.content then
                    obj.contentSize=enObj.contentSize or 30
                else
                    obj.content='[No Data]';
                    obj.contentSize=30
                end
            end

            obj.titleText=nil-- Generate when needed (__index at basedictionary.lua)

            ins(dispDict,obj)
            dispDict[obj.id]=obj
            if target==obj.id then
                selected=obj
                selectedNum=#dispDict
            end
        end
    end

    if not selected then selected=dispDict[1] end
    listBox:setList(dispDict)
    if selectedNum then listBox:select(selectedNum)end
    listBox._scrollPos1=listBox._scrollPos
    SFX.play('dict_open')
    collectgarbage()
end

function scene.keyDown(key,isRep)
    local act=KEYMAP.sys:getAction(key)
    if act=='up' or act=='down' then
        listBox:arrowKey(key)
    elseif act=='help' or act=='back' then
        back()
    elseif key=='pageup'   then
        listBox:scroll(-15)
    elseif key=='pagedown' then
        listBox:scroll(15)
    elseif #key==1 and key:find'[0-9a-z]' then
        if WIDGET.sel~=inputBox then
            WIDGET.focus(inputBox)
            WIDGET.textinput(key)
            return true
        end
    elseif key=='delete' or key=='backspace' then
        inputBox:keypress(key)
    elseif not isRep then
        if key=='return' then
            if selected~=listBox:getItem() then
                listBox.code()
            end
        elseif key=='home' then
            listBox:scroll(-1e99)
        elseif key=='end' then
            listBox:scroll(1e99)
        end
    end
end

function scene.update(dt)
    if prevScene.update then
        prevScene.update(dt)
    end
    if quiting then
        time=math.max(time-12.6*dt,0)
        freshWidgetPos()
        if time<=0 then
            SCN.back('none')
        end
    elseif time<1 then
        time=math.min(time+6.26*dt,1)
        freshWidgetPos()
    end
end

local w,h=900,700
local w2,h2=250,600
local searchH=80

function scene.draw()
    -- Draw previous scene's things
    if prevScene.draw then
        prevScene.draw()
    end
    if prevScene.widgetList then
        gc.replaceTransform(SCR.xOy)
        WIDGET._draw(prevScene.widgetList)
    end

    -- Dark background
    gc.replaceTransform(SCR.origin)
    gc.setColor(.1,.1,.1,time*.8)
    gc.rectangle('fill',0,0,SCR.w,SCR.h)

    -- Dictionary
    gc.replaceTransform(SCR.xOy_m)
    gc.translate(70-w/2,50*(1-time))

    -- Dark shade
    gc.setLineWidth(10)
    gc.setColor(.45,.45,.45,time)
    gc.translate(5,5)
    gc.rectangle('line',-5,-h/2-5,w+10,h+10,10)
    gc.rectangle('line',-w2-5,-h2/2-5,w2,h2+10,10)
    gc.line(-5,h/2-searchH,w+5,h/2-searchH)
    gc.translate(-5,-5)

    -- Light frame
    gc.setColor(.62,.62,.62,time)
    gc.rectangle('line',-5,-h/2-5,w+10,h+10,10)
    gc.rectangle('line',-w2-5,-h2/2-5,w2,h2+10,10)
    gc.line(-5,h/2-searchH,w+5,h/2-searchH)

    -- Screen
    gc.setColor(.4,.45,.55,time*.4)
    gc.rectangle('fill',0,-h/2,w,h-searchH-5,5)
    gc.rectangle('fill',0,h/2-searchH+5,w,searchH-5,5)
    gc.rectangle('fill',-w2,-h2/2,w2-10,h2,5)

    -- Title & Content
    GC.stc_reset()
    GC.stc_rect(0,-h/2,w,h-searchH-5,5)
    gc.setColor(categoryColor[selected.cat].content)
        -- Title
        gc.draw(selected.titleText,15,-h/2+5,nil,math.min(1,(w-25)/selected.titleText:getWidth()),1)

        gc.translate(0,selected.titleText:getHeight()+5)
        -- Line
        GC.setLineWidth(2)
        gc.line(15,-h/2,w-10,-h/2)
        -- Content
        FONT.set(selected.contentSize)
        gc.printf(selected.content,15,-h/2+5,w-30,'left')
    GC.stc_stop()
end

scene.widgetList={
    listBox,
    inputBox,
    WIDGET.new{type='button',pos={.5,.5},x=600,y=-310,w=80,h=80,sound=false,lineWidth=4,cornerR=0,fontSize=60,text=CHAR.icon.cross_big,code=back},
    WIDGET.new{type='button',pos={.5,.5},x=370,y=210, w=80,h=80,sound=false,lineWidth=4,cornerR=0,fontSize=60,text=CHAR.icon.earth},
    WIDGET.new{type='button',pos={.5,.5},x=470,y=210, w=80,h=80,sound=false,lineWidth=4,cornerR=0,fontSize=60,text=CHAR.icon.copy},
}
return scene
