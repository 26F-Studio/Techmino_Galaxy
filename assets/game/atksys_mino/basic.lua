return {
    drop=function(self)
        if self.lastMovement.clear then
            return {
                amount=self.lastMovement.clear.line,
            }
        end
    end,
}
