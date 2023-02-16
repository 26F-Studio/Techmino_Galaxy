return {
    drop=function(self)
        if self.lastMovement.clear then
            local lines=#self.lastMovement.clear
            self.texts:add{
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
