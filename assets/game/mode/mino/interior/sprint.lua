local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race',PROGRESS.getMain()==1 and 'simp' or 'base')
        BG.set('none')
    end,
    settings={mino={
        skin='mino_interior',
        shakeness=0,
        dropDelay=1000,
        lockDelay=1000,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'A3' or 'A4')
            end,
        },
        event={
            afterClear=function(P)
                P.modeData.line=math.min(P.modeData.line+P.clearHistory[#P.clearHistory].line,40)
                if P.modeData.line>=40 then
                    P:finish('AC')
                    PROGRESS.setInteriorScore('sprint',
                        P.gameTime<60e3  and 200 or
                        P.gameTime<90e3  and MATH.interpolate(P.gameTime,90e3,140,60e3,200) or
                        P.gameTime<180e3 and MATH.interpolate(P.gameTime,180e3,90,90e3,140) or
                        P.gameTime<300e3 and MATH.interpolate(P.gameTime,300e3,40,180e3,90) or
                        40
                    )
                end
                if PROGRESS.getMain()>=2 and P.modeData.line>10 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-10)/20,1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-40)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(40-P.modeData.line,-300,-55)
            end,
            gameOver=function(P)
                if P.modeData.line<40 then
                    PROGRESS.setInteriorScore('marathon',P.modeData.line*0.75)
                    PROGRESS.setInteriorScore('sprint',P.modeData.line)
                end
            end
        },
    }},
}
