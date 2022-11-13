return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_simp',
        shakeness=0,
        readyDelay=1,
        spawnDelay=260,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=0,
        holdSlot=0,
        deathDelay=0,
        seqType='none',
        actionPack={
            'moveLeft',
            'moveRight',
        },
        soundEvent={
            countDown=NULL,
        },
        event={
            gameStart=function(P)
                P.spawnTimer=6500
            end,
            afterLock=function(P)
                if P.modeData.quest==1 then
                    if #P.nextQueue==0 then
                        P.modeData.signal=P.field:getHeight()<=2
                    end
                elseif P.modeData.quest==2 then
                    if #P.nextQueue==1 then
                        if P.field:getHeight()>2 then
                            P.modeData.signal=false
                        end
                    elseif #P.nextQueue==0 then
                        P.modeData.signal=P.field:getHeight()<=2
                    end
                elseif P.modeData.quest==3 then
                    if #P.nextQueue==1 then
                        if P.field:getHeight()>2 then
                            P.modeData.signal=false
                        end
                    elseif #P.nextQueue==0 then
                        P.modeData.signal=P.field:getHeight()<=1
                    end
                else
                    if #P.nextQueue==0 then
                        P.modeData.signal=P.field:getHeight()<=2
                        if P.modeData.signal then
                            P.settings.spawnDelay=1e99
                        end
                    end
                end
            end,
        },
        script={
            {cmd='say',arg={duration='3s',text="@tutorial_basic_1",size=80,type='bold',style='beat',y=-60}},
            "[3s]",

            "pushNext O",
            {cmd='say',arg={duration='3s',text="@tutorial_basic_2",y=-60}},
            "[3s]",

            {cmd='say',arg={duration='12s',text="@tutorial_basic_3",size=50,y=-100}},
            "[6s]",

            {cmd='say',arg={duration='6s',text="@tutorial_basic_4",size=50,y=-30}},

            "switchAction hardDrop",
            "setc quest,1",
            "setc signal,0",
            "j skipFirstO",

            "setc quest,1",
            "quest1:",
            "setc signal,0",
            "pushNext O",
            "skipFirstO:",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=math.random(5,6)+MATH.coin(-1,1)*math.random(2,3)
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest1,signal,false",
            "sfx win",

            "setc quest,2",
            "quest2:",
            "setc signal,0",
            "clearNext",
            "pushNext OO",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=math.random(5,6)+MATH.coin(-1,1)*math.random(2,3)
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                r=(r+3)%10+1
                if r==10 then r=2 end
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest2,signal,false",
            "sfx win",

            "setc quest,3",
            "quest3:",
            "setc signal,0",
            "clearNext",
            "pushNext OI",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=math.random(5,6)+MATH.coin(-1,1)*math.random(2,3)
                d[1][r],d[2][r],d[1][r+1],d[2][r+1]=0,0,0,0
                local r2=r<=5 and r+2 or r-4
                for i=0,3 do d[1][r2+i]=0 end
                P:setField(d)
            end},
            "wait signal",
            "jeq quest3,signal,false",
            "sfx win",

            "switchAction rotateCW",
            "switchAction rotateCCW",
            "switchAction rotate180",
            "setc quest,4",
            "quest4:",
            "setc signal,0",
            {cmd='say',arg={duration='3s',text="@tutorial_basic_5",size=50,y=40}},
            "clearNext",
            "pushNext T",
            {cmd=function(P)
                local d={
                    sudden=false,
                    resetHand=false,
                    {8,8,8,8,8,8,8,8,8,8},
                    {8,8,8,8,8,8,8,8,8,8},
                }
                local r=math.random(5,6)+MATH.coin(-1,1)*math.random(2,3)
                d[1][r-1],d[1][r],d[1][r+1],d[2][r]=0,0,0,0
                P:setField(d)
            end},
            "wait signal",
            "jeq quest4,signal,false",
            "sfx win",

            {cmd='say',arg={duration='6.26s',text="@tutorial_basic_6",size=120,type='bold',style='beat',c=COLOR.lG,y=-30}},
            "finish AC",
        },
    }},
}
