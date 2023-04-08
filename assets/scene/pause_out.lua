
local scene={}

function scene.keyDown(key,isRep)
    if isRep then return end

    local action=KEYMAP.sys:getAction(key)
    if action=='restart' then
        -- scene.enter()
    elseif action=='back' then
        SCN.swapTo('game_out','none')
    end
end

function scene.draw()
    SCN.scenes['game_out'].draw()
    GC.replaceTransform(SCR.origin)
    GC.setColor(0,0,0,.626)
    GC.rectangle('fill',0,0,SCR.w,SCR.h)

    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(COLOR.L)
    FONT.set(80,'bold')
    GC.mStr(Text.pause,0,-62)
end

scene.widgetList={
    WIDGET.new{type='button',pos={0,0},x=120,y=80,w=160,h=80,sound='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
    WIDGET.new{type='button',pos={0,0},x=316,y=80,w=160,h=80,sound='button_back',fontSize=60,text=CHAR.icon.play,code=function() SCN.swapTo('game_out', 'none') end},
}
return scene
