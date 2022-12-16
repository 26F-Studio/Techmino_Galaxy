return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
    end,
    settings={mino={
        skin='mino_interior',
        shakeness=0.1,
        dropDelay=1e99,
        lockDelay=1e99,
        readyDelay=1000,
        event={
            afterLock=function(P)
                if P.field:getHeight()>=19 then
                    for y=1,P.field:getHeight()-18 do for x=1,10 do
                        if not P.field:getCell(x,y) then
                            P.field:setCell({},x,y)
                        end
                    end end
                    P:playSound('desuffocate')
                end
            end,
        },
    }},
}
