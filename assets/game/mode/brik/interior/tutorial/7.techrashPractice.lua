---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('space')
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
                PROGRESS.setInteriorScore('tuto_B3_score',0)
                PROGRESS.setInteriorScore('tuto_B3_time',2600,'<')
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
                    P.modeData.score=s2
                    PROGRESS.setInteriorScore('tuto_B3_score',s2)
                    if s2>=99 then
                        if not P.modeData.display then
                            PROGRESS.setInteriorScore('tuto_B3_time',P.gameTime/1000,'<')
                            P.modeData.display=STRING.time(P.gameTime/1000)
                        end
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
                GC.setColor(P.modeData.display and 0.62 or 1,P.modeData.multiplier==1 and 1 or 0.62,1-P.combo*.26,P.modeData.protect and .5 or 1)
                FONT.set(80) GC.mStr(P.modeData.score,-300,-70)
                FONT.set(30) GC.mStr(Text.target_score,-300,20)
                FONT.set(20)
                GC.setColor(1,1,1,.872)
                if P.modeData.display then
                    GC.mStr(P.modeData.display,-300,60)
                elseif PROGRESS.getInteriorScore('tuto_B3_score')<99 then
                    GC.mStr(PROGRESS.getInteriorScore('tuto_B3_score'),-300,60)
                else
                    GC.mStr(STRING.time(PROGRESS.getInteriorScore('tuto_B3_time')),-300,60)
                end
            end,
        },
    }},
    result=autoBack_interior,
}
