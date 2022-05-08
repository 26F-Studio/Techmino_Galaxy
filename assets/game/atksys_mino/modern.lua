return {
    init=function(self)
        self.atkSysData.b2b=false
    end,
    drop=function(self)
        if self.lastMovement.clear then
            local M=self.lastMovement
            local C=M.clear
            local L
            if C.line>=4 then
                L=C.line
                if self.atkSysData.b2b then L=L+1 end
                self.atkSysData.b2b=true
            elseif self.hand.shape==5 and M.action=='rotate' and (M.immobile or M.corners) then
                L=2*C.line
                if self.atkSysData.b2b then L=L+1 end
                self.atkSysData.b2b=true
            else
                L=C.line-1
                self.atkSysData.b2b=false
            end
            L=L+math.min(math.floor(self.combo/3),3)
            if L>0 then return {
                amount=L,
            } end
        end
    end,
}
