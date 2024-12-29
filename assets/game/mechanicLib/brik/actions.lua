local ceil=math.ceil

local function getCharge(charge,mode,SET)
    if mode=='reset' then
        return 0
    elseif mode=='keep' then
        local base=SET.asd-SET.asp
        if charge>base then
            return charge-(charge-base)%SET.asp
        end
    elseif mode=='raw' then
        return charge
    elseif mode=='full' then
        return SET.asd
    else
        error("WTF why dblMoveChrg is "..tostring(mode))
    end
end
local function move(P,dir,canBuffer)
    if P.hand then
        if P[dir=='L' and 'moveLeft' or 'moveRight'](P) then
            P:playSound('move')
        else
            P:freshDelay('move')
            if P.settings.wallChrg=='on' or P.settings.wallChrg=='full' then
                P.moveCharge=P.settings.asd
            end
            P:playSound('move_failed')
            if P.settings.particles then
                P:createHandErrorEffect(1,.26,0)
            end
        end
    else
        if P.settings.entryChrg=='full' then
            P.moveCharge=P.settings.asd
        end
        if canBuffer then
            P.keyBuffer.move=dir
        end
    end
end
local function pressMove(P,dir)
    local d=dir=='L' and -1 or 1

    local SET=P.settings
    if P.keyState[dir=='L' and 'moveRight' or 'moveLeft'] then
        if SET.dblMoveCover then
            P.moveDir=d
        end
        P.moveCharge=getCharge(P.moveCharge,SET.dblMoveChrg,SET)
        if SET.dblMoveStep then move(P,dir,true) end
    else
        P.moveDir=d
        P.moveCharge=0
        move(P,dir,true)
    end
end
local function releaseMove(P,dir)
    local invD=dir=='L' and 'R' or 'L'
    local invDN=dir=='L' and -1 or 1

    local SET=P.settings
    if P.keyState[dir=='L' and 'moveRight' or 'moveLeft'] then
        if P.moveDir==-invDN then -- Normal Release
            P.moveCharge=getCharge(P.moveCharge,SET.dblMoveRelChrg,SET)
            if SET.dblMoveRelStep then move(P,invD,false) end
        else -- Inversed Release
            if SET.dblMoveRelInvRedir then P.moveDir=-invDN end
            P.moveCharge=getCharge(P.moveCharge,SET.dblMoveRelInvChrg,SET)
            if SET.dblMoveRelInvStep then move(P,invD,true) end
        end
    else
        P.moveDir=false
        P.moveCharge=0
        if P.keyBuffer.move==dir then P.keyBuffer.move=false end
        if P.hand and P.deathTimer then P[dir=='L' and 'moveRight' or 'moveLeft'](P) end
    end
end

---@type Map<Map<fun(P:Techmino.Player.Brik)> | function>
local actions={}
actions.moveLeft={
    press=function(P) pressMove(P,'L') end,
    release=function(P) releaseMove(P,'L') end
}
actions.moveRight={
    press=function(P) pressMove(P,'R') end,
    release=function(P) releaseMove(P,'R') end
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
        if P.hand and (P.handY>(P.ghostY or 1) or P.deathTimer) and P:moveDown() then
            P:playSound('move_down')
        end
    end,
    release=function(P)
        if P.hand and P.deathTimer then P:moveUp() end
    end
}
actions.hardDrop={
    press=function(P)
        if P.mHdLockTimer~=0 or P.aHdLockTimer~=0 then
            P:playSound('rotate_failed')
        elseif P.hand then
            if not P.deathTimer then
                P.mHdLockTimer=P.settings.mHdLock
                P:brikDropped()
            else
                P.deathTimer=ceil(P.deathTimer/2.6)
            end
        else
            P.keyBuffer.hardDrop=true
        end
    end,
    release=function(P)
        P.keyBuffer.hardDrop=false
    end
}
actions.holdPiece={
    press=function(P)
        if P.hand then
            P:hold()
        else
            P.keyBuffer.hold=true
        end
    end,
    release=function(P)
        P.keyBuffer.hold=false
    end
}

actions.func1=function() end
actions.func2=function() end
actions.func3=function() end
actions.func4=function() end
actions.func5=function() end

return actions
