local availableActionMap={
    moveLeft=true,
    moveRight=true,
    rotateCW=true,
    rotateCCW=true,
    rotate180=true,
    holdPiece=true,
}
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
        readyDelay=1,
        spawnDelay=62,
        dropDelay=2600,
        lockDelay=2600,
        soundEvent={
            countDown=NULL,
            drop=gameSoundFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.modeData.target.line=20
                P.modeData.keyCount=0

                PROGRESS.setInteriorScore('tuto8_keys',2600,'<')
                P.modeData.display=PROGRESS.getInteriorScore('tuto8_keys')
            end,
            beforePress=function(P,act)
                if availableActionMap[act] then
                    P.modeData.keyCount=P.modeData.keyCount+1
                end
            end,
            afterClear=mechLib.brik.misc.lineClear_event_afterClear,
            drawOnPlayer=function(P)
                GC.setColor(COLOR.L)
                FONT.set(80) GC.mStr(P.modeData.target.line-P.stat.line,-300,-140)
                FONT.set(30) GC.mStr(Text.target_line,-300,-55)
                FONT.set(80) GC.mStr(P.modeData.keyCount,-300,10)
                FONT.set(30) GC.mStr(Text.target_key,-300,95)
                GC.setColor(1,1,1,.872)
                FONT.set(20) GC.mStr(P.modeData.display,-300,130)
            end,
            gameOver=function(P,reason)
                if reason=='win' then
                    PROGRESS.setInteriorScore('tuto8_keys',P.modeData.keyCount,'<')
                end
            end,
        },
        script={
            {cmd='say',arg={duration='4.2s',text="@tutorial_finessePlus_1",size=60,type='bold',y=-40}},
            {cmd='say',arg={duration='4.2s',text="@tutorial_finessePlus_2",size=30,y=20}},
        },
    }},
    result=autoBack_interior,
}
