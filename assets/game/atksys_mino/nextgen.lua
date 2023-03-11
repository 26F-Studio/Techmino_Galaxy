return {
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
                text=Text.spin:repD(M.mino.name).." "
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
            if pwr>0 then
                return {
                    power=pwr,
                    time=200+pwr*50,
                }
            end
        else
            if spin then
                text=Text.spin:repD(M.mino.name)
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
