local floor,ceil=math.floor,math.ceil
local max,min=math.max,math.min
local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('here','base')
    end,
    settings={mino={
        atkSys='nextgen',
        allowCancel=true,
        initialRisingSpeed=0,
        risingAcceleration=.0006,
        risingDeceleration=.0002,
        maxRisingSpeed=0.5,
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
                    md.waveTimer=min(md.waveTimer-1,P.garbageSum*620)
                end
                if md.waveTimer==0 and P.garbageSum<=10 then
                    md.wave=md.wave+1

                    local wave=md.wave
                    md.waveTimer0=floor(
                        wave<=10 and MATH.interpolate(wave,0,20000,10,15000) or
                        wave<=30 and MATH.interpolate(wave,10,15000,30,12000) or
                        max(MATH.interpolate(wave,30,12000,60,10000),10000)
                    )
                    md.waveTimer=md.waveTimer0
                    for i=1,3 do
                        GAME.send(nil,GAME.initAtk{
                            target=GAME.mainID,
                            power=
                                2+2*i+ -- Basic Attack (4+6+8)
                                P:random(
                                    MATH.clamp(ceil(wave/20-P.field:getHeight()/15),0,2), -- Random lower bound (from 0 to 2 on wave 40, -1 if field reach 15)
                                    min(floor(wave/10),4) -- Random Upper bound (from 0 to 4 on wave 40)
                                ),
                            mode=0,
                            time=
                                max(6000-50*wave,4000)+ -- Basic delay (from 6s to 4s on wave 40)
                                (i-1)*max(3000-wave*30,1500), -- Split time (from 3s to 1.5s on wave 50)
                            fatal=floor(min(30+wave/4,50)),-- Fatal (from 30 to 50 on wave 80)
                            -- speed=?,
                        })
                    end

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
