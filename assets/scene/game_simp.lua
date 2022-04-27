local gc=love.graphics

local scene={}

local touches={}
local repMode=false

function scene.enter()
    TABLE.cut(touches)
    GAME.reset(SCN.args[1])
    GAME.newPlayer(1,'mino')
    GAME.setMain(1)
    GAME.start()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local action=KEYMAP:_getAction(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        GAME.press(action:sub(5))
    elseif action:sub(1,5)=='menu_' then
        if action=='menu_back' then
            SCN.back()
        end
    elseif action=='game_restart' then
        scene.enter()
    elseif action:sub(1,4)=='rep_' then
        if not repMode then return end
        -- TODO
    end
end

function scene.keyUp(key)
    local action=KEYMAP:_getAction(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        GAME.release(action:sub(5))
    elseif action:sub(1,5)=='menu_' then
        if action=='menu_back' then
            SCN.back()
        end
    end
end

function scene.touchDown(x,y,id)
    table.insert(touches,{
        id=id,
        x=x,y=y,
    })
end

function scene.touchMove(x,y,_,_,id)
    for i=1,#touches do
        if touches[i].id==id then
            touches[i].x=x
            touches[i].y=y
            break
        end
    end
end

function scene.touchUp(_,_,id)
    for i=1,#touches do
        if touches[i].id==id then
            table.remove(touches,i)
            break
        end
    end
end

function scene.update(dt)
    GAME.update(dt)
end

function scene.draw()
    GAME.render()

    if SETTINGS.system.showTouch then
        gc.setColor(1,1,1,.5)
        gc.setLineWidth(4)
        gc.replaceTransform(SCR.xOy)
        for i=1,#touches do
            gc.circle('line',touches[i].x,touches[i].y,80)
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
