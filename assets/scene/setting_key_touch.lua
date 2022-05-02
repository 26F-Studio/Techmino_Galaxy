local scene={}

local function updateWidgetVisible()
    if VCTRL.focus then
        scene.widgetList.button1._visible=VCTRL.focus.type=='button'
        scene.widgetList.button2._visible=VCTRL.focus.type=='button'
        scene.widgetList.stick1._visible=VCTRL.focus.type=='stick2way'
        scene.widgetList.stick2._visible=VCTRL.focus.type=='stick2way'
    else
        scene.widgetList.button1._visible=false
        scene.widgetList.button2._visible=false
        scene.widgetList.stick1._visible=false
        scene.widgetList.stick2._visible=false
    end
end

function scene.enter()
    VCTRL.reset()
    updateWidgetVisible()
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
    -- WIDGET.new{type='checkBox',pos={.5,.18},x=-260,w=70, text=LANG'setting_touch_stick2way', fontSize=40,widthLimit=480,labelPos='right'},
    WIDGET.new{type='button',  pos={.5,.1}, x=-260,w=100,                    fontSize=80,text='-',code=WIDGET.c_pressKey('-')},
    WIDGET.new{type='text',    pos={.5,.1}, text=LANG'setting_touch_button', fontSize=40,widthLimit=400},
    WIDGET.new{type='button',  pos={.5,.1}, x=260, w=100,                    fontSize=80,text='+',code=WIDGET.c_pressKey('+')},

    WIDGET.new{type='slider',  pos={.5,.22},name='button1',x=-300,w=600,axis={60,260,20},  smooth=true, text=LANG'setting_touch_buttonSize', disp=function() return VCTRL.focus and VCTRL.focus.type=='button' and VCTRL.focus.r      end,code=function(v) if VCTRL.focus then VCTRL.focus.r=v     end end},
    WIDGET.new{type='button',  pos={.5,.33},name='button2',       w=360,h=100,             fontSize=40, text=LANG'settinh_touch_buttonShape',                                                                                             code=WIDGET.c_pressKey('0'),                                    },
    WIDGET.new{type='slider',  pos={.5,.22},name='stick1', x=-300,w=600,axis={200,500,25}, smooth=true, text=LANG'setting_touch_stickLength',disp=function() return VCTRL.focus and VCTRL.focus.type=='stick2way' and VCTRL.focus.len end,code=function(v) if VCTRL.focus then VCTRL.focus.len=v   end end},
    WIDGET.new{type='slider',  pos={.5,.3}, name='stick2', x=-300,w=600,axis={100,200,10}, smooth=true, text=LANG'setting_touch_stickSize',  disp=function() return VCTRL.focus and VCTRL.focus.type=='stick2way' and VCTRL.focus.h   end,code=function(v) if VCTRL.focus then VCTRL.focus.h=v     end end},

    WIDGET.new{type='button',  pos={1,0},x=-120,y=80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}

return scene
