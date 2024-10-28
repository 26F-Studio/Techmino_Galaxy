local exMap
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

function scene.load()
    local firstLoad
    if not exMap then
        exMap=require'assets.game.exteriorMap'
        firstLoad=true
    end
    local modeStates=PROGRESS.getExteriorMapState()
    exMap:freshUnlocked(modeStates,firstLoad)
    exMap:reset(TABLE.getSize(modeStates)>3)
    panel:setSel(false)
    panel.timer=1
    PROGRESS.applyExteriorBG()
    PROGRESS.applyExteriorBGM()
end

function scene.mouseMove(x,y,dx,dy)
    exMap:hideCursor()
    if love.mouse.isDown(1) then
        exMap:moveCam(dx,dy)
    else
        x,y=SCR.xOy:transformPoint(x,y)
        exMap:mouseMove(x,y)
    end
end
function scene.mouseClick(x,y,k)
    exMap:hideCursor()
    if k==1 then
        x,y=SCR.xOy:transformPoint(x,y)
        panel:setSel(exMap:mouseClick(x,y))
    end
end
function scene.wheelMove(dx,dy)
    exMap:hideCursor()
    if isCtrlPressed() then
        exMap:rotateCam(-(dx+dy)*.26)
    else
        exMap:scaleCam(1.1^(dx+dy))
    end
    return true
end
function scene.touchMove(_,_,dx,dy)
    exMap:hideCursor()
    exMap:moveCam(dx,dy)
end
function scene.touchDown()
    exMap:hideCursor()
end
function scene.touchClick(x,y)
    exMap:hideCursor()
    scene.mouseClick(x,y,1)
end

local function sysAction(action)
    if action=='select' then
        panel:setSel(exMap:keyboardSelect())
    elseif action=='back' then
        SCN._pop()
        SCN.back('fadeHeader')
    end
end
function scene.mouseDown(_,_,k) if k==2 then sysAction('back') end end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='f6' then exMap:_printModePos() return true end
    if key=='f5' then MSG.new('info',"Mode cache cleared") GAME._refresh() return true end
    if key=='\\' then exMap:_unlockall() end
    sysAction(KEYMAP.sys:getAction(key))
    return true
end

function scene.update(dt)
    exMap:update(dt)
    exMap:keyboardMove(SCR.xOy:transformPoint(800,600))
    panel:update(dt)
end

function scene.draw()
    exMap:draw()
    panel:draw()
    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound_trigger='button_back',fontSize=40,text=backText,code=function() sysAction('back') end},
    {type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'graph_brik_title'},
}
return scene
