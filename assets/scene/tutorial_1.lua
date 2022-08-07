local gc=love.graphics

local scene={}

function scene.enter()

end

function scene.leave()

end

function scene.mouseDown(x,y,k)

end
function scene.keyDown(key,isRep)

end

function scene.update(dt)

end

function scene.draw()

end

scene.widgetList={
    WIDGET.new{type='button',     pos={0,.5},x=210,y=-360,w=200,h=80,cornerR=0,sound='back', fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
    WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=-160,w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_move',    cornerR=0},
    WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=240, w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_stack',   cornerR=0},
    WIDGET.new{type='button_fill',pos={.5,.5},x=-300,y=40,  w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_next',    cornerR=0},
    WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=40,  w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_hold',    cornerR=0},
    WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=-160,w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_clear',   cornerR=0},
    WIDGET.new{type='button_fill',pos={.5,.5},x=300, y=240, w=540,h=150,color='B',fontSize=45,text=LANG'tutorial_1_techrash',cornerR=0},
}
return scene
