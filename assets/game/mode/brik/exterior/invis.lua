local max,min=math.max,math.min
local floor,abs=math.floor,math.abs
local ins,rem=table.insert,table.remove
local round,cItp=MATH.round,MATH.clampInterpolate

-- Speed of Invisible EP:
-- Phase 1: 126 BPM (476.19 ms/Beat) 6=F
-- Phase 2: 143 BPM (419.58 ms/Beat) 6=F#
-- Phase 3: 160 BPM (375.00 ms/Beat) 6=G
local beatItvl={476.19,419.58,375.00}
local torikanScore,secretScore=2600,4000

local haunted={}
function haunted.dropSound1(vol)
    FMOD.effect('drop_'..math.random(6),{tune=-4,volume=vol})
end
function haunted.dropSound2(vol)
    FMOD.effect('drop_'..math.random(6),{tune=-3,volume=vol})
end
function haunted.dropSound3(vol)
    FMOD.effect('drop_'..math.random(6),{tune=-2,volume=vol})
end
local len=6
function haunted.afterLock(P)
    ---@cast P Techmino.Player.Brik
    local l=P.modeData.lastDropTimes
    ins(l,1,P.gameTime)
    if #l<len then return end
    l[len+1]=nil

    local step=beatItvl[P.modeData.phase]
    local minDelta=1e99
    ---@type integer[] [len]
    local l2=TABLE.copy(l)
    for j=len,1,-1 do
        l2[j]=(l2[j]-l2[1]+step/2)%step
    end
    for i=2,len do
        local delta=l2[1]-(MATH.sum(l2,2)-l2[i])/(len-2)
        if abs(delta)<minDelta then minDelta=delta end
    end
    if abs(minDelta)<=62 then
        P.modeData.beatChain=P.modeData.beatChain+1
        if P.modeData.beatChain>=6 then
            local perfect=abs(minDelta)<=26
            local phase=P.modeData.phase
            local acc
            if perfect then
                acc=10
                if phase==1 then
                    playSample('saw',{'F2',1,62})
                    playSample('organ',{'F2',.626,62})
                elseif phase==2 then
                    playSample('saw',{'G#2',1,62})
                    playSample('organ',{'G#2',.626,62})
                elseif phase==3 then
                    playSample('saw',{'A#2',1,62})
                    playSample('organ',{'A#2',.626,62})
                end
            else
                acc=3
                if phase==1 then
                    playSample('complex',{'F2',1,62})
                elseif phase==2 then
                    playSample('complex',{'G#2',1,62})
                elseif phase==3 then
                    playSample('complex',{'A#2',1,62})
                end
            end
            P.modeData.energy=P.modeData.energy+acc
            if P.modeData.energy>secretScore then
                PROGRESS.setSecret('exterior_invis_rhythmMaster')
            end
        end
    else
        P.modeData.beatChain=0
    end
end
function haunted.p2_afterSpawn(P)
    local N=P.nextQueue[#P.nextQueue]
    if not N then return end
    N=N.matrix
    local cellList={}
    for y=1,#N do for x=1,#N[1] do if N[y][x] then
        ins(cellList,N[y][x])
    end end end
    for _,cell in next,cellList do
        if P:roll(P.modeData.cyanizeRate/100) then
            cell.color=186
        end
    end
end
function haunted.p3_afterSpawn(P)
    local N=P.nextQueue[#P.nextQueue]
    if not N then return end
    N=N.matrix
    local cellList={}
    for y=1,#N do for x=1,#N[1] do if N[y][x] then
        ins(cellList,N[y][x])
    end end end
    for _,cell in next,cellList do
        if P:roll(P.modeData.deColorRate/100) then
            cell.color=P:roll(P.modeData.darkRate/100) and 222 or 444
        end
    end
end
regFuncLib({
    haunted=haunted,
},'exterior_invis')

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('sugar fairy')
    end,
    settings={brik={
        pieceVisTime=1000,
        pieceFadeTime=1000,
        event={
            playerInit=function(P)
                P.modeData.target.line=100
                local T=mechLib.common.task
                T.install(P)
                T.add(P,'invis_haunted','modeTask_invis_haunted_title','modeTask_invis_haunted_desc','(0/4)')
                if PROGRESS.getExteriorModeScore('invis','showHidden') then
                    T.add(P,'invis_hidden','modeTask_invis_hidden_title','modeTask_invis_hidden_desc')
                end
            end,
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterClear={
                function(P,clear)
                    ---@cast P Techmino.Player.Brik
                    local T=mechLib.common.task
                    T.set(P,'invis_haunted',P.stat.line/4,"("..P.stat.line.."/4)")
                    if clear.line>=4 then
                        P.modeData.subMode='hidden'
                        if not PROGRESS.getExteriorModeScore('invis','showHidden') then
                            PROGRESS.setExteriorScore('invis','showHidden',1,'>')
                            T.add(P,'invis_hidden','modeTask_invis_hidden_title','modeTask_invis_hidden_desc')
                        end
                        T.set(P,'invis_hidden',true)
                    else
                        if P.stat.line>=4 then
                            P.modeData.subMode='haunted'
                            T.set(P,'invis_haunted',true,"(4/4)")
                        end
                    end
                    if P.modeData.subMode then
                        if P.modeData.subMode=='haunted' then
                            -- Haunted Phase 1 init
                            P.modeData.linePoint=P.stat.line
                            P.modeData.phase=1
                            P.modeData.lastDropTimes={}
                            P.modeData.beatChain=0
                            P.modeData.accuracyPoint=0
                            P.modeData.energy=0
                            P.modeData.energyShow=0
                            P.settings.spawnDelay=round(beatItvl[1]/2)
                            P.settings.clearDelay=round(beatItvl[1])
                            P.settings.lockDelay=round(beatItvl[1]*2.5)
                            P:addEvent('afterLock',haunted.afterLock)
                            playBgm('invisible')
                            P:addSoundEvent('drop',haunted.dropSound1)
                            PROGRESS.setBgmUnlocked('invisible mode',1)
                            if FMOD.music.getParam('section')>0 then
                                FMOD.music.setParam('section',0)
                                FMOD.music.seek(0)
                            end
                        elseif P.modeData.subMode=='hidden' then
                            -- Hidden init
                            P.modeData.maxSimplicity=0
                            P.modeData.simplicity=0
                            P.settings.pieceVisTime=260
                            P.settings.pieceFadeTime=260
                            mechLib.common.music.set(P,{path='stat.line',s=50,e=100},'afterClear')
                        end
                        return true
                    end
                end,
                function(P,clear)
                    ---@cast P Techmino.Player.Brik
                    if P.modeData.subMode=='haunted' then
                        if clear.line>=4 and P.modeData.energy<torikanScore then
                            -- Gain energy with Techrashes
                            P.modeData.energy=min(P.modeData.energy+clear.line/4*100,torikanScore)
                        end
                        P.modeData.linePoint=P.modeData.linePoint+clear.line*2-1
                        local LP=P.modeData.linePoint
                        if P.modeData.phase==1 then
                            if LP<100 then
                                -- Haunted Phase 1 step
                                P.settings.dropDelay=round(cItp(20,beatItvl[1],80,beatItvl[1]/2,MATH.clamp(LP,20,80)))
                                mechLib.brik.misc.haunted_turnOn(P,
                                    round(cItp(70,5,90,20,LP)),
                                    260,
                                    round(cItp(0,1600,80,600,LP)),
                                    round(cItp(0,600,80,300,LP))
                                )
                            else
                                -- Haunted Phase 2 init
                                P.modeData.phase=2
                                P.modeData.target.line=200
                                P.settings.spawnDelay=round(beatItvl[2]/4)
                                P.settings.clearDelay=round(beatItvl[2])
                                P.settings.lockDelay=round(beatItvl[2]*2.5)
                                P:addEvent('afterSpawn',haunted.p2_afterSpawn)
                                P:addSoundEvent('drop',haunted.dropSound2)
                                P:playSound('beep_rise')
                                FMOD.music.setParam('section',1)
                                PROGRESS.setBgmUnlocked('invisible mode 2',1)
                            end
                        end
                        if P.modeData.phase==2 then
                            if LP<200 then
                                -- Haunted Phase 2 step
                                P.settings.dropDelay=round(cItp(120,round(beatItvl[2]/2),180,round(beatItvl[2]/4),MATH.clamp(LP,120,180)))
                                P.modeData.cyanizeRate=round(cItp(102,16,126,100,LP))
                                mechLib.brik.misc.haunted_turnOn(P,
                                    round(cItp(100,26,200,42,LP)),
                                    260,
                                    round(cItp(100,800,150,500,LP)),
                                    round(cItp(100,400,150,260,LP))
                                )
                            else
                                local passTimeTorikan=P.gameTime<=260e3
                                local passEnergyTorikan=P.modeData.energy>=torikanScore
                                if passTimeTorikan or passEnergyTorikan then
                                    -- Haunted Phase 3 init
                                    P.modeData.phase=3
                                    P.modeData.target.line=260
                                    if passEnergyTorikan and passTimeTorikan then
                                        P.settings.spawnDelay=round(beatItvl[3]/4)
                                        P.settings.clearDelay=0
                                        P.settings.dropDelay=0
                                        P.settings.lockDelay=round(beatItvl[3]*1.5)
                                        P.settings.asd=max(P.settings.asd,62)
                                        P.settings.asp=max(P.settings.asp,26)
                                    else
                                        P.settings.spawnDelay=round(beatItvl[3])
                                        P.settings.clearDelay=0
                                        P.settings.dropDelay=round(beatItvl[3]/4)
                                        P.settings.lockDelay=round(beatItvl[3]*2.5)
                                    end
                                    P:delEvent('afterSpawn',haunted.p2_afterSpawn)
                                    P:addEvent('afterSpawn',haunted.p3_afterSpawn)
                                    mechLib.brik.misc.haunted_turnOn(P,62,120,600,1000)
                                    P:addSoundEvent('drop',haunted.dropSound3)
                                    P:playSound('beep_rise')
                                    FMOD.music.setParam('section',2)
                                    PROGRESS.setBgmUnlocked('total mayhem',1)
                                else
                                    P:finish('timeout')
                                end
                            end
                        end
                        if P.modeData.phase==3 then
                            if LP<260 then
                                -- Haunted Phase 3 step
                                P.modeData.deColorRate=round(cItp(200,0,230,42,LP))
                                P.modeData.darkRate=round(cItp(220,26,240,62,LP))
                            else
                                -- Haunted finished
                                P.stat.line=260
                                P:finish('win')
                                FMOD.music.setParam('section',3)
                                return true
                            end
                        end
                    elseif P.modeData.subMode=='hidden' then
                        if P.stat.line>=P.modeData.target.line then
                            P.stat.line=P.modeData.target.line
                            P:finish('win')
                        else
                            if clear.line<4 then
                                P.modeData.simplicity=P.modeData.simplicity+(5-clear.line)
                            else
                                P.modeData.simplicity=P.modeData.simplicity-2
                            end
                            P.modeData.simplicity=min(P.modeData.simplicity,62-floor(P.stat.line/5))
                            P.modeData.maxSimplicity=max(P.modeData.maxSimplicity,P.modeData.simplicity)
                            P.settings.pieceVisTime=round(MATH.cLerp(260,2e3,P.modeData.simplicity/62))
                            P.settings.pieceFadeTime=round(MATH.cLerp(260,1e3,P.modeData.simplicity/62))
                        end
                    end
                end,
            },
            drawInField=mechLib.brik.misc.lineClear_event_drawInField,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-80,160,160)
                GC.setColor(COLOR.L)
                FONT.set(70)
                if P.modeData.subMode=='haunted' then
                    GC.mStr(P.modeData.linePoint,-300,-90)
                    GC.mStr(P.modeData.target.line,-300,-5)
                    FONT.set(30)
                    GC.setColor(1,1,P.modeData.energy>=secretScore and .62 or 1,P.modeData.phase<3 and P.gameTime>260e3 and .42 or 1)
                    GC.setLineWidth(1)
                    GC.rectangle('line',-375,-2,150,4)
                    GC.rectangle('fill',-375,-2,150*min(P.modeData.energy/torikanScore,1),4)
                else
                    GC.mStr(P.stat.line,-300,-90)
                    GC.rectangle('fill',-375,-2,150,4)
                    GC.mStr(P.modeData.target.line,-300,-5)
                end
            end,
            gameOver=function(P,reason)
                if P.modeData.subMode=='haunted' then
                    PROGRESS.setExteriorScore('invis','haunted',min(P.modeData.linePoint,260),'>')
                    if reason=='win' then
                        PROGRESS.setExteriorScore('invis','haunted_time',P.gameTime,'<')
                    end
                elseif P.modeData.subMode=='hidden' then
                    PROGRESS.setExteriorScore('invis','line',min(P.stat.line,100),'>')
                    if reason=='win' then
                        PROGRESS.setExteriorScore('invis','easy',P.gameTime,'<')
                        if P.modeData.maxSimplicity<=12 then
                            PROGRESS.setExteriorScore('invis','hard',P.gameTime,'<')
                            P:showInvis(1,P.settings.pieceFadeTime/2)
                        else
                            P:showInvis(2,P.settings.pieceFadeTime)
                        end
                        if P.stat.clears[1]+P.stat.clears[2]+P.stat.clears[3]==0 then
                            PROGRESS.setSecret('exterior_invis_superBrain')
                        end
                    end
                end
            end,
        },
    }},
}
