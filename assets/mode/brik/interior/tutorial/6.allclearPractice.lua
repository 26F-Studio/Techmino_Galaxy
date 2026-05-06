local function newQuestion(P)
    ---@cast P Techmino.Player.Brik
    P.modeData.questCount=P.modeData.questCount+1
    P.modeData.currentQuestType=
        P.modeData.score<10 and (
            'box3'
            -- P.modeData.questCount%2==1 and 'box3' or 'pco3'
        ) or 'box4'
        -- P.modeData.questCount%2==1 and 'box4' or 'pco4'
    local field,seq=mechLib.brik.allclearGenerator.newQuestion(P,{
        lib=P.modeData.currentQuestType,
        raw=true,
    })
    P:setField(field)
    P:pushNext(seq)
    if not P.modeData.protect then
        P.modeData.dumpData=nil
        P.modeData.dumpData=P:serialize()
    end
end

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
        holdSlot=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
            drop=GameSndFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.currentQuestType='box3'
                P.modeData.questCount=0
                P.modeData.score=0
                P.modeData.protect=false
                P.modeData.display=false
                P.modeData.lastPassTime=0

                if PROGRESS.getInteriorScore('tuto6_score')<99 then
                    P.modeData.display=PROGRESS.getInteriorScore('tuto6_score').."/99"
                else
                    P.modeData.display={COLOR.lY,STRING.time(PROGRESS.getInteriorScore('tuto6_time')/1000)}
                end

                newQuestion(P)
            end,
            gameStart=function(P)
                P.modeData.dumpData=nil
                P.modeData.dumpData=P:serialize()
            end,
            beforeDiscard=function(P)
                local ac=#P.field._matrix==0
                if #P.nextQueue==0 or ac then
                    if ac then
                        local timeUsed=(P.gameTime-P.modeData.lastPassTime)/1000
                        P.modeData.lastPassTime=P.gameTime
                        local parTime=P.modeData.currentQuestType=='box3' and 6.26 or 10.33
                        local scoreAdd=timeUsed<parTime and not P.modeData.protect and 2 or 1
                        P:playSound(scoreAdd<=1 and 'beep_rise' or 'beep_notice')
                        P.modeData.score=math.min(P.modeData.score+scoreAdd,99)
                        P.modeData.protect=false
                        if P.modeData.score>=99 then
                            PROGRESS.setInteriorScore('tuto6_score',99)
                            PROGRESS.setInteriorScore('tuto6_time',P.gameTime,'<')
                            P.modeData.display=STRING.time(P.gameTime/1000)
                            P:finish('win')
                        else
                            newQuestion(P)
                        end
                    else
                        if not P.modeData.protect then
                            PROGRESS.setInteriorScore('tuto6_score',P.modeData.score)
                        end
                        local data=P.modeData.dumpData
                        local gameTime=P.gameTime
                        P:unserialize(data)
                        P:release('moveLeft')
                        P:release('moveRight')
                        P:release('softDrop')
                        P.modeData.dumpData=data

                        P.modeData.protect=true
                        P.modeData.display=PROGRESS.getInteriorScore('tuto6_score').."/99"
                        P.modeData.score=math.max(P.modeData.score-3,0)
                        P.gameTime=gameTime
                    end
                end
            end,
            drawOnPlayer=function(P)
                GC.setColor(1,1,1,P.modeData.protect and .5 or 1)
                FONT.set(80) GC.mStr(P.modeData.score,-300,-70)
                FONT.set(30) GC.mStr(Text.target_score,-300,20)
                GC.setColor(1,1,1,.872)
                FONT.set(20) GC.mStr(P.modeData.display,-300,60)
            end,
        },
        script={
            {cmd='say',arg={duration='4.2s',text="@tutorial_allclearPractice_1",size=60,type='bold',y=-80}},
            {cmd='say',arg={duration='4.2s',text="@tutorial_allclearPractice_2",size=30,y=60}},
        },
    }},
    result=autoBack_interior,
}
