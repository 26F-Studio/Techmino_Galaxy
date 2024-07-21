---@param P Techmino.Player.Brik
local function accelerate_event_always(P)
    local md=P.modeData
    if md.idleTime<1260 then
        md.idleTime=md.idleTime+1
    else
        for i=1,4.2-P.field:getHeight()/4.2 do
            local g=P.garbageBuffer[i]
            if g then
                g._time=math.min(g._time+1,g.time)
            end
        end
    end
end
---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('new era')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1000,
        readyDelay=0,
        atkSys='modern',
        event={
            playerInit={
                mechLib.brik.survivor.event_playerInit,
                function(P)
                    P.modeData.idleTime=0
                    P.modeData.lastPieceWave={-1,-1,-1,-1}
                    local T=mechLib.common.task
                    T.install(P)
                    T.add(P,'survivor_cheese','modeTask_survivor_cheese_title','modeTask_survivor_cheese_desc')
                    T.add(P,'survivor_power','modeTask_survivor_power_title','modeTask_survivor_power_desc')

                    if PROGRESS.getExteriorModeScore('survivor','showSpike') then
                        T.add(P,'survivor_spike','modeTask_survivor_spike_title','modeTask_survivor_spike_desc')
                    end
                end,
            },
            gameStart=function(P) P.timing=false end,
            afterLock=function(P)
                P.modeData.idleTime=0
                if P.modeData.subMode then
                    table.remove(P.modeData.lastPieceWave,1)
                    table.insert(P.modeData.lastPieceWave,P.modeData.wave)
                    if P.modeData.lastPieceWave[1]%10==0 then
                        PROGRESS.setExteriorScore('survivor',P.modeData.subMode,P.modeData.lastPieceWave[1])
                    end
                end
            end,
            beforeCancel=function(P)
                local T=mechLib.common.task
                T.set(P,'survivor_cheese',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                T.set(P,'survivor_power',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                T.set(P,'survivor_spike',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                if P.stat.atk>=8 then
                    local eff=P.stat.atk/P.stat.line
                    if eff>=2 then
                        if not PROGRESS.getExteriorModeScore('survivor','showSpike') then
                            T.add(P,'survivor_spike','modeTask_survivor_spike_title','modeTask_survivor_spike_desc')
                            T.set(P,'survivor_spike',P.stat.atk/8,("($1/8)"):repD(P.stat.atk))
                        end
                        T.set(P,'survivor_spike',true)
                        PROGRESS.setExteriorScore('survivor','showSpike',1)
                        P.modeData.subMode='spike'
                        P.settings.dropDelay=260
                        P.settings.maxFreshChance=10
                        P.settings.maxFreshTime=2600
                        P:setAttackSystem('nextgen')
                        P:addEvent('always',mechLib.brik.survivor.spike_event_always)
                        playBgm('there')
                        mechLib.common.music.set(P,{path='.wave',s=10,e=30},'afterClear')
                    elseif eff>=1 then
                        T.set(P,'survivor_power',true)
                        P.modeData.subMode='power'
                        P.settings.dropDelay=620
                        P.settings.maxFreshChance=12
                        P.settings.maxFreshTime=4200
                        P:addEvent('always',mechLib.brik.survivor.power_event_always)
                        playBgm('here')
                        mechLib.common.music.set(P,{path='.wave',s=20,e=50},'afterClear')
                    else
                        T.set(P,'survivor_cheese',true)
                        P.modeData.subMode='cheese'
                        P.settings.dropDelay=1000
                        P.settings.maxFreshChance=15
                        P.settings.maxFreshTime=6200
                        P:setAttackSystem('basic')
                        P:addEvent('always',mechLib.brik.survivor.cheese_event_always)
                        playBgm('shift')
                        mechLib.common.music.set(P,{path='.wave',s=30,e=80},'afterClear')
                    end
                    if P.modeData.subMode then
                        P.timing=true
                        P:addEvent('drawOnPlayer',mechLib.brik.survivor.event_drawOnPlayer)
                        P:addEvent('always',accelerate_event_always)
                        return true
                    end
                end
            end,
            gameOver=function(P)
                if P.modeData.subMode then
                    PROGRESS.setExteriorScore('survivor',P.modeData.subMode,P.modeData.lastPieceWave[1])
                end
            end,
        },
    }},
}
