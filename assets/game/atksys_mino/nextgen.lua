return {
    init=function(self)
        self.settings.tuck=true
        self.settings.spin_immobile=true
    end,
    drop=function(self)
        local M=self.lastMovement
        local C=M.clear
        local text=''
        local spin=M.action=='rotate' and (M.corners or M.immobile)
        if M.clear then
            local textDuration=C.line/3

            -- Multi-clear text
            local multi
            if C.line>=4 and C.combo>1 then
                local lastClear=self.clearHistory[#self.clearHistory-1]
                if lastClear and C.line==lastClear.line then
                    multi=true
                end
            end

            if multi then
                text=text.."M-"
                textDuration=textDuration+.6
                self:playSound('frenzy')
            end

            -- Spin text
            if spin then
                text=Text.spin:repD(M.mino.name).." "
                textDuration=textDuration+.6
                self:playSound('spin',C.line)
            end

            -- Clear text
            text=text..(Text.clearName[C.line] or ('['..C.line..']'))
            self.texts:add{
                text=text,
                a=.626,
                fontSize=math.min(C.line-3,0)*10+(spin and 60 or 70),
                style=C.line>=4 and 'stretch' or spin and 'spin' or 'appear',
                duration=textDuration,
            }

            -- Combo text
            if C.combo>1 then
                self.texts:add{
                    text=
                        C.combo<11 and Text.combo_small:repD(C.combo-1) or
                        C.combo<21 and Text.combo_large:repD(C.combo-1) or
                        Text.mega_combo,
                    a=.7-.3/(2+C.combo),
                    y=60,
                    fontSize=15+math.min(C.combo,15)*5,
                }
            end

            -- All (Half) clear text
            if self.field:getHeight()==0 then
                self.texts:add{
                    text=Text.allClear,
                    y=-80,
                    a=.626,
                    fontSize=75,
                    style='flicker',
                    duration=2.5,
                }
                self:playSound('allClear')
            elseif M.y>self.field:getHeight() then
                self.texts:add{
                    text=Text.halfClear,
                    y=-80,
                    a=.8,
                    fontSize=65,
                    style='fly',
                    duration=1.6,
                }
                self:playSound('halfClear')
            end

            self:playSound('combo',C.combo)

            -- Calculate attack
            local atk

            -- Clear type
            if C.line>=4 then
                atk=C.line
                if multi then atk=atk+1 end
            elseif spin then
                atk=2*C.line
            else
                atk=C.line-1
            end

            -- All clear bonus
            if self.field:getHeight()==0 then
                atk=atk+8
            elseif M.y>self.field:getHeight() then
                atk=atk+4
            end

            -- Combo bonus
            atk=atk+math.min(math.floor(self.combo/3),3)
            if atk>0 then
                return {
                    power=atk,
                }
            end
        else
            if spin then
                text=Text.spin:repD(M.mino.name)
                self:playSound('spin',0)
            end
            if #text>0 then
                self.texts:add{
                    text=text,
                    a=.4,
                    duration=.8,
                }
            end
        end
    end,
}
