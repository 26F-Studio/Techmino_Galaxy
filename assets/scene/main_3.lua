local gc=love.graphics

local scene={}

function scene.enter()

end

function scene.leave()

end

function scene.update(dt)

end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(1,1,1)
    GC.mDraw(IMG.title.techmino,0,-288,0,.53)
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
