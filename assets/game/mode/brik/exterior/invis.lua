local max,min=math.max,math.min
local floor,abs=math.floor,math.abs
local ins=table.insert
local cIntp=MATH.clampInterpolate

-- Speed of Invisible EP:
-- Phase 1: 126 BPM (476.2 ms/Beat)
-- Phase 2: 143 BPM (419.6 ms/Beat)
-- Phase 3: 160 BPM (375.0 ms/Beat)

local function haunted_p2_afterSpawn(P)
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
local function haunted_p3_afterSpawn(P)
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
regFuncLib(haunted_p2_afterSpawn,'exterior_invis.haunted_p2_afterSpawn')
regFuncLib(haunted_p3_afterSpawn,'exterior_invis.haunted_p3_afterSpawn')

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
                P.modeData.maxSimplicity=0
                P.modeData.simplicity=0
                P.modeData.target.line=100

                local T=mechLib.common.task
                T.install(P)
                T.add(P,'invis_haunted','modeTask_invis_haunted_title','modeTask_invis_haunted_desc','(0/4)')
                if PROGRESS.getExteriorModeScore('invis','showHidden') then
                    T.add(P,'invis_hidden','modeTask_invis_hidden_title','modeTask_invis_hidden_desc')
                end
            end,
            afterClear={
                function(P,clear)
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
                            P.settings.spawnDelay=238
                            P.settings.clearDelay=476
                            playBgm('invisible')
                            PROGRESS.setBgmUnlocked('invisible mode',1)
                            if FMOD.music.getParam('section')>0 then
                                FMOD.music.setParam('section',0)
                                FMOD.music.seek(0)
                            end
                        elseif P.modeData.subMode=='hidden' then
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
                        local prev,curLine=P.stat.line-clear.line,P.stat.line
                        if prev<100 and curLine>=100 then
                            -- Haunted Phase 2 init
                            P.modeData.target.line=200
                            P.settings.spawnDelay=210
                            P.settings.clearDelay=420
                            P:addEvent('afterSpawn',haunted_p2_afterSpawn)
                            P:playSound('beep_rise')
                            FMOD.music.setParam('section',1)
                            PROGRESS.setBgmUnlocked('invisible mode 2',1)
                        elseif prev<200 and curLine>=200 then
                            local passTechrashTorikan=P.stat.clears[4]>42
                            local passTimeTorikan=P.gameTime<=303e3
                            if passTechrashTorikan or passTimeTorikan then
                                -- Haunted Phase 3 init
                                P.modeData.target.line=260
                                if passTechrashTorikan and passTimeTorikan then
                                    P.settings.spawnDelay=188
                                    P.settings.clearDelay=188
                                    P.settings.dropDelay=0
                                else
                                    P.settings.spawnDelay=375
                                    P.settings.clearDelay=0
                                    P.settings.dropDelay=94
                                end
                                P:delEvent('afterSpawn',haunted_p2_afterSpawn)
                                P:addEvent('afterSpawn',haunted_p3_afterSpawn)
                                mechLib.brik.misc.haunted_turnOn(P,62,120,600,1000)
                                P:playSound('beep_rise')
                                FMOD.music.setParam('section',2)
                                PROGRESS.setBgmUnlocked('total mayhem',1)
                            else
                                P:finish('timeout')
                            end
                        elseif curLine>=260 then
                            P:finish('win')
                            FMOD.music.setParam('section',3)
                            return true
                        end

                        if curLine<100 then
                            -- Haunted Phase 1 step
                            P.settings.dropDelay=floor(cIntp(20,476,80,238,MATH.clamp(curLine,20,80)))
                            mechLib.brik.misc.haunted_turnOn(P,
                                floor(cIntp(70,5,90,20,curLine)),
                                260,
                                floor(cIntp(0,1600,80,600,curLine)),
                                floor(cIntp(0,600,80,300,curLine))
                            )
                        elseif curLine<200 then
                            -- Haunted Phase 2 step
                            P.settings.dropDelay=floor(cIntp(120,210,180,105,MATH.clamp(curLine,120,180)))
                            P.modeData.cyanizeRate=floor(cIntp(102,16,126,100,curLine))
                            mechLib.brik.misc.haunted_turnOn(P,
                                floor(cIntp(100,26,200,42,curLine)),
                                260,
                                floor(cIntp(100,500,150,300,curLine)),
                                floor(cIntp(100,300,150,200,curLine))
                            )
                        else
                            -- Haunted Phase 3 step
                            P.modeData.deColorRate=floor(cIntp(200,0,230,42,curLine))
                            P.modeData.darkRate=floor(cIntp(220,26,240,62,curLine))
                        end
                    elseif P.modeData.subMode=='hidden' then
                        if P.stat.line>=P.modeData.target.line then
                            P:finish('win')
                        else
                            if clear.line<4 then
                                P.modeData.simplicity=P.modeData.simplicity+(5-clear.line)
                            else
                                P.modeData.simplicity=P.modeData.simplicity-2
                            end
                            P.modeData.simplicity=min(P.modeData.simplicity,62-floor(P.stat.line/5))
                            P.modeData.maxSimplicity=max(P.modeData.maxSimplicity,P.modeData.simplicity)
                            P.settings.pieceVisTime=floor(MATH.cLerp(260,2e3,P.modeData.simplicity/62))
                            P.settings.pieceFadeTime=floor(MATH.cLerp(260,1e3,P.modeData.simplicity/62))
                        end
                    end
                end,
            },
            drawInField=mechLib.brik.misc.lineClear_event_drawInField,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-80,160,160)
                GC.setColor(COLOR.L)
                FONT.set(70)
                GC.mStr(P.stat.line,-300,-90)
                GC.rectangle('fill',-375,-2,150,4)
                GC.mStr(P.modeData.target.line,-300,-5)
            end,
            gameOver=function(P,reason)
                if P.modeData.subMode=='haunted' then
                    PROGRESS.setExteriorScore('invis','haunted',min(P.stat.line,260),'>')
                    if reason=='AC' then
                        PROGRESS.setExteriorScore('invis','haunted_time',P.gameTime,'<')
                    end
                elseif P.modeData.subMode=='hidden' then
                    PROGRESS.setExteriorScore('invis','line',min(P.stat.line,100),'>')
                    if reason=='AC' then
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
