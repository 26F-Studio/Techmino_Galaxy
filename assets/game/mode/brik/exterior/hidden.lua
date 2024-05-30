---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('sugar fairy')
    end,
    settings={brik={
        event={
            playerInit=function(P)
                P.settings.pieceVisTime=260
                P.settings.pieceFadeTime=260
                P.modeData.maxSimplicity=0
                P.modeData.simplicity=0
                P.modeData.target.line=100
                mechLib.common.music.set(P,{path='.stat.line',s=50,e=100},'afterClear')
            end,
            afterClear={
                mechLib.brik.misc.lineClear_event_afterClear,
                function(P,clear)
                    if clear.line<4 then
                        P.modeData.simplicity=P.modeData.simplicity+(5-clear.line)
                    else
                        P.modeData.simplicity=P.modeData.simplicity-2
                    end
                    P.modeData.simplicity=math.min(P.modeData.simplicity,62-math.floor(P.modeData.stat.line/5))
                    P.modeData.maxSimplicity=math.max(P.modeData.maxSimplicity,P.modeData.simplicity)
                    P.settings.pieceVisTime=math.floor(MATH.cLerp(260,2e3,P.modeData.simplicity/62))
                    P.settings.pieceFadeTime=math.floor(MATH.cLerp(260,1e3,P.modeData.simplicity/62))
                end,
            },
            drawInField=mechLib.brik.misc.lineClear_event_drawInField,
            drawOnPlayer=mechLib.brik.misc.lineClear_event_drawOnPlayer,
            gameOver=function(P)
                PROGRESS.setExteriorScore('hidden','line',math.min(P.modeData.stat.line,100))
                if P.finished=='AC' then
                    PROGRESS.setExteriorScore('hidden','easy',P.gameTime,'<')
                    if P.modeData.maxSimplicity<=12 then
                        PROGRESS.setExteriorScore('hidden','hard',P.gameTime,'<')
                        P:showInvis(1,P.settings.pieceFadeTime/2)
                    else
                        P:showInvis(2,P.settings.pieceFadeTime)
                    end
                    if P.modeData.stat.clears[1]+P.modeData.stat.clears[2]+P.modeData.stat.clears[3]==0 then
                        PROGRESS.setSecret('exterior_hidden_superBrain')
                    end
                end
            end,
        },
    }},
}
