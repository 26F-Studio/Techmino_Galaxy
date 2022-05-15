return {
    init=function(self)
        self.atkSysData.b2b=0
    end,
    drop=function(self)
        local M=self.lastMovement
        local C=M.clear
        local spin=self.hand.name=='T' and M.action=='rotate' and (M.corners or M.immobile)
        if M.clear then
            do-- Text & Sound
                local t=""

                -- Add B2B text & sound
                if (C.line>=4 or spin) and self.atkSysData.b2b>0 then
                    t=t..Text.b2b.." "
                    self:playSound('b2b',self.atkSysData.b2b)
                end

                -- Add spin text & sound
                if spin then
                    t=t..Text.spin:repD(M.mino.name).." "
                    self:playSound('spin',C.line)
                end

                -- Clearing text
                self.texts:add{
                    text=t..(Text.clearName[C.line] or ('['..C.line..']')),
                    a=.626,
                    fontSize=math.min(30+C.line*10,60)+(spin and 0 or 10),
                    style=C.line>=4 and 'stretch' or spin and 'spin' or 'appear',
                    duration=C.line/3+(spin and .6 or 0),
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
                -- AC text & sound
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
                end

                -- Combo & Clearing sound
                self:playSound('combo',C.combo)
            end

            do-- Calculate attack
                local atk

                -- Clearing type
                if spin then
                    atk=2*C.line
                    atk=atk+math.ceil(self.atkSysData.b2b/4,2)
                    self.atkSysData.b2b=math.min(self.atkSysData.b2b+1,26)
                elseif C.line>=4 then
                    atk=C.line
                    atk=atk+math.min(math.ceil(self.atkSysData.b2b/4),4)
                    self.atkSysData.b2b=math.min(self.atkSysData.b2b+1,26)
                else
                    atk=C.line-1
                    if self.atkSysData.b2b>=4 then
                        self:playSound('b2b_break')
                    end
                    self.atkSysData.b2b=0
                end

                -- All clear bonus
                if self.field:getHeight()==0 then
                    atk=math.max(atk,10)
                end

                -- Combo bonus
                atk=atk+math.min(math.floor(self.combo/3),3)

                -- Send
                if atk>0 then
                    return {
                        power=atk,
                    }
                end
            end
        elseif spin then
            self.texts:add{
                text=Text.spin:repD(M.mino.name),
                a=.4,
                duration=.8,
            }
            self:playSound('spin',0)
        end
    end,
}
