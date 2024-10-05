local function newQuestion(P)
    ---@cast P Techmino.Player.Brik
    local score=P.modeData.score
    local field,seq=mechLib.brik.allclearGenerator.newQuestion(P,{
        lib=score<10 and 'box_3_4' or score%2==0 and 'pco' or 'box_4_4',
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
        holdSlot=0,
        seqType='none',
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.score=0
                P.modeData.protect=false
                P.modeData.display=false

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
                        P.modeData.protect=false
                        P.modeData.score=P.modeData.score+1
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
