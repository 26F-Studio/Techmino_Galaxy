---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('space',true)
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        shakeness=0,
        spawnDelay=62,
        dropDelay=1e99,
        lockDelay=1e99,
        deathDelay=0,
        nextSlot=3,
        holdSlot=1,
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.score=0
                P.modeData.multiplier=1
                P.modeData.protect=false
                P.modeData.display=false
                P.modeData.techrashTimer=0
                PROGRESS.setInteriorScore('tuto7_score',0)
                PROGRESS.setInteriorScore('tuto7_time',2600e3,'<')
            end,
            always=function(P)
                if P.modeData.techrashTimer>0 then
                    P.modeData.techrashTimer=P.modeData.techrashTimer-1
                end
            end,
            afterClear=function(P,clear)
                if clear.line<4 then
                    if not P.modeData.protect then
                        P.modeData.protect=true
                        P.modeData.score=math.max(P.modeData.score-10,0)
                        P.settings.holdSlot=1
                        P.modeData.multiplier=1
                        if P.modeData.score==0 then
                            P.holdQueue[1]=nil
                        end
                    end
                    P.combo=0
                else
                    P.modeData.protect=false
                    local s1=P.modeData.score
                    local s2=math.min(s1+P.modeData.multiplier*math.min(P.combo,10),99)
                    if s2-s1>1 then
                        P.modeData.techrashTimer=P.modeData.techrashTimer+260*(s2-s1-1)
                    end
                    P.modeData.score=s2
                    PROGRESS.setInteriorScore('tuto7_score',s2)
                    if s2>=99 then
                        PROGRESS.setInteriorScore('tuto7_time',P.gameTime,'<')
                        P.modeData.display=STRING.time(P.gameTime/1000)
                        P:finish('win')
                    elseif s1<62 and s2>=62 then
                        P.settings.holdSlot=0
                        P.holdQueue[1]=nil
                    elseif s1<10 and s2>=10 then
                        if not P.holdQueue[1] then
                            P.settings.holdSlot=0
                            P.modeData.multiplier=2
                        end
                    end
                end
            end,
            drawOnPlayer=function(P)
                GC.setColor(1,P.modeData.multiplier==1 and 1 or 0.62,1.1-P.combo*.126,P.modeData.protect and .5 or 1)
                FONT.set(80) GC.mStr(P.modeData.score,-300,-70)
                FONT.set(30) GC.mStr(P.modeData.techrashTimer>0 and Text.target_score or Text.target_techrash,-300,20)
                GC.setColor(1,1,1,.62)
                GC.mStr(Text.target_score,-300,20)
                FONT.set(20)
                GC.setColor(1,1,1,.872)
                if P.modeData.display then
                    GC.mStr(P.modeData.display,-300,60)
                elseif PROGRESS.getInteriorScore('tuto7_score')<99 then
                    GC.mStr(PROGRESS.getInteriorScore('tuto7_score'),-300,60)
                else
                    GC.mStr(STRING.time(PROGRESS.getInteriorScore('tuto7_time')/1000),-300,60)
                end
            end,
        },
        script={
            {cmd='say',arg={duration='4.2s',text="@tutorial_techrashPractice_1",size=60,type='bold',y=-80}},
            {cmd='say',arg={duration='4.2s',text="@tutorial_techrashPractice_2",size=30,y=60}},
        },
    }},
    result=autoBack_interior,
}
