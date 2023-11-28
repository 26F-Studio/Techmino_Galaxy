local actions={}
actions.moveLeft={
    press=function(P)
        P.moveDir=-1
        P.moveCharge=0
        if P.hand then
            if P:moveLeft() then
                P:playSound('move')
            else
                P:freshDelay('move')
                P:playSound('move_failed')
                P:createHandEffect(1,.26,0)
            end
        else
            P.keyBuffer.move='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='L' then P.keyBuffer.move=false end
        if P.hand and P.deathTimer then P:moveRight() end
    end
}
actions.moveRight={
    press=function(P)
        P.moveDir=1
        P.moveCharge=0
        if P.hand then
            if P:moveRight() then
                P:playSound('move')
            else
                P:freshDelay('move')
                P:playSound('move_failed')
                P:createHandEffect(1,.26,0)
            end
        else
            P.keyBuffer.move='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.move=='R' then P.keyBuffer.move=false end
        if P.hand and P.deathTimer then P:moveLeft() end
    end
}
actions.rotateCW={
    press=function(P)
        if P.hand then
            P:rotate('R')
        else
            P.keyBuffer.rotate='R'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='R' then P.keyBuffer.rotate=false end
    end
}
actions.rotateCCW={
    press=function(P)
        if P.hand then
            P:rotate('L')
        else
            P.keyBuffer.rotate='L'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='L' then P.keyBuffer.rotate=false end
    end
}
actions.rotate180={
    press=function(P)
        if P.hand then
            P:rotate('F')
        else
            P.keyBuffer.rotate='F'
        end
    end,
    release=function(P)
        if P.keyBuffer.rotate=='F' then P.keyBuffer.rotate=false end
    end
}
actions.softDrop={
    press=function(P)
        P.downCharge=0
        if P.hand and (P.handY>P.ghostY or P.deathTimer) and P:moveDown() then
            P:playSound('move_down')
        end
    end,
    release=function(P)
        if P.hand and P.deathTimer then P:moveUp() end
    end
}
actions.hardDrop={
    press=function(P)
        if P.hdLockMTimer~=0 or P.hdLockATimer~=0 then
            P:playSound('rotate_failed')
        elseif P.hand and not P.deathTimer then
            P.hdLockMTimer=P.settings.hdLockM
            P:puyoDropped()
        else
            P.keyBuffer.hardDrop=true
        end
    end,
    release=function(P)
        P.keyBuffer.hardDrop=false
    end
}

actions.func1=function() end
actions.func2=function() end
actions.func3=function() end
actions.func4=function() end
actions.func5=function() end

return actions
