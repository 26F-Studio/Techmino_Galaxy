---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        BGM.play{
            'race/accompany1',
            'race/decoration',
            'race/drum',
        }
    end,
    settings={mino={
        inputDelay=620,
        event={
            afterClear={
                mechLib.mino.sprint.event_afterClear[20],
                mechLib.mino.progress.sprint_delay_20_afterClear,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[20],
            gameOver=mechLib.mino.progress.sprint_delay_20_gameOver,
        },
    }},
}
