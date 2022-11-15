return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('space','simp')
    end,
    settings={mino={
        skin='mino_interior',
        shakeness=0,
        readyDelay=1,
        spawnDelay=260,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=0,
        holdSlot=0,
        deathDelay=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
        },
        event={
            gameStart=function(P)
                P.spawnTimer=1800
            end,
            afterLock=function(P)
                local F=P.field
                if P.modeData.quest==1 then
                    if F:getHeight()~=4 then
                        P.modeData.signal=false
                    else
                        for i=1,10 do
                            if not F:getCell(i,1) then
                                P.modeData.wrongPiece=
                                    i==10 and 'J' or
                                    F:getCell(i+1,4) and 'J' or
                                    'L'
                                P:pushNext(P.modeData.wrongPiece)
                                break
                            end
                        end
                        P.modeData.signal=true
                    end
                elseif P.modeData.quest==2 then
                    if #P.nextQueue==1 then
                        if F:getHeight()~=4 then
                            P.modeData.signal=false
                        end
                    else
                        P.modeData.signal=F:getHeight()==3
                    end
                elseif P.modeData.quest==3 then
                    if F:getHeight()>4 then
                        P.modeData.signal=false
                    elseif #P.nextQueue+#P.holdQueue==0 then
                        P.modeData.signal=F:getHeight()==3
                    end
                elseif P.modeData.quest==4 then
                    if #P.nextQueue+#P.holdQueue==0 then
                        local hasHole
                        for y=F:getHeight(),1,-1 do
                            for x=1,F:getWidth() do
                                if not F:getCell(x,y) then
                                    hasHole=true
                                    break
                                end
                            end
                        end
                        if not hasHole then
                            P.modeData.signal=true
                            P.modeData.extra=F:getHeight()==2
                        else
                            P.modeData.signal=false
                        end
                    end
                end
            end,
        },
        script={
            {cmd='say',arg={duration='1.5s',text="@tutorial_sequence_1",y=-60}},
            "[1.5s]",

            "setc quest,1",
            "quest1:",
            "setc signal,0",
            "clearNext",

            "pushNext T",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                }
                for _=1,math.random(0,8) do for y=1,#d do
                    table.insert(d[y],table.remove(d[y],1))
                end end
                P:setField(d)
            end},

            "wait signal",
            "jeq quest1,signal,false",
            "switchAction hardDrop",
            "[5.62s]",

            {cmd='say',arg={duration='3s',text="@tutorial_sequence_2",y=-60}},
            "[3s]",

            {cmd=function(P)
                P.settings.nextSlot=3
                P.hand=false
                P.spawnTimer=1200
            end},
            "switchAction hardDrop",
            "setc quest,2",
            "quest2:",
            "setc signal,0",
            {cmd='say',arg={duration='3s',text="@tutorial_sequence_3",size=50,y=-60}},
            "clearNext",
            {cmd=function(P) P:pushNext('T'..P.modeData.wrongPiece) end},
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                }
                for _=1,math.random(0,8) do for y=1,#d do
                    table.insert(d[y],table.remove(d[y],1))
                end end
                P:setField(d)
            end},
            "wait signal",
            "jeq quest2,signal,false",
            "sfx win",

            {cmd=function(P)
                P.settings.holdSlot=1
                P.hand=false
                P.spawnTimer=1200
            end},
            "setc quest,3",
            "quest3:",
            "setc signal,0",
            {cmd='say',arg={duration='3s',text="@tutorial_sequence_4",size=50,y=-60}},
            "clearHold",
            "clearNext",
            {cmd=function(P) P:pushNext(P.modeData.wrongPiece..'T') end},
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                    {8,8,8,8,8,8,8,8,0,0},
                }
                for _=1,math.random(0,8) do for y=1,#d do
                    table.insert(d[y],table.remove(d[y],1))
                end end
                P:setField(d)
            end},
            "wait signal",
            "jeq quest3,signal,false",
            "sfx win",

            {cmd=function(P)
                P.spawnTimer=1200
            end},
            "setc quest,4",
            "quest4:",
            "setc signal,0",
            "clearHold",
            "clearNext",
            "pushNext ZTI",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,0,0,0,0,0,0,0},
                    {8,8,8,0,0,0,0,8,8,8},
                    {8,8,8,0,8,8,8,8,8,8},
                }
                for _=1,math.random(0,3) do for y=1,#d do
                    table.insert(d[y],table.remove(d[y],1))
                end end
                P:setField(d)
            end},
            "wait signal",
            "jeq quest4,signal,false",
            "sfx win",

            "jeq extra,extra,true",
            {cmd='say',arg={duration='6.26s',text="@tutorial_sequence_5",size=120,type='bold',style='beat',c=COLOR.lG,y=-30}},
            "j end",
            "extra:",
            {cmd='say',arg={duration='6.26s',text="@tutorial_sequence_5",size=120,type='bold',style='beat',c=COLOR.lY,y=-30}},
            "end:",
            {cmd=function(P) if P.isMain then PROGRESS.setTutorialPassed(2) end end},
            "finish AC",
        },
    }},
}
