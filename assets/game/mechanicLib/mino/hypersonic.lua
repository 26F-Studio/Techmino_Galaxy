local gc=love.graphics

--- @type Techmino.Mech.mino
local hypersonic={}

--- @param mode 'low'|'high'|'hidden'
function hypersonic.event_playerInit_auto(P,mode)
    if mode=='low' then
        hypersonic.event_playerInit(P)
        hypersonic.low_event_playerInit(P)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.low_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.event_drawOnPlayer)
    elseif mode=='high' then
        hypersonic.event_playerInit(P)
        hypersonic.high_event_playerInit(P)
        P:addEvent('always',hypersonic.high_event_always)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',hypersonic.high_event_afterClear)
        P:addEvent('drawOnPlayer',hypersonic.event_drawOnPlayer)
    elseif mode=='hidden' then
        hypersonic.event_playerInit(P)
        hypersonic.hidden_event_playerInit(P)
        P:addEvent('always',hypersonic.hidden_event_always)
        P:addEvent('afterSpawn',hypersonic.event_afterSpawn)
        P:addEvent('afterClear',mechLib.mino.hypersonic.hidden_event_afterClear)
        P:addEvent('drawOnPlayer',mechLib.mino.hypersonic.hidden_event_drawOnPlayer)
    else
        error('No hypersonic mode '..tostring(mode))
    end
end

function hypersonic.event_playerInit(P)
    P.modeData.point=0
    P.modeData.level=1
    P.modeData.target=100
    P.modeData.storedDas=P.settings.das
    P.modeData.storedArr=P.settings.arr
end

function hypersonic.event_afterSpawn(P)
    local md=P.modeData
    if md.point<md.target-1 then
        md.point=md.point+1
        if md.point==md.target-1 then
            P:playSound('notice')
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

do-- low
    local levels={
        {lock=1e3,spawn=320,das=200,arr=36},
        {lock=850,spawn=290,das=170,arr=32},
        {lock=700,spawn=260,das=140,arr=28},
        {lock=550,spawn=230,das=120,arr=24},
        {lock=400,spawn=200,das=100,arr=20},
    }

    function hypersonic.low_event_playerInit(P)
        P.settings.dropDelay=0
        P.settings.das=math.max(P.modeData.storedDas,levels[1].das)
        P.settings.arr=math.max(P.modeData.storedArr,levels[1].arr)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=300
    end

    function hypersonic.low_event_afterClear(P,clear)
        local md=P.modeData
        local dScore=math.floor((clear.line+1)^2/4)-- 1,2,4,6
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

                    P.settings.das=math.max(md.storedDas,levels[md.level].das)
                    P.settings.arr=math.max(md.storedArr,levels[md.level].arr)
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

do-- high
    local levels={
        {lock=450,fresh=4400,spawn=150,clear=380,das=130,arr=29,bumpInterval=false},
        {lock=400,fresh=4200,spawn=140,clear=340,das=120,arr=28,bumpInterval=false},
        {lock=360,fresh=4000,spawn=130,clear=300,das=110,arr=27,bumpInterval=false},
        {lock=330,fresh=3800,spawn=120,clear=260,das=105,arr=26,bumpInterval=false},
        {lock=300,fresh=3600,spawn=110,clear=220,das=100,arr=25,bumpInterval=false},
        {lock=300,fresh=3400,spawn=100,clear=180,das=96, arr=24,bumpInterval=10000},
        {lock=300,fresh=3200,spawn=95, clear=160,das=92, arr=23,bumpInterval=8000},
        {lock=300,fresh=3000,spawn=90, clear=140,das=88, arr=22,bumpInterval=6000},
        {lock=300,fresh=2800,spawn=85, clear=120,das=84, arr=21,bumpInterval=5000},
        {lock=300,fresh=2600,spawn=80, clear=100,das=80, arr=20,bumpInterval=4000},
    }

    function hypersonic.high_event_playerInit(P)
        P.modeData.bumpDelay=false
        P.modeData.bumpTimer=false

        P.settings.dropDelay=0
        P.settings.das=math.max(P.modeData.storedDas,levels[1].das)
        P.settings.arr=math.max(P.modeData.storedArr,levels[1].arr)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=levels[1].clear
        P.settings.maxFreshTime=levels[1].fresh
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
                newLine[i]=firstLine[i] and {color=firstLine[i].color,conn={}} or false
            end
            table.insert(F._matrix,1,newLine)
            for i=1,#firstLine do
                local cells=P:getConnectedCells(i,2)
                for j=1,#cells do
                    local c=F:getCell(cells[j][1],cells[j][2])
                    c.conn[newLine[i]]=true
                    newLine[i].conn[c]=true
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
        local dScore=math.floor((clear.line+1)^2/4)-- 1,2,4,6
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

                    P.settings.das=math.max(md.storedDas,levels[md.level].das)
                    P.settings.arr=math.max(md.storedArr,levels[md.level].arr)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    P.settings.clearDelay=levels[md.level].clear
                    P.settings.maxFreshTime=levels[md.level].fresh

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

do-- hidden
    local levels={
        {lock=510,fresh=6000,spawn=150,clear=400,das=130,arr=29,visTime=5000,fadeTime=2600},
        {lock=460,fresh=5800,spawn=140,clear=360,das=120,arr=28,visTime=4000,fadeTime=2600},
        {lock=420,fresh=5600,spawn=130,clear=320,das=110,arr=27,visTime=3500,fadeTime=2600},
        {lock=380,fresh=5400,spawn=120,clear=280,das=105,arr=26,visTime=3000,fadeTime=2600},
        {lock=350,fresh=5200,spawn=110,clear=240,das=100,arr=25,visTime=2500,fadeTime=2100},
        {lock=320,fresh=5000,spawn=100,clear=200,das=96, arr=24,visTime=2000,fadeTime=1500},
        {lock=300,fresh=4800,spawn=95, clear=180,das=92, arr=23,visTime=1600,fadeTime=1100},
        {lock=280,fresh=4600,spawn=90, clear=160,das=88, arr=22,visTime=1200,fadeTime=900 },
        {lock=270,fresh=4400,spawn=85, clear=140,das=84, arr=21,visTime=900, fadeTime=800 },
        {lock=260,fresh=4200,spawn=80, clear=120,das=80, arr=20,visTime=600, fadeTime=600 },
    }

    local showInvisPeriod=26000*10
    local showInvisStep=30
    local showVisTime=1000
    local showFadeTime=1000

    local flashProbability=.1626
    local flashInterval=math.floor(4*60*1000/130/2^(-1/12)+.5)
    local flashVisTime1,flashVisTime2=120,460
    local flashFadeTime=620

    local endAllInterval=math.floor(60*1000/130/2^(-1/12)+.5)
    local endVisTime1,endVisTime2=620,723
    local endFadeTime=1260

    function hypersonic.hidden_event_playerInit(P)
        P.modeData.flashTimer=flashInterval
        P.modeData.swipeTimer=showInvisStep*26
        P.modeData.swipeStep=10
        P.modeData.showAllTimer=endAllInterval

        P.settings.dropDelay=0
        P.settings.das=math.max(P.modeData.storedDas,levels[1].das)
        P.settings.arr=math.max(P.modeData.storedArr,levels[1].arr)
        P.settings.lockDelay=levels[1].lock
        P.settings.spawnDelay=levels[1].spawn
        P.settings.clearDelay=levels[1].clear
        P.settings.maxFreshTime=levels[1].fresh
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

        local dScore=math.floor((clear.line)^2/2)-- 0,2,4,8
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

                    P.settings.das=math.max(md.storedDas,levels[md.level].das)
                    P.settings.arr=math.max(md.storedArr,levels[md.level].arr)
                    P.settings.lockDelay=levels[md.level].lock
                    P.settings.spawnDelay=levels[md.level].spawn
                    P.settings.clearDelay=levels[md.level].clear
                    P.settings.maxFreshTime=levels[md.level].fresh
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

return hypersonic
