local floor,clamp=math.floor,MATH.clamp

local squeeze={}

---@param width? number
---@param wait? number
---@param speed? number
function squeeze.switch_auto(P,width,wait,speed)
    squeeze.switch(P,width,wait,speed)
    local setCode,setEvent=P.modeData.squeeze_enabled and P.addCodeSeg or P.delCodeSeg,P.modeData.squeeze_enabled and P.addEvent or P.delEvent
    setCode(P,'extraSolidCheck',squeeze.codeSeg_extraSolidCheck)
    setCode(P,'changeSpawnPos',squeeze.codeSeg_changeSpawnPos)
    setEvent(P,'afterDrop',squeeze.event_afterDrop)
    setEvent(P,'drawInField',squeeze.event_drawInField)
end

---@param width? number
---@param wait? number
---@param speed? number
function squeeze.switch(P,width,wait,speed)
    local md=P.modeData
    if not md.squeeze_enabled then
        md.squeeze_enabled=true
        md.squeeze_width=width or floor(10*.6+.5)
        md.squeeze_wait=wait or floor(10/10+1+.5)
        md.squeeze_move=speed or floor(10/10+.5)
        md.squeeze_pos=floor(P.settings.fieldW/2-md.squeeze_width/2+.5)
        md.squeeze_rest=0
    else
        md.squeeze_enabled=false
        md.squeeze_width=false
        md.squeeze_wait=false
        md.squeeze_move=false
        md.squeeze_pos=false
        md.squeeze_rest=false
    end
end

function squeeze.codeSeg_extraSolidCheck(P,CB,cx,_)
    local md=P.modeData
    if md.squeeze_enabled and (
        cx<=md.squeeze_pos or
        cx+#CB[1]-1>=md.squeeze_pos+md.squeeze_width+1
    ) then return true end
end

function squeeze.codeSeg_changeSpawnPos(P)
    local md=P.modeData
    if md.squeeze_enabled then
        P:moveHand('reset',floor(md.squeeze_pos+md.squeeze_width/2-#P.hand.matrix[1]/2+1),P.handY)
    end
end

function squeeze.event_afterDrop(P)
    local md=P.modeData
    if md.squeeze_enabled then
        for _=1,math.abs(md.squeeze_move) do
            if md.squeeze_rest==0 then
                md.squeeze_pos=clamp(md.squeeze_pos+MATH.sign(md.squeeze_move),0,P.settings.fieldW-md.squeeze_width)
                if md.squeeze_pos<=0 or md.squeeze_pos+md.squeeze_width>=P.settings.fieldW then
                    md.squeeze_move=-md.squeeze_move
                    md.squeeze_rest=md.squeeze_wait
                end
            else
                md.squeeze_rest=md.squeeze_rest-1
            end
        end
    end
end

function squeeze.event_drawInField(P)
    local md=P.modeData
    if md.squeeze_enabled then
        local t=love.timer.getTime()
        GC.setColor(1,1,1,.42+.126*math.sin(t*16.26))
        local leftBoundary=40*md.squeeze_pos
        local rightBoundary=40*(md.squeeze_pos+md.squeeze_width)
        GC.rectangle('fill',0,0,leftBoundary,-880)
        GC.rectangle('fill',leftBoundary,0,-4,-880)
        GC.rectangle('fill',rightBoundary,0,40*(P.settings.fieldW-md.squeeze_pos-md.squeeze_width),-880)
        GC.rectangle('fill',rightBoundary,0,4,-880)
    end
end

return squeeze
