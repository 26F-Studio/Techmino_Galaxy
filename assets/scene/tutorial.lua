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
    TABLE.cover(t,w)
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
    PROGRESS.playBGM_main_in()
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,lineWidth=4,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},

    B{name='T1',x=nil, y=-200,text=LANG'tutorial_basic',            code=playMode'mino/interior/tutorial/1.basic'},
    B{name='T2',x=nil, y= 0,  text=LANG'tutorial_sequence',         code=playMode'mino/interior/tutorial/2.sequence'},
    B{name='T3',x=nil, y= 200,text=LANG'tutorial_stackBasic',       code=playMode'mino/interior/tutorial/3.stackBasic'},

    B{name='T4',x=nil, y=-200,text=LANG'tutorial_twoRotatingKey',   code=playMode'mino/interior/tutorial/4.twoRotatingKey'},
    B{name='T5',x=nil, y= 0,  text=LANG'tutorial_stackAdvanced',    code=playMode'mino/interior/tutorial/5.stackAdvanced'},
    B{name='T6',x=nil, y= 200,text=LANG'tutorial_finesse',          code=playMode'mino/interior/tutorial/6.finesse'},
}
return scene
