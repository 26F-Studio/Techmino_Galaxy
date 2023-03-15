-- 1~3 attack 0~2, 4+ attack 4+
-- T-Spin only, but both 3-corner or immobile count, attack=line*2
-- Combo attack 0,0,1,1,1,2,2,2,3+
-- B2B give n/4 attack, up to 4 for T-Spin, 2 for Techrash. B2B chain length up to 26.

return {
    init=function(P)
        P.atkSysData.b2b=0
        P.settings.spin_immobile=true
        P.settings.spin_corners=3
    end,
    drop=function(P)
        local M=P.lastMovement
        local spin=P.hand.name=='T' and M.action=='rotate' and (M.corners or M.immobile)
        if M.clear then
            local lines,combo=#P.lastMovement.clear,P.lastMovement.combo
            do-- Text & Sound
                local t=""

                -- Add B2B text & sound
                if (lines>=4 or spin) and P.atkSysData.b2b>0 then
                    t=t..Text.b2b.." "
                    P:playSound('b2b',P.atkSysData.b2b)
                end

                -- Add spin text & sound
                if spin then
                    t=t..Text.spin:repD(M.mino.name).." "
                    P:playSound('spin',lines)
                end

                -- AC text & sound, or Clearing text if no AC
                if P.field:getHeight()==0 then
                    P.texts:add{
                        text=Text.allClear,
                        a=.626,
                        fontSize=75,
                        style='flicker',
                        duration=2.5,
                    }
                    P:playSound('allClear')
                else
                    P.texts:add{
                        text=t..(Text.clearName[lines] or ('['..lines..']')),
                        a=.626,
                        fontSize=math.min(30+lines*10,60)+(spin and 0 or 10),
                        style=lines>=4 and 'stretch' or spin and 'spin' or 'appear',
                        duration=lines/3+(spin and .6 or 0),
                    }
                end

                -- Combo text
                if combo>1 then
                    P.texts:add{
                        text=
                            combo<11 and Text.combo_small:repD(combo-1) or
                            combo<21 and Text.combo_large:repD(combo-1) or
                            Text.mega_combo,
                        a=.7-.3/(2+combo),
                        y=60,
                        fontSize=15+math.min(combo,15)*5,
                    }
                end

                -- Combo sound
                P:playSound('combo',combo)
            end

            do-- Calculate attack
                local pwr
                local tm

                -- Clearing type
                if spin then
                    pwr=2*lines
                    pwr=pwr+math.ceil(P.atkSysData.b2b/4,2)
                    tm=300
                    P.atkSysData.b2b=math.min(P.atkSysData.b2b+1,26)
                elseif lines>=4 then
                    pwr=lines
                    tm=200
                    pwr=pwr+math.min(math.ceil(P.atkSysData.b2b/4),4)
                    P.atkSysData.b2b=math.min(P.atkSysData.b2b+1,26)
                else
                    pwr=lines-1
                    tm=100
                    if P.atkSysData.b2b>1 then
                        P:playSound('b2b_break')
                    end
                    P.atkSysData.b2b=0
                end

                -- All clear bonus
                if P.field:getHeight()==0 then
                    pwr=math.max(pwr,10)
                end

                -- Combo bonus
                tm=tm+P.combo*100
                pwr=pwr+math.min(math.floor(P.combo/3),3)

                -- Send
                if pwr>0 then
                    return {
                        power=pwr,
                        time=tm+pwr*50,
                    }
                end
            end
        elseif spin then
            P.texts:add{
                text=Text.spin:repD(M.mino.name),
                a=.4,
                duration=.8,
            }
            P:playSound('spin',0)
        end
    end,
}
