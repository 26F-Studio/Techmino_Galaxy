local scene={}

local function updateWidgetVisible()
    if VCTRL.focus then
        scene.widgetList.button1._visible=VCTRL.focus.type=='button'
        scene.widgetList.button2._visible=VCTRL.focus.type=='button'
        scene.widgetList.stick2_1._visible=VCTRL.focus.type=='stick2way'
        scene.widgetList.stick2_2._visible=VCTRL.focus.type=='stick2way'
        scene.widgetList.stick4_1._visible=VCTRL.focus.type=='stick4way'
        scene.widgetList.stick4_2._visible=VCTRL.focus.type=='stick4way'
    else
        scene.widgetList.button1._visible=false
        scene.widgetList.button2._visible=false
        scene.widgetList.stick2_1._visible=false
        scene.widgetList.stick2_2._visible=false
        scene.widgetList.stick4_1._visible=false
        scene.widgetList.stick4_2._visible=false
    end
end

function scene.enter()
    VCTRL.reset()
    updateWidgetVisible()
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
    elseif key=='q' then
        VCTRL.switchStick2way()
    elseif key=='w' then
        VCTRL.switchStick4way()
    elseif key=='escape' then
        SCN.back()
    end
end

function scene.touchDown(x,y,id)
    VCTRL.press(x,y,id)
    updateWidgetVisible()
end
function scene.touchMove(_,_,dx,dy,id) VCTRL.drag(dx,dy,id) end
function scene.touchUp(_,_,id) VCTRL.release(id) end

function scene.mouseDown(x,y,k) if k==1 then scene.touchDown(x,y,1) end end
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
function scene.mouseUp(x,y,k) if k==1 then scene.touchUp(x,y,1) end end

function scene.draw() VCTRL.draw(true) end

scene.widgetList={
    WIDGET.new{type='button',  pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back', fontSize=40,text='Back',code=WIDGET.c_backScn},

    WIDGET.new{type='button',  pos={.6,0}, x=-260,y=150,w=100,                        fontSize=80,text='-',code=WIDGET.c_pressKey('-')},
    WIDGET.new{type='text',    pos={.6,0}, x=0,y=150,text=LANG'setting_touch_button', fontSize=40,widthLimit=400},
    WIDGET.new{type='button',  pos={.6,0}, x=260,y=150,w=100,                         fontSize=80,text='+',code=WIDGET.c_pressKey('+')},

    WIDGET.new{type='button',  pos={.32,0}, x=0,y=150,w=200,h=100, fontSize=25,text=LANG'stick2_switch',code=WIDGET.c_pressKey('q')},
    WIDGET.new{type='button',  pos={.32,0}, x=0,y=270,w=200,h=100, fontSize=25,text=LANG'stick4_switch',code=WIDGET.c_pressKey('w')},

    WIDGET.new{type='slider',  pos={.6,.22}, name='button1',  x=-300,w=600,axis={60,260,20},  text=LANG'setting_touch_buttonSize',  widthLimit=200, disp=function() return VCTRL.focus and VCTRL.focus.type=='button' and VCTRL.focus.r      end,code=function(v) if VCTRL.focus then VCTRL.focus.r=v     end end},
    WIDGET.new{type='button',  pos={.6,.33}, name='button2',  w=360,h=100,fontSize=40,        text=LANG'settinh_touch_buttonShape', code=WIDGET.c_pressKey('0')},
    WIDGET.new{type='slider',  pos={.6,.22}, name='stick2_1', x=-300,w=600,axis={200,500,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.len  end,code=function(v) VCTRL.focus.len=v    end},
    WIDGET.new{type='slider',  pos={.6,.3},  name='stick2_2', x=-300,w=600,axis={100,200,10}, text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.h    end,code=function(v) VCTRL.focus.h=v      end},
    WIDGET.new{type='slider',  pos={.6,.22}, name='stick4_1', x=-300,w=600,axis={100,250,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.r    end,code=function(v) VCTRL.focus.r=v      end},
    WIDGET.new{type='slider',  pos={.6,.3},  name='stick4_2', x=-300,w=600,axis={.1,.8,.1},   text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.ball end,code=function(v) VCTRL.focus.stickR=v end},
}

return scene
