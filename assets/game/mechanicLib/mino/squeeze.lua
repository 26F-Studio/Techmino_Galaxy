local floor,clamp=math.floor,MATH.clamp

local squeeze={}

function squeeze.switch_auto(P,...)
    squeeze.switch(P,...)
    local setCode,setEvent=P.modeData.inSqueeze and P.addCodeSeg or P.delCodeSeg,P.modeData.inSqueeze and P.addEvent or P.delEvent
    setCode(P,'extraSolidCheck',squeeze.codeSeg_extraSolidCheck)
    setCode(P,'changeSpawnPos',squeeze.codeSeg_changeSpawnPos)
    setEvent(P,'afterDrop',squeeze.event_afterDrop)
    setEvent(P,'drawInField',squeeze.event_drawInField)
end
function squeeze.switch(P,width,wait,move)
    local md=P.modeData
    if not md.inSqueeze then
        md.inSqueeze=true
        md.squeezeWidth=width or floor(10*.6+.5)
        md.squeezeWait=wait or floor(10/10+1+.5)
        md.squeezeMove=move or floor(10/10+.5)
        md.squeezePos=floor(P.settings.fieldW/2-md.squeezeWidth/2+.5)
        md.squeezeWaitTimer=0
    else
        md.inSqueeze=false
        md.squeezeWidth=false
        md.squeezeWait=false
        md.squeezeMove=false
        md.squeezePos=false
        md.squeezeWaitTimer=false
    end
end

function squeeze.codeSeg_extraSolidCheck(P,CB,cx,_)
    local md=P.modeData
    if md.inSqueeze and (
        cx<=md.squeezePos or
        cx+#CB[1]-1>=md.squeezePos+md.squeezeWidth+1
    ) then return true end
end

function squeeze.codeSeg_changeSpawnPos(P)
    local md=P.modeData
    if md.inSqueeze then
        P:moveHand('reset',floor(md.squeezePos+md.squeezeWidth/2-#P.hand.matrix[1]/2+1),P.handY)
    end
end

function squeeze.event_afterDrop(P)
    local md=P.modeData
    if md.inSqueeze then
        for _=1,math.abs(md.squeezeMove) do
            if md.squeezeWaitTimer==0 then
                md.squeezePos=clamp(md.squeezePos+MATH.sign(md.squeezeMove),0,P.settings.fieldW-md.squeezeWidth)
                if md.squeezePos<=0 or md.squeezePos+md.squeezeWidth>=P.settings.fieldW then
                    md.squeezeMove=-md.squeezeMove
                    md.squeezeWaitTimer=md.squeezeWait
                end
            else
                md.squeezeWaitTimer=md.squeezeWaitTimer-1
            end
        end
    end
end

function squeeze.event_drawInField(P)
    local md=P.modeData
    if md.inSqueeze then
        local t=love.timer.getTime()
        GC.setColor(1,1,1,.42+.126*math.sin(t*16.26))
        local leftBoundary=40*md.squeezePos
        local rightBoundary=40*(md.squeezePos+md.squeezeWidth)
        GC.rectangle('fill',0,0,leftBoundary,-880)
        GC.rectangle('fill',leftBoundary,0,-4,-880)
        GC.rectangle('fill',rightBoundary,0,40*(P.settings.fieldW-md.squeezePos-md.squeezeWidth),-880)
        GC.rectangle('fill',rightBoundary,0,4,-880)
    end
end

return squeeze
