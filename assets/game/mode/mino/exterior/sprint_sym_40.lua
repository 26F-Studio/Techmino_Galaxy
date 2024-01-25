---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            afterLock=mechLib.mino.misc.symmetery_event_afterLock,
            afterClear={
                mechLib.mino.sprint.event_afterClear[40],
                mechLib.mino.music.sprint_sym_40_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
            gameOver=mechLib.mino.progress.sprint_sym_40_gameOver,
        },
    }},
}
