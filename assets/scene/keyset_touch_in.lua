local scene={}

function scene.enter()
    resetVirtualKeyMode('mino')
    updateWidgetVisible(scene.widgetList)
end

function scene.leave()
    saveTouch()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='-' then
        VCTRL.removeButton()
    elseif key=='+' then
        VCTRL.addButton()
    elseif key=='0' then
        if VCTRL.focus and VCTRL.focus.type=='button' then
            VCTRL.focus.shape=TABLE.next({'circle','square'},VCTRL.focus.shape)
        end
    elseif key=='[' or key==']' then
        if VCTRL.focus then
            VCTRL.focus.iconSize=MATH.clamp(VCTRL.focus.iconSize+(key=='[' and -10 or 10),0,100)
        end
    elseif key=='q' then
        VCTRL.switchStick2way()
    elseif key=='w' then
        VCTRL.switchStick4way()
    elseif key=='escape' then
        SCN.back(SCN.cur=='keyset_touch_in' and 'none' or nil)
    end
end

function scene.touchDown(x,y,id)
    VCTRL.press(x,y,id)
    updateWidgetVisible(scene.widgetList)
end
function scene.touchMove(_,_,dx,dy,id) VCTRL.drag(dx,dy,id) end
function scene.touchUp(_,_,id) VCTRL.release(id) end

function scene.mouseDown(x,y,k) if k==1 then scene.touchDown(x,y,1) end end
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
function scene.mouseUp(x,y,k) if k==1 then scene.touchUp(x,y,1) end end

function scene.draw() VCTRL.draw(true) end

scene.widgetList={
    WIDGET.new{type='button',                pos={0,.5}, x=210, y=-360,w=200,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none'),lineWidth=4,cornerR=0},

    WIDGET.new{type='button',                pos={.5,.5},x=-330,y=-360,w=200,h=80,fontSize=25,text=LANG'stick2_switch',code=WIDGET.c_pressKey('q'),lineWidth=4,cornerR=0},
    WIDGET.new{type='button',                pos={.5,.5},x=-330,y=-270,w=200,h=80,fontSize=25,text=LANG'stick4_switch',code=WIDGET.c_pressKey('w'),lineWidth=4,cornerR=0},

    WIDGET.new{type='button',                pos={.5,.5},x=40,  y=-350,w=100,fontSize=80,text='-',code=WIDGET.c_pressKey('-'),lineWidth=4,cornerR=0},
    WIDGET.new{type='button',                pos={.5,.5},x=560, y=-350,w=100,fontSize=80,text='+',code=WIDGET.c_pressKey('+'),lineWidth=4,cornerR=0},
    WIDGET.new{type='text',                  pos={.5,.5},x=300, y=-350,fontSize=40,widthLimit=400,text=LANG'setting_touch_button',},

    WIDGET.new{type='slider',name='iconSize',pos={.5,.5},x=-430,y=-120,w=200,axis={0,100,20},   text=LANG'setting_touch_iconSize',    widthLimit=200, disp=function() return VCTRL.focus and VCTRL.focus.iconSize end,code=function(v) if VCTRL.focus then VCTRL.focus.iconSize=v end end},

    WIDGET.new{type='slider',name='button1', pos={.5,.5},x=0,   y=-220,w=600,axis={60,260,20},  text=LANG'setting_touch_buttonSize',  widthLimit=200, disp=function() return VCTRL.focus and VCTRL.focus.r end,code=function(v) if VCTRL.focus then VCTRL.focus.r=v end end},
    WIDGET.new{type='button',name='button2', pos={.5,.5},x=430, y=-120,w=360,h=100,fontSize=40, text=LANG'setting_touch_buttonShape', code=WIDGET.c_pressKey('0'),lineWidth=4,cornerR=0},

    WIDGET.new{type='slider',name='stick2_1',pos={.5,.5},x=0,   y=-220,w=600,axis={200,500,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.len  end,code=function(v) VCTRL.focus.len=v  end},
    WIDGET.new{type='slider',name='stick2_2',pos={.5,.5},x=0,   y=-120,w=600,axis={100,200,10}, text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.h    end,code=function(v) VCTRL.focus.h=v    end},

    WIDGET.new{type='slider',name='stick4_1',pos={.5,.5},x=0,   y=-220,w=600,axis={100,250,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.r    end,code=function(v) VCTRL.focus.r=v    end},
    WIDGET.new{type='slider',name='stick4_2',pos={.5,.5},x=0,   y=-120,w=600,axis={.1,.8,.1},   text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.ball end,code=function(v) VCTRL.focus.ball=v end},
}

return scene
