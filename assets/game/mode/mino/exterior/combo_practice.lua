local bgmTransBegin,bgmTransFinish=50,100

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('oxygen','base')
    end,
    settings={mino={
        spawnDelay=60,
        clearDelay=120,
        atkSys='modern',
        event={
            playerInit=mechLib.mino.comboPractice.event_playerInit,
            afterDrop=mechLib.mino.comboPractice.event_afterDrop,
            afterLock=mechLib.mino.comboPractice.event_afterLock,
            afterClear=mechLib.mino.comboPractice.event_afterClear,
            beforeDiscard={
                mechLib.mino.comboPractice.event_beforeDiscard[200],
                function(P)
                    if P.modeData.comboCount>bgmTransBegin and P.modeData.comboCount<=bgmTransFinish and P.isMain then
                        BGM.set(bgmList['oxygen'].add,'volume',math.min((P.modeData.comboCount-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawOnPlayer=mechLib.mino.comboPractice.event_drawOnPlayer[200],
        },
    }},
}
