local selected,fullband

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
    function musicListBox.drawFunc(name,n,sel)
        if sel then
            GC.setColor(1,1,1,.26)
            GC.rectangle('fill',0,0,700,80)
        end
        FONT.set(60)
        GC.setColor(name==selected and COLOR.L or COLOR.LD)
        GC.print(('%02d'):format(n)..'. '..bigTitle[name],20,4)
    end
    function musicListBox.code()
        if BGM.isPlaying() and selected==musicListBox:getItem() then
            BGM.stop()
        else
            selected=musicListBox:getItem()
            playBgm(selected,fullband and 'full' or 'base')
        end
    end
    musicListBox=WIDGET.new(musicListBox)

    local l={}
    for k in next,bgmList do
        table.insert(l,k)
    end
    table.sort(l)
    musicListBox:setList(l)
end

local scene={}

function scene.enter()
    selected,fullband=getBgm()
    fullband=type(fullband)=='string' and fullband:find('full')
    musicListBox:select(TABLE.find(musicListBox:getList(),selected))
end

function scene.wheelMoved(_,y)
    WHEELMOV(y)
end
function scene.keyDown(key,isRep)
    if key=='space' or key=='return' then
        if not isRep then
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
            sel=sel%#list+1
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
        GC.replaceTransform(SCR.xOy_l)
        FONT.set(30)
        GC.setColor(COLOR.L)
        GC.printf(STRING.time_simp(BGM.tell()%BGM.getDuration()),100,230,626,'left')
        GC.printf(STRING.time_simp(BGM.getDuration()),1500-626,230,626,'right')
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
    musicListBox,
    WIDGET.new{type='slider_progress',pos={.5,.5},x=-700,y=200,w=1400,
        disp=function() return BGM.tell()/BGM.getDuration()%1 end,
        code=function(v) BGM.set('all','seek',v*BGM.getDuration()) end,
        visibleFunc=function() return BGM.isPlaying() end,
    },
    WIDGET.new{type='switch',pos={.5,.5},x=-650,y=350,h=50,disp=function() return fullband end,
        name='fullband',text=LANG'musicroom_fullband',
        code=function()
            fullband=not fullband
            if BGM.isPlaying() then
                BGM.set(bgmList[selected].add,'volume',fullband and 1 or 0,.26)
            end
        end,
        visibleFunc=function()
            return type(bgmList[selected])=='table' and bgmList[selected].base
        end,
    },
    WIDGET.new{type='button',pos={.5,.5},y=350,w=120,h=120,text=CHAR.icon.playPause,fontSize=60,code=musicListBox.code},
    WIDGET.new{type='slider_progress',pos={1,.5},x=-350,y=350,w=250,text=CHAR.icon.volUp,fontSize=60,disp=TABLE.func_getVal(SETTINGS.system,'bgmVol'),code=TABLE.func_setVal(SETTINGS.system,'bgmVol')},
}

return scene
