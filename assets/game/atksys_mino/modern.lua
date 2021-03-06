return {
    init=function(self)
        self.atkSysData.b2b=0
        self.settings.spin_immobile=true
        self.settings.spin_corners=3
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

                -- AC text & sound, or Clearing text if no AC
                if self.field:getHeight()==0 then
                    self.texts:add{
                        text=Text.allClear,
                        a=.626,
                        fontSize=75,
                        style='flicker',
                        duration=2.5,
                    }
                    self:playSound('allClear')
                else
                    self.texts:add{
                        text=t..(Text.clearName[C.line] or ('['..C.line..']')),
                        a=.626,
                        fontSize=math.min(30+C.line*10,60)+(spin and 0 or 10),
                        style=C.line>=4 and 'stretch' or spin and 'spin' or 'appear',
                        duration=C.line/3+(spin and .6 or 0),
                    }
                end

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

                -- Combo sound
                self:playSound('combo',C.combo)
            end

            do-- Calculate attack
                local pwr
                local tm

                -- Clearing type
                if spin then
                    pwr=2*C.line
                    pwr=pwr+math.ceil(self.atkSysData.b2b/4,2)
                    tm=.3
                    self.atkSysData.b2b=math.min(self.atkSysData.b2b+1,26)
                elseif C.line>=4 then
                    pwr=C.line
                    tm=.2
                    pwr=pwr+math.min(math.ceil(self.atkSysData.b2b/4),4)
                    self.atkSysData.b2b=math.min(self.atkSysData.b2b+1,26)
                else
                    pwr=C.line-1
                    tm=.1
                    if self.atkSysData.b2b>1 then
                        self:playSound('b2b_break')
                    end
                    self.atkSysData.b2b=0
                end

                -- All clear bonus
                if self.field:getHeight()==0 then
                    pwr=math.max(pwr,10)
                end

                -- Combo bonus
                tm=tm+self.combo*.1
                pwr=pwr+math.min(math.floor(self.combo/3),3)

                -- Send
                if pwr>0 then
                    return {
                        power=pwr,
                        time=tm+pwr*.05,
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
