local scene={}

function scene.enter()
    VCTRL.reset()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='-' then
        VCTRL.set('button','remove')
    elseif key=='+' then
        VCTRL.set('button','add')
    end
end

function scene.touchDown(x,y,id)
    if VCTRL.press(x,y,id) then return end
end
function scene.touchMove(_,_,dx,dy,id)
    VCTRL.drag(dx,dy,id)
end
function scene.touchUp(_,_,id)
    VCTRL.release(id)
end

scene.mouseDown=scene.touchDown
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
scene.mouseUp=scene.touchUp

function scene.draw()
    VCTRL.draw(true)
end

scene.widgetList={
    -- WIDGET.new{type='checkBox',pos={.5,.18},x=-260,w=70, text=LANG'setting_touch_stick2way', fontSize=40,widthLimit=480,labelPos='right'},
    WIDGET.new{type='button',  pos={.5,.3}, x=-260,w=100,                    fontSize=80,text='-',code=WIDGET.c_pressKey('-')},
    WIDGET.new{type='text',    pos={.5,.3}, text=LANG'setting_touch_button', fontSize=40,widthLimit=400},
    WIDGET.new{type='button',  pos={.5,.3}, x=260, w=100,                    fontSize=80,text='+',code=WIDGET.c_pressKey('+')},
    WIDGET.new{type='button',  pos={1,0},x=-120,y=80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
