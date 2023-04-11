local gc=love.graphics
local gc_setColor=gc.setColor
local gc_print,gc_printf=gc.print,gc.printf
local setFont=FONT.set

local max,min=math.max,math.min
local sin=math.sin

local selected,fullband
local collectCount=0
local noProgress=false
local autoplay=false

local bigTitle=setmetatable({},{
    __index=function(self,name)
        local up=true
        local s=''
        for c in name:gmatch'.' do
            if up then
                c=c:upper()
                up=false
            else
                up=c:match'%s'
            end
            s=s..c
        end
        self[name]=s
        return self[name]
    end
})

local musicListBox do
    musicListBox={type='listBox',pos={1,.5},x=-800,y=-320,w=700,h=500,lineHeight=80}
    function musicListBox.drawFunc(name,_,sel)
        if sel then
            gc_setColor(1,1,1,.26)
            gc.rectangle('fill',0,0,700,80)
        end
        setFont(60)
        gc_setColor(name==selected and COLOR.L or COLOR.LD)
        gc_print(bigTitle[name],20,4)
        setFont(20)
        gc_printf(bgmList[name].author,0,45,685,'right')
        if sel and name~=selected then
            setFont(100)
            gc_setColor(COLOR.L)
            GC.mStr(CHAR.icon.play,350,-20)
        end
    end
    function musicListBox.code()
        if selected~=musicListBox:getItem() then
            selected=musicListBox:getItem()
            if noProgress or PROGRESS.getBgmUnlocked(selected)==2 then
                fullband=fullband==true
            else
                fullband=nil
            end
            playBgm(selected,fullband==nil and 'simp' or fullband and 'full' or 'base',noProgress and '-noProgress' or '')
        end
    end
    musicListBox=WIDGET.new(musicListBox)
end
local progressBar=WIDGET.new{type='slider_progress',pos={1,.5},x=-1500,y=230,w=1400,
    disp=function() return BGM.tell()/BGM.getDuration()%1 end,
    code=function(v) BGM.set('all','seek',v*BGM.getDuration()) end,
    visibleFunc=function() return BGM.isPlaying() end,
}


local scene={}

function scene.enter()
    selected,fullband=getBgm()
    if not selected then selected='blank' end
    if PROGRESS.getBgmUnlocked(selected)==2 then
        fullband=fullband=='full'
    else
        fullband=nil
    end
    local l={}
    for k in next,bgmList do
        if noProgress or PROGRESS.getBgmUnlocked(k) then
            table.insert(l,k)
        end
    end
    table.sort(l)
    collectCount=#l
    musicListBox:setList(l)
    musicListBox:select(TABLE.find(musicListBox:getList(),selected))

    if SETTINGS.system.bgmVol<.0626 then
        MES.new('warn',Text.musicroom_lowVolume)
    end
end

function scene.keyDown(key,isRep)
    local act=KEYMAP.sys:getAction(key)
    if act=='up' or act=='down' then
        musicListBox:arrowKey(key)
    elseif act=='left' or act=='right' then
        if BGM.isPlaying() then
            BGM.set('all','seek',key=='left' and max(BGM.tell()-5,0) or (BGM.tell()+5)%BGM.getDuration())
        end
    elseif #key==1 and key:find'[0-9a-z]' then
        local list=musicListBox:getList()
        local sel=musicListBox:getSelect()
        for _=1,#list do
            sel=(sel-1+(love.keyboard.isDown('lshift','rshift') and -1 or 1))%#list+1
            if list[sel]:sub(1,1)==key then
                musicListBox:select(sel)
                break
            end
        end
    elseif not isRep then
        if key=='space' then
            if BGM.isPlaying() then
                BGM.stop(.26)
            else
                playBgm(selected,fullband and 'full' or 'base',noProgress and '-noProgress' or '')
            end
            progressBar:reset()
        elseif key=='tab' then
            local w=scene.widgetList[love.keyboard.isDown('lctrl','rctrl') and 'autoplay' or 'fullband']
            if w._visible then
                w.code()
            end
        elseif key=='return' then
            if selected~=musicListBox:getItem() then
                musicListBox.code()
            end
        elseif key=='home' then
            BGM.set('all','seek',0)
        elseif key=='`' and love.keyboard.isDown('lalt','ralt') then
            noProgress=true
            scene.enter()
        elseif act=='back' then
            SCN.back('fadeHeader')
        end
    end
end

function scene.update(dt)
    if autoplay and BGM.isPlaying() then
        if autoplay>0 then
            autoplay=max(autoplay-dt,0)
        else
            if BGM.getDuration()-BGM.tell()<.26 then
                autoplay=math.random(42,120)
                fullband=MATH.roll(.42)

                local list,r=musicListBox:getList()
                repeat
                    r=math.random(#list)
                until list[r]~=musicListBox:getItem()
                musicListBox:select(r)
                musicListBox.code()
            else
                autoplay=.0626
            end
        end
    end
end

local objText,titleTextObj='',gc.newText(FONT.get(90,'bold'))
function scene.draw()
    PROGRESS.drawExteriorHeader()

    gc.replaceTransform(SCR.xOy_r)

    -- Song title
    if objText~=bigTitle[selected] then
        objText=bigTitle[selected]
        titleTextObj:set(bigTitle[selected])
    end
    local t=love.timer.getTime()
    gc_setColor(sin(t*.5)*.2+.8,sin(t*.7)*.2+.8,sin(t)*.2+.8)
    gc.draw(titleTextObj,-900,-100,0,min(1,650/titleTextObj:getWidth()),nil,titleTextObj:getWidth(),titleTextObj:getHeight())

    -- Author and message
    setFont(50)
    gc_setColor(COLOR.L)
    gc_printf(bgmList[selected].author,-1600,-90,700,'right')
    if bgmList[selected].message then
        setFont(30)
        gc_setColor(COLOR.LD)
        gc_printf(bgmList[selected].message,-1600,0,700,'right')
    end

    -- Time
    if BGM.tell() then
        setFont(30)
        gc_setColor(COLOR.L)
        gc_printf(STRING.time_simp(BGM.tell()%BGM.getDuration()),-1500,260,626,'left')
        gc_printf(STRING.time_simp(BGM.getDuration()),-100-626,260,626,'right')
    end

    -- Collecting progress
    gc_setColor(COLOR.L)
    gc.setLineWidth(2)
    gc.line(-99,-320,-99,-365,-235,-365,-255,-320)
    setFont(30)
    gc_printf(collectCount.."/"..bgmCount,-105-626,-362,626,'right')

    -- Autoswitch timer
    if autoplay then
        gc_setColor(COLOR.L)
        gc.setLineWidth(2)
        gc.circle('line',-1470,95,20)
        gc_setColor(1,1,1,.26)
        gc.arc('fill','pie',-1470,95,20,-MATH.pi/2,-MATH.pi/2+autoplay/120*MATH.tau)
    end
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_musicroom'},

    musicListBox,
    progressBar,

    -- Play/Stop
    WIDGET.new{type='button_invis',pos={1,.5},x=-800,y=360,w=160,cornerR=80,text=CHAR.icon.play,fontSize=90,code=WIDGET.c_pressKey'space',visibleFunc=function() return not BGM.isPlaying() end},
    WIDGET.new{type='button_invis',pos={1,.5},x=-800,y=360,w=160,cornerR=80,text=CHAR.icon.stop,fontSize=90,code=WIDGET.c_pressKey'space',visibleFunc=function() return BGM.isPlaying() end},

    -- Fullband Switch
    WIDGET.new{type='switch',pos={1,.5},x=-1450,y=360,h=50,widthLimit=260,labelPos='right',disp=function() return fullband end,
        name='fullband',text=LANG'musicroom_fullband',
        sound_on=false,sound_off=false,
        code=function()
            fullband=not fullband
            if BGM.isPlaying() then
                BGM.set(bgmList[selected].add,'volume',fullband and 1 or 0,.26)
            elseif SETTINGS.system.bgmVol==0 and MATH.roll(0.1) then
                noProgress=true
                scene.enter()
            end
        end,
        visibleFunc=function()
            return fullband~=nil and bgmList[selected].base
        end,
    },
    -- Auto Switching Switch
    WIDGET.new{type='switch',pos={1,.5},x=-1450,y=150,h=50,widthLimit=260,labelPos='right',disp=function() return autoplay end,
        name='autoplay',text=LANG'musicroom_autoplay',
        sound_on=false,sound_off=false,
        code=function()
            if autoplay then
                autoplay=false
            else
                autoplay=math.random(42,120)
            end
        end,
    },

    -- Volume slider
    WIDGET.new{type='slider_progress',pos={1,.5},x=-350,y=360,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
}

return scene
