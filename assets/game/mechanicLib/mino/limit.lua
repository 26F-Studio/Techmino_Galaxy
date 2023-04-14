local limit={}

function limit.slowHide_event_gameOver(P)
    P:showInvis(4,626)
end

function limit.fastField_event_gameOver(P)
    P:showInvis(1,100)
end

function limit.coverField_event_playerInit(P)
    P.modeData.coverAlpha=0
end
function limit.coverField_event_always(P)
    if P.finished then
        if P.modeData.coverAlpha>2000 then
            P.modeData.coverAlpha=P.modeData.coverAlpha-1
        end
    else
        if P.modeData.coverAlpha<2600 then
            P.modeData.coverAlpha=P.modeData.coverAlpha+1
        end
    end
end
function limit.coverField_event_gameOver(P)
    P:showInvis()
end
function limit.coverField_event_drawInField(P)
    GC.setColor(.26,.26,.26,P.modeData.coverAlpha/2600)
    GC.rectangle('fill',0,0,P.settings.fieldW*40,-P.settings.spawnH*40)
end

function limit.noRotate_event_playerInit(P)
    P:switchAction('rotateCW',false)
    P:switchAction('rotateCCW',false)
    P:switchAction('rotate180',false)
end

function limit.noMove_event_playerInit(P)
    P:switchAction('moveLeft',false)
    P:switchAction('moveRight',false)
end

function limit.noFallAfterClear_event_afterClear(P,clear)
    for i=clear.line,1,-1 do
        table.insert(P.field._matrix,clear.lines[i],TABLE.new(false,P.settings.fieldW))
    end
    P.field:fresh()
end

function limit.swapDirection_event_playerInit(P)
    P.modeData.flip=false
end
function limit.swapDirection_event_key(P)
    if P.modeData.flip then
        P.keyState.rotateCW,P.keyState.rotateCCW=P.keyState.rotateCCW,P.keyState.rotateCW
        P.keyState.moveLeft,P.keyState.moveRight=P.keyState.moveRight,P.keyState.moveLeft
    end
end
function limit.swapDirection_event_afterLock(P)
    P.modeData.flip=not P.modeData.flip
    P.actions.rotateCW,P.actions.rotateCCW=P.actions.rotateCCW,P.actions.rotateCW
    P.actions.moveLeft,P.actions.moveRight=P.actions.moveRight,P.actions.moveLeft
end

return limit
