local minoMap
local panel={
    selected=false,
    timer=2.6,
    modeNameText=GC.newText(FONT.get(45),""),
    modeInfoText='',
    update=function(self,dt)
        self.timer=self.timer+dt
    end,
    setSel=function(self,tar)
        if self.selected~=tar then
            if tar then
                if not self.selected then
                    self.timer=0
                end
                local info=Text.exteriorModeInfo[tar.name]
                if type(info)~='table' then info={'?','?'} end
                self.modeNameText:set(info[1])
                self.modeInfoText=info[2]
            elseif self.selected then
                self.timer=0
            end
            self.selected=tar
        end
    end,
    poly={
        26,-340,
        -320,-340,
        -360,-270,
        -360,310,
        -320,380,
        26,380,
    },
    draw=function(self)
        local a=0
        if self.selected then
            if self.timer>.1 or self.timer>.02 and self.timer<.05 then
                a=1
            end
        elseif self.timer<.126 then
            a=1-self.timer/.126
        end
        if a==0 then return end

        GC.replaceTransform(SCR.xOy_r)
        if not self.selected then
            GC.translate(62*(self.timer*6.26)^2,0)
        end

        GC.setColor(.26,.26,.26,.8*a)
        GC.polygon('fill',self.poly)

        GC.setColor(1,1,1,.8*a)
        GC.setLineWidth(4)
        GC.polygon('line',self.poly)

        GC.setColor(.99,.99,.99,a)
        GC.draw(self.modeNameText,-170,-320,nil,math.min(1,310/self.modeNameText:getWidth()),1,self.modeNameText:getWidth()/2,0)
        FONT.set(25)
        GC.printf(self.modeInfoText,-340,-260,320,'center')
    end
}

---@type Zenitha.Scene
local scene={}

function scene.enter()
    if not minoMap then
        minoMap=require'assets.game.minomap'
        minoMap:freshUnlocked(PROGRESS.getModeState('mino_stdMap'),true)
    else
        minoMap:freshUnlocked(PROGRESS.getModeState('mino_stdMap'))
    end
    minoMap:reset()
    minoMap:setFullVersion(
        PROGRESS.getModeState('mino_stdMap','sprint_40')>0 or
        PROGRESS.getModeState('mino_stdMap','marathon')>0 or
        PROGRESS.getModeState('mino_stdMap','dig_practice')>0
    )
    panel:setSel(false)
    PROGRESS.setExteriorBG()
    PROGRESS.playExteriorBGM()
end

function scene.mouseMove(x,y,dx,dy)
    minoMap:hideCursor()
    if love.mouse.isDown(1) then
        minoMap:moveCam(dx,dy)
    else
        x,y=SCR.xOy:transformPoint(x,y)
        minoMap:mouseMove(x,y)
    end
end
function scene.mouseClick(x,y,k)
    minoMap:hideCursor()
    if k==1 then
        x,y=SCR.xOy:transformPoint(x,y)
        panel:setSel(minoMap:mouseClick(x,y))
    end
end
function scene.wheelMoved(dx,dy)
    minoMap:hideCursor()
    if isCtrlPressed() then
        minoMap:rotateCam(-(dx+dy)*.26)
    else
        minoMap:scaleCam(1.1^(dx+dy))
    end
end
function scene.touchMove(_,_,dx,dy)
    minoMap:hideCursor()
    minoMap:moveCam(dx,dy)
end
function scene.touchDown()
    minoMap:hideCursor()
end
function scene.touchClick(x,y)
    minoMap:hideCursor()
    scene.mouseClick(x,y,1)
end

local function sysAction(action)
    if action=='select' then
        panel:setSel(minoMap:keyboardSelect())
    elseif action=='back' then
        if not PROGRESS.getModeUnlocked('gem_wip') and not PROGRESS.getModeUnlocked('puyo_wip') and PROGRESS.getModeUnlocked('mino_stdMap') then
            SCN._pop()
        end
        SCN.back('fadeHeader')
    end
end
function scene.keyDown(key,isRep)
    if isRep then return end
    -- if key=='z' then minoMap:_printModePos() return end
    if key=='`' and isAltPressed() then minoMap:_unlockall() end
    sysAction(KEYMAP.sys:getAction(key))
end

function scene.update(dt)
    minoMap:update(dt)
    minoMap:keyboardMove(SCR.xOy:transformPoint(800,600))
    panel:update(dt)
end

function scene.draw()
    minoMap:draw()
    panel:draw()
    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=function() sysAction('back') end},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'graph_mino_title'},
}
return scene
