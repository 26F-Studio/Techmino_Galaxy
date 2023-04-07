return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                for _=1,5 do
                    P:riseGarbage({1,3,5,7,9})
                    P:riseGarbage({2,4,6,8,10})
                end
                P.fieldDived=0
                P.modeData.garbageRemain=10
            end,
            afterClear=function(P,clear)
                local remain=clear.lines[clear.line]-1
                if remain<P.modeData.garbageRemain then
                    P.modeData.garbageRemain=remain
                    if remain==0 then
                        P:finish('AC')
                    end
                end
            end,
        },
    }},
}
