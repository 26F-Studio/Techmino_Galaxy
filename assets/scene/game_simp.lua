local gc=love.graphics
local restartTimer,holdR=false,false

local KEYMAP={
    {act='game_restart',   keys={'r','`'}},

    {act='act_moveLeft',   keys={'kp1'}},
    {act='act_moveRight',  keys={'kp3'}},
    {act='act_rotateCW',   keys={'kp5'}},
    {act='act_rotateCCW',  keys={'kp2'}},
    {act='act_rotate180',  keys={'kp6'}},
    {act='act_softDrop',   keys={'x'}},
    {act='act_sonicDrop',  keys={'c'}},
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

    {act='act_sonicLeft',  keys={}},
    {act='act_sonicRight', keys={}},
    {act='act_dropLeft',   keys={}},
    {act='act_dropRight',  keys={}},
    {act='act_zangiLeft',  keys={}},
    {act='act_zangiRight', keys={}},

    {act='menu_up',        keys={'up'}},
    {act='menu_down',      keys={'down'}},
    {act='menu_left',      keys={'left'}},
    {act='menu_right',     keys={'right'}},
    {act='menu_confirm',   keys={'return'}},
    {act='menu_back',      keys={'escape'}},

    {act='rep_pause',      keys={'space'}},
    {act='rep_nextFrame',  keys={'n'}},
    {act='rep_speedDown',  keys={'left'}},
    {act='rep_speedUp',    keys={'right'}},
    {act='rep_speed1/16x', keys={'1'}},
    {act='rep_speed1/6x',  keys={'2'}},
    {act='rep_speed1/2x',  keys={'3'}},
    {act='rep_speed1x',    keys={'4'}},
    {act='rep_speed2x',    keys={'5'}},
    {act='rep_speed6x',    keys={'6'}},
    {act='rep_speed16x',   keys={'7'}},
}
local function _getAction(k)
    for i=1,#KEYMAP do
        local l=KEYMAP[i].keys
        for j=1,#l do
            if l[j]==k then
                return KEYMAP[i].act
            end
        end
    end
end

local scene={}

function scene.enter()
    GAME.reset('sprint')
    GAME.newPlayer(1,'mino')
    GAME.setMain(1)
    GAME.loadSettings()
    GAME.start()
end

function scene.keyDown(key,isRep)
    if isRep then return end
    local action=_getAction(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        GAME.press(action:sub(5))
    elseif action:sub(1,5)=='menu_' then
        if action=='menu_confirm' then
            if GAME.canPause then
                SCN.go()
            end
        elseif action=='menu_back' then
            SCN.back()
        end
    elseif action=='game_restart' then
        holdR=true
        restartTimer=restartTimer or 0
    elseif action:sub(1,4)=='rep_' then
        -- TODO
    end
end

function scene.keyUp(key)
    local action=_getAction(key)
    if not action then return end
    if action:sub(1,4)=='act_' then
        GAME.release(action:sub(5))
    elseif action=='game_restart' then
        holdR=false
    elseif action:sub(1,5)=='menu_' then
        if action=='menu_back' then
            SCN.back()
        end
    end
end

function scene.update(dt)
    GAME.update(dt)
    if restartTimer then
        if holdR then
            restartTimer=restartTimer+dt
            if restartTimer>=.26 then
                holdR=false
                scene.enter()
            end
        else
            restartTimer=restartTimer-2.6*dt
            if restartTimer<=0 then
                restartTimer=false
            end
        end
    end
end

function scene.draw()
    GAME.render()
    gc.replaceTransform(SCR.origin)
    if restartTimer then
        gc.setColor(0,0,0,restartTimer/.26)
        gc.rectangle('fill',0,0,SCR.w,SCR.h)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound='back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn},
}
return scene
