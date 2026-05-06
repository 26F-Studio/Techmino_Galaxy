---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('space',true)
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
            drop=GameSndFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.score=0
                P.modeData.protect=false
                P.modeData.display=false
                P.modeData.techrashTimer=0

                if PROGRESS.getInteriorScore('tuto7_score')<26 then
                    P.modeData.display=PROGRESS.getInteriorScore('tuto7_score').."/26"
                else
                    P.modeData.display={COLOR.lY,(PROGRESS.getInteriorScore('tuto7_time')/1000).."s"}
                end
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
                        PROGRESS.setInteriorScore('tuto7_score',P.modeData.score)
                        P.modeData.display=PROGRESS.getInteriorScore('tuto7_score').."/26"
                        P.modeData.score=math.max(P.modeData.score-4,0)
                        P.holdQueue[1]=nil
                    end
                    P.combo=0
                else
                    P.modeData.protect=false
                    local s1=P.modeData.score
                    local s2=math.min(s1+math.min(P.combo,10),26)
                    if s2-s1>1 then
                        P.modeData.techrashTimer=P.modeData.techrashTimer+260*(s2-s1-1)
                    end
                    P.modeData.score=s2
                    if s2>=26 then
                        PROGRESS.setInteriorScore('tuto7_score',26)
                        PROGRESS.setInteriorScore('tuto7_time',P.gameTime,'<')
                        P.modeData.display={COLOR.lY,PROGRESS.getInteriorScore('tuto7_time')/1000}
                        P:finish('win')
                    end
                end
            end,
            drawOnPlayer=function(P)
                GC.setColor(1,1,1.1-P.combo*.126,P.modeData.protect and .5 or 1)
                FONT.set(80) GC.mStr(P.modeData.score,-300,-70)
                FONT.set(30) GC.mStr(P.modeData.techrashTimer>0 and Text.target_score or Text.target_techrash,-300,20)
                GC.setColor(1,1,1,.62)
                GC.mStr(Text.target_score,-300,20)
                GC.setColor(1,1,1,.872)
                FONT.set(20) GC.mStr(P.modeData.display,-300,60)
            end,
        },
        script={
            {cmd='say',arg={duration='4.2s',text="@tutorial_techrashPractice_1",size=60,type='bold',y=-80}},
            {cmd='say',arg={duration='4.2s',text="@tutorial_techrashPractice_2",size=30,y=60}},
        },
    }},
    result=autoBack_interior,
}
