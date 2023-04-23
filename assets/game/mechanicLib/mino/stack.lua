local floor,min=math.floor,math.min

local scale={
    'E3','F3','G3','A3',
    'B3','D4','E4','F4',
    'G4','A4','B4','D5',
    'F5','G5','A5','C6',
    'E6','G6','B6','C7',
    'E7','G7','A7','C8',
}
local lineFont={
    30,35,40,45,--1~4
    50,50,55,55,55,--5~9
    60,60,60,60,60,--10~14
    75,75,75,80,80,--15~19
    85,85,--20,21
    90,90,--22,23
    95,95,--24,25
    100,--26+
}

local stack={}

function stack.switch(P)
    if not P.modeData.inZone then
        P.modeData.inZone=true
        P.modeData.zone_lines=0
        P.modeData.zone_highestLine=0
        P.modeData.zone_lineList={}-- For no-fall mode
        P.modeData.zoneTextHeight0=0
        P.modeData.zoneTextHeight=false-- For line number animation

        P.settings.clearFullLine=false

        -- Switch to 0G
        P.dropTimer=P.dropTimer/P.settings.dropDelay*1e99
        P.lockTimer=P.lockTimer/P.settings.lockDelay*1e99
        P.modeData.zone_dropDelay=P.settings.dropDelay
        P.modeData.zone_lockDelay=P.settings.lockDelay
        P.settings.dropDelay,P.settings.lockDelay=1e99,1e99

        BGM.set('all','highgain',.626,.26)
    else
        if P.modeData.zone_lines>0 then
            P:say{
                text=tostring(P.modeData.zone_lines),
                y=P.modeData.zoneTextHeight or P.modeData.zoneTextHeight0,
                size=min(lineFont[min(P.modeData.zone_lines,26)]*2,100),
                duration=min(P.modeData.zone_lines^.5*.626,3),
                type='bold',
                style='zoomout',
                styleArg=.626,
            }
        end
        local lines=P:getFullLines()
        if lines then
            P:clearLines(lines)
            P:freshGhost()
        end

        P.modeData.inZone=false
        P.modeData.zone_lines=false
        P.modeData.zone_highestLine=false
        P.modeData.zone_lineList=false
        P.modeData.zoneTextHeight,P.modeData.zoneTextHeight0=false,false

        P.settings.clearFullLine=true

        -- Recover gravity
        P.dropTimer=floor(P.dropTimer/P.settings.dropDelay*P.modeData.zone_dropDelay)
        P.lockTimer=floor(P.lockTimer/P.settings.lockDelay*P.modeData.zone_lockDelay)
        P.settings.dropDelay=P.modeData.zone_dropDelay
        P.settings.lockDelay=P.modeData.zone_lockDelay
        P.modeData.zone_dropDelay,P.modeData.zone_lockDelay=nil,nil

        BGM.set('all','highgain',1,.1)
    end
end

local expApproach=MATH.expApproach
function stack.event_always_animated(P)
    local md=P.modeData
    if md.inZone and md.zoneTextHeight then
        md.zoneTextHeight=expApproach(md.zoneTextHeight,md.zoneTextHeight0,.00626)
    end
end

function stack.event_afterLock(P)
    if P.modeData.inZone then
        local F=P.field
        local list={}
        local md=P.modeData
        for y=md.zone_lines+1,F:getHeight() do
            if P:isFullLine(y) then
                table.insert(list,y)
            end
        end
        for i=1,#list do
            if list[i]-(i==1 and md.zone_lines or list[i-1])>1 then
                P:cutConnection(list[i]-1)
            end
            if i==#list or list[i+1]-list[i]>1 then
                P:cutConnection(list[i])
            end
        end
        for _,y in next,list do
            if y>=md.zone_lines+1 then
                for x=1,#F._matrix[y] do
                    local C=F:getCell(x,y)
                    if C then C.color=0 end
                end
                table.insert(F._matrix,md.zone_lines+1,table.remove(F._matrix,y))
            end
            md.zone_lines=md.zone_lines+1
            md.zone_highestLine=md.zone_highestLine+1
            md.zoneTextHeight0=400-(md.zone_highestLine+.5)*(400/P.settings.fieldW)/2
            if not P.modeData.zoneTextHeight then P.modeData.zoneTextHeight=P.modeData.zoneTextHeight0 end
            SFX.playSample('bass',(20-md.zone_lines)/10,scale[md.zone_lines])
            SFX.playSample('lead',min(md.zone_lines/10,1),scale[md.zone_lines])
            -- or 9.5-tone scale
        end
    end
end
function stack.event_afterLock_noFall(P)
    if P.modeData.inZone then
        local F=P.field
        local list={}
        local md=P.modeData
        for y=1,F:getHeight() do
            if not P.modeData.zone_lineList[y] and P:isFullLine(y) then
                table.insert(list,y)
                P.modeData.zone_lineList[y]=true
                if y>md.zone_highestLine then
                    md.zone_highestLine=y
                    md.zoneTextHeight0=400-(md.zone_highestLine+.5)*(400/P.settings.fieldW)/2
                    if not P.modeData.zoneTextHeight then P.modeData.zoneTextHeight=P.modeData.zoneTextHeight0 end
                end
            end
        end
        for _,y in next,list do
            if y>=md.zone_lines+1 then
                for x=1,#F._matrix[y] do
                    local C=F:getCell(x,y)
                    if C then C.color=0 end
                end
            end
            md.zone_lines=md.zone_lines+1
            SFX.playSample('bass',(20-md.zone_lines)/10,scale[md.zone_lines])
            SFX.playSample('lead',min(md.zone_lines/10,1),scale[md.zone_lines])
        end
    end
end

function stack.event_whenSuffocate(P)
    if P.modeData.inZone then
        stack.switch(P,false)
    end
end

function stack.event_drawOnPlayer(P)
    local md=P.modeData
    if md.inZone and md.zone_lines>0 then
        GC.push('transform')
        GC.translate(0,md.zoneTextHeight0)
        GC.scale(2)
        local fontSize=lineFont[min(md.zone_lines,26)]
        FONT.set(fontSize,'bold')
        GC.shadedPrint(md.zone_lines,0,-fontSize*.5,'center',2,8,COLOR.lD,COLOR.L)
        GC.pop()
    end
end
function stack.event_drawOnPlayer_animated(P)
    local md=P.modeData
    if md.inZone and md.zone_lines>0 then
        GC.push('transform')
        GC.translate(0,md.zoneTextHeight)
        GC.scale(2)
        local fontSize=lineFont[min(md.zone_lines,26)]
        FONT.set(fontSize,'bold')
        GC.shadedPrint(md.zone_lines,0,-fontSize*.5,'center',2,8,COLOR.lD,COLOR.L)
        GC.pop()
    end
end

return stack
