---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race')
    end,
    settings={mino={
        spawnH=4,
        extraSpawnH=0,
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.music.sprint_low_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_low_40_gameOver,
        },
    }},
}
