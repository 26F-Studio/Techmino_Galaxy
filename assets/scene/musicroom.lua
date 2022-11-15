local selected,fullband
local collectCount=0

local bigTitle=setmetatable({},{
    __index=function(self,name)
        local up=true
        local s=''
        for c in name:gmatch'.' do
            if up then
                s=s..c:upper()
                up=false
            else
                up=c:match'%s'
                s=s..c
            end
        end
        self[name]=s
        -- self[k]=k:sub(1,1):upper()..k:sub(2)
        return self[name]
    end
})

local musicListBox do
    musicListBox={type='listBox',pos={1,.5},x=-800,y=-400,w=700,h=500,lineHeight=80}
    function musicListBox.drawFunc(name,_,sel)
        if sel then
            GC.setColor(1,1,1,.26)
            GC.rectangle('fill',0,0,700,80)
        end
        FONT.set(60)
        GC.setColor(name==selected and COLOR.L or COLOR.LD)
        GC.print(bigTitle[name].." - "..bgmList[name].author,20,4)
        if sel and name~=selected then
            FONT.set(100)
            GC.setColor(COLOR.L)
            GC.mStr(CHAR.icon.play,350,-20)
        end
    end
    function musicListBox.code()
        if selected~=musicListBox:getItem() then
            selected=musicListBox:getItem()
            if PROGRESS.getBgmUnlocked(selected) and PROGRESS.getBgmUnlocked(selected)==2 then
                fullband=fullband==true
            else
                fullband=nil
            end
            playBgm(selected,fullband==nil and 'simp' or fullband and 'full' or 'base')
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
        if PROGRESS.getBgmUnlocked(k) then
            table.insert(l,k)
        end
    end
    table.sort(l)
    collectCount=#l
    musicListBox:setList(l)
    musicListBox:select(TABLE.find(musicListBox:getList(),selected))
end

function scene.keyDown(key,isRep)
    if isRep and not (key=='up' or key=='down') then return end
    if key=='space' then
        if BGM.isPlaying() then
            BGM.stop()
        else
            playBgm(selected,fullband and 'full' or 'base')
        end
    elseif key=='return' then
        if selected~=musicListBox:getItem() then
            musicListBox.code()
        end
    elseif key=='up' or key=='down' then
        musicListBox:arrowKey(key)
    elseif key=='tab'then
        local w=scene.widgetList.fullband
        if w._visible then
            w.code()
        end
    elseif key=='escape'then
        SCN.back()
    elseif #key==1 and key:find'[0-9a-z]'then
        local list=musicListBox:getList()
        local sel=musicListBox:getSelect()
        for _=1,#list do
            sel=(sel-1+(love.keyboard.isDown('lshift','rshift') and -1 or 1))%#list+1
            if list[sel]:sub(1,1)==key then
                musicListBox:select(sel)
                break
            end
        end
    end
end

local objText,titleTextObj='',GC.newText(FONT.get(90,'bold'))
function scene.draw()
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
        GC.printf(STRING.time_simp(BGM.tell()%BGM.getDuration()),-700,230,626,'left')
        GC.printf(STRING.time_simp(BGM.getDuration()),700-626,230,626,'right')
    end

    GC.replaceTransform(SCR.xOy_r)
    FONT.set(30)
    GC.printf(collectCount.."/"..bgmCount,-100-626,-450,626,'right')
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=2,cornerR=26,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
    musicListBox,
    WIDGET.new{type='slider_progress',pos={.5,.5},x=-700,y=200,w=1400,
        disp=function() return BGM.tell()/BGM.getDuration()%1 end,
        code=function(v) BGM.set('all','seek',v*BGM.getDuration()) end,
        visibleFunc=function() return BGM.isPlaying() end,
    },
    WIDGET.new{type='switch',pos={0,.5},x=150,y=350,h=50,labelPos='right',disp=function() return fullband end,
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
    WIDGET.new{type='button_invis',pos={.5,.5},y=350,w=160,cornerR=80,text=CHAR.icon.play,fontSize=90,code=function() playBgm(selected,fullband and 'full' or 'base') end,visibleFunc=function() return not BGM.isPlaying() end},
    WIDGET.new{type='button_invis',pos={.5,.5},y=350,w=160,cornerR=80,text=CHAR.icon.stop,fontSize=90,code=function() BGM.stop() end,visibleFunc=function() return BGM.isPlaying() end},
    WIDGET.new{type='slider_progress',pos={1,.5},x=-350,y=350,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
}

return scene
