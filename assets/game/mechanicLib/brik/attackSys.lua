local max,min=math.max,math.min
local floor,ceil=math.floor,math.ceil

---@enum (key) Techmino.Mech.Brik.AttackSysName
local atkSys={

-- No attack
none={
    init=NULL,
    drop=NULL,
},

-- N attack N
basic={
    drop=function(P)
        if P.lastMovement.clear then
            local lines=#P.lastMovement.clear
            P.texts:add{
                text=Text.clearName[lines] or ('['..lines..']'),
                a=.626,
                fontSize=min(40+10*lines,70),
                style=lines>=4 and 'stretch' or 'appear',
                duration=lines/2,
            }
            return {power=lines,time=lines}
        end
    end,
},

-- 1~3 attack 0~2, charge-6
-- 4+ attack 4+, charge+1
-- T-Spin attack=line*2, charge+1, (WIP: Both 3-corner or immobile count as T-Spin)
-- Combo attack 0,0,1,1,1,2,2,2,3+
-- Charge give 0.25*CHG (round+) more attack, up to 2 for T-Spin, 4 for Techrash(+), [Discharged count]/2 (round-) otherwise
modern={
    init=function(P)
        P.atkSysData.charge=0
        P.settings.spin_immobile=true
        P.settings.spin_corners=3
        P.settings.combo_sound=true
    end,
    drop=function(P)
        ---@type Techmino.Game.Attack
        local atk
        local M=P.lastMovement
        local tspin=P.hand.name=='T' and M.action=='rotate' and (M.corners or M.immobile)
        if M.clear then
            local lines,combo=#P.lastMovement.clear,P.lastMovement.combo

            local oldCharge=P.atkSysData.charge
            local newCharge=
                tspin and min(oldCharge+1,26) or
                lines>=4 and min(oldCharge+1,26) or
                max(oldCharge-6,0)
            P.atkSysData.charge=newCharge

            do -- Calculate attack
                local power
                local sharpness=1
                local hardness=1
                local time
                local fatal=30

                -- Clearing type
                if tspin then
                    power=2*lines
                    power=power+min(ceil(oldCharge/4),2)
                    time=300
                elseif lines>=4 then
                    power=lines
                    time=200
                    power=power+min(ceil(oldCharge/4),4)
                else
                    power=lines-1+floor((oldCharge-newCharge)/2)
                    time=100
                    fatal=60
                    sharpness=2
                    hardness=2
                    if newCharge>=2 then
                        P:playSound('discharge')
                    end
                end

                -- All clear bonus
                if P.field:getHeight()==0 then
                    power=max(power,10)
                end

                -- Combo bonus
                time=time+P.combo*100
                power=power+min(floor(P.combo/3),3)

                -- Send
                if power>0 then
                    atk={
                        power=power,
                        sharpness=sharpness,
                        hardness=hardness,
                        time=time+power*50,
                        fatal=fatal,
                    }
                end
            end

            do -- Text & Sound
                local t=STRING.newBuf()

                -- Add CHG text & sound
                if newCharge>oldCharge then
                    if newCharge>1 then
                        t:put(Text.charge.." ")
                        P:playSound('charge',newCharge)
                    end
                elseif oldCharge-newCharge>=2 then
                    t:put(Text.charge.." ")
                    P:playSound('discharge')
                end

                -- Add spin text & sound
                if tspin then
                    t:put(Text.spin:repD(M.brik.name).." ")
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
                    P:playSound('clear_all')
                else
                    P.texts:add{
                        text=t..(Text.clearName[lines] or ('['..lines..']')),
                        a=.626,
                        fontSize=min(30+lines*10,60)+(tspin and 0 or 10),
                        style=lines>=4 and 'stretch' or tspin and 'spin' or 'appear',
                        duration=lines/3+(tspin and .6 or 0),
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
                        fontSize=15+min(combo,15)*5,
                    }
                end
            end
        elseif tspin then
            P.texts:add{
                text=Text.spin:repD(M.brik.name),
                a=.4,
                duration=.8,
            }
            P:playSound('spin',0)
        end
        return atk
    end,
},

-- 1~3 attack 0~2, 4+ attack 4+
-- Continous 4+ get frenzy bonus (+1 attack)
-- Combo attack 0,0,1,1,1,2,2,2,3+
-- All and only `immobile` placement are spin, attack=line*2
-- TODO: long-term charging for spin
nextgen={
    init=function(P)
        P.atkSysData.charge=0
        P.settings.spin_immobile=true
        P.settings.combo_sound=true
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
                fontSize=min(lines-3,0)*10+(spin and 60 or 70),
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
                    fontSize=15+min(combo,15)*5,
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
                P:playSound('clear_all')
            elseif M.y>P.field:getHeight() then
                P.texts:add{
                    text=Text.halfClear,
                    y=-80,
                    a=.8,
                    fontSize=65,
                    style='fly',
                    duration=1.6,
                }
                P:playSound('clear_half')
            end

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
            pwr=pwr+min(floor(P.combo/3),3)

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
},

}

for _,sys in next,atkSys do
    setmetatable(sys,{__index=atkSys.none})
end

---@cast atkSys Map<Map<Techmino.Event.Brik>>
return atkSys
