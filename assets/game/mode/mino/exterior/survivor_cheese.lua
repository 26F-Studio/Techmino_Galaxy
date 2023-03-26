local gc=love.graphics
local max,min=math.max,math.min
local bgmTransBegin,bgmTransFinish=30,80

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='basic',
        allowCancel=true,
        clearStuck=false,
        initialRisingSpeed=0,
        risingAcceleration=.003,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=function(P)
                local md=P.modeData
                md.waveTimer0=3000
                md.waveTimer=0
                md.wave=0
            end,
            always=function(P)
                if not P.timing then return end
                local md=P.modeData
                if md.waveTimer>0 then
                    md.waveTimer=min(md.waveTimer-1,(P.field:getHeight()+3*P.garbageSum)*260)
                end
                if md.waveTimer==0 and P.garbageSum<=max(15-P.field:getHeight()/2,8) then
                    md.wave=md.wave+1

                    local wave=md.wave
                    md.waveTimer0=math.floor(
                        wave<=80 and MATH.interpolate(wave,0,3000,80,2000) or
                        wave<=150 and MATH.interpolate(wave,80,2000,150,2500) or
                        math.max(2000-(wave-150)*10,1000)
                    )
                    md.waveTimer=md.waveTimer0
                    GAME.send(nil,GAME.initAtk{
                        target=GAME.mainID,
                        power=P:random(0,10)+P:random(-5,5)>=P.field:getHeight() and 2 or 1,
                        defendRate=wave<60 and 2 or 3,
                        mode=0,
                        time=wave<50 and 100000/(50+wave)-1000 or 0,
                        fatal=MATH.clamp(
                            (
                                wave<100 and MATH.interpolate(wave,0,20,100,60) or
                                wave<200 and MATH.interpolate(wave,100,60,200,100) or
                                100
                            )+math.floor((P:random()*2-1)*min(wave,100)/5),
                            0,100
                        ),
                        -- speed=?,
                    })

                    if wave>bgmTransBegin and wave<=bgmTransFinish and P.isMain then
                        BGM.set(bgmList['here'].add,'volume',min((wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(P.modeData.wave,-300,-70)
                FONT.set(30) GC.mStr("Waves",-300,15)

                local cd=P.modeData.waveTimer/P.modeData.waveTimer0
                GC.setLineWidth(10)
                GC.setColor(COLOR.DL)
                GC.arc('line','open',-300,130,40,-MATH.pi*.5,cd*MATH.tau-MATH.pi*.5)
                GC.setLineWidth(3)
                GC.setColor(COLOR.lD)
                GC.circle('line',-300,130,32)
                GC.circle('line',-300,130,48)
            end,
        },
    }},
}
