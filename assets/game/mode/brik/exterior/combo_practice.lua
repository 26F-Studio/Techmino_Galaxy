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
        atkSys='modern',
        event={
            playerInit=mechLib.brik.comboPractice.event_playerInit,
            afterDrop=mechLib.brik.comboPractice.event_afterDrop,
            afterLock=mechLib.brik.comboPractice.event_afterLock,
            afterClear={
                mechLib.brik.comboPractice.event_afterClear,
                mechLib.brik.music.combo_practice_afterClear,
                mechLib.brik.progress.combo_practice_afterClear,
            },
            beforeDiscard=mechLib.brik.comboPractice.event_beforeDiscard[200],
            drawOnPlayer=mechLib.brik.comboPractice.event_drawOnPlayer[200],
            gameOver=mechLib.brik.progress.combo_practice_gameOver,
        },
    }},
}
