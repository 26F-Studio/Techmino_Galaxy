local gc=love.graphics
local gc_setColor=gc.setColor
local gc_print,gc_printf=gc.print,gc.printf
local setFont=FONT.set

local max,min=math.max,math.min
local sin=math.sin

local totalBgmCount

local selected,fullband
local collectCount=0
local noProgress=false
local autoplay=false ---@type number|false
local fakeProgress=0
local searchStr,searchTimer
local noResponseTimer=6.26

---@type Zenitha.Scene
local scene={}

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
local bgmList={
    ['8-bit happiness']       ={author="MrZ"},
    ['8-bit sadness']         ={author="MrZ"},
    ['antispace']             ={author="MrZ",message="Space VMX"},
    ['battle']                ={author="Aether & MrZ"},
    ['blank']                 ={author="MrZ",message="The beginning"},
    ['blox']                  ={author="MrZ",message="Old song remix"},
    ['distortion']            ={author="MrZ",message="Someone said that 'rectification' is too flat"},
    ['down']                  ={author="MrZ"},
    ['dream']                 ={author="MrZ"},
    ['echo']                  ={author="MrZ",message="Canon experiment"},
    ['exploration']           ={author="MrZ",message="Let's explore the universe"},
    ['far']                   ={author="MrZ"},
    ['hope']                  ={author="MrZ"},
    ['infinite']              ={author="MrZ"},
    ['lounge']                ={author="Hailey (cudsys) & MrZ",message="Welcome to Space Café"},
    ['minoes']                ={author="MrZ",message="Old song remix"},
    ['moonbeam']              ={author="Beethoven & MrZ"},
    ['new era']               ={author="MrZ"},
    ['overzero']              ={author="MrZ",message="Blank VMX"},
    ['oxygen']                ={author="MrZ"},
    ['peak']                  ={author="MrZ",message="3D pinball is fun!"},
    ['pressure']              ={author="MrZ"},
    ['push']                  ={author="MrZ"},
    ['race']                  ={author="MrZ"},
    ['reason']                ={author="MrZ"},
    ['rectification']         ={author="MrZ",message="Someone said that 'Distortion' is too noisy"},
    ['reminiscence']          ={author="MrZ",message="Nitrome games are fun!"},
    ['secret7th']             ={author="MrZ",message="The 7th secret"},
    ['secret8th']             ={author="MrZ",message="The 8th secret"},
    ['shining terminal']      ={author="MrZ"},
    ['sine']                  ={author="MrZ",message="~~~~~~"},
    ['space']                 ={author="MrZ",message="Blank VMX"},
    ['spring festival']       ={author="MrZ",message="Happy New Year!"},
    ['storm']                 ={author="MrZ",message="Remake of a milestone"},
    ['sugar fairy']           ={author="Tchaikovsky & MrZ",message="A little dark remix"},
    ['subspace']              ={author="MrZ",message="Blank VMX"},
    ['supercritical']         ={author="MrZ"},
    ['truth']                 ={author="MrZ",message="Firefly in a Fairytale Remix"},
    ['vapor']                 ={author="MrZ",message="Here is my water!"},
    ['venus']                 ={author="MrZ"},
    ['warped']                ={author="MrZ"},
    ['waterfall']             ={author="MrZ"},
    ['way']                   ={author="MrZ"},
    ['xmas']                  ={author="MrZ",message="Merry Christmas!"},
    ['empty']                 ={author="ERM",message="First blank remix from community"},
    ['none']                  ={author="MrZ",message="Blank VMX"},
    ['nil']                   ={author="MrZ",message="Blank VMX"},
    ['null']                  ={author="MrZ",message="Blank VMX"},
    ['vacuum']                ={author="MrZ",message="Blank VMX"},
    ['blank orchestra']       ={author="T0722",message="A cool blank remix"},
    ['jazz nihilism']         ={author="Trebor",message="A cool blank remix"},
    ['beat5th']               ={author="MrZ",message="5/4 experiment"},
    ['super7th']              ={author="MrZ",message="FL experiment"},
    ['secret8th remix']       ={author="MrZ"},
    ['shift']                 ={author="MrZ"},
    ['here']                  ={author="MrZ"},
    ['there']                 ={author="MrZ"},
    ['1980s']                 ={author="C₂₉H₂₅N₃O₅",message="Old song remix"},
    ['sakura']                ={author="ZUN & C₂₉H₂₅N₃O₅",plain=true},
    ['malate']                ={author="ZUN & C₂₉H₂₅N₃O₅"},
    ['shibamata']             ={author="C₂₉H₂₅N₃O₅",message="Nice song, Nice remix"},
    ['race remix']            ={author="柒栎流星",plain=true},
    ['secret7th remix']       ={author="柒栎流星",plain=true},
    ['propel']                ={author="TetraCepra",message="A cool push remix"},
    ['gallery']               ={author="MrZ",message="A venus remix"},
    ['subzero']               ={author="TetraCepra",message="A cool blank remix"},
    ['infinitesimal']         ={author="TetraCepra",message="A cool blank remix"},
    ['vanifish']              ={author="Trebor & MrZ",message="A cool blank remix"},
    ['gelly']                 ={author="MrZ",message="Old song remix"},
    ['humanity']              ={author="MrZ"},
    ['space retro']           ={author="LR & MrZ"},
}

local musicListBox do
    musicListBox={
        type='listBox',pos={.5,.5},x=0,y=-320,w=700,h=500,
        lineHeight=80,
        scrollBarWidth=5,
        scrollBarDist=4,
        scrollBarColor='dL',
        activeColor='L',idleColor='L',
    }
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
            GC.mStr(CHAR.icon.play,350,-25)
        end
    end
    function musicListBox.code()
        if selected~=musicListBox:getItem() then
            selected=musicListBox:getItem()
            local fullBandMode=not bgmList[selected].plain and (noProgress or PROGRESS.getBgmUnlocked(selected)==2)
            scene.widgetList.fullband:setVisible(fullBandMode)
            if fullBandMode then
                fullband=fullband==true
            else
                fullband=nil
            end
            playBgm(selected,fullband,noProgress)
        end
    end
    ---@type Zenitha.Widget.listBox
    musicListBox=WIDGET.new(musicListBox)
end

---@type Zenitha.Widget.slider_progress
local progressBar=WIDGET.new{type='slider_progress',pos={.5,.5},x=-700,y=230,w=1400,
    disp=function() return fakeProgress end,
    code=function(v,mode)
        fakeProgress=v
        if mode=='release' then
            FMOD.music.seek(v*FMOD.music.getDuration())
        end
    end,
    visibleTick=function() return FMOD.music.getPlaying() end,
}

function scene.enter()
    noResponseTimer=-1
    scene.focus(true)
    selected=getBgm()
    fakeProgress=0
    searchStr,searchTimer="",0
    if not selected then selected='blank' end
    local l={}
    for k in next,bgmList do
        if noProgress or PROGRESS.getBgmUnlocked(k) then
            table.insert(l,k)
        end
    end
    table.sort(l)
    collectCount=#l
    totalBgmCount=totalBgmCount or TABLE.getSize(bgmList)
    musicListBox:setList(l)
    musicListBox:select(TABLE.find(musicListBox:getList(),selected))
    musicListBox.code()

    if SETTINGS.system.bgmVol<.0626 then
        MSG.new('warn',Text.musicroom_lowVolume)
    end
end
function scene.leave()
    scene.focus(true)
end

local function searchMusic(str)
    local bestID,bestDist=-1,999
    local list=musicListBox:getList()
    for i=1,#list do
        local dist=list[i]:find(str)
        if dist and dist<bestDist then
            bestID,bestDist=i,dist
        end
    end
    if bestID>0 then
        musicListBox:select(bestID)
    end
end
function scene.keyDown(key,isRep)
    scene.focus(true)
    local act=KEYMAP.sys:getAction(key)
    if act=='up' or act=='down' then
        musicListBox:arrowKey(key)
    elseif act=='left' or act=='right' then
        if FMOD.music.getPlaying() then
            local now=FMOD.music.tell()
            local dur=FMOD.music.getDuration()
            FMOD.music.seek(key=='left' and max(now-5,0) or (now+5)%dur)
        end
    elseif #key==1 and key:find'[0-9a-z]' then
        if searchTimer==0 then
            searchStr=""
        end
        if #searchStr<26 then
            searchStr=searchStr..key
            searchTimer=1.26
            searchMusic(searchStr)
        end
    elseif not isRep then
        if key=='space' then
            if FMOD.music.getPlaying() then
                stopBgm()
            else
                playBgm(selected,fullband,noProgress)
            end
            progressBar:reset()
        elseif key=='tab' then
            if isCtrlPressed() then
                scene.widgetList.autoplay.code()
            else
                scene.widgetList.fullband.code()
            end
        elseif key=='`' and isAltPressed() then
            noProgress=true
            scene.enter()
        elseif key=='return' then
            if selected~=musicListBox:getItem() then
                musicListBox.code()
            end
        elseif key=='home' then
            FMOD.music.seek(0)
        elseif act=='back' then
            SCN.back('fadeHeader')
        end
    end
    return true
end
function scene.mouseMove() scene.focus(true) end
function scene.touchDown() scene.focus(true) end
function scene.focus(f) -- Reduce carbon footprint for music lovers
    if f then
        if noResponseTimer<=0 then
            ZENITHA.setMaxFPS(SETTINGS.system.maxFPS)
            ZENITHA.setUpdateFreq(SETTINGS.system.updRate)
            ZENITHA.setDrawFreq(SETTINGS.system.drawRate)
        end
        noResponseTimer=6.26
    else
        ZENITHA.setMaxFPS(26)
        ZENITHA.setUpdateFreq(26)
        ZENITHA.setDrawFreq(26)
    end
end

function scene.update(dt)
    if noResponseTimer>0 then
        noResponseTimer=noResponseTimer-dt
        if noResponseTimer<=0 then
            scene.focus(false)
        end
    end
    if searchTimer>0 then
        searchTimer=max(searchTimer-dt,0)
    end
    if autoplay and FMOD.music.getPlaying() then
        if autoplay>0 then
            autoplay=max(autoplay-dt,0)
        else
            if FMOD.music.getDuration()-FMOD.music.tell()<.26 then
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
    if not love.mouse.isDown(1,2,3) and FMOD.music.getPlaying() then
        fakeProgress=FMOD.music.tell()/FMOD.music.getDuration()%1
    end
end

local objText,titleTextObj='',gc.newText(FONT.get(90,'bold'))
function scene.draw()
    PROGRESS.drawExteriorHeader()

    gc.replaceTransform(SCR.xOy_m)

    -- Song title
    if objText~=bigTitle[selected] then
        objText=bigTitle[selected]
        titleTextObj:set(bigTitle[selected])
    end
    local t=love.timer.getTime()
    gc_setColor(sin(t*.5)*.2+.8,sin(t*.7)*.2+.8,sin(t)*.2+.8)
    gc.draw(titleTextObj,-100,-100,0,min(1,650/titleTextObj:getWidth()),nil,titleTextObj:getWidth(),titleTextObj:getHeight())

    -- Author and message
    setFont(50)
    gc_setColor(COLOR.L)
    gc_printf(bgmList[selected].author,-800,-90,700,'right')
    if bgmList[selected].message then
        setFont(30)
        gc_setColor(COLOR.LD)
        gc_printf(bgmList[selected].message,-800,0,700,'right')
    end

    -- Time
    if FMOD.music.getPlaying() then
        setFont(30)
        gc_setColor(COLOR.L)
        gc_printf(STRING.time_simp(FMOD.music.tell()%FMOD.music.getDuration()),-700,260,626,'left')
        gc_printf(STRING.time_simp(FMOD.music.getDuration()),700-626,260,626,'right')
    end

    -- Searching
    if searchTimer>0 then
        gc_setColor(1,1,1,searchTimer*1.26)
        setFont(30)
        gc_print(searchStr,0,-360)
    end

    -- Collecting progress
    gc_setColor(COLOR.L)
    gc.setLineWidth(2)
    gc.line(701,-320,701,-365,565,-365,545,-320)
    setFont(30)
    gc_printf(collectCount.."/"..totalBgmCount,695-626,-362,626,'right')

    -- Autoswitch timer
    if autoplay then
        gc_setColor(COLOR.L)
        gc.setLineWidth(2)
        gc.circle('line',-670,95,20)
        gc_setColor(1,1,1,.26)
        gc.arc('fill','pie',-670,95,20,-MATH.pi/2,-MATH.pi/2+autoplay/120*MATH.tau)
    end
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'musicroom_title'},

    musicListBox,
    progressBar,

    -- Play/Stop
    {type='button_invis',pos={.5,.5},x=0,y=360,w=160,cornerR=80,text=CHAR.icon.play,fontSize=90,code=WIDGET.c_pressKey'space',visibleTick=function() return not FMOD.music.getPlaying() end},
    {type='button_invis',pos={.5,.5},x=0,y=360,w=160,cornerR=80,text=CHAR.icon.stop,fontSize=90,code=WIDGET.c_pressKey'space',visibleTick=function() return FMOD.music.getPlaying() end},

    -- Auto Switching Switch
    {type='switch',pos={.5,.5},x=-650,y=150,h=50,widthLimit=260,labelPos='right',disp=function() return autoplay end,
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

    -- Fullband Switch
    {type='switch',pos={.5,.5},x=-650,y=360,h=50,widthLimit=260,labelPos='right',disp=function() return fullband end,
        name='fullband',text=LANG'musicroom_fullband',
        sound_on=false,sound_off=false,
        code=function()
            fullband=not fullband
            if FMOD.music.getPlaying() then
                FMOD.music.setParam('intensity',fullband and 1 or 0)
            elseif SETTINGS.system.bgmVol==0 and MATH.roll(0.1) then
                noProgress=true
                scene.enter()
            end
        end,
        visibleTick=function()
            return fullband~=nil
        end,
    },

    -- Volume slider
    {type='slider_progress',pos={.5,.5},x=450,y=360,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
}

return scene
