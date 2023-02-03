return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('way','simp')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                local dir=P.seqRND:random(0,1)*2-1
                local phase=P.seqRND:random(3,6)
                for i=0,11 do P:riseGarbage((phase+i)*dir%10+1) end
                P.fieldDived=0
                P.modeData.garbageRemain=12
            end,
            afterClear=function(P,movement)
                local remain=movement.clear[#movement.clear]-1
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
