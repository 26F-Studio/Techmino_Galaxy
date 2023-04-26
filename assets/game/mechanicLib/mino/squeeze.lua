local floor,clamp=math.floor,MATH.clamp

local squeeze={}

function squeeze.switch(P)
    local md=P.modeData
    if not md.inSqueeze then
        md.inSqueeze=true
        md.squeezePos=2
        md.squeezeWidth=6
        md.squeezeMove=1
        md.squeezeWait=0
        md.squeezeWait0=2
        P:addCodeSeg('extraSolidCheck',squeeze.codeSeg_extraSolidCheck)
        P:addCodeSeg('changeSpawnPos',squeeze.codeSeg_changeSpawnPos)
        P:addEvent('afterDrop',squeeze.event_afterDrop)
        P:addEvent('drawInField',squeeze.event_drawInField)
    else
        md.inSqueeze=false
        P:delCodeSeg('extraSolidCheck',squeeze.codeSeg_extraSolidCheck)
        P:addCodeSeg('changeSpawnPos',squeeze.codeSeg_changeSpawnPos)
        P:delEvent('afterDrop',squeeze.event_afterDrop)
        P:delEvent('drawInField',squeeze.event_drawInField)
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
            if md.squeezeWait==0 then
                md.squeezePos=clamp(md.squeezePos+MATH.sign(md.squeezeMove),0,P.settings.fieldW-md.squeezeWidth)
                if md.squeezePos<=0 or md.squeezePos+md.squeezeWidth>=P.settings.fieldW then
                    md.squeezeMove=-md.squeezeMove
                    md.squeezeWait=md.squeezeWait0
                end
            else
                md.squeezeWait=md.squeezeWait-1
            end
        end
    end
end

function squeeze.event_drawInField(P)
    local md=P.modeData
    if md.inSqueeze then
        local t=love.timer.getTime()
        GC.setColor(1,1,1,.42+.16*math.sin(t*12.6))
        local leftBoundary=40*md.squeezePos
        local rightBoundary=40*(md.squeezePos+md.squeezeWidth)
        GC.rectangle('fill',0,0,leftBoundary,-840)
        GC.rectangle('fill',leftBoundary,0,-4,-840)
        GC.rectangle('fill',rightBoundary,0,40*(P.settings.fieldW-md.squeezePos-md.squeezeWidth),-840)
        GC.rectangle('fill',rightBoundary,0,4,-840)
    end
end

return squeeze
