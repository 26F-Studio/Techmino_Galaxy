--- @type Techmino.Mech.mino
local dig={}

dig.sprint_event_playerInit=TABLE.newPool(function(self,lineStay)
    self[lineStay]=function(P)
        for _=1,lineStay do P:riseGarbage() end
        P.fieldDived=0
        P.modeData.lineDig=0
        P.modeData.lineExist=lineStay
    end
    return self[lineStay]
end)
dig.sprint_event_afterClear=TABLE.newPool(function(self,info)
    assert(type(info)=='string')
    local lineCount,lineStay=info:match('(%d+),(%d+)')
    lineCount,lineStay=tonumber(lineCount),tonumber(lineStay)
    self[info]=function(P,clear)
        local md=P.modeData
        local cleared=0
        for _,v in next,clear.linePos do
            if v<=md.lineExist then
                cleared=cleared+1
            end
        end
        if cleared>0 then
            md.lineDig=md.lineDig+cleared
            if md.lineDig>=lineCount then
                P:finish('AC')
            else
                md.lineExist=md.lineExist-cleared
                local add=math.min(lineCount-md.lineDig,lineStay)-md.lineExist
                if add>0 then
                    for _=1,add do P:riseGarbage() end
                    md.lineExist=md.lineExist+add
                end
            end
        end
    end
    return self[info]
end)

dig.practice_event_playerInit=TABLE.newPool(function(self,lineStart)
    self[lineStart]=function(P)
        local dir=P:random(0,1)*2-1
        local phase=P:random(3,6)
        for i=1,12 do P:riseGarbage((phase+i)*dir%P.settings.fieldW+1) end
        P.fieldDived=0
        P.modeData.lineExist=lineStart
    end
    return self[lineStart]
end)
function dig.practice_event_afterClear(P,clear)
    for i=#clear.linePos,1,-1 do
        if clear.linePos[i]<=P.modeData.lineExist then
            P.modeData.lineExist=P.modeData.lineExist-1
            if P.modeData.lineExist==0 then
                P:finish('AC')
                break
            end
        end
    end
end

dig.checker_event_playerInit=TABLE.newPool(function(self,lineStart)
    self[lineStart]=function(P)
        local f=P:random()>.5
        for _=1,lineStart do
            P:riseGarbage(f and {1,3,5,7,9} or {2,4,6,8,10})
            f=not f
        end
        P.fieldDived=0
        P.modeData.lineExist=lineStart
    end
    return self[lineStart]
end)
dig.checker_event_afterClear=dig.practice_event_afterClear

local function pushShaleGarbage(P)
    P:riseGarbage(P:calculateHolePos(
        P:random(2,3),-- count
        -.2,-- splitRate
        -.1,-- copyRate
        -1 -- sandwichRate
    ))
end
dig.shale_event_playerInit=TABLE.newPool(function(self,lineStay)
    self[lineStay]=function(P)
        for _=1,lineStay do pushShaleGarbage(P) end
        P.fieldDived=0
        P.modeData.lineDig=0
        P.modeData.lineExist=lineStay
    end
    return self[lineStay]
end)
dig.shale_event_afterClear=TABLE.newPool(function(self,info)
    assert(type(info)=='string')
    local lineCount,lineStay=info:match('(%d+),(%d+)')
    lineCount,lineStay=tonumber(lineCount),tonumber(lineStay)
    self[info]=function(P,clear)
        local md=P.modeData
        local cleared=0
        for _,v in next,clear.linePos do
            if v<=md.lineExist then
                cleared=cleared+1
            end
        end
        if cleared>0 then
            md.lineDig=md.lineDig+cleared
            if md.lineDig>=lineCount then
                P:finish('AC')
            else
                md.lineExist=md.lineExist-cleared
                local add=math.min(lineCount-md.lineDig,lineStay)-md.lineExist
                if add>0 then
                    for _=1,add do pushShaleGarbage(P) end
                    md.lineExist=md.lineExist+add
                end
            end
        end
    end
    return self[info]
end)

local function pushVocanicsGarbage(P)
    P:riseGarbage(P:calculateHolePos(
        P:random(3,4),-- count
        .2,-- splitRate
        -.1, -- copyRate
        .1 -- sandwichRate
    ))
end
dig.vocanics_event_playerInit=TABLE.newPool(function(self,lineStay)
    self[lineStay]=function(P)
        for _=1,lineStay do pushVocanicsGarbage(P) end
        P.fieldDived=0
        P.modeData.lineDig=0
        P.modeData.lineExist=lineStay
    end
    return self[lineStay]
end)
dig.vocanics_event_afterClear=TABLE.newPool(function(self,info)
    assert(type(info)=='string')
    local lineCount,lineStay=info:match('(%d+),(%d+)')
    lineCount,lineStay=tonumber(lineCount),tonumber(lineStay)
    self[info]=function(P,clear)
        local md=P.modeData
        local cleared=0
        for _,v in next,clear.linePos do
            if v<=md.lineExist then
                cleared=cleared+1
            end
        end
        if cleared>0 then
            md.lineDig=md.lineDig+cleared
            if md.lineDig>=lineCount then
                P:finish('AC')
            else
                md.lineExist=md.lineExist-cleared
                local add=math.min(lineCount-md.lineDig,lineStay)-md.lineExist
                if add>0 then
                    for _=1,add do pushVocanicsGarbage(P) end
                    md.lineExist=md.lineExist+add
                end
            end
        end
    end
    return self[info]
end)

dig.event_drawOnPlayer=TABLE.newPool(function(self,lineCount)
    self[lineCount]=function(P)
        P:drawInfoPanel(-380,-60,160,120)
        FONT.set(80) GC.mStr(lineCount-P.modeData.lineDig,-300,-55)
    end
    return self[lineCount]
end)

return dig
