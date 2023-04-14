local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                function(P)
                    P.modeData._coords={}
                end,
            },
            afterDrop=function(P)
                local CB=P.hand.matrix
                for y=1,#CB do for x=1,#CB[1] do if CB[y][x] then
                    table.insert(P.modeData._coords,{P.handX+x-1,P.handY+y-1})
                end end end
            end,
            afterLock=function(P)
                local id=nil
                for _,coord in next,P.modeData._coords do
                    local C=P.field:getCell((P.settings.fieldW+1)-coord[1],coord[2])
                    C=C and C.id or false
                    if id==nil then
                        id=C
                    elseif id~=C then
                        for _,coord in next,P.modeData._coords do
                            P.field:setCell(false,coord[1],coord[2])
                        end
                        break
                    end
                end
                TABLE.cut(P.modeData._coords)
            end,
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
