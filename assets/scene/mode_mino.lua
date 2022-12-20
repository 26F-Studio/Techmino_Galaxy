local scene={}

function scene.enter()
    MINOMAP:reset()
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
        MINOMAP:mouseClick(x,y)
    end
end
function scene.wheelMoved(dx,dy)
    MINOMAP:hideCursor()
    if love.keyboard.isDown('lctrl','rctrl') then
        MINOMAP:rotateCam(-(dx+dy)*.26)
    else
        MINOMAP:scaleCam(1.1^(dx+dy))
    end
end
function scene.touchMove(_,_,dx,dy)
    MINOMAP:hideCursor()
    MINOMAP:moveCam(dx,dy)
end
function scene.touchDown(x,y)
    MINOMAP:hideCursor()
    scene.touchMove(x,y)
end
function scene.touchClick(x,y)
    MINOMAP:hideCursor()
    scene.mouseClick(x,y,1)
end
function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='space' or key=='return' then
        MINOMAP:keyboardSelect()
    elseif key=='escape' then
        if PROGRESS.getMinoUnlocked() and not PROGRESS.getPuyoUnlocked() and not PROGRESS.getGemUnlocked() then
            SCN.pop()
            SCN.back('fadeHeader')
        end
    end
end

function scene.update(dt)
    MINOMAP:update(dt)
    MINOMAP:keyboardMove(SCR.xOy:transformPoint(800,600))
end

function scene.draw()
    MINOMAP:draw()
    PROGRESS.drawExteriorHeader()
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,color='B',cornerR=15,sound='back',fontSize=40,text=backText,code=WIDGET.c_pressKey'escape'},
    WIDGET.new{type='text',pos={0,0},x=240,y=60,alignX='left',fontType='bold',fontSize=60,text=LANG'title_mode_mino'},
}
return scene
