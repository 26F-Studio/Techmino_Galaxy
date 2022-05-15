return {
    drop=function(self)
        if self.lastMovement.clear then
            local C=self.lastMovement.clear
            self.texts:add{
                text=Text.clearName[C.line] or ('['..C.line..']'),
                a=.626,
                fontSize=math.min(40+10*C.line,70),
                style=C.line>=4 and 'stretch' or 'appear',
                duration=C.line/2,
            }
            return {power=C.line,}
        end
    end,
}
