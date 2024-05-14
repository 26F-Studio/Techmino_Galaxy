---@type Zenitha.Scene
local scene={}

local function B(t)
    local w={
        type='button_fill',
        pos={.5,.52},
        w=620,h=140,
        color='B',
        fontSize=50,
        cornerR=0,
    }
    TABLE.update(w,t)
    return WIDGET.new(w)
end

function scene.enter()
    local L=scene.widgetList
    for _,v in next,scene.widgetList do
        if v.name then
            v.color=PROGRESS.getTutorialPassed(tonumber(v.name:sub(-1))) and 'lG' or 'B'
        end
    end
    if not (PROGRESS.getTutorialPassed(1) and PROGRESS.getTutorialPassed(2) and PROGRESS.getTutorialPassed(3)) then
        L.T1.x,L.T2.x,L.T3.x=0,0,0
        L.T1.w,L.T2.w,L.T3.w=800,800,800
        L.T4:setVisible(false)
        L.T5:setVisible(false)
        L.T6:setVisible(false)
        WIDGET._reset()
    else
        L.T1.x,L.T2.x,L.T3.x=-360,-360,-360
        L.T1.w,L.T2.w,L.T3.w=600,600,600
        L.T4.x,L.T5.x,L.T6.x=360,360,360
        L.T4:setVisible(true)
        L.T5:setVisible(true)
        L.T6:setVisible(true)
        WIDGET._reset()
    end
    PROGRESS.playInteriorBGM()
end

function scene.keyDown(key)
    if KEYMAP.sys:getAction(key)=='back' then
        SCN.back('none')
        return true
    end
end

function scene.draw()
    if PROGRESS.get('main')>1 then
        GC.replaceTransform(SCR.xOy_m)
        GC.setColor(1,1,1,.42)
        GC.rectangle('fill',-7,-250,4,540)
    end
end

scene.widgetList={
    {type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn('none')},

    B{name='T1',x=nil, y=-200,text=LANG'tutorial_basic',          code=playInterior'brik/interior/tutorial/1.basic'},
    B{name='T2',x=nil, y= 0,  text=LANG'tutorial_sequence',       code=playInterior'brik/interior/tutorial/2.sequence'},
    B{name='T3',x=nil, y= 200,text=LANG'tutorial_piece',          code=WIDGET.c_goScn('tutorial_shape','none')},

    B{name='T4',x=nil, y=-200,text=LANG'tutorial_stackBasic',     code=playInterior'brik/interior/tutorial/4.stackBasic'},
    B{name='T5',x=nil, y= 0,  text=LANG'tutorial_twoRotatingKey', code=playInterior'brik/interior/tutorial/5.twoRotatingKey'},
    B{name='T6',x=nil, y= 200,text=LANG'tutorial_rotating',       code=WIDGET.c_goScn('tutorial_rotate','none')},
}
return scene
