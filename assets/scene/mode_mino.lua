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

local scene={}

function scene.enter()
    local fullVersion=true -- TODO
    panel:setSel(false)
    MINOMAP:reset()
    MINOMAP:setFullVersion(fullVersion)
    PROGRESS.setExteriorBG()
    PROGRESS.playExteriorBGM()
end

function scene.mouseMove(x,y,dx,dy)
    MINOMAP:hideCursor()
    if love.mouse.isDown(1) then
        MINOMAP:moveCam(dx,dy)
    else
        x,y=SCR.xOy:transformPoint(x,y)
        MINOMAP:mouseMove(x,y)
    end
end
function scene.mouseClick(x,y,k)
    MINOMAP:hideCursor()
    if k==1 then
        x,y=SCR.xOy:transformPoint(x,y)
        panel:setSel(MINOMAP:mouseClick(x,y))
    end
end
function scene.wheelMoved(dx,dy)
    MINOMAP:hideCursor()
    if isCtrlPressed() then
        MINOMAP:rotateCam(-(dx+dy)*.26)
    else
        MINOMAP:scaleCam(1.1^(dx+dy))
    end
end
function scene.touchMove(_,_,dx,dy)
    MINOMAP:hideCursor()
    MINOMAP:moveCam(dx,dy)
end
function scene.touchDown()
    MINOMAP:hideCursor()
end
function scene.touchClick(x,y)
    MINOMAP:hideCursor()
    scene.mouseClick(x,y,1)
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if KEYMAP.sys:getAction(key)=='select' then
        panel:setSel(MINOMAP:keyboardSelect())
    elseif KEYMAP.sys:getAction(key)=='back' then
        if PROGRESS.getMinoUnlocked() and not PROGRESS.getPuyoUnlocked() and not PROGRESS.getGemUnlocked() then
            SCN._pop()
            SCN.back('fadeHeader')
        end
    -- elseif key=='z' then
    --     MINOMAP:_printModePos()
    end
end

function scene.update(dt)
    MINOMAP:update(dt)
    MINOMAP:keyboardMove(SCR.xOy:transformPoint(800,600))
    panel:update(dt)
end

function scene.draw()
    MINOMAP:draw()
    panel:draw()
    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=WIDGET.c_pressKey'escape'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'graph_mino_title'},
}
return scene
