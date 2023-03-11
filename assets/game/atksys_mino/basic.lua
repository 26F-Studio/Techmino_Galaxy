return {
    drop=function(P)
        if P.lastMovement.clear then
            local lines=#P.lastMovement.clear
            P.texts:add{
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
