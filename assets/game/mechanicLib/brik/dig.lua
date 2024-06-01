---@type Map<Techmino.Event.Brik|Map<Techmino.Event.Brik>>
local dig={}

function dig.sprint_event_playerInit(P)
    for _=1,P.modeData.target.lineStay do P:riseGarbage() end
    P.fieldDived=0
    P.modeData.lineDig=0
    P.modeData.lineExist=P.modeData.target.lineStay
end
function dig.sprint_event_afterClear(P,clear)
    local md=P.modeData
    local digLine=0
    for _,v in next,clear.linePos do
        if v<=md.lineExist then
            digLine=digLine+1
        end
    end
    if digLine>0 then
        md.lineDig=md.lineDig+digLine
        if md.lineDig>=P.modeData.target.lineDig then
            P:finish('AC')
        else
            md.lineExist=md.lineExist-digLine
            local add=math.min(P.modeData.target.lineDig-md.lineDig,P.modeData.target.lineStay)-md.lineExist
            if add>0 then
                for _=1,add do P:riseGarbage() end
                md.lineExist=md.lineExist+add
            end
        end
    end
end

function dig.practice_event_playerInit(P)
    local dir=P:random(0,1)*2-1
    local phase=P:random(3,6)
    for i=1,12 do P:riseGarbage((phase+i)*dir%P.settings.fieldW+1) end
    P.fieldDived=0
    P.modeData.lineExist=P.modeData.target.lineStart
end
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

function dig.checker_event_playerInit(P)
    local f=P:random()>.5
    for _=1,P.modeData.target.lineStart do
        P:riseGarbage(f and {1,3,5,7,9} or {2,4,6,8,10})
        f=not f
    end
    P.fieldDived=0
    P.modeData.lineExist=P.modeData.target.lineStart
end
dig.checker_event_afterClear=dig.practice_event_afterClear

local function pushShaleGarbage(P)
    P:riseGarbage(P:calculateHolePos(
        P:random(2,3), -- count
        -.2, -- splitRate
        -.1, -- copyRate
        -1 -- sandwichRate
    ))
end
function dig.shale_event_playerInit(P)
    for _=1,P.modeData.target.lineStay do pushShaleGarbage(P) end
    P.fieldDived=0
    P.modeData.lineDig=0
    P.modeData.lineExist=P.modeData.target.lineStay
end
function dig.shale_event_afterClear(P,clear)
    local md=P.modeData
    local cleared=0
    for _,v in next,clear.linePos do
        if v<=md.lineExist then
            cleared=cleared+1
        end
    end
    if cleared>0 then
        md.lineDig=md.lineDig+cleared
        if md.lineDig>=P.modeData.target.lineDig then
            P:finish('AC')
        else
            md.lineExist=md.lineExist-cleared
            local add=math.min(P.modeData.target.lineDig-md.lineDig,P.modeData.target.lineStay)-md.lineExist
            if add>0 then
                for _=1,add do pushShaleGarbage(P) end
                md.lineExist=md.lineExist+add
            end
        end
    end
end

local function pushVolcanicsGarbage(P)
    P:riseGarbage(P:calculateHolePos(
        P:random(3,4), -- count
        .2,  -- splitRate
        -.1, -- copyRate
        .1   -- sandwichRate
    ))
end
function dig.volcanics_event_playerInit(P)
    for _=1,P.modeData.target.lineStay do pushVolcanicsGarbage(P) end
    P.fieldDived=0
    P.modeData.lineDig=0
    P.modeData.lineExist=P.modeData.target.lineStay
end
function dig.volcanics_event_afterClear(P,clear)
    local md=P.modeData
    local cleared=0
    for _,v in next,clear.linePos do
        if v<=md.lineExist then
            cleared=cleared+1
        end
    end
    if cleared>0 then
        md.lineDig=md.lineDig+cleared
        if md.lineDig>=P.modeData.target.lineDig then
            P:finish('AC')
        else
            md.lineExist=md.lineExist-cleared
            local add=math.min(P.modeData.target.lineDig-md.lineDig,P.modeData.target.lineStay)-md.lineExist
            if add>0 then
                for _=1,add do pushVolcanicsGarbage(P) end
                md.lineExist=md.lineExist+add
            end
        end
    end
end

function dig.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.target.lineDig-P.modeData.lineDig,-300,-70)
    FONT.set(30) GC.mStr(Text.target_line,-300,15)
end

return dig
