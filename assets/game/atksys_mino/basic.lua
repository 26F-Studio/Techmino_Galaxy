return {
    drop=function(self)
        if self.lastMovement.clear then
            return {
                power=self.lastMovement.clear.line,
            }
        end
    end,
}
