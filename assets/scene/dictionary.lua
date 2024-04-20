local gc_setColor,gc_setLineWidth=GC.setColor,GC.setLineWidth
local gc_draw,gc_print,gc_rectangle,gc_line=GC.draw,GC.print,GC.rectangle,GC.line
local gc_stc_reset,gc_stc_rect,gc_stc_stop=GC.stc_reset,GC.stc_rect,GC.stc_stop
local gc_translate,gc_replaceTransform=GC.translate,GC.replaceTransform

local ins=table.insert
local kbIsDown=love.keyboard.isDown
local scene={}

local categoryColor={
    intro= {index=COLOR.F, content=COLOR.lF}, -- Instruction for current scene
    guide= {index=COLOR.Y, content=COLOR.lY}, -- Practice methods
    term=  {index=COLOR.lB,content=COLOR.LB}, -- Concept in game
    tech=  {index=COLOR.G, content=COLOR.lG}, -- General technics
    other= {index=COLOR.M, content=COLOR.lM}, -- Other
}
local mainW,mainH=900,700
local mainX=100-mainW/2
local listW,listH=300,600
local searchH=80

local aboveScene
local searchTimer,lastSearchText
local time,quiting
local selected
local contents={
    _width=0,
    title=GC.newText(FONT.get(30),''),
    texts={},
}
-- Base dict data, not formatted
local baseDict do
    baseDict=require('assets/basedictionary')
    local dictObjMeta={__index=function(obj,k)
        if k=='titleText' then
            obj.titleText=GC.newText(FONT.get(obj.titleSize,'bold'),obj.titleFull)
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

-- Entries from baseDict, with data from languages
local dispDict={}
local filteredDict={}

-- Dict data of current language
local currentDict={locale=false}
-- Dict data of English
local enDict=FILE.load('assets/language/dict_en.lua','-lua -canskip')

local listBox,inputBox,linkButton,copyButton
local function close()
    quiting=true
    FMOD.effect('dict_close')
end
local function selectItem(item)
    selected=item
    linkButton:setVisible(item and item.link and true)
    if item then
        contents.title=selected.titleText
        contents._width,contents.texts=FONT.get(item.contentSize):getWrap(item.content,mainW-30)
        contents.scroll=0
        contents.maxScroll=126+(contents.title:getHeight()+5)-(mainH-searchH)
        for i=1,#contents.texts do
            local str=contents.texts[i]
            local line={}
            if str:sub(1,2)=='~~' then
                str=str:sub(str:find('[^~]') or #str):trim()
                line.divider=MATH.clamp(math.floor((tonumber(str) or 1)+.5),1,10)
                line.height=line.divider+10
            else
                line.text=str
                line.height=item.contentSize+10
            end
            contents.maxScroll=contents.maxScroll+line.height
            contents.texts[i]=line
        end
        contents.maxScroll=math.max(contents.maxScroll,0)
        table.insert(contents.texts,1,{divider=4,height=10})
        copyButton:setVisible(true)
    else
        contents.title="x"
        contents.texts=NONE
        contents.scroll=0
        contents.maxScroll=0
    end
    contents.scroll=0
end
local function openLink()
    if selected.link then
        love.system.openURL(selected.link)
        FMOD.effect('dict_link')
    end
end
local function copyText()
    love.system.setClipboardText(("%s:\n%s\n==Techmino Dict==\n"):format(selected.titleFull,selected.content))
    FMOD.effect('dict_copy')
    copyButton:setVisible(false)
end
local function freshWidgetPos()
    local y0=SCR.h0/2+50*(1-time)
    for i=1,#scene.widgetList do
        scene.widgetList[i]._y=scene.widgetList[i].y+y0
    end
end
local function dictSortFunc(a,b)
    return a._priority>b._priority
end
local function search(str)
    str=str:trim():lower()
    if str=='' then
        listBox:setList(dispDict)
    else
        TABLE.cut(filteredDict)
        for i=1,#dispDict do
            local obj=dispDict[i]
            obj._priority=
                (obj.title:lower():find(str,nil,true) and 26 or 0)+
                (obj.titleFull and obj.titleFull:lower():find(str,nil,true) and 16 or 0)+
                (#str>=3 and obj.content:lower():find(str,nil,true) and 3*math.min(#str,5) or 0)
            if obj._priority>0 then
                ins(filteredDict,obj)
            end
        end
        table.sort(filteredDict,dictSortFunc)
        listBox:setList(filteredDict)
        if filteredDict[1] then
            selectItem(filteredDict[1])
        end
    end
end
do -- Widgets
    listBox={
        type='listBox',pos={.5,.5},x=mainX-listW,y=-listH/2,w=listW-10,h=listH,
        lineHeight=40,
        scrollBarWidth=5,
        scrollBarDist=12,
        scrollBarColor=COLOR.lY,
        activeColor={0,0,0,0},idleColor={0,0,0,0},
        stencilMode='single',
    }
    function listBox.drawFunc(obj,_,sel)
        if sel then
            gc_setColor(1,1,1,.26)
            gc_rectangle('fill',0,0,listW-10,40)
        end
        FONT.set(30,'norm')
        gc_setColor(categoryColor[obj.cat].index)
        gc_print(obj.title,5,0)
        if obj==selected then
            gc_setColor(1,1,1,.62+.355*math.sin(love.timer.getTime()*12.6))
            gc_print(obj.title,5,0)
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
        frameColor={0,0,0,0},
    }
    copyButton=WIDGET.new{
        type='button',pos={.5,.5},x=mainX+mainW-50,y=210,w=80,h=80,
        sound_trigger=false,lineWidth=4,
        fontSize=60,text=CHAR.icon.copy,
        code=copyText,
    }
    linkButton=WIDGET.new{
        type='button',pos={.5,.5},x=mainX+mainW-150,y=210,w=80,h=80,
        sound_trigger=false,lineWidth=4,
        fontSize=60,text=CHAR.icon.earth,
        code=openLink,
    }
end

local function assertObj(cond,message,obj)
    assertf(cond,"Dict parse error: %s\nLine %d: %s",message,obj._line,obj._id)
end
local function parseDict(data)
    data=data:split('\n')
    local result={}
    local buffer
    for lineNum,line in next,data do
        local commentPos=line:find('%-%-')
        while 1 do
            if commentPos then
                if line:sub(commentPos-1,commentPos-1)~='\\' then
                    line=line:gsub('%-%-.*',''):trim()
                    if #line==0 then break end
                end
                line=line:gsub('\\(%-%-+)','%1')
            end
            local head=line:sub(1,1)
            if head=='#' then
                if buffer then
                    assertObj(not result[buffer._id],'Duplicate ID',buffer)
                    result[buffer._id]=buffer
                    buffer.content=buffer.content:trim()
                end
                buffer={
                    _id=line:sub(2):trim(),
                    _line=lineNum,
                }
                assertObj(#buffer._id>0,'Empty ID',buffer)
            elseif head=='@' then
                local key,value=line:match('@%s*(%w+)%s*(.+)')
                if key=='title' then
                    value=value:gsub('%%n','\n')
                    buffer.title=not buffer.title and value or buffer.title..'\n'..value
                    assertObj(#buffer.title>0,'Empty title',buffer)
                elseif key=='titleFull' then
                    value=value:gsub('%%n','\n')
                    buffer.titleFull=not buffer.titleFull and value or buffer.titleFull..'\n'..value
                elseif key=='titleSize' then
                    assertObj(not buffer.titleSize,'Duplicate @titleSize',buffer)
                    buffer.titleSize=tonumber(value)
                    assertObj(buffer.titleSize and buffer.titleSize>0,'Invalid titleSize',buffer)
                elseif key=='contentSize' then
                    assertObj(not buffer.contentSize,'Duplicate @contentSize',buffer)
                    buffer.contentSize=tonumber(value)
                    assertObj(buffer.contentSize and buffer.contentSize>0,'Invalid contentSize',buffer)
                elseif key=='link' then
                    assertObj(not buffer.link,'Duplicate @link',buffer)
                    buffer.link=value
                end
            else
                buffer.content=not buffer.content and line or buffer.content..'\n'..line
            end
            break
        end
    end
    if buffer then
        result[buffer._id]=buffer
    end
    return result
end

function scene.enter()
    listBox._scrollPos1=listBox._scrollPos
    if SCN.prev=='zeta_input_method' and SCN.args[1] then
        inputBox:addText(SCN.args[1])
        return
    end
    local target=SCN.args[1] or 'aboutDict'

    quiting=false
    time=0
    aboveScene=SCN.scenes[SCN.stack[#SCN.stack-1]] or NONE
    searchTimer,lastSearchText=0,''
    inputBox._value=''
    FMOD.effect('dict_open')
    freshWidgetPos()

    selectItem(false)

    -- Initialize dictionary for current language (if need)
    if currentDict.locale~=SETTINGS.system.locale then
        currentDict=FILE.load('assets/language/dict_'..SETTINGS.system.locale..'.lua','-lua -canskip')
        if type(currentDict)=='string' then
            local res,data
            res,data=pcall(parseDict,currentDict)
            if res then
                currentDict=data
            else
                currentDict=nil
                MSG.new('error',data,10)
            end
        end
        if not currentDict then currentDict={} end
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
            obj.titleText=nil -- Generate when needed (__index at basedictionary.lua)

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
    if selectedNum then listBox:select(selectedNum or 1)end
    collectgarbage()
end

function scene.keyDown(key,isRep)
    if WIDGET.isFocus(inputBox) and #key==1 then return end
    local act=KEYMAP.sys:getAction(key)
    if act=='up' or act=='down' then
        if not (isCtrlPressed() or isShiftPressed() or isAltPressed()) then
            local sel=listBox:getItem()
            listBox:arrowKey(key)
            if listBox:getItem()~=sel then
                FMOD.effect(listBox.sound_select)
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
            if not WIDGET.isFocus(inputBox) then
                WIDGET.focus(inputBox)
            end
        end
    elseif key=='delete' or key=='backspace' then
        inputBox:keypress(key)
    elseif not isRep then
        if act=='select' then
            if selected~=listBox:getItem() and listBox:getItem() then
                listBox.code()
                FMOD.effect(listBox.sound_click)
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
    if not WIDGET.isFocus(listBox) and love.mouse.isDown(1) and x and y and inScreen(x,y) then
        scroll(dy)
    end
end
function scene.mouseDown(_,_,k)
    if k==2 then
        close()
    end
end
function scene.touchMove(x,y,_,dy)
    if not WIDGET.isFocus(listBox) and inScreen(x,y) then
        scroll(dy)
    end
end

function scene.wheelMoved(_,y)
    if not WIDGET.isFocus(listBox)then
        scroll(y*62)
    else
        return true
    end
end

function scene.update(dt)
    if aboveScene.update then
        aboveScene.update(dt)
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
    searchTimer=searchTimer+dt
    if searchTimer>.26 then
        local prompt=inputBox:getText():trim()
        if (prompt=='' or #prompt>=2) and prompt~=lastSearchText then
            lastSearchText=prompt
            search(lastSearchText)
        end
        searchTimer=0
    end
    if kbIsDown('up','down') and (isCtrlPressed() or isShiftPressed() or isAltPressed()) then
        scroll(260*dt*(kbIsDown('up') and 1 or -1))
    end
end

function scene.draw()
    -- Previous scene's things
    if aboveScene.draw then
        aboveScene.draw()
    end
    if aboveScene.widgetList then
        gc_replaceTransform(SCR.xOy)
        WIDGET.draw(aboveScene.widgetList)
    end

    -- Dark background
    gc_replaceTransform(SCR.origin)
    gc_setColor(.1,.1,.1,time*.8)
    gc_rectangle('fill',0,0,SCR.w,SCR.h)

    -- Dictionary
    gc_replaceTransform(SCR.xOy_m)
    gc_translate(mainX,50*(1-time))

    -- Dark shade
    gc_setLineWidth(10)
    gc_setColor(.45,.45,.45,time)
    gc_translate(5,5)
    gc_rectangle('line',-5,-mainH/2-5,mainW+10,mainH+10,10)
    gc_rectangle('line',-listW-5,-listH/2-5,listW,listH+10,10)
    gc_line(-5,mainH/2-searchH,mainW+5,mainH/2-searchH)
    gc_translate(-5,-5)

    -- Light frame
    gc_setColor(.62,.62,.62,time)
    gc_rectangle('line',-5,-mainH/2-5,mainW+10,mainH+10,10)
    gc_rectangle('line',-listW-5,-listH/2-5,listW,listH+10,10)
    gc_line(-5,mainH/2-searchH,mainW+5,mainH/2-searchH)

    -- Screen
    gc_setColor(.4,.45,.55,time*.4)
    gc_rectangle('fill',0,-mainH/2,mainW,mainH-searchH-5,5)
    gc_rectangle('fill',0,mainH/2-searchH+5,mainW,searchH-5,5)
    gc_rectangle('fill',-listW,-listH/2,listW-10,listH,5)

    -- Title & Content
    gc_stc_reset()
    gc_stc_rect(0,-mainH/2,mainW,mainH-searchH-5,5)
    gc_setColor(categoryColor[selected.cat].content)
        gc_translate(0,-contents.scroll)
        -- Title
        gc_draw(contents.title,15,-mainH/2+5,nil,math.min(1,(mainW-25)/contents.title:getWidth()),1)
        gc_translate(0,contents.title:getHeight())

        -- Content
        FONT.set(selected.contentSize)
        local fontH=FONT.get(selected.contentSize):getHeight()
        gc_translate(0,-mainH/2+5)
        for _,line in next,contents.texts do
            if love.keyboard.isDown('f1') then
                gc_setLineWidth(1)
                gc_rectangle('line',15,0,mainW-25,line.height)
            end
            if line.divider then
                gc_setLineWidth(line.divider)
                gc_line(15,line.height/2,mainW-10,line.height/2)
            elseif line.text then
                gc_print(line.text,15,(line.height-fontH)/2)
            end
            gc_translate(0,line.height)
        end
    gc_stc_stop()
end

scene.widgetList={
    listBox,
    inputBox,
    copyButton,
    linkButton,
    {type='button',pos={.5,.5},x=mainX+mainW+70,y=-310,w=80,h=80,sound_trigger=false,lineWidth=4,fontSize=60,text=CHAR.icon.cross_big,code=close},
    {
        type='button',pos={.5,.5},x=mainX+mainW+70,y=320,w=80,h=80,sound_trigger='button_soft',lineWidth=4,fontSize=50,text="写",
        code=WIDGET.c_goScn('zeta_input_method','none'),
        visibleFunc=function() return SETTINGS._system.locale=='zh' end,
    },
}
return scene
