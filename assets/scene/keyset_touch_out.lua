local scene={}

function scene.enter()
    resetVCTRL('mino')
    updateWidgetVisible(scene.widgetList)
end

function scene.leave(...)     SCN.scenes['keyset_touch_in'].leave(...)     end
function scene.keyDown(...)   SCN.scenes['keyset_touch_in'].keyDown(...)   end

function scene.touchDown(x,y,id)
    VCTRL.press(x,y,id)
    updateWidgetVisible(scene.widgetList)
end

function scene.touchMove(...) SCN.scenes['keyset_touch_in'].touchMove(...) end
function scene.touchUp(...)   SCN.scenes['keyset_touch_in'].touchUp(...)   end

function scene.mouseDown(x,y,k) if k==1 then scene.touchDown(x,y,1) end end
function scene.mouseMove(x,y,dx,dy) scene.touchMove(x,y,dx,dy,1) end
function scene.mouseUp(x,y,k) if k==1 then scene.touchUp(x,y,1) end end

function scene.draw(...)      SCN.scenes['keyset_touch_in'].draw(...)      end

scene.widgetList={
    WIDGET.new{type='button',                pos={0,.5}, x=210, y=-360,w=200,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},

    WIDGET.new{type='button',                pos={.5,.5},x=-330,y=-360,w=200,h=80,fontSize=25,text=LANG'stick2_switch',code=WIDGET.c_pressKey('q')},
    WIDGET.new{type='button',                pos={.5,.5},x=-330,y=-270,w=200,h=80,fontSize=25,text=LANG'stick4_switch',code=WIDGET.c_pressKey('w')},

    WIDGET.new{type='button',                pos={.5,.5},x=40,  y=-350,w=100,fontSize=80,text='-',code=WIDGET.c_pressKey('-')},
    WIDGET.new{type='button',                pos={.5,.5},x=560, y=-350,w=100,fontSize=80,text='+',code=WIDGET.c_pressKey('+')},
    WIDGET.new{type='text',                  pos={.5,.5},x=300, y=-350,fontSize=40,widthLimit=400,text=LANG'setting_touch_button'},

    WIDGET.new{type='slider',name='iconSize',pos={.5,.5},x=-430,y=-120,w=200,axis={0,100,20},   text=LANG'setting_touch_iconSize',    widthLimit=200, disp=function() return VCTRL.focus and VCTRL.focus.iconSize end,code=function(v) if VCTRL.focus then VCTRL.focus.iconSize=v end end},

    WIDGET.new{type='slider',name='button1', pos={.5,.5},x=0,   y=-220,w=600,axis={60,260,20},  text=LANG'setting_touch_buttonSize',  widthLimit=200, disp=function() return VCTRL.focus and VCTRL.focus.r end,code=function(v) if VCTRL.focus then VCTRL.focus.r=v end end},
    WIDGET.new{type='button',name='button2', pos={.5,.5},x=430, y=-120,w=360,h=100,fontSize=40, text=LANG'setting_touch_buttonShape', code=WIDGET.c_pressKey('0')},

    WIDGET.new{type='slider',name='stick2_1',pos={.5,.5},x=0,   y=-220,w=600,axis={200,500,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.len  end,code=function(v) VCTRL.focus.len=v  end},
    WIDGET.new{type='slider',name='stick2_2',pos={.5,.5},x=0,   y=-120,w=600,axis={100,200,10}, text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.h    end,code=function(v) VCTRL.focus.h=v    end},

    WIDGET.new{type='slider',name='stick4_1',pos={.5,.5},x=0,   y=-220,w=600,axis={100,250,25}, text=LANG'setting_touch_stickSize',   widthLimit=200, disp=function() return VCTRL.focus.r    end,code=function(v) VCTRL.focus.r=v    end},
    WIDGET.new{type='slider',name='stick4_2',pos={.5,.5},x=0,   y=-120,w=600,axis={.1,.8,.1},   text=LANG'setting_touch_ballSize',    widthLimit=200, disp=function() return VCTRL.focus.ball end,code=function(v) VCTRL.focus.ball=v end},
}

return scene
