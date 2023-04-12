local scale={
    'E3','F3','G3','A3',
    'B3','D4','E4','F4',
    'G4','A4','B4','D5',
    'F5','G5','A5','C6',
    'E6','G6','B6','C7',
    'E7','G7','A7','C8',
}

local stack={}

function stack.switch(P)
    if not P.modeData.inZone then
        P.modeData.inZone=true
        P.modeData.zone_lineList={highest=0}-- For no-fall mode
        P.modeData.zone_lines=0
        P.settings.clearFullLine=false

        -- Switch to 0G
        P.dropTimer=P.dropTimer/P.settings.dropDelay*1e99
        P.lockTimer=P.lockTimer/P.settings.lockDelay*1e99
        P.modeData.zone_dropDelay=P.settings.dropDelay
        P.modeData.zone_lockDelay=P.settings.lockDelay
        P.settings.dropDelay,P.settings.lockDelay=1e99,1e99

        BGM.set('all','highgain',.626,.26)
    else
        P.modeData.inZone=false
        P.modeData.zone_lineList=false
        P.modeData.zone_lines=false
        P.settings.clearFullLine=true

        -- Recover gravity
        P.dropTimer=math.floor(P.dropTimer/P.settings.dropDelay*P.modeData.zone_dropDelay)
        P.lockTimer=math.floor(P.lockTimer/P.settings.lockDelay*P.modeData.zone_lockDelay)
        P.settings.dropDelay=P.modeData.zone_dropDelay
        P.settings.lockDelay=P.modeData.zone_lockDelay
        P.modeData.zone_dropDelay,P.modeData.zone_lockDelay=nil,nil

        local lines=P:getFullLines()
        if lines then
            P:clearLines(lines)
            P:freshGhost()
        end
        BGM.set('all','highgain',1,.1)
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
            md.zone_lineList.highest=md.zone_lineList.highest+1
            SFX.playSample('bass',(20-md.zone_lines)/10,scale[md.zone_lines])
            SFX.playSample('lead',math.min(md.zone_lines/10,1),scale[md.zone_lines])
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
                if y>md.zone_lineList.highest then
                    md.zone_lineList.highest=y
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
            SFX.playSample('lead',math.min(md.zone_lines/10,1),scale[md.zone_lines])
        end
    end
end

function stack.event_whenSuffocate(P)
    if P.modeData.inZone then
        stack.switch(P,false)
    end
end

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
function stack.event_drawOnPlayer(P)
    local md=P.modeData
    if md.inZone and md.zone_lines>0 then
        GC.push('transform')
        GC.translate(0,400-(md.zone_lineList.highest+.5)*(400/P.settings.fieldW)/2)
        GC.scale(2)
        local fontSize=lineFont[math.min(md.zone_lines,26)]
        FONT.set(fontSize,'bold')
        GC.shadedPrint(md.zone_lines,0,-fontSize*.5,'center',2,8,COLOR.lD,COLOR.L)
        GC.pop()
    end
end

return stack
