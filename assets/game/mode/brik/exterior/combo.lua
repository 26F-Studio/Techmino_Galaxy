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
            playerInit={
                mechLib.brik.comboGenerator.event_playerInit,
                function(P)
                    P.modeData.target.combo=200
                    mechLib.common.music.set(P,{path='.comboCount',s=50,e=100},'afterClear')
                end,
            },
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterDrop=mechLib.brik.comboGenerator.event_afterDrop,
            afterLock=mechLib.brik.comboGenerator.event_afterLock,
            afterClear=mechLib.brik.comboGenerator.event_afterClear,
            beforeDiscard=mechLib.brik.comboGenerator.event_beforeDiscard,
            drawOnPlayer=mechLib.brik.comboGenerator.event_drawOnPlayer,
        },
    }},
}
