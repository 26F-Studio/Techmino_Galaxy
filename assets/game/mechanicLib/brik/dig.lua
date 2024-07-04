---@type Map<Techmino.Event.Brik>
local dig={}

local garbageTypes={
    line=function(P)
        if not P.modeData.dig_line_init then
            P.modeData.dig_line_init=true
            P.modeData.risePosition=math.floor((P.settings.fieldW+1)/2+P:random())
            P.modeData.riseDirection=P:random(0,1)*2-1
        end
        P:riseGarbage(P.modeData.risePosition)
        if P.modeData.risePosition<=1 or P.modeData.risePosition>=P.settings.fieldW then
            P.modeData.riseDirection=-P.modeData.riseDirection
        end
        P.modeData.risePosition=P.modeData.risePosition+P.modeData.riseDirection
        P.modeData.garbageRised=P.modeData.garbageRised+1
    end,
    drill=function(P)
        P:riseGarbage()
    end,
    solid=function(P)
        P:riseGarbage({})
        P.modeData.garbageRised=P.modeData.garbageRised+1
    end,
    shale=function(P)
        P:riseGarbage(P:calculateHolePos(
            P:random(2,3), -- count
            -.2, -- splitRate
            -.1, -- copyRate
            -1   -- sandwichRate
        ))
        P.modeData.garbageRised=P.modeData.garbageRised+1
    end,
    volcanics=function(P)
        P:riseGarbage(P:calculateHolePos(
            P:random(3,4), -- count
            .2,  -- splitRate
            -.1, -- copyRate
            .1   -- sandwichRate
        ))
        P.modeData.garbageRised=P.modeData.garbageRised+1
    end,
    checker=function(P)
        P:riseGarbage(P.modeData.garbageRised%2==0 and {1,3,5,7,9} or {2,4,6,8,10})
        P.modeData.garbageRised=P.modeData.garbageRised+1
    end,
}

function dig.event_playerInit(P)
    P.modeData.garbageRised=0
    P.modeData.lineDig=0
    P.modeData.lineExist=P.modeData.lineStay
    for _=1,P.modeData.lineStay do
        garbageTypes[P.modeData.digMode](P)
    end
end

function dig.event_afterClear(P,clear)
    local md=P.modeData
    local digLine=0
    for _,v in next,clear.linePos do
        if v<=md.lineExist then
            digLine=digLine+1
        end
    end
    if digLine>0 or md.lineExist<md.lineStay then
        md.lineDig=md.lineDig+digLine
        md.lineExist=md.lineExist-digLine
        if md.lineDig>=md.target.lineDig then
            P:finish('AC')
        else
            -- print(md.target.lineDig-md.lineDig,md.lineStay)
            local add=math.min(md.target.lineDig-md.lineDig,md.lineStay)-md.lineExist
            if add>0 then
                for _=1,add do garbageTypes[P.modeData.digMode](P) end
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
