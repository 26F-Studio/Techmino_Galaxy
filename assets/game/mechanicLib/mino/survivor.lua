local floor,ceil=math.floor,math.ceil
local max,min=math.max,math.min
local gc=love.graphics

--- @type Techmino.Mech.mino
local survivor={}

function survivor.event_playerInit(P)
    local md=P.modeData
    md.curWaveTime=1
    md.waveTimer=0
    md.wave=0
end

function survivor.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-60,160,120)
    FONT.set(80) GC.mStr(P.modeData.wave,-300,-70)
    FONT.set(30) GC.mStr(Text.target_wave,-300,15)

    local cd=P.modeData.waveTimer/P.modeData.curWaveTime
    gc.setLineWidth(10)
    gc.setColor(COLOR.DL)
    gc.arc('line','open',-300,130,40,-MATH.pi*.5,cd*MATH.tau-MATH.pi*.5)
    gc.setLineWidth(3)
    gc.setColor(COLOR.lD)
    gc.circle('line',-300,130,32)
    gc.circle('line',-300,130,48)
end

function survivor.b2b_event_always(P)
    if not P.timing then return end
    local md=P.modeData
    if md.waveTimer>0 then
        md.waveTimer=min(md.waveTimer-1,(P.field:getHeight()+3*P.garbageSum)*260)
    end
    if md.waveTimer==0 and P.garbageSum<=max(20-P.field:getHeight(),12) then
        md.wave=md.wave+1

        local wave=md.wave
        md.curWaveTime=math.floor(
            wave<=40 and MATH.interpolate(0,6000,40,4000,wave) or
            wave<=80 and MATH.interpolate(40,4000,80,1500,wave) or
            max(MATH.interpolate(80,1500,150,800,wave),800)
        )
        md.waveTimer=md.curWaveTime
        GAME.send(nil,GAME.initAtk{
            target=GAME.mainID,
            power=4+P:random(0,MATH.clamp(math.floor(wave/30-P.field:getHeight()/10),0,3)),
            mode=0,
            time=
                (wave<50 and 100e3/(100+2*wave)+500 or 1000)+
                MATH.clamp(400-wave,150,350)*max(P.field:getHeight()+P.garbageSum-8,0),
            fatal=math.floor(min(30+wave/2,50)),
            -- speed=?,
        })
    end
end
function survivor.cheese_event_always(P)
    if not P.timing then return end
    local md=P.modeData
    if md.waveTimer>0 then
        md.waveTimer=min(md.waveTimer-1,(P.field:getHeight()+3*P.garbageSum)*260)
    end
    if md.waveTimer==0 and P.garbageSum<=max(15-P.field:getHeight()/2,8) then
        md.wave=md.wave+1

        local wave=md.wave
        md.curWaveTime=math.floor(
            wave<=80 and MATH.interpolate(0,3000,80,2000,wave) or
            wave<=150 and MATH.interpolate(80,2000,150,2500,wave) or
            math.max(2000-(wave-150)*10,1000)
        )
        md.waveTimer=md.curWaveTime
        GAME.send(nil,GAME.initAtk{
            target=GAME.mainID,
            power=P:random(0,10)+P:random(-5,5)>=P.field:getHeight() and 2 or 1,
            defendRate=wave<60 and 2 or 3,
            mode=0,
            time=wave<50 and 100e3/(50+wave)-1000 or 0,
            fatal=MATH.clamp(
                (
                    wave<100 and MATH.interpolate(0,20,100,60,wave) or
                    wave<200 and MATH.interpolate(100,60,200,100,wave) or
                    100
                )+math.floor((P:random()*2-1)*min(wave,100)/5),
                0,100
            ),
            -- speed=?,
        })
    end
end
function survivor.spike_event_always(P)
    if not P.timing then return end
    local md=P.modeData
    if md.waveTimer>0 then
        md.waveTimer=min(md.waveTimer-1,P.garbageSum*620)
    end
    if md.waveTimer==0 and P.garbageSum<=10 then
        md.wave=md.wave+1

        local wave=md.wave
        md.curWaveTime=floor(
            wave<=10 and MATH.interpolate(0,20e3,10,15e3,wave) or
            wave<=30 and MATH.interpolate(10,15e3,30,12e3,wave) or
            max(MATH.interpolate(30,12e3,60,10e3,wave),10e3)
        )
        md.waveTimer=md.curWaveTime
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
                fatal=floor(min(30+wave/4,50)), -- Fatal (from 30 to 50 on wave 80)
                -- speed=?,
            })
        end

    end
end

return survivor
