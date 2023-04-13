local bgmTransBegin,bgmTransFinish=50,75

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('echo','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        clearStuck=true,
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                function(P)
                    P.modeData._currentPower=false
                end,
            },
            beforeCancel=function(P,atk)
                P.modeData._currentPower=atk.power
            end,
            beforeSend=function(P,atk)
                local powerList={}
                local section=0
                for i=1,P.modeData._currentPower do
                    section=section+1
                    if P:random()<.5 or i==P.modeData._currentPower then
                        table.insert(powerList,section)
                        section=0
                    end
                end
                for i=1,#powerList do
                    atk.power=powerList[i]
                    P:receive(atk)
                end
                P.modeData._currentPower=false
            end,
            afterClear={
                mechLib.mino.statistics.event_afterClear,
                mechLib.mino.sprint.event_afterClear[100],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['echo'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[100],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[100],
        },
    }},
}
