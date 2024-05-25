---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('oxygen')
    end,
    settings={brik={
        spawnDelay=60,
        clearDelay=120,
        atkSys='nextgen',
        event={
            playerInit=mechLib.brik.comboGenerator.event_playerInit,
            afterDrop=mechLib.brik.comboGenerator.event_afterDrop,
            afterLock=mechLib.brik.comboGenerator.event_afterLock,
            afterClear={
                mechLib.brik.comboGenerator.event_afterClear,
                {1e62,function(P)
                    if not P.isMain then return true end
                    FMOD.music.setParam('intensity',MATH.icLerp(50,100,P.modeData.comboCount))
                end},
            },
            beforeDiscard=mechLib.brik.comboGenerator.event_beforeDiscard[200],
            drawOnPlayer=mechLib.brik.comboGenerator.event_drawOnPlayer[200],
        },
    }},
}
