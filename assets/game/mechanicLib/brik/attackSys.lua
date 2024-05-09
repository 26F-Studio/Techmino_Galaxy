---@type Map<Map<function>>
local atkSys={}

-- No attack
atkSys.none={
    init=NULL,
    drop=NULL,
}

-- N attack N
atkSys.basic={
    drop=function(P)
        if P.lastMovement.clear then
            local lines=#P.lastMovement.clear
            P.texts:add{
                text=Text.clearName[lines] or ('['..lines..']'),
                a=.626,
                fontSize=math.min(40+10*lines,70),
                style=lines>=4 and 'stretch' or 'appear',
                duration=lines/2,
            }
            return {power=lines,time=lines}
        end
    end,
}

-- 1~3 attack 0~2, 4+ attack 4+
-- T-Spin only, but both 3-corner or immobile count, attack=line*2
-- Combo attack 0,0,1,1,1,2,2,2,3+
-- B2B give n/4 attack, up to 4 for T-Spin, 2 for Techrash. B2B chain length up to 26.
atkSys.modern={
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
            do -- Text & Sound
                local t=""

                -- Add B2B text & sound
                if (lines>=4 or spin) and P.atkSysData.b2b>0 then
                    t=t..Text.b2b.." "
                    P:playSound('b2b',P.atkSysData.b2b)
                end

                -- Add spin text & sound
                if spin then
                    t=t..Text.spin:repD(M.brik.name).." "
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

            do -- Calculate attack
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
                text=Text.spin:repD(M.brik.name),
                a=.4,
                duration=.8,
            }
            P:playSound('spin',0)
        end
    end,
}

-- 1~3 attack 0~2, 4+ attack 4+
-- Continous 4+ get frenzy bonus (+1 attack)
-- Combo attack 0,0,1,1,1,2,2,2,3+
-- All and only `immobile` placement are spin, attack=line*2
-- No B2B
atkSys.nextgen={
    init=function(P)
        P.settings.tuck=true
        P.settings.spin_immobile=true
    end,
    drop=function(P)
        local text=''
        local M=P.lastMovement
        local spin=M.action=='rotate' and (M.corners or M.immobile)
        if M.clear then
            local lines,combo=#P.lastMovement.clear,P.lastMovement.combo
            local textDuration=lines/3

            -- Multi-clear text
            local multi
            if lines>=4 and combo>1 then
                local lastClear=P.clearHistory[#P.clearHistory-1]
                if lastClear and lines==lastClear.line then
                    multi=true
                end
            end

            if multi then
                text=text.."M-"
                textDuration=textDuration+.6
                P:playSound('frenzy')
            end

            -- Spin text
            if spin then
                text=Text.spin:repD(M.brik.name).." "
                textDuration=textDuration+.6
                P:playSound('spin',lines)
            end

            -- Clear text
            text=text..(Text.clearName[lines] or ('['..lines..']'))
            P.texts:add{
                text=text,
                a=.626,
                fontSize=math.min(lines-3,0)*10+(spin and 60 or 70),
                style=lines>=4 and 'stretch' or spin and 'spin' or 'appear',
                duration=textDuration,
            }

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

            -- All (Half) clear text
            if P.field:getHeight()==0 then
                P.texts:add{
                    text=Text.allClear,
                    y=-80,
                    a=.626,
                    fontSize=75,
                    style='flicker',
                    duration=2.5,
                }
                P:playSound('allClear')
            elseif M.y>P.field:getHeight() then
                P.texts:add{
                    text=Text.halfClear,
                    y=-80,
                    a=.8,
                    fontSize=65,
                    style='fly',
                    duration=1.6,
                }
                P:playSound('halfClear')
            end

            P:playSound('combo',combo)

            -- Calculate attack
            local pwr

            -- Clear type
            if lines>=4 then
                pwr=lines
                if multi then pwr=pwr+1 end
            elseif spin then
                pwr=2*lines
            else
                pwr=lines-1
            end

            -- All clear bonus
            if P.field:getHeight()==0 then
                pwr=pwr+8
            elseif M.y>P.field:getHeight() then
                pwr=pwr+4
            end

            -- Combo bonus
            pwr=pwr+math.min(math.floor(P.combo/3),3)

            -- Send
            if pwr>0 then
                return {
                    power=pwr,
                    time=200+pwr*50,
                }
            end
        else
            if spin then
                text=Text.spin:repD(M.brik.name)
                P:playSound('spin',0)
            end
            if #text>0 then
                P.texts:add{
                    text=text,
                    a=.4,
                    duration=.8,
                }
            end
        end
    end,
}

for _,sys in next,atkSys do
    setmetatable(sys,{__index=atkSys.none})
end

return atkSys
