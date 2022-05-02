local KEYMAP={
    {act='act_moveLeft',    keys={'kp1'}},
    {act='act_moveRight',   keys={'kp3'}},
    {act='act_rotateCW',    keys={'kp5'}},
    {act='act_rotateCCW',   keys={'kp2'}},
    {act='act_rotate180',   keys={'kp6'}},
    {act='act_holdPiece',   keys={'space'}},
    {act='act_softDrop',    keys={'x'}},
    {act='act_hardDrop',    keys={'z'}},
    {act='act_sonicDrop',   keys={'c'}},
    {act='act_sonicLeft',   keys={}},
    {act='act_sonicRight',  keys={}},

    {act='act_function1',   keys={'a'}},
    {act='act_function2',   keys={'s'}},
    {act='act_function3',   keys={'d'}},
    {act='act_function4',   keys={'q'}},
    {act='act_function5',   keys={'w'}},
    {act='act_function6',   keys={'e'}},

    {act='game_restart',    keys={'r','`'}},
    {act='game_chat',       keys={'return'}},

    {act='menu_up',         keys={'up'}},
    {act='menu_down',       keys={'down'}},
    {act='menu_left',       keys={'left'}},
    {act='menu_right',      keys={'right'}},
    {act='menu_confirm',    keys={'return'}},
    {act='menu_back',       keys={'escape'}},

    {act='rep_pause',       keys={'space','1'}},
    {act='rep_prevFrame',   keys={'left',','}},
    {act='rep_nextFrame',   keys={'right','.'}},
    {act='rep_speedDown',   keys={'down'}},
    {act='rep_speedUp',     keys={'up'}},
    {act='rep_speed1_16x',  keys={'2'}},
    {act='rep_speed1_6x',   keys={'3'}},
    {act='rep_speed1_2x',   keys={'4'}},
    {act='rep_speed1x',     keys={'5'}},
    {act='rep_speed2x',     keys={'6'}},
    {act='rep_speed6x',     keys={'7'}},
    {act='rep_speed16x',    keys={'8'}},
}
function KEYMAP.load(data)
    if not data then return end
    for i=1,#KEYMAP do
        if data[i] then
            KEYMAP[i].keys=TABLE.shift(data[i],0)
        end
    end
end
function KEYMAP.getKeys(action)
    for i=1,#KEYMAP do
        if KEYMAP[i].act==action then
            return KEYMAP[i].keys
        end
    end
end
function KEYMAP.getAction(key)
    for i=1,#KEYMAP do
        local l=KEYMAP[i].keys
        for j=1,#l do
            if l[j]==key then
                return KEYMAP[i].act
            end
        end
    end
end

function KEYMAP.remKey(key)
    for j=1,#KEYMAP do
        local k=TABLE.find(KEYMAP[j].keys,key)
        if k then
            table.remove(KEYMAP[j].keys,k)
        end
    end
end

function KEYMAP.addKey(act,key)
    for i=1,#KEYMAP do
        if KEYMAP[i].act==act then
            table.insert(KEYMAP[i].keys,key)
            while #KEYMAP[i].keys>=5 do
                table.remove(KEYMAP[i].keys,1)
            end
            SFX.play('beep1')
            break
        end
    end
end

return KEYMAP
