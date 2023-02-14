local gc=love.graphics
local max,min=math.max,math.min
local bgmTransBegin,bgmTransFinish=30,80
-- if buffer + dBuffer <= 50 - 2*fieldHeight
--     P:inject_dBuffer()

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
                md.waveTimer=0
                md.wave=0
            end,
            always=function(P)
                if not P.timing then return end
                local md=P.modeData
                if md.waveTimer>0 then
                    md.waveTimer=min(md.waveTimer,(P.field:getHeight()+3*P.garbageSum)*260)-1
                end
                if md.waveTimer==0 and P.garbageSum<=max(15-P.field:getHeight()/2,8) then
                    md.wave=md.wave+1

                    local wave=md.wave
                    md.waveTimer=
                        wave<=100 and MATH.interpolate(wave,0,3000,100,1000) or
                        wave<=200 and MATH.interpolate(wave,100,1000,200,2000) or
                        2000-(wave-200)*10
                    GAME.send(nil,GAME.initAtk{
                        target=GAME.mainID,
                        power=P.seqRND:random(0,10)+P.seqRND:random(-5,5)>=P.field:getHeight() and 2 or 1,
                        defendRate=3,
                        mode=0,
                        time=wave<50 and 100000/(50+wave)-1000 or 0,
                        fatal=MATH.clamp(
                            (
                                wave<100 and MATH.interpolate(wave,0,20,100,60) or
                                wave<200 and MATH.interpolate(wave,100,60,200,100) or
                                100
                            )+math.floor((P.seqRND:random()*2-1)*min(wave,100)/5),
                            0,100
                        ),
                        -- speed=?,
                    })

                    if wave>bgmTransBegin and wave<bgmTransFinish and P.isMain then
                        BGM.set(bgmList['here'].add,'volume',min((wave-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.wave,-300,-55)
                FONT.set(30)
                GC.mStr("Waves",-300,30)
            end,
        },
    }},
}
