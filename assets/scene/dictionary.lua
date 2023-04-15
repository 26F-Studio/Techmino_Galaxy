local ins=table.insert
local gc=love.graphics
local scene={}

local prevScene
local time,quiting
local selected
local baseDict=require('assets/basedictionary')
local dispDict={}
local currentDict={locale=false}
local enDict=FILE.load('assets/language/dict_en.lua','-lua -canskip')
local index={
    type='listBox',pos={.5,.5},x=-630,y=-300,w=240,h=600,
    lineHeight=40,cornerR=5,
    scrollBarWidth=5,
    scrollBarDist=12,
    scrollBarColor=COLOR.lY,
    activeColor={0,0,0,0},idleColor={0,0,0,0},
}
local categoryColor={
    about=     {[false]=COLOR.LF,[true]=COLOR.F, text=COLOR.lF},
    tutorial=  {[false]=COLOR.LY,[true]=COLOR.Y, text=COLOR.lY},
    concept=   {[false]=COLOR.LB,[true]=COLOR.lB,text=COLOR.LB},
    technique= {[false]=COLOR.LG,[true]=COLOR.G, text=COLOR.lG},
    other=     {[false]=COLOR.LM,[true]=COLOR.M, text=COLOR.lM},
}
function index.drawFunc(obj,_,sel)
    if sel then
        gc.setColor(1,1,1,.26)
        gc.rectangle('fill',0,0,240,40)
    end
    FONT.set(30,'norm')
    GC.stc_reset()
    GC.stc_rect(0,0,240,40)
    gc.setColor(categoryColor[obj.cat][selected==obj])
    gc.print(obj.title,5,0)
    GC.stc_stop()
end
function index.code()
    if selected~=index:getItem() then
        selected=index:getItem()
    end
end
index=WIDGET.new(index)

local function freshIndexPanelPos()
    index._y=200+50*(1-time)
end
function scene.enter()
    local target=SCN.args[1] or 'aboutDict'

    time=0
    freshIndexPanelPos()

    quiting=false
    prevScene=SCN.stack[#SCN.stack-1]
    selected=false

    -- Initialize dictionary for current language (if need)
    if currentDict.locale~=SETTINGS.system.locale then
        currentDict=FILE.load('assets/language/dict_'..SETTINGS.system.locale..'.lua','-lua -canskip')
        if not currentDict then
            currentDict={aboutDict={title="[No Dict Data]",content="No dictionary file detected."}};
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
            obj.title=curObj.title or enObj.title or '['..obj.id..']';
            obj.titleSize=obj.content==curObj.content and curObj.titleSize or obj.content==enObj.content and enObj.titleSize or 50
            obj.content=curObj.content or enObj.content or '[No Data]';
            obj.contentSize=obj.content==curObj.content and curObj.contentSize or obj.content==enObj.content and enObj.contentSize or 30

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
    index:setList(dispDict)
    if selectedNum then index:select(selectedNum)end
    index._scrollPos1=index._scrollPos
end

local function back()
    quiting=true
end
function scene.keyDown(key)
    local action=KEYMAP.sys:getAction(key)
    if action=='left' then
        -- TODO
    elseif action=='help' or action=='back' then
        back()
    end
end

function scene.update(dt)
    if prevScene then
        SCN.scenes[prevScene].update(dt)
    end
    if quiting then
        time=math.max(time-12.6*dt,0)
        freshIndexPanelPos()
        if time<=0 then
            SCN.back('none')
        end
    elseif time<1 then
        time=math.min(time+6.26*dt,1)
        freshIndexPanelPos()
    end
end

local frame=10
local w,h=900,700
local w2,h2=250,600

function scene.draw()
    -- Draw previous scene's things
    if prevScene then
        SCN.scenes[prevScene].draw()
    end
    gc.replaceTransform(SCR.xOy)
    WIDGET._draw(SCN.scenes[prevScene].widgetList)

    -- Dark background
    gc.replaceTransform(SCR.origin)
    gc.setColor(.1,.1,.1,time*.8)
    gc.rectangle('fill',0,0,SCR.w,SCR.h)

    -- Dictionary
    gc.replaceTransform(SCR.xOy_m)
    gc.translate(70-w/2,50*(1-time))

    -- Dark shade
    gc.setLineWidth(frame)
    gc.setColor(.44,.44,.44,time)
    gc.translate(5,5)
    gc.rectangle('line',-frame/2,-h/2-frame/2,w+frame,h+frame,10)
    gc.rectangle('line',-w2-frame/2,-h2/2-frame/2,w2,h2+frame,10)
    gc.translate(-5,-5)

    -- Light frame
    gc.setColor(.62,.62,.62,time)
    gc.rectangle('line',-frame/2,-h/2-frame/2,w+frame,h+frame,10)
    gc.rectangle('line',-w2-frame/2,-h2/2-frame/2,w2,h2+frame,10)

    -- Screen
    gc.setColor(.38,.44,.54,time*.4)
    gc.rectangle('fill',0,-h/2,w,h,5)
    gc.rectangle('fill',-w2,-h2/2,w2-frame,h2,5)

    gc.setColor(categoryColor[selected.cat].text)
    -- Title
    gc.draw(selected.titleText,15,-h/2+5,nil,math.min(1,(w-25)/selected.titleText:getWidth()),1)

    gc.translate(0,selected.titleText:getHeight()+5)
    -- Line
    GC.setLineWidth(2)
    gc.line(15,-h/2,w-10,-h/2)
    -- Content
    FONT.set(selected.contentSize)
    gc.printf(selected.content,15,-h/2+5,w-30,'left')
end

scene.widgetList={
    WIDGET.new{type='button',pos={.5,.5},x=600,y=-310,w=80,h=80,lineWidth=4,cornerR=0,fontSize=60,text=CHAR.icon.cross_big,code=back,visibleFunc=function() return not quiting end},
    index,
}
return scene
