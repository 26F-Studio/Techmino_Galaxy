local gc=love.graphics

---@type Techmino.Mech.mino
local hypersonic={}

---@param mode 'low'|'high'|'hidden'|'titanium'
function hypersonic.event_playerInit_auto(P,mode)
    hypersonic.event_playerInit(P)
    if mode=='low' then
        hypersonic.low_event_playerInit(P)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.low_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.event_drawOnPlayer)
    elseif mode=='high' then
        hypersonic.high_event_playerInit(P)
        P:addEvent('always',hypersonic.high_event_always)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.high_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.event_drawOnPlayer)
    elseif mode=='hidden' then
        hypersonic.hidden_event_playerInit(P)
        P:addEvent('always',hypersonic.hidden_event_always)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.hidden_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.hidden_event_drawOnPlayer)
    elseif mode=='titanium' then
        hypersonic.titanium_event_playerInit(P)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.titanium_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.titanium_event_drawOnPlayer)
    else
        error('No hypersonic mode '..tostring(mode))
    end
end

function hypersonic.event_playerInit(P)
    P.modeData.point=0
    P.modeData.level=1
    P.modeData.target=100
    P.modeData.maxHold=0
    P.modeData.storedAsd=P.settings.asd
    P.modeData.storedAsp=P.settings.asp
    P.settings.initMove='hold'
    P.settings.initRotate='hold'
    P.settings.initHold='hold'
end

function hypersonic.event_afterSpawn(P)
    local md=P.modeData
    if md.maxHold<#P.holdQueue then
        md.maxHold=#P.holdQueue
    else
        if md.point<md.target-1 then
            md.point=md.point+1
            if md.point==md.target-1 then
                P:playSound('notice')
            end
        end
    end
end

function hypersonic.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-80,160,160)
    FONT.set(70)
    GC.mStr(P.modeData.point,-300,-90)
    gc.rectangle('fill',-375,-2,150,4)
    GC.mStr(P.modeData.target,-300,-5)
end

do -- low
    local levels={
        {lock=1e3,spawn=320,asd=200,asp=36},
        {lock=850,spawn=290,asd=170,asp=33},
        {lock=700,spawn=260,asd=140,asp=30},
        {lock=550,spawn=230,asd=120,asp=28},
        {lock=400,spawn=200,asd=100,asp=26},
    }

    function hypersonic.low_event_playerInit(P)
        P.settings.dropDelay=0
        P.settings.asd=math.max(P.modeData.storedAsd,levels[1].asd)
        P.settings.asp=math.max(P.modeData.storedAsp,levels[1].asp)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=300
    end

    function hypersonic.low_event_afterClear(P,clear)
        local md=P.modeData
        local dScore=math.floor((clear.line+1)^2/4) -- 1,2,4,6
        if dScore==0 then return end
        md.point=md.point+dScore
        if md.point==md.target-1 then
            P:playSound('notice')
        else
            while md.point>=md.target do
                if md.level<5 then
                    P:playSound('reach')
                    md.level=md.level+1
                    md.target=100*md.level

                    P.settings.asd=math.max(md.storedAsd,levels[md.level].asd)
                    P.settings.asp=math.max(md.storedAsp,levels[md.level].asp)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                else
                    md.point=md.target
                    P:finish('AC')
                    return
                end
            end
        end
    end
end

do -- high
    local levels={
        {lock=450,freshT=4400,spawn=150,clear=380,asd=130,asp=29,bumpInterval=false},
        {lock=400,freshT=4200,spawn=140,clear=340,asd=120,asp=28,bumpInterval=false},
        {lock=360,freshT=4000,spawn=130,clear=300,asd=110,asp=27,bumpInterval=false},
        {lock=330,freshT=3800,spawn=120,clear=260,asd=105,asp=26,bumpInterval=false},
        {lock=300,freshT=3600,spawn=110,clear=220,asd=100,asp=25,bumpInterval=false},
        {lock=300,freshT=3400,spawn=100,clear=180,asd=96, asp=24,bumpInterval=10e3},
        {lock=290,freshT=3200,spawn=95, clear=160,asd=92, asp=23,bumpInterval=8e3},
        {lock=280,freshT=3000,spawn=90, clear=140,asd=88, asp=22,bumpInterval=6e3},
        {lock=270,freshT=2800,spawn=85, clear=120,asd=84, asp=21,bumpInterval=5e3},
        {lock=260,freshT=2600,spawn=80, clear=100,asd=80, asp=20,bumpInterval=4e3},
    }

    function hypersonic.high_event_playerInit(P)
        P.modeData.bumpDelay=false
        P.modeData.bumpTimer=false

        P.settings.dropDelay=0
        P.settings.asd=math.max(P.modeData.storedAsd,levels[1].asd)
        P.settings.asp=math.max(P.modeData.storedAsp,levels[1].asp)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=levels[1].clear
        P.settings.maxFreshTime=levels[1].freshT
    end

    function hypersonic.high_event_always(P)
        if P.finished or not P.modeData.bumpTimer then return end
        P.modeData.bumpTimer=P.modeData.bumpTimer-1
        if P.modeData.bumpTimer<=0 then
            local F=P.field
            P.modeData.bumpTimer=P.modeData.bumpDelay

            if P.field:getHeight()==0 then return end

            local firstLine=F._matrix[1]
            local newLine={}
            for i=1,#firstLine do
                newLine[i]=firstLine[i] and P:newCell(firstLine[i].color) or false
            end
            table.insert(F._matrix,1,newLine)
            for i=1,#firstLine do
                local cells=P:getConnectedCells(i,2)
                for j=1,#cells do
                    local c=F:getCell(cells[j][1],cells[j][2])
                    c.conn[newLine[i].cid]=0
                    newLine[i].conn[c.cid]=0
                end
            end
            if P.hand then
                P.handY=P.handY+1
                P.minY=P.minY+1
                P:freshGhost()
            end
            P:playSound('move_failed')
        end
    end

    function hypersonic.high_event_afterClear(P,clear)
        local md=P.modeData
        local dScore=math.floor((clear.line+1)^2/4) -- 1,2,4,6
        if dScore==0 then return end
        md.point=md.point+dScore
        if md.point==md.target-1 then
            P:playSound('notice')
        else
            while md.point>=md.target do
                if md.level<10 then
                    P:playSound('reach')
                    md.level=md.level+1
                    md.target=100*md.level

                    P.settings.asd=math.max(md.storedAsd,levels[md.level].asd)
                    P.settings.asp=math.max(md.storedAsp,levels[md.level].asp)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    P.settings.clearDelay=levels[md.level].clear
                    P.settings.maxFreshTime=levels[md.level].freshT

                    md.bumpDelay=levels[md.level].bumpInterval
                    if md.bumpDelay then
                        md.bumpTimer=md.bumpDelay
                    end
                else
                    md.point=md.target
                    P:finish('AC')
                    return
                end
            end
        end
    end
end

do -- hidden
    local levels={
        {lock=510,freshT=6000,spawn=150,clear=400,asd=130,asp=29,visTime=5000,fadeTime=2600},
        {lock=460,freshT=5800,spawn=140,clear=360,asd=120,asp=28,visTime=4000,fadeTime=2600},
        {lock=420,freshT=5600,spawn=130,clear=320,asd=110,asp=27,visTime=3500,fadeTime=2600},
        {lock=380,freshT=5400,spawn=120,clear=280,asd=105,asp=26,visTime=3000,fadeTime=2600},
        {lock=350,freshT=5200,spawn=110,clear=240,asd=100,asp=25,visTime=2500,fadeTime=2100},
        {lock=320,freshT=5000,spawn=100,clear=200,asd=96, asp=24,visTime=2000,fadeTime=1500},
        {lock=300,freshT=4800,spawn=95, clear=180,asd=92, asp=23,visTime=1600,fadeTime=1100},
        {lock=280,freshT=4600,spawn=90, clear=160,asd=88, asp=22,visTime=1200,fadeTime=900 },
        {lock=270,freshT=4400,spawn=85, clear=140,asd=84, asp=21,visTime=900, fadeTime=800 },
        {lock=260,freshT=4200,spawn=80, clear=120,asd=80, asp=20,visTime=600, fadeTime=600 },
    }

    local showInvisPeriod=26000*10
    local showInvisStep=30
    local showVisTime=1000
    local showFadeTime=1000

    local bpm=130
    local flashProbability=.1626
    local flashInterval=math.floor(4*60*1000/bpm/2^(-1/12)+.5)
    local flashVisTime1,flashVisTime2=120,460
    local flashFadeTime=620

    local endAllInterval=math.floor(60*1000/bpm/2^(-1/12)+.5)
    local endVisTime1,endVisTime2=620,723
    local endFadeTime=1260

    function hypersonic.hidden_event_playerInit(P)
        P.modeData.flashTimer=flashInterval
        P.modeData.swipeTimer=showInvisStep*26
        P.modeData.swipeStep=10
        P.modeData.showAllTimer=endAllInterval

        P.settings.dropDelay=0
        P.settings.asd=math.max(P.modeData.storedAsd,levels[1].asd)
        P.settings.asp=math.max(P.modeData.storedAsp,levels[1].asp)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=levels[1].clear
        P.settings.maxFreshTime=levels[1].freshT
        P.settings.pieceVisTime=levels[1].visTime
        P.settings.pieceFadeTime=levels[1].fadeTime
    end

    function hypersonic.hidden_event_always(P)
        local md=P.modeData
        -- Show all after finished
        if P.finished then
            md.showAllTimer=(md.showAllTimer-1)%endAllInterval
            if md.showAllTimer==0 then
                for y=1,P.field:getHeight() do
                    for x=1,P.settings.fieldW do
                        local c=P.field:getCell(x,y)
                        if c then
                            c.visTimer=P:random(endVisTime1,endVisTime2)
                            c.fadeTime=endFadeTime
                        end
                    end
                end
            end
        else
            -- Swipe show invis periodly
            local t=md.swipeTimer
            local swiping=t/showInvisStep<=P.field:getHeight()
            t=t%showInvisPeriod+(swiping and 1 or md.swipeStep)
            if swiping and t%showInvisStep==0 then
                for x=1,P.settings.fieldW do
                    local c=P.field:getCell(x,t/showInvisStep)
                    if c then
                        c.visTimer=math.max(c.visTimer or 0,showVisTime)
                        c.fadeTime=math.max(c.fadeTime or 0,showFadeTime)
                    end
                end
            end
            md.swipeTimer=t

            -- Random flashing on beat (may on wrong phase)
            md.flashTimer=(md.flashTimer-1)%flashInterval
            if md.flashTimer==0 then
                for y=1,math.min(P.field:getHeight(),2*P.settings.fieldW) do
                    for x=1,P.settings.fieldW do
                    if P:random()<flashProbability then
                            local c=P.field:getCell(x,y)
                            if c then
                                c.visTimer=math.max(c.visTimer or 0,P:random(flashVisTime1,flashVisTime2))
                                c.fadeTime=math.max(c.fadeTime or 0,flashFadeTime)
                            end
                        end
                    end
                end
            end
        end
    end

    function hypersonic.hidden_event_afterClear(P,clear)
        local md=P.modeData

        -- Update showInvis speed
        md.swipeStep=10
        for i=#P.clearHistory,#P.clearHistory-4,-1 do
            local c=P.clearHistory[i]
            if not c then break end
            md.swipeStep=math.max(md.swipeStep+(3-c.line),1)
        end

        local dScore=math.floor(clear.line^2/2) -- 0,2,4,8
        if dScore==0 then return end
        md.point=md.point+dScore
        if md.point==md.target-1 then
            P:playSound('notice')
        else
            while md.point>=md.target do
                if md.level<10 then
                    P:playSound('reach')
                    md.level=md.level+1
                    md.target=100*md.level

                    P.settings.asd=math.max(md.storedAsd,levels[md.level].asd)
                    P.settings.asp=math.max(md.storedAsp,levels[md.level].asp)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    P.settings.clearDelay=levels[md.level].clear
                    P.settings.maxFreshTime=levels[md.level].freshT
                    P.settings.pieceVisTime=levels[md.level].visTime
                    P.settings.pieceFadeTime=levels[md.level].fadeTime
                else
                    md.point=md.target
                    P:finish('AC')
                    return
                end
            end
        end
    end

    function hypersonic.hidden_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-80,160,160)
        FONT.set(70)
        GC.mStr(P.modeData.point,-300,-90)
        gc.rectangle('fill',-375,-2,150,4)
        GC.mStr(P.modeData.target,-300,-5)
        GC.setAlpha(.7023)
        GC.mStr(P.modeData.point,-300+10*math.sin(P.time),-90)
    end
end

do -- titanium
    local levels={
        {lock=350,freshT=900,freshC=5,spawn=170,clear=380,asd=98,asp=29},
        {lock=300,freshT=850,freshC=5,spawn=160,clear=340,asd=96,asp=28},
        {lock=270,freshT=800,freshC=5,spawn=150,clear=300,asd=94,asp=27},
        {lock=240,freshT=750,freshC=5,spawn=140,clear=260,asd=92,asp=26},
        {lock=220,freshT=700,freshC=4,spawn=130,clear=220,asd=90,asp=25},
        {lock=200,freshT=650,freshC=4,spawn=120,clear=180,asd=88,asp=24},
        {lock=180,freshT=600,freshC=4,spawn=115,clear=160,asd=86,asp=23},
        {lock=170,freshT=550,freshC=4,spawn=110,clear=140,asd=84,asp=22},
        {lock=160,freshT=460,freshC=3,spawn=105,clear=120,asd=82,asp=21},
        {lock=150,freshT=420,freshC=3,spawn=100,clear=100,asd=80,asp=20},
    }
    function hypersonic.titanium_event_playerInit(P)
        P.settings.dropDelay=0
        P.settings.asd=math.max(P.modeData.storedAsd,levels[1].asd)
        P.settings.asp=math.max(P.modeData.storedAsp,levels[1].asp)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=levels[1].clear
        P.settings.maxFreshTime=levels[1].freshT
        P.settings.maxFreshChance=levels[1].freshC
        P.freshChance=levels[1].freshC
    end
    function hypersonic.titanium_event_afterClear(P,clear)
        local md=P.modeData
        local dScore=math.floor(clear.line^2/3+2) -- 2,3,5,7
        if dScore==0 then return end
        md.point=md.point+dScore
        if md.point==md.target-1 then
            P:playSound('notice')
        else
            while md.point>=md.target do
                if md.level<10 then
                    P:playSound('reach')
                    md.level=md.level+1
                    md.target=100*md.level

                    P.settings.asd=math.max(md.storedAsd,levels[md.level].asd)
                    P.settings.asp=math.max(md.storedAsp,levels[md.level].asp)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    P.settings.clearDelay=levels[md.level].clear
                    P.settings.maxFreshTime=levels[md.level].freshT
                    P.settings.maxFreshChance=levels[md.level].freshC
                else
                    md.point=md.target
                    P:finish('AC')
                    return
                end
            end
        end
    end
    function hypersonic.titanium_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-80,160,160)
        FONT.set(70)
        GC.mStr(P.modeData.point,-300,-90)
        gc.rectangle('fill',-375,-2,150,4)
        GC.mStr(P.modeData.target,-300,-5)
        FONT.set(85)
        GC.setAlpha(.42+.162*math.sin(P.time/126))
        GC.mStr(P.modeData.point,-300,-100)
    end
end

return hypersonic
