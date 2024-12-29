local actions={}
function actions.swapLeft(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap(P.swapX,P.swapY,-1,0)
    end
end
function actions.swapRight(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap(P.swapX,P.swapY,1,0)
    end
end
function actions.swapUp(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap(P.swapX,P.swapY,0,1)
    end
end
function actions.swapDown(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.swap then
        P:swap(P.swapX,P.swapY,0,-1)
    end
end
function actions.twistCW(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistR then
        P:twist(P.twistX,P.twistY,'R')
    end
end
function actions.twistCCW(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistL then
        P:twist(P.twistX,P.twistY,'L')
    end
end
function actions.twist180(P)
    if (P.settings.multiMove or #P.movingGroups==0) and P.settings.twistF then
        P:twist(P.twistX,P.twistY,'F')
    end
end
function actions.moveLeft(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirH=-1
    P.moveChargeH=0

    if P.swapX>1 then
        P.swapX=P.swapX-1
        if P.twistX>1 then
            P.twistX=P.twistX-1
        end
        P:playSound('move')
    elseif P.twistX>1 then
        P.twistX=P.twistX-1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveRight(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirH=1
    P.moveChargeH=0

    if P.swapX<P.settings.fieldSize then
        P.swapX=P.swapX+1
        if P.twistX<P.settings.fieldSize-1 then
            P.twistX=P.twistX+1
        end
        P:playSound('move')
    elseif P.twistX<P.settings.fieldSize-1 then
        P.twistX=P.twistX+1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveUp(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirV=1
    P.moveChargeV=0

    if P.swapY<P.settings.fieldSize then
        P.swapY=P.swapY+1
        if P.twistY<P.settings.fieldSize-1 then
            P.twistY=P.twistY+1
        end
        P:playSound('move')
    elseif P.twistY<P.settings.fieldSize-1 then
        P.twistY=P.twistY+1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end
function actions.moveDown(P)
    P.mouseX,P.mouseY=false,false
    P.moveDirV=-1
    P.moveChargeV=0

    if P.swapY>1 then
        P.swapY=P.swapY-1
        if P.twistY>1 then
            P.twistY=P.twistY-1
        end
        P:playSound('move')
    elseif P.twistY>1 then
        P.twistY=P.twistY-1
        P:playSound('move')
    else
        P:playSound('move_failed')
    end
end

actions.func1=function() end
actions.func2=function() end
actions.func3=function() end
actions.func4=function() end
actions.func5=function() end

return actions
