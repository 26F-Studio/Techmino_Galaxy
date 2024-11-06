local gc=love.graphics
local gc_setColor=gc.setColor
local gc_print,gc_printf=gc.print,gc.printf
local setFont=FONT.set

local max,min=math.max,math.min
local sin=math.sin

local totalBgmCount

local selected,fullband,section
local collectCount=0
local noProgress=false
local autoplay=false ---@type number|false
local autoplayLastRec
local fakeProgress=0
local searchStr,searchTimer
local noResponseTimer=6.26

local _glitchProtect=false

---@type Zenitha.Scene
local scene={}

local musicListBox do
    musicListBox={
        type='listBox',pos={.5,.5},x=0,y=-320,w=700,h=500,
        name='musicList',
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
        gc_print(SONGBOOK[name].title,20,4)
        setFont(20)
        gc_printf(SONGBOOK[name].author,0,45,685,'right')
        if sel and name~=selected then
            setFont(100)
            gc_setColor(COLOR.L)
            GC.mStr(CHAR.icon.play,350,-25)
        end
    end
    function musicListBox.code()
        if selected~=musicListBox:getItem() then
            selected=musicListBox:getItem()
            local fullbandMode=SONGBOOK[selected].intensity and (noProgress or PROGRESS.getBgmUnlocked(selected)==2)
            local sectionMode=SONGBOOK[selected].section and (noProgress or PROGRESS.getBgmUnlocked(selected)==2)
            scene.widgetList.fullband:setVisible(fullbandMode)
            scene.widgetList.section:setVisible(sectionMode)
            scene.widgetList.progressBar.fillColor=SONGBOOK[selected].looppoint and COLOR.LD or COLOR.L
            if fullbandMode then fullband=fullband==true else fullband=nil end
            if sectionMode then section=section==true else section=nil end
            playBgm(selected,fullband,noProgress)
        end
    end
    ---@type Zenitha.Widget.listBox
    musicListBox=WIDGET.new(musicListBox)
end

---@type Zenitha.Widget.slider_progress
local progressBar=WIDGET.new{type='slider_progress',pos={.5,.5},x=-700,y=230,w=1400,
    name='progressBar',text='',
    disp=function() return fakeProgress end,
    code=function(v,mode)
        fakeProgress=v
        if mode=='release' then
            _glitchProtect=0.26
            FMOD.music.seek(v*FMOD.music.getDuration())
            if autoplay then
                autoplay=0.626
                autoplayLastRec=false
            end
        end
    end,
    visibleTick=function() return FMOD.music.getPlaying() end,
}

function scene.load()
    noResponseTimer=-1
    scene.focus(true)
    selected=getBgm()
    fakeProgress=0
    searchStr,searchTimer="",0
    if not selected then selected='blank' end
    local l={}
    for k in next,SONGBOOK do
        if noProgress or PROGRESS.getBgmUnlocked(k) then
            table.insert(l,k)
        end
    end
    table.sort(l)
    collectCount=#l
    if not totalBgmCount then
        totalBgmCount=0
        for _,data in next,SONGBOOK do
            if not data.inside then
                totalBgmCount=totalBgmCount+1
            end
        end
    end
    musicListBox:setList(l)
    musicListBox:select(TABLE.find(l,selected) or 1)
    musicListBox.code()

    if SETTINGS.system.bgmVol<.0626 then
        MSG.new('warn',Text.musicroom_lowVolume)
    end
end
function scene.unload()
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
local function timeBomb()
    TASK.yieldT(26)
    if TASK.getLock('musicroom_glitchFX') then
        FMOD.effect.keyOff('music_glitch')
        TASK.unlock('musicroom_glitchFX')
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
            FMOD.music.seek(act=='left' and max(now-5,0) or (now+5)%dur)
        end
    elseif key=='backspace' or key=='delete' then
        searchStr=""
    elseif #key==1 and key:find'[0-9a-z]' then
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
            elseif isShiftPressed() then
                scene.widgetList.section.code()
            else
                scene.widgetList.fullband.code()
            end
        elseif key=='return' then
            if selected~=musicListBox:getItem() then
                musicListBox.code()
            end
        elseif key=='home' then
            FMOD.music.seek(0)
        elseif act=='back' then
            SCN.back('fadeHeader')
        elseif key=='\\' then
            noProgress=true
            scene.load()
        elseif key=='f3' then
            if TASK.lock('musicroom_glitchFX') then
                FMOD.effect('music_glitch')
                TASK.new(timeBomb)
            end
        end
    end
    return true
end
function scene.mouseMove() scene.focus(true) end
function scene.mouseDown(_,_,k) scene.focus(true) end
function scene.wheelMove() scene.focus(true) end
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
        ZENITHA.hideCursor()
        noResponseTimer=-1
        ZENITHA.setMaxFPS(26)
        ZENITHA.setUpdateFreq(26)
        ZENITHA.setDrawFreq(26)
    end
end

function scene.update(dt)
    PROGRESS.updateMusicTime(dt)
    if noResponseTimer>0 then
        noResponseTimer=noResponseTimer-dt
        if noResponseTimer<=0 then
            scene.focus(false)
        end
    end
    if searchTimer>0 then
        searchTimer=max(searchTimer-dt,0)
        if searchTimer<=0 then
            if searchStr:sub(6)=='recoll' then
                PROGRESS.setSecret('musicroom_recollection')
            elseif searchStr=='piano' or searchStr=='liszt' then
                PROGRESS.setSecret('musicroom_piano')
                SCN.go('piano')
            elseif searchStr=='chord' then
                SCN.go('harmony4')
            end
            searchStr=""
        end
    end
    if autoplay and FMOD.music.getPlaying() then
        if autoplay>0 then
            autoplay=max(autoplay-dt,0)
        else
            if autoplayLastRec then
                if math.abs(FMOD.music.tell()-autoplayLastRec)>2.6 then
                    autoplay=math.random(42,126)
                    fullband=MATH.roll(.62)

                    local list,r=musicListBox:getList()
                    repeat
                        r=math.random(#list)
                    until list[r]~=musicListBox:getItem()
                    musicListBox:select(r)
                    musicListBox.code()
                else
                    autoplay=.26
                    autoplayLastRec=FMOD.music.tell()
                end
            else
                autoplayLastRec=FMOD.music.tell()
            end
        end
    end
    if WIDGET.sel~=progressBar or not love.mouse.isDown(1,2,3) and FMOD.music.getPlaying() then
        local v=FMOD.music.tell()/FMOD.music.getDuration()%1
        if _glitchProtect then
            if math.abs(fakeProgress-v)<.0026 then
                fakeProgress=v
                _glitchProtect=false
            else
                _glitchProtect=_glitchProtect-dt
                if _glitchProtect<=0 then
                    fakeProgress=v
                    _glitchProtect=false
                end
            end
        else
            fakeProgress=v
        end
    end
end

local objText,titleTextObj='',gc.newText(FONT.get(90,'bold'))
function scene.draw()
    PROGRESS.drawExteriorHeader()

    gc.replaceTransform(SCR.xOy_m)

    -- Song title
    if objText~=SONGBOOK[selected].title then
        objText=SONGBOOK[selected].title
        titleTextObj:set(SONGBOOK[selected].title)
    end
    local t=love.timer.getTime()
    if SONGBOOK[selected].inside then
        gc_setColor(1,1,1,MATH.roundUnit(.5+sin(6.2*t)*.26,.26))
        gc.draw(titleTextObj,-100,-100,0,min(1,650/titleTextObj:getWidth()),nil,titleTextObj:getWidth(),titleTextObj:getHeight())
    else
        local ox,oy=titleTextObj:getWidth(),titleTextObj:getHeight()
        local sx=min(1,650/ox)
        local r,g,b=sin(t*.5)*.2+.8,sin(t*.7)*.2+.8,sin(t)*.2+.8
        gc_setColor(r*.2,g*.2,b*.2)
        GC.strokeDraw('full',4,titleTextObj,-100,-100,0,sx,nil,ox,oy)
        gc_setColor(r*.4,g*.4,b*.4)
        GC.strokeDraw('side',2,titleTextObj,-100,-100,0,sx,nil,ox,oy)
        gc_setColor(r,g,b)
        gc.draw(titleTextObj,-100,-100,0,sx,nil,ox,oy)
    end

    -- Author and message
    setFont(50)
    gc_setColor(COLOR.L)
    gc_printf(SONGBOOK[selected].author,-800,-90,700,'right')
    if SONGBOOK[selected].message then
        setFont(30)
        gc_setColor(COLOR.LD)
        gc_printf(SONGBOOK[selected].message,-800,0,700,'right')
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
        gc.arc('fill','pie',-670,95,20,-MATH.pi/2,-MATH.pi/2+autoplay/126*MATH.tau)
    end
end

function scene.overDraw()
    if TASK.getLock('musicroom_glitchFX') then
        drawGlitch2()
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
                autoplay=math.random(42,126)
                autoplayLastRec=false
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
                scene.load()
            end
        end,
        visibleTick=function()
            return fullband~=nil
        end,
    },

    -- Section Switch
    {type='switch',pos={.5,.5},x=-650,y=430,h=50,widthLimit=260,labelPos='right',disp=function() return section end,
        name='section',text=LANG'musicroom_section',
        sound_on=false,sound_off=false,
        code=function()
            if section==nil then return end
            section=not section
            if FMOD.music.getPlaying() then
                FMOD.music.setParam('section',section and 1 or 0)
            end
        end,
        visibleTick=function()
            return section~=nil
        end,
    },

    -- Volume slider
    {type='slider_progress',pos={.5,.5},x=450,y=360,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},

    {type='button_invis',pos={1,0},x=-200,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.note_circ, sound_trigger='button_soft',code=WIDGET.c_goScn('piano'),visibleFunc=function() return PROGRESS.getSecret('musicroom_piano') end},
    -- {type='button_invis',pos={1,0},x=-400,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.note_circ, sound_trigger='button_soft',code=WIDGET.c_goScn('piano'),visibleFunc=function() return PROGRESS.getSecret('musicroom_piano') end},
    -- {type='button_invis',pos={1,0},x=-600,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.note_circ, sound_trigger='button_soft',code=WIDGET.c_goScn('piano'),visibleFunc=function() return PROGRESS.getSecret('musicroom_piano') end},
    -- {type='button_invis',pos={1,0},x=-800,y=60,w=80,cornerR=20,fontSize=70,text=CHAR.icon.note_circ, sound_trigger='button_soft',code=WIDGET.c_goScn('piano'),visibleFunc=function() return PROGRESS.getSecret('musicroom_piano') end},
}

return scene
