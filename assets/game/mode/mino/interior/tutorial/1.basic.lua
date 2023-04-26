return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('space','simp')
    end,
    settings={mino={
        skin='mino_interior',
        particles=false,
        shakeness=0,
        readyDelay=1,
        spawnDelay=260,
        dropDelay=1e99,
        lockDelay=1e99,
        nextSlot=0,
        holdSlot=0,
        deathDelay=0,
        seqType='none',
        soundEvent={countDown=NULL},
        event={
            playerInit=function(P)
                P.modeData.line=0
                P:switchAction('rotateCW',false)
                P:switchAction('rotateCCW',false)
                P:switchAction('rotate180',false)
                P:switchAction('softDrop',false)
                P:switchAction('hardDrop',false)
                P:switchAction('holdPiece',false)
            end,
            gameStart=function(P)
                P.spawnTimer=6500
            end,
            afterDrop=function(P)
                if P.modeData.quest==1 then
                    if P.handY~=1 then P.hand=false end
                    P.modeData.signal=P.handY==1
                elseif P.modeData.quest==2 then
                    if P.handY~=1 then
                        P.hand=false
                        P.modeData.signal=false
                    elseif #P.nextQueue==0 then
                        P.modeData.signal=true
                    end
                elseif P.modeData.quest==3 then
                    if P.handY~=1 then
                        P.hand=false
                        P.modeData.signal=false
                    elseif #P.nextQueue==0 then
                        P.modeData.signal=true
                    end
                else
                    if P.handY==1 and P.hand.direction==2 then
                        P.modeData.signal=true
                    else
                        P.hand=false
                        P.modeData.signal=false
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
            "setc signal,nil",
            "j skipFirstO",

            "setc quest,1",
            "quest1:",
            "setc signal,nil",
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
            "setc signal,nil",
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
            "setc signal,nil",
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
            "setc quest,4",
            "quest4:",
            "setc signal,nil",
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

            {cmd='say',arg={duration='6.26s',text="@tutorial_pass",size=120,type='bold',style='beat',c=COLOR.lG,y=-30}},
            {cmd=function(P) if P.isMain then PROGRESS.setTutorialPassed(1) end end},
            "finish AC",
        },
    }},
    result=task_interiorAutoQuit,
}
