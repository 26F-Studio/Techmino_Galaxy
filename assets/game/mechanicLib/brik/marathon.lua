local gc=love.graphics
local floor=math.floor
local min,max=math.min,math.max

---@type Map<Techmino.Event.Brik>
local marathon={}

do -- marathon
    local levels={-- par: drop interval
        {drop=1000,lock=1000,spawn=150, par=999},
        {drop=730, lock=1000,spawn=150, par=909},
        {drop=533, lock=1000,spawn=150, par=833},
        {drop=389, lock=1000,spawn=150, par=714},
        {drop=284, lock=1000,spawn=150, par=666},
        {drop=207, lock=800 ,spawn=130, par=625},
        {drop=151, lock=800 ,spawn=130, par=588},
        {drop=110, lock=800 ,spawn=130, par=555},
        {drop=81,  lock=800 ,spawn=130, par=526},
        {drop=59,  lock=800 ,spawn=130, par=500},
        {drop=43,  lock=700 ,spawn=110, par=454},
        {drop=31,  lock=700 ,spawn=110, par=416},
        {drop=23,  lock=700 ,spawn=110, par=384},
        {drop=17,  lock=700 ,spawn=110, par=357},
        {drop=12,  lock=700 ,spawn=110, par=333},
        {drop=9,   lock=600 ,spawn=90,  par=312},
        {drop=7,   lock=580 ,spawn=90,  par=294},
        {drop=5,   lock=560 ,spawn=90,  par=277},
        {drop=3,   lock=540 ,spawn=90,  par=263},
        {drop=2,   lock=520 ,spawn=90,  par=250},
        {drop=0,   lock=500 ,spawn=75,  par=238},
        {drop=0,   lock=480 ,spawn=75,  par=227},
        {drop=0,   lock=460 ,spawn=75,  par=217},
        {drop=0,   lock=440 ,spawn=75,  par=200},
        {drop=0,   lock=420 ,spawn=75,  par=189},
        {drop=0,   lock=400 ,spawn=70,  par=179},
        {drop=0,   lock=380 ,spawn=70,  par=169},
        {drop=0,   lock=360 ,spawn=70,  par=161},
        {drop=0,   lock=340 ,spawn=70,  par=154},
        {drop=0,   lock=320 ,spawn=70,  par=143},
    }

    function marathon.event_playerInit(P)
        P.settings.asd=max(P.settings.asd,100)
        P.settings.asp=max(P.settings.asp,20)

        P.settings.dropDelay=levels[1].drop
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn

        P.modeData.transition1=1e99
        P.modeData.transition2=1e99
        P.modeData.lineTarget=10

        P.modeData.level=1
        P.modeData.dispLevel=1
        P.modeData.levelStartTime=0
        P.modeData.levelPieces=0
        P:addEvent('afterLock',marathon.event_afterLock)
        P:addEvent('afterClear',marathon.event_afterClear)
        P:addEvent('drawOnPlayer',marathon.event_drawOnPlayer)
    end
    function marathon.event_afterLock(P)
        P.modeData.levelPieces=P.modeData.levelPieces+1
    end
    function marathon.event_afterClear(P)
        local md=P.modeData
        while P.stat.line>=md.lineTarget do
            if md.lineTarget<200 then
                if md.level<30 then
                    local autoLevel=md.level
                    -- Ignore spawn delay, Assume clear 3 times
                    local averageDropTime=(P.gameTime-md.levelStartTime-P.settings.clearDelay*3)/md.levelPieces-P.settings.spawnDelay
                    while averageDropTime<levels[autoLevel].par and autoLevel<30 do
                        autoLevel=autoLevel+1
                    end
                    local _level=md.level
                    md.level=min(max(md.level+1,min(md.level+3,autoLevel)),30)
                    if _level<=10 and md.level>10 then
                        md.transition1=#P.dropHistory
                    elseif _level<=20 and md.level>20 then
                        md.transition2=#P.dropHistory
                    end

                    P.settings.dropDelay=levels[md.level].drop
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    md.dispLevel=md.level
                else
                    md.level=md.level+1
                    if md.level>=4 then
                        P.settings.lockDelay=max(P.settings.lockDelay-40,200)
                        P.settings.spawnDelay=max(P.settings.spawnDelay-25,0)
                    end
                end
                md.lineTarget=md.lineTarget+10
                md.levelPieces=0
                md.levelStartTime=P.gameTime
                P:playSound('beep_rise')
            else
                P:finish('win')
                return
            end
        end
    end
    function marathon.event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-100,160,200)

        local md=P.modeData
        FONT.set(70)
        GC.mStr(min(P.stat.line,200),-300,-90)
        gc.rectangle('fill',-375,-2,150,4)
        GC.mStr(md.lineTarget,-300,-5)
        FONT.set(30,'bold')
        gc.setColor(md.level<=10 and COLOR.G or md.level<=20 and COLOR.Y or COLOR.R)
        GC.mStr(md.dispLevel,-300,70)
    end
end

do -- hypersonic (of course they are variations of marathon, aren't they?)
    function marathon.hypersonic_event_playerInit(P)
        P.modeData.point=0
        P.modeData.level=1
        P.modeData.target.point=100
        P.modeData.maxHold=0
        P.modeData.storedAsd=P.settings.asd
        P.modeData.storedAsp=P.settings.asp
        P.settings.initMove='hold'
        P.settings.initRotate='hold'
        P.settings.initHold='hold'
    end

    function marathon.hypersonic_event_afterSpawn(P)
        local md=P.modeData
        if md.maxHold<#P.holdQueue then
            md.maxHold=#P.holdQueue
            return
        end
        if md.point<md.target.point-1 then
            md.point=md.point+1
            if md.point==md.target.point-1 then
                P:playSound('beep_notice')
            end
        end
    end

    function marathon.hypersonic_event_drawOnPlayer(P)
        P:drawInfoPanel(-380,-80,160,160)
        FONT.set(70)
        GC.mStr(P.modeData.point,-300,-90)
        gc.rectangle('fill',-375,-2,150,4)
        GC.mStr(P.modeData.target.point,-300,-5)
    end

    do -- hypersonic_low
        local levels={
            {lock=1e3,spawn=320,asd=200,asp=36},
            {lock=850,spawn=290,asd=170,asp=33},
            {lock=700,spawn=260,asd=140,asp=30},
            {lock=550,spawn=230,asd=120,asp=28},
            {lock=400,spawn=200,asd=100,asp=26},
        }

        function marathon.hypersonic_low_event_playerInit(P)
            marathon.hypersonic_event_playerInit(P)

            P.settings.dropDelay=0
            P.settings.asd=max(P.modeData.storedAsd,levels[1].asd)
            P.settings.asp=max(P.modeData.storedAsp,levels[1].asp)
            P.settings.lockDelay=levels[1].lock
            P.settings.spawnDelay=levels[1].spawn
            P.settings.clearDelay=300
            P:addEvent('afterSpawn',marathon.hypersonic_event_afterSpawn)
            P:addEvent('afterClear',marathon.hypersonic_low_event_afterClear)
            P:addEvent('drawOnPlayer',marathon.hypersonic_event_drawOnPlayer)
        end

        function marathon.hypersonic_low_event_afterClear(P,clear)
            local md=P.modeData
            local dScore=floor((clear.line+1)^2/4) -- 1,2,4,6
            if dScore==0 then return end
            md.point=md.point+dScore
            if md.point==md.target.point-1 then
                P:playSound('beep_notice')
            else
                while md.point>=md.target.point do
                    if md.level<5 then
                        P:playSound('beep_rise')
                        md.level=md.level+1
                        md.target.point=100*md.level

                        P.settings.asd=max(md.storedAsd,levels[md.level].asd)
                        P.settings.asp=max(md.storedAsp,levels[md.level].asp)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
                    else
                        md.point=md.target.point
                        P:finish('win')
                        return
                    end
                end
            end
        end
    end

    do -- hypersonic_high
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

        function marathon.hypersonic_high_event_playerInit(P)
            marathon.hypersonic_event_playerInit(P)

            P.modeData.bumpDelay=false
            P.modeData.bumpTimer=false

            P.settings.dropDelay=0
            P.settings.asd=max(P.modeData.storedAsd,levels[1].asd)
            P.settings.asp=max(P.modeData.storedAsp,levels[1].asp)
            P.settings.lockDelay=levels[1].lock
            P.settings.spawnDelay=levels[1].spawn
            P.settings.clearDelay=levels[1].clear
            P.settings.maxFreshTime=levels[1].freshT
            P:addEvent('always',marathon.hypersonic_high_event_always)
            P:addEvent('afterSpawn',marathon.hypersonic_event_afterSpawn)
            P:addEvent('afterClear',marathon.hypersonic_high_event_afterClear)
            P:addEvent('drawOnPlayer',marathon.hypersonic_event_drawOnPlayer)
        end

        function marathon.hypersonic_high_event_always(P)
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

        function marathon.hypersonic_high_event_afterClear(P,clear)
            local md=P.modeData
            local dScore=floor((clear.line+1)^2/4) -- 1,2,4,6
            if dScore==0 then return end
            md.point=md.point+dScore
            if md.point==md.target.point-1 then
                P:playSound('beep_notice')
            else
                while md.point>=md.target.point do
                    if md.level<10 then
                        P:playSound('beep_rise')
                        md.level=md.level+1
                        md.target.point=100*md.level

                        P.settings.asd=max(md.storedAsd,levels[md.level].asd)
                        P.settings.asp=max(md.storedAsp,levels[md.level].asp)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
                        P.settings.clearDelay=levels[md.level].clear
                        P.settings.maxFreshTime=levels[md.level].freshT

                        md.bumpDelay=levels[md.level].bumpInterval
                        if md.bumpDelay then
                            md.bumpTimer=md.bumpDelay
                        end
                    else
                        md.point=md.target.point
                        P:finish('win')
                        return
                    end
                end
            end
        end
    end

    do -- hypersonic_hidden
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
        local flashInterval=floor(4*60*1000/bpm/2^(-1/12)+.5)
        local flashVisTime1,flashVisTime2=120,460
        local flashFadeTime=620

        local endAllInterval=floor(60*1000/bpm/2^(-1/12)+.5)
        local endVisTime1,endVisTime2=620,723
        local endFadeTime=1260

        function marathon.hypersonic_hidden_event_playerInit(P)
            marathon.hypersonic_event_playerInit(P)

            P.modeData.flashTimer=flashInterval
            P.modeData.swipeTimer=showInvisStep*26
            P.modeData.swipeStep=10
            P.modeData.showAllTimer=endAllInterval

            P.settings.dropDelay=0
            P.settings.asd=max(P.modeData.storedAsd,levels[1].asd)
            P.settings.asp=max(P.modeData.storedAsp,levels[1].asp)
            P.settings.lockDelay=levels[1].lock
            P.settings.spawnDelay=levels[1].spawn
            P.settings.clearDelay=levels[1].clear
            P.settings.maxFreshTime=levels[1].freshT
            P.settings.pieceVisTime=levels[1].visTime
            P.settings.pieceFadeTime=levels[1].fadeTime
            P:addEvent('always',marathon.hypersonic_hidden_event_always)
            P:addEvent('afterSpawn',marathon.hypersonic_event_afterSpawn)
            P:addEvent('afterClear',marathon.hypersonic_hidden_event_afterClear)
            P:addEvent('drawOnPlayer',marathon.hypersonic_hidden_event_drawOnPlayer)
        end

        function marathon.hypersonic_hidden_event_always(P)
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
                            c.visTimer=max(c.visTimer or 0,showVisTime)
                            c.fadeTime=max(c.fadeTime or 0,showFadeTime)
                        end
                    end
                end
                md.swipeTimer=t

                -- Random flashing on beat (may on wrong phase)
                md.flashTimer=(md.flashTimer-1)%flashInterval
                if md.flashTimer==0 then
                    for y=1,min(P.field:getHeight(),2*P.settings.fieldW) do
                        for x=1,P.settings.fieldW do
                        if P:random()<flashProbability then
                                local c=P.field:getCell(x,y)
                                if c then
                                    c.visTimer=max(c.visTimer or 0,P:random(flashVisTime1,flashVisTime2))
                                    c.fadeTime=max(c.fadeTime or 0,flashFadeTime)
                                end
                            end
                        end
                    end
                end
            end
        end

        function marathon.hypersonic_hidden_event_afterClear(P,clear)
            local md=P.modeData

            -- Update showInvis speed
            md.swipeStep=10
            for i=#P.clearHistory,#P.clearHistory-4,-1 do
                local c=P.clearHistory[i]
                if not c then break end
                md.swipeStep=max(md.swipeStep+(3-c.line),1)
            end

            local dScore=floor(clear.line^2/2) -- 0,2,4,8
            if dScore==0 then return end
            md.point=md.point+dScore
            if md.point==md.target.point-1 then
                P:playSound('beep_notice')
            else
                while md.point>=md.target.point do
                    if md.level<10 then
                        P:playSound('beep_rise')
                        md.level=md.level+1
                        md.target.point=100*md.level

                        P.settings.asd=max(md.storedAsd,levels[md.level].asd)
                        P.settings.asp=max(md.storedAsp,levels[md.level].asp)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
                        P.settings.clearDelay=levels[md.level].clear
                        P.settings.maxFreshTime=levels[md.level].freshT
                        P.settings.pieceVisTime=levels[md.level].visTime
                        P.settings.pieceFadeTime=levels[md.level].fadeTime
                    else
                        md.point=md.target.point
                        P:finish('win')
                        return
                    end
                end
            end
        end

        function marathon.hypersonic_hidden_event_drawOnPlayer(P)
            P:drawInfoPanel(-380,-80,160,160)
            FONT.set(70)
            GC.mStr(P.modeData.point,-300,-90)
            gc.rectangle('fill',-375,-2,150,4)
            GC.mStr(P.modeData.target.point,-300,-5)
            GC.setAlpha(.7023)
            GC.mStr(P.modeData.point,-300+10*math.sin(P.time),-90)
        end
    end

    do -- hypersonic_titanium
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
        function marathon.hypersonic_titanium_event_playerInit(P)
            marathon.hypersonic_event_playerInit(P)

            P.settings.dropDelay=0
            P.settings.asd=max(P.modeData.storedAsd,levels[1].asd)
            P.settings.asp=max(P.modeData.storedAsp,levels[1].asp)
            P.settings.lockDelay=levels[1].lock
            P.settings.spawnDelay=levels[1].spawn
            P.settings.clearDelay=levels[1].clear
            P.settings.maxFreshTime=levels[1].freshT
            P.settings.maxFreshChance=levels[1].freshC
            P.freshChance=levels[1].freshC
            P:addEvent('afterSpawn',marathon.hypersonic_event_afterSpawn)
            P:addEvent('afterClear',marathon.hypersonic_titanium_event_afterClear)
            P:addEvent('drawOnPlayer',marathon.hypersonic_titanium_event_drawOnPlayer)
        end
        function marathon.hypersonic_titanium_event_afterClear(P,clear)
            local md=P.modeData
            local dScore=floor(clear.line^2/3+2) -- 2,3,5,7
            if dScore==0 then return end
            md.point=md.point+dScore
            if md.point==md.target.point-1 then
                P:playSound('beep_notice')
            else
                while md.point>=md.target.point do
                    if md.level<10 then
                        P:playSound('beep_rise')
                        md.level=md.level+1
                        if md.level>9 then
                            FMOD.music.setParam('section',3)
                        elseif md.level>5 then
                            FMOD.music.setParam('section',2)
                        elseif md.level>2 then
                            FMOD.music.setParam('section',1)
                        end
                        md.target.point=100*md.level

                        P.settings.asd=max(md.storedAsd,levels[md.level].asd)
                        P.settings.asp=max(md.storedAsp,levels[md.level].asp)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
                        P.settings.clearDelay=levels[md.level].clear
                        P.settings.maxFreshTime=levels[md.level].freshT
                        P.settings.maxFreshChance=levels[md.level].freshC
                    else
                        md.point=md.target.point
                        P:finish('win')
                        return
                    end
                end
            end
        end
        function marathon.hypersonic_titanium_event_drawOnPlayer(P)
            P:drawInfoPanel(-380,-80,160,160)
            FONT.set(70)
            GC.mStr(P.modeData.point,-300,-90)
            gc.rectangle('fill',-375,-2,150,4)
            GC.mStr(P.modeData.target.point,-300,-5)
            FONT.set(85)
            GC.setAlpha(.42+.162*math.sin(P.time/126))
            GC.mStr(P.modeData.point,-300,-100)
        end
    end
end

return marathon
