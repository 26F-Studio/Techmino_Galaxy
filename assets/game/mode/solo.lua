local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.newPlayer(2,'mino')
        GAME.setMain(1)
        playBgm('battle','-base')
    end,
    settings={
        dropDelay=1000,
        lockDelay=1000,
        event={
            gameOver=function(P)
                -- TODO
            end,
        },
    },
    result=function(P)
        -- TODO
    end,
    scorePage=function(data)
        -- TODO
    end,
}
