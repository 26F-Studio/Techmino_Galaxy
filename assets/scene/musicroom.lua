local gc=love.graphics

local author={
    battle="Aether & MrZ",
    moonbeam="Beethoven & MrZ",
    empty="ERM",
    ["sugar fairy"]="Tchaikovsky & MrZ",
    ["secret7th remix"]="柒栎流星",
    ["jazz nihilism"]="Trebor",
    ["race remix"]="柒栎流星",
    sakura="ZUN & C₂₉H₂₅N₃O₅",
    ["1980s"]="C₂₉H₂₅N₃O₅",
    lounge="Hailey (cudsys) & MrZ",
    ['blank orchestra']='T0722',
}
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
    musicListBox={type='listBox',pos={0,.5},x=100,y=-400,w=500,h=800,lineHeight=50}
    function musicListBox.drawFunc(name,n,sel)
        if sel then
            gc.setColor(1,1,1,.2)
            gc.rectangle('fill',0,0,500,50)
        end
        FONT.set(40)
        gc.setColor(COLOR.LD)
        gc.print(n,10,-2)
        gc.setColor(COLOR.L)
        gc.print(bigTitle[name],75,-2)
    end
    musicListBox=WIDGET.new(musicListBox)

    local l={}
    for k in next,bgmList do
        table.insert(l,k)
    end
    table.sort(l)
    musicListBox:setList(l)
end

local selected

local scene={}

function scene.enter()
    selected=getBgm()
    musicListBox:select(TABLE.find(musicListBox:getList(),selected))
end

function scene.wheelMoved(_,y)
    WHEELMOV(y)
end
function scene.keyDown(key,isRep)
    if key=='space' or key=='return' then
        if not isRep then
            selected=musicListBox:getSel()
            playBgm(selected)
        end
    elseif key=='up' or key=='down' then
        musicListBox:arrowKey(key)
    elseif key=='escape'then
        SCN.back()
    elseif #key==1 and key:find'[0-9a-z]'then
        local list=musicListBox:getList()
        local sel=TABLE.find(list,selected)
        for _=1,#list do
            sel=sel%#list+1
            if list[sel]:sub(1,1)==key then
                selected=list[sel]
                musicListBox:select(sel)
                break
            end
        end
    end
end

function scene.draw()
    local t=love.timer.getTime()
    FONT.set(90)
    gc.setColor(math.sin(t*.5)*.2+.8,math.sin(t*.7)*.2+.8,math.sin(t)*.2+.8)
    gc.print(bigTitle[selected],630,120)

    FONT.set(50)
    gc.setColor(1,math.sin(t*2.6)*.5+.5,math.sin(t*2.6)*.5+.5)
    gc.print(author[selected] or 'MrZ',700,230)

    if BGM.tell() then
        FONT.set(20)
        gc.setColor(COLOR.L)
        gc.print(STRING.time_simp(BGM.tell()%BGM.getDuration()).." / "..STRING.time_simp(BGM.getDuration()),630,750)
    end
end

scene.widgetList={
    musicListBox,
    WIDGET.new{type='slider',x=630,y=720,w=600,
        valueShow='null',
        disp=function() return BGM.tell()/BGM.getDuration()%1 end,
        code=function(v) BGM.set('all','seek',v*BGM.getDuration()) end,
        visibleFunc=function() return BGM.isPlaying() end,
    },
    WIDGET.new{type='button',pos={0,.5},x=720,y=350,w=180,h=90,text=CHAR.icon.play,fontSize=80,code=WIDGET.c_pressKey('space')},
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
