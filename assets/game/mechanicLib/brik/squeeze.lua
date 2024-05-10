local floor,clamp=math.floor,MATH.clamp

---@type Map<Techmino.Mech.Brik>
local squeeze={}

---@param width? number
---@param wait? number
---@param depth? number
---@param speed? number
function squeeze.turnOn_auto(P,width,wait,depth,speed)
    if not P.modeData.squeeze_enabled then
        squeeze.switch_auto(P,width,wait,depth,speed)
    end
end
function squeeze.turnOff_auto(P)
    if P.modeData.squeeze_enabled then
        squeeze.switch_auto(P)
    end
end

---@param width? number
---@param wait? number
---@param depth? number
---@param speed? number
function squeeze.switch_auto(P,width,wait,depth,speed)
    squeeze.switch(P,width,wait,depth,speed)
    local setEvent=P.modeData.squeeze_enabled and P.addEvent or P.delEvent
    setEvent(P,'extraSolidCheck',squeeze.event_extraSolidCheck)
    setEvent(P,'changeSpawnPos',squeeze.event_changeSpawnPos)
    setEvent(P,'afterDrop',squeeze.event_afterDrop)
    setEvent(P,'drawInField',squeeze.event_drawInField)
end

---@param width? number
---@param wait? number
---@param depth? number
---@param speed? number
function squeeze.switch(P,width,wait,depth,speed)
    local md=P.modeData
    if not md.squeeze_enabled then
        local fieldW=P.settings.fieldW
        md.squeeze_enabled=true
        md.squeeze_width=width or floor(2*fieldW^.5)
        md.squeeze_wait=wait or floor(fieldW/10+.5)
        md.squeeze_depth=depth or floor(md.squeeze_width/2-1.5)
        md.squeeze_move=speed or floor(fieldW/10+.5)
        md.squeeze_pos=floor(fieldW/2-md.squeeze_width/2+.5)
        md.squeeze_rest=0
    else
        md.squeeze_enabled=false
        md.squeeze_width=false
        md.squeeze_wait=false
        md.squeeze_depth=false
        md.squeeze_move=false
        md.squeeze_pos=false
        md.squeeze_rest=false
    end
end

function squeeze.event_extraSolidCheck(P,CB,cx,_)
    local md=P.modeData
    if md.squeeze_enabled and (
        cx<=md.squeeze_pos or
        cx+#CB[1]-1>=md.squeeze_pos+md.squeeze_width+1
    ) then return true end
end

function squeeze.event_changeSpawnPos(P)
    local md=P.modeData
    if md.squeeze_enabled then
        P:moveHand('reset',clamp(floor(md.squeeze_pos+md.squeeze_width/2-#P.hand.matrix[1]/2+1),1,P.settings.fieldW-#P.hand.matrix+1),P.handY)
    end
end

function squeeze.event_afterDrop(P)
    local md=P.modeData
    if md.squeeze_enabled then
        local dir=md.squeeze_move
        for _=1,math.abs(dir) do
            if md.squeeze_rest==0 then
                local lBound,rBound=-md.squeeze_depth,P.settings.fieldW-md.squeeze_width+md.squeeze_depth
                md.squeeze_pos=clamp(md.squeeze_pos+MATH.sign(dir),lBound,rBound)
                if md.squeeze_pos<=lBound or md.squeeze_pos>=rBound then
                    md.squeeze_move=-dir
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
        GC.setColor(1,1,1,.42+.0626*math.sin(t*16.26))
        if md.squeeze_pos>0 then
            local lBound=40*md.squeeze_pos
            GC.rectangle('fill',0,0,lBound,-880)
            GC.rectangle('fill',lBound,0,-4,-880)
        end
        if md.squeeze_pos+md.squeeze_width<P.settings.fieldW then
            local rBound=40*(md.squeeze_pos+md.squeeze_width)
            GC.rectangle('fill',rBound,0,40*(P.settings.fieldW-md.squeeze_pos-md.squeeze_width),-880)
            GC.rectangle('fill',rBound,0,4,-880)
        end
    end
end

return squeeze
