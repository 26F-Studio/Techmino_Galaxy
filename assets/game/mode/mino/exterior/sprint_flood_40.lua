local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        seqType=function(P)-- bag7 with extra 3 S pieces and 3 Z pieces
            local l={}
            while true do
                if not l[1] then
                    for i=1,7 do l[i]=i end
                    l[8],l[9],l[10]=1,1,1
                    l[11],l[12],l[13]=2,2,2
                end
                coroutine.yield(table.remove(l,P:random(#l)))
            end
        end,
        event={
            playerInit=mechLib.mino.statistics.event_playerInit,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[40],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[40],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[40],
        },
    }},
}
