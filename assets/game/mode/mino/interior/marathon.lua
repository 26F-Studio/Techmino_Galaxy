local dropSpeed={1000,833,666,500,400,300,200,150,100,70,50,42,30,16,12,8,7,6,5,4}
local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('push',PROGRESS.getMain()==1 and 'simp' or 'base')
    end,
    settings={mino={
        skin='mino_interior',
        shakeness=0.1,
        das=120,
        arr=16,
        sdarr=16,
        spawnDelay=130,
        clearDelay=300,
        soundEvent={
            countDown=function(num)
                SFX.playSample('lead',num>0 and 'A3' or 'A4')
            end,
        },
        event={
            playerInit=function(P)
                P.settings.dropDelay=dropSpeed[1]
                P.modeData.line=0
                P.modeData.target=10
            end,
            afterClear=function(P)
                P.modeData.line=math.min(P.modeData.line+P.clearHistory[#P.clearHistory].line,200)
                if P.modeData.line>=P.modeData.target then
                    if P.modeData.target<200 then
                        if PROGRESS.getMain()>=2 and P.modeData.target<=150 and P.isMain then
                            BGM.set(bgmList['push'].add,'volume',(P.modeData.target/150)^2,2.6)
                        end
                        P.settings.dropDelay=dropSpeed[P.modeData.target/10+1]
                        P.modeData.target=P.modeData.target+10
                        P:playSound('reach')
                    else
                        P:finish('AC')
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.line,-300,-110)
                gc.rectangle('fill',-380,-2,160,4)
                GC.mStr(P.modeData.target,-300,0)
            end,
            gameOver=function(P)
                PROGRESS.setInteriorScore('sprint',math.min(P.modeData.line*4/3,40))
                PROGRESS.setInteriorScore('marathon',
                    P.modeData.line>=200 and 160 or
                    P.modeData.line>=130 and MATH.interpolate(P.modeData.line,130,120,200,160) or
                    P.modeData.line>=80  and MATH.interpolate(P.modeData.line,80,90,130,120) or
                    P.modeData.line>=40  and MATH.interpolate(P.modeData.line,40,40,80,90) or
                    MATH.interpolate(P.modeData.line,0,0,40,40)
                )
            end,
        },
    }},
}
