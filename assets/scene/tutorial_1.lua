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
    if SCN.args[1]==1 then
        L.T1_1.x,L.T1_2.x,L.T1_3.x=0,0,0
        L.T1_1.w,L.T1_2.w,L.T1_3.w=800,800,800
        L.T2_1:setVisible(false)
        L.T2_2:setVisible(false)
        L.T2_3:setVisible(false)
        WIDGET._reset()
    elseif SCN.args[1]==2 then
        L.T1_1.x,L.T1_2.x,L.T1_3.x=-360,-360,-360
        L.T1_1.w,L.T1_2.w,L.T1_3.w=600,600,600
        L.T2_1.x,L.T2_2.x,L.T2_3.x=360,360,360
        L.T2_1:setVisible(true)
        L.T2_2:setVisible(true)
        L.T2_3:setVisible(true)
        WIDGET._reset()
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},

    B{name='T1_1',x=nil, y=-200,text=LANG'tutorial_basic',            code=playMode'mino/tutorial/1.basic'},
    B{name='T1_2',x=nil, y= 0,  text=LANG'tutorial_sequence',         code=playMode'mino/tutorial/2.sequence'},
    B{name='T1_3',x=nil, y= 200,text=LANG'tutorial_stackBasic',       code=playMode'mino/tutorial/3.stackBasic'},

    B{name='T2_1',x=nil, y=-200,text=LANG'tutorial_twoRotatingKey',   code=playMode'mino/tutorial/4.twoRotatingKey'},
    B{name='T2_2',x=nil, y= 0,  text=LANG'tutorial_stackAdvanced',    code=playMode'mino/tutorial/5.stackAdvanced'},
    B{name='T2_3',x=nil, y= 200,text=LANG'tutorial_finesse',          code=playMode'mino/tutorial/6.finesse'},

    -- WIDGET.new{type='button_fill',x=-300,y=-160,w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_0'},
    -- WIDGET.new{type='button_fill',x=300, y=-160,w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_1'},
    -- WIDGET.new{type='button_fill',x=-300,y=40,  w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_2'},
    -- WIDGET.new{type='button_fill',x=300, y=40,  w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_3'},
    -- WIDGET.new{type='button_fill',x=-300,y=240, w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_4'},
    -- WIDGET.new{type='button_fill',x=300, y=240, w=540,h=150,color='B',fontSize=50,text=LANG'tutorial_2_5'},
}
return scene
