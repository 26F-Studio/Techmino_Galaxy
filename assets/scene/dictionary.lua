local ins=table.insert
local gc,GC=love.graphics,GC
local kbIsDown=love.keyboard.isDown
local scene={}

local categoryColor={
    intro= {index=COLOR.F, content=COLOR.lF},-- Instruction for current scene
    guide= {index=COLOR.Y, content=COLOR.lY},-- Practice methods
    term=  {index=COLOR.lB,content=COLOR.LB},-- Concept in game
    tech=  {index=COLOR.G, content=COLOR.lG},-- General technics
    other= {index=COLOR.M, content=COLOR.lM},-- Other
}
local mainW,mainH=900,700
local mainX=100-mainW/2
local listW,listH=300,600
local searchH=80

local prevScene
local time,quiting
local selected
local contents={
    _width=0,
    title=GC.newText(FONT.get(30),""),
    texts={},
    lineH=0,
}

-- Base dict data, not formatted
local baseDict do
    baseDict=require('assets/basedictionary')
    local dictObjMeta={__index=function(obj,k)
        if k=='titleText' then
            obj.titleText=love.graphics.newText(FONT.get(obj.titleSize,'bold'),obj.titleFull)
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

local listBox,inputBox,linkButton,copyButton
local function close()
    quiting=true
    SFX.play('dict_close')
end
local function selectItem(item)
    selected=item
    linkButton:setVisible(item and item.link and true)
    if item then
        contents.title=selected.titleText
        contents._width,contents.texts=FONT.get(item.contentSize):getWrap(item.content,mainW-30)
        contents.lineH=1.26*item.contentSize
        contents.scroll=0
        contents.maxScroll=math.max(
            #contents.texts*contents.lineH
            +126
            +(contents.title:getHeight()+5)
            -(mainH-searchH),
            0
        )
        copyButton:setVisible(true)
    else
        contents.texts=NONE
        contents.maxScroll=0
    end
    contents.scroll=0
end
local function openLink()
    if selected.link then
        love.system.openURL(selected.link)
        SFX.play('dict_link')
    end
end
local function copyText()
    love.system.setClipboardText(("%s:\n%s\n==Techmino Dict==\n"):format(selected.titleFull,selected.content))
    SFX.play('dict_copy')
    copyButton:setVisible(false)
end
do-- Widgets
    listBox={
        type='listBox',pos={.5,.5},x=mainX-listW,y=-listH/2,w=listW-10,h=listH,
        lineHeight=40,cornerR=5,
        scrollBarWidth=5,
        scrollBarDist=12,
        scrollBarColor=COLOR.lY,
        activeColor={0,0,0,0},idleColor={0,0,0,0},
    }
    function listBox.drawFunc(obj,_,sel)
        if sel then
            gc.setColor(1,1,1,.26)
            gc.rectangle('fill',0,0,listW-10,40)
        end
        FONT.set(30,'norm')
        gc.setColor(categoryColor[obj.cat].index)
        gc.print(obj.title,5,0)
        if obj==selected then
            gc.setColor(1,1,1,.62+.355*math.sin(love.timer.getTime()*12.6))
            gc.print(obj.title,5,0)
        end
    end
    function listBox.code()
        if selected~=listBox:getItem() then
            selectItem(listBox:getItem())
        end
    end
    listBox=WIDGET.new(listBox)

    inputBox=WIDGET.new{
        type='inputBox',pos={.5,.5},x=mainX,y=280,w=mainW,h=searchH-10,
        cornerR=5,
        frameColor={0,0,0,0},
    }
    copyButton=WIDGET.new{
        type='button',pos={.5,.5},x=mainX+mainW-50,y=210,w=80,h=80,
        sound=false,lineWidth=4,cornerR=0,
        fontSize=60,text=CHAR.icon.copy,
        code=copyText,
    }
    linkButton=WIDGET.new{
        type='button',pos={.5,.5},x=mainX+mainW-150,y=210,w=80,h=80,
        sound=false,lineWidth=4,cornerR=0,
        fontSize=60,text=CHAR.icon.earth,
        code=openLink,
    }
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
    selectItem(false)

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

            obj.title=curObj.title
            if obj.title then
                obj.titleSize=curObj.titleSize or 50
            else
                obj.title=enObj.title
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
            obj.titleSize=5*math.floor(obj.titleSize/5+.5)
            obj.contentSize=5*math.floor(obj.contentSize/5+.5)
            obj.titleFull=curObj.titleFull or obj.title or enObj.titleFull or enObj.title
            obj.link=curObj.link or false
            obj.titleText=nil-- Generate when needed (__index at basedictionary.lua)

            ins(dispDict,obj)
            dispDict[obj.id]=obj
            if target==obj.id then
                selectItem(obj)
                selectedNum=#dispDict
            end
        end
    end

    if not selected then selectItem(dispDict[1]) end
    listBox:setList(dispDict)
    if selectedNum then listBox:select(selectedNum)end
    listBox._scrollPos1=listBox._scrollPos
    SFX.play('dict_open')
    collectgarbage()
end

function scene.keyDown(key,isRep)
    local act=KEYMAP.sys:getAction(key)
    if act=='up' or act=='down' then
        if not (isCtrlPressed() or isShiftPressed() or isAltPressed()) then
            local sel=listBox:getItem()
            listBox:arrowKey(key)
            if listBox:getItem()~=sel then
                SFX.play(listBox.sound_select)
            end
        end
    elseif act=='help' or act=='back' then
        close()
    elseif key=='pageup'   then
        listBox:scroll(-15)
    elseif key=='pagedown' then
        listBox:scroll(15)
    elseif #key==1 and key:find'[0-9a-z]' then
        if key=='c' and isCtrlPressed() then
            copyText()
        else
            if WIDGET.sel~=inputBox then
                WIDGET.focus(inputBox)
                WIDGET.textinput(key)
                return true
            end
        end
    elseif key=='delete' or key=='backspace' then
        inputBox:keypress(key)
    elseif not isRep then
        if act=='select' then
            if selected~=listBox:getItem() then
                listBox.code()
                SFX.play(listBox.sound_click)
            end
        elseif key=='home' then
            listBox:scroll(-1e99)
        elseif key=='end' then
            listBox:scroll(1e99)
        end
    end
end

local function inScreen(x,y)
    x,y=SCR.xOy:transformPoint(x,y)
    x,y=SCR.xOy_m:inverseTransformPoint(x,y)
    return x>=mainX and x<mainX+mainW and y>-mainH/2 and y<mainH/2-searchH
end
local function scroll(dy)
    contents.scroll=MATH.clamp(contents.scroll-dy,0,contents.maxScroll)
end
function scene.mouseMove(x,y,_,dy)
    if WIDGET.sel~=listBox and love.mouse.isDown(1) and x and y and inScreen(x,y) then
        scroll(dy)
    end
end
function scene.mouseDown(_,_,k)
    if k==2 then
        close()
    end
end
function scene.touchMove(x,y,_,dy)
    if WIDGET.sel~=listBox and inScreen(x,y) then
        scroll(dy)
    end
end

function scene.wheelMoved(_,y)
    scroll(y*contents.lineH*2)
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
    if kbIsDown('up','down') and (isCtrlPressed() or isShiftPressed() or isAltPressed()) then
        scroll(12.6*contents.lineH*dt*(kbIsDown('up') and 1 or -1))
    end
end

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
    gc.translate(mainX,50*(1-time))

    -- Dark shade
    gc.setLineWidth(10)
    gc.setColor(.45,.45,.45,time)
    gc.translate(5,5)
    gc.rectangle('line',-5,-mainH/2-5,mainW+10,mainH+10,10)
    gc.rectangle('line',-listW-5,-listH/2-5,listW,listH+10,10)
    gc.line(-5,mainH/2-searchH,mainW+5,mainH/2-searchH)
    gc.translate(-5,-5)

    -- Light frame
    gc.setColor(.62,.62,.62,time)
    gc.rectangle('line',-5,-mainH/2-5,mainW+10,mainH+10,10)
    gc.rectangle('line',-listW-5,-listH/2-5,listW,listH+10,10)
    gc.line(-5,mainH/2-searchH,mainW+5,mainH/2-searchH)

    -- Screen
    gc.setColor(.4,.45,.55,time*.4)
    gc.rectangle('fill',0,-mainH/2,mainW,mainH-searchH-5,5)
    gc.rectangle('fill',0,mainH/2-searchH+5,mainW,searchH-5,5)
    gc.rectangle('fill',-listW,-listH/2,listW-10,listH,5)

    -- Title & Content
    GC.stc_reset()
    GC.stc_rect(0,-mainH/2,mainW,mainH-searchH-5,5)
    gc.setColor(categoryColor[selected.cat].content)
        gc.translate(0,-contents.scroll)
        -- Title
        gc.draw(contents.title,15,-mainH/2+5,nil,math.min(1,(mainW-25)/contents.title:getWidth()),1)

        gc.translate(0,contents.title:getHeight()+5)
        -- Line
        GC.setLineWidth(2)
        gc.line(15,-mainH/2,mainW-10,-mainH/2)
        -- Content
        FONT.set(selected.contentSize)
        for i=1,#contents.texts do
            gc.print(contents.texts[i],15,-mainH/2+5+contents.lineH*(i-1))
        end
    GC.stc_stop()
end

scene.widgetList={
    listBox,
    inputBox,
    copyButton,
    linkButton,
    WIDGET.new{type='button',pos={.5,.5},x=mainX+mainW+70,y=-310,w=80,h=80,sound=false,lineWidth=4,cornerR=0,fontSize=60,text=CHAR.icon.cross_big,code=close},
}
return scene
