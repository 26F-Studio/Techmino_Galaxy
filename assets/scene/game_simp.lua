local gc=love.graphics

local KEYMAP={
    {act='game_restart',   keys={'r','`'}},
    {act='game_pause',     keys={'escape'}},

    {act='act_moveLeft',   keys={'left'}},
    {act='act_moveRight',  keys={'right'}},
    {act='act_rotateCW',   keys={'up'}},
    {act='act_rotateCCW',  keys={'down'}},
    {act='act_rotate180',  keys={'kp0'}},
    {act='act_softDrop',   keys={'c'}},
    {act='act_sonicDrop',  keys={'x'}},
    {act='act_hardDrop',   keys={'z'}},
    {act='act_holdPiece',  keys={'space'}},

    {act='act_function1',  keys={'a'}},
    {act='act_function2',  keys={'s'}},
    {act='act_function3',  keys={'d'}},
    {act='act_function4',  keys={'f'}},

    {act='act_target1',    keys={'q'}},
    {act='act_target2',    keys={'w'}},
    {act='act_target3',    keys={'e'}},
    {act='act_target4',    keys={'r'}},

    {act='act_fastLeft',   keys={}},
    {act='act_fastRight',  keys={}},
    {act='act_dropLeft',   keys={}},
    {act='act_dropRight',  keys={}},
    {act='act_zangiLeft',  keys={}},
    {act='act_zangiRight', keys={}},

    {act='menu_up',        keys={'up'}},
    {act='menu_down',      keys={'down'}},
    {act='menu_left',      keys={'left'}},
    {act='menu_right',     keys={'right'}},
    {act='menu_pause',     keys={'return'}},
    {act='menu_quit',      keys={'escape'}},

    {act='rep_pause',      keys={}},
    {act='rep_nextFrame',  keys={}},
    {act='rep_speed1/16x', keys={}},
    {act='rep_speed1/6x',  keys={}},
    {act='rep_speed1/2x',  keys={}},
    {act='rep_speed1x',    keys={}},
    {act='rep_speed2x',    keys={}},
    {act='rep_speed6x',    keys={}},
    {act='rep_speed16x',   keys={}},
}
local function _getKey(k)
    for i=1,#KEYMAP do
        local l=KEYMAP[i].keys
        for j=1,#l do
            if l[j]==k then
                return KEYMAP[i].act
            end
        end
    end
end

local P1

local scene={}

function scene.enter()
    P1=require'assets.player.minoPlayer'.new{
        id=1,
    }
    P1:setPosition(800,500)
    for y=1,2 do
        P1.field.matrix[y]={}
        for x=1,10 do
            P1.field.matrix[y][x]=MATH.roll() and {}
        end
    end
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local action=_getKey(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        P1:press(action:sub(5))
    elseif action:sub(1,5)=='menu_' then
        -- if action=='menu_pause' then
        --     pauseGame()
        -- elseif action=='menu_quit' then
        --     quitGame()
        -- end
    end
end

function scene.keyUp(key)
    local action=_getKey(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        P1:release(action:sub(5))
    end
end

function scene.update(dt)
    P1:update(dt)
end

function scene.draw()
    P1:draw()
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
