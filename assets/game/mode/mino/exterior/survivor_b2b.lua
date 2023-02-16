local gc=love.graphics
local max,min=math.max,math.min
local bgmTransBegin,bgmTransFinish=20,50

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='modern',
        allowCancel=true,
        initialRisingSpeed=1,
        risingAcceleration=.001,
        risingDeceleration=.001,
        maxRisingSpeed=1,
        minRisingSpeed=1,
        event={
            playerInit=function(P)
                local md=P.modeData
                md.waveTimer0=6000
                md.waveTimer=0
                md.wave=0
            end,
            always=function(P)
                if not P.timing then return end
                local md=P.modeData
                if md.waveTimer>0 then
                    md.waveTimer=min(md.waveTimer,(P.field:getHeight()+3*P.garbageSum)*260)-1
                end
                if md.waveTimer==0 and P.garbageSum<=max(20-P.field:getHeight(),12) then
                    md.wave=md.wave+1

                    local wave=md.wave
                    md.waveTimer0=math.floor(
                        wave<=40 and MATH.interpolate(wave,0,6000,40,4000) or
                        wave<=80 and MATH.interpolate(wave,40,4000,80,1500) or
                        max(MATH.interpolate(wave,80,1500,150,800),800)
                    )
                    md.waveTimer=md.waveTimer0
                    GAME.send(nil,GAME.initAtk{
                        target=GAME.mainID,
                        power=4+P.seqRND:random(0,MATH.clamp(math.floor(wave/30-P.field:getHeight()/10),0,3)),
                        mode=0,
                        time=(wave<50 and 100000/(100+2*wave)+500 or 1000)+MATH.clamp(400-wave,150,350)*max(P.field:getHeight()+P.garbageSum-8,0),
                        fatal=math.floor(min(30+wave/2,50)),
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
