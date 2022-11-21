local selected,fullband
local collectCount=0
local noProgress=false

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
            GC.setColor(1,1,1,.26)
            GC.rectangle('fill',0,0,700,80)
        end
        FONT.set(60)
        GC.setColor(name==selected and COLOR.L or COLOR.LD)
        GC.print(bigTitle[name],20,4)
        FONT.set(20)
        GC.printf(bgmList[name].author,0,45,685,'right')
        if sel and name~=selected then
            FONT.set(100)
            GC.setColor(COLOR.L)
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
            playBgm(selected,fullband==nil and 'simp' or fullband and 'full' or 'base','',noProgress)
        end
    end
    musicListBox=WIDGET.new(musicListBox)
end

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
end

function scene.keyDown(key,isRep)print(key,isRep)
    if key=='space' then
        if BGM.isPlaying() then
            BGM.stop()
        else
            playBgm(selected,fullband and 'full' or 'base','',noProgress)
        end
    elseif key=='tab' then
        local w=scene.widgetList.fullband
        if w._visible then
            w.code()
        end
    elseif key=='up' or key=='down' then
        musicListBox:arrowKey(key)
    elseif key=='return' then
        if selected~=musicListBox:getItem() then
            musicListBox.code()
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
    elseif key=='`' and love.keyboard.isDown('lalt','ralt') then
        noProgress=true
        scene.enter()
    elseif key=='escape' then
        SCN.back('fadeHeader')
    end
end

local objText,titleTextObj='',GC.newText(FONT.get(90,'bold'))
function scene.draw()
    PROGRESS.drawExteriorHeader()

    GC.replaceTransform(SCR.xOy_l)

    -- Song title
    if objText~=bigTitle[selected] then
        objText=bigTitle[selected]
        titleTextObj:set(bigTitle[selected])
    end
    local t=love.timer.getTime()
    GC.setColor(math.sin(t*.5)*.2+.8,math.sin(t*.7)*.2+.8,math.sin(t)*.2+.8)
    GC.draw(titleTextObj,700,-100,0,math.min(1,650/titleTextObj:getWidth()),nil,titleTextObj:getWidth(),titleTextObj:getHeight())

    -- Author and message
    FONT.set(50)
    GC.setColor(COLOR.L)
    GC.printf(bgmList[selected].author,0,-90,700,'right')
    if bgmList[selected].message then
        FONT.set(30,'thin')
        GC.setColor(COLOR.LD)
        GC.printf(bgmList[selected].message,0,0,700,'right')
    end

    if BGM.tell() then
        GC.replaceTransform(SCR.xOy_m)
        FONT.set(30)
        GC.setColor(COLOR.L)
        GC.printf(STRING.time_simp(BGM.tell()%BGM.getDuration()),-700,260,626,'left')
        GC.printf(STRING.time_simp(BGM.getDuration()),700-626,260,626,'right')
    end

    GC.replaceTransform(SCR.xOy_r)
    GC.setColor(COLOR.L)
    GC.setLineWidth(2)
    GC.line(-99,-320,-99,-365,-235,-365,-255,-320)
    FONT.set(30)
    GC.printf(collectCount.."/"..bgmCount,-105-626,-362,626,'right')
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_backScn'fadeHeader'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_musicroom'},

    musicListBox,

    -- Time bar
    WIDGET.new{type='slider_progress',pos={.5,.5},x=-700,y=230,w=1400,
        disp=function() return BGM.tell()/BGM.getDuration()%1 end,
        code=function(v) BGM.set('all','seek',v*BGM.getDuration()) end,
        visibleFunc=function() return BGM.isPlaying() end,
    },

    -- Play/Stop
    WIDGET.new{type='button_invis',pos={.5,.5},y=360,w=160,cornerR=80,text=CHAR.icon.play,fontSize=90,code=function() playBgm(selected,fullband and 'full' or 'base','',noProgress) end,visibleFunc=function() return not BGM.isPlaying() end},
    WIDGET.new{type='button_invis',pos={.5,.5},y=360,w=160,cornerR=80,text=CHAR.icon.stop,fontSize=90,code=function() BGM.stop() end,visibleFunc=function() return BGM.isPlaying() end},

    -- Fullband Switch
    WIDGET.new{type='switch',pos={0,.5},x=150,y=360,h=50,labelPos='right',disp=function() return fullband end,
        name='fullband',text=LANG'musicroom_fullband',
        sound_on=false,sound_off=false,
        code=function()
            fullband=not fullband
            if BGM.isPlaying() then
                BGM.set(bgmList[selected].add,'volume',fullband and 1 or 0,.26)
            end
        end,
        visibleFunc=function()
            return fullband~=nil and bgmList[selected].base
        end,
    },

    -- Volume slider
    WIDGET.new{type='slider_progress',pos={1,.5},x=-350,y=360,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
}

return scene
