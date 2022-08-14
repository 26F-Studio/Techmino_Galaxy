local scene={}

scene.widgetList={
    WIDGET.new{type='button',     pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back', fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
    WIDGET.new{type='button_fill',pos={.5,.5},y=-160,w=720,h=150,color='B',fontSize=50,text=LANG'tutorial_1_basic',    cornerR=0,code=playMode'mino/tutorial_1/basic'},
    WIDGET.new{type='button_fill',pos={.5,.5},y=40,  w=720,h=150,color='B',fontSize=50,text=LANG'tutorial_1_sequence', cornerR=0,code=playMode'mino/tutorial_1/sequence'},
    WIDGET.new{type='button_fill',pos={.5,.5},y=240, w=720,h=150,color='B',fontSize=50,text=LANG'tutorial_1_stack',    cornerR=0,code=playMode'mino/tutorial_1/stack'},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=-160,w=540,h=150},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=-160,w=540,h=150},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=40,  w=540,h=150},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=40,  w=540,h=150},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=240, w=540,h=150},
    -- WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=240, w=540,h=150},
}
return scene
