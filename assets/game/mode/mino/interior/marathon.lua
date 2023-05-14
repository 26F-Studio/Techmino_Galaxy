local gc=love.graphics
local dropSpeed={1000,833,666,500,400,300,200,150,100,70,50,30,22,16,12,8,7,6,5,4}

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('push',PROGRESS.getMain()==1 and 'simp' or 'base')
    end,
    settings={mino={
        skin='mino_interior',
        clearMovement='teleBack',
        particles=false,
        spawnDelay=130,
        clearDelay=300,
        soundEvent={countDown=mechLib.mino.misc.interior_soundEvent_countDown},
        event={
            playerInit=function(P)
                P.settings.das=math.max(P.settings.das,100)
                P.settings.arr=math.max(P.settings.arr,20)
                P.settings.sdarr=math.max(P.settings.sdarr,20)

                P.settings.dropDelay=dropSpeed[1]
                P.modeData.line=0
                P.modeData.target=10
            end,
            afterClear=function(P)
                local md=P.modeData
                md.line=math.min(md.line+P.clearHistory[#P.clearHistory].line,200)
                if md.line>=md.target then
                    if md.target<200 then
                        if PROGRESS.getMain()>=2 and md.target<=150 and P.isMain then
                            BGM.set(bgmList['push'].add,'volume',(md.target/150)^2,2.6)
                        end
                        P.settings.dropDelay=dropSpeed[md.target/10+1]
                        md.target=md.target+10
                        P:playSound('reach')
                    else
                        P:finish('AC')
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(70)
                GC.mStr(P.modeData.line,-300,-90)
                gc.rectangle('fill',-375,-2,150,4)
                GC.mStr(P.modeData.target,-300,-5)
            end,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if not P then return end
        PROGRESS.setInteriorScore('sprint',math.min(P.modeData.line*4/3,40))
        PROGRESS.setInteriorScore('marathon',
            P.modeData.line>=200 and 160 or
            P.modeData.line>=130 and MATH.interpolate(P.modeData.line,130,120,200,160) or
            P.modeData.line>=80  and MATH.interpolate(P.modeData.line,80,90,130,120) or
            P.modeData.line>=40  and MATH.interpolate(P.modeData.line,40,40,80,90) or
            MATH.interpolate(P.modeData.line,0,0,40,40)
        )
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end

        local line=math.min(P.modeData.line,math.floor(math.max(time-.26,0)*162))

        -- XX/200
        FONT.set(100)
        GC.setColor(COLOR.L)
        GC.mStr(line.." / 200",800,350)

        -- Bar frame
        GC.setLineWidth(6)
        GC.rectangle('line',800-400-15,550-50-15,800+30,100+30)

        -- Filling bar
        GC.setColor(.2,.4,1,.8)
        GC.rectangle('fill',800-400,550-50,math.floor(line/10)*10/200*800,100)
    end,
}
