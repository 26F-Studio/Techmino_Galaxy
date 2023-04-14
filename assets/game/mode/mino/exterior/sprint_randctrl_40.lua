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
                    P.modeData.randomPressTimer=2600
                end,
            },
            beforePress=function(P)
                if P.modeData.randomPressTimer>260 then
                    P.modeData.randomPressTimer=P.modeData.randomPressTimer-120
                end
            end,
            always=function(P)
                if not P.timing then return end
                P.modeData.randomPressTimer=P.modeData.randomPressTimer-1
                if P.modeData.randomPressTimer==0 then
                    local r=P:random(P.holdTime==0 and 5 or 4)
                    if r==1 then
                        P:moveLeft()
                    elseif r==2 then
                        P:moveRight()
                    elseif r==3 then
                        P:rotate('R')
                    elseif r==4 then
                        P:rotate('L')
                    elseif r==5 then
                        P:hold()
                    end
                    P.modeData.randomPressTimer=P:random(1620,2600)
                end
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
