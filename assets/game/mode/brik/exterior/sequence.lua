local function cutField_event_always(P)
    P.modeData.initTimer=P.modeData.initTimer-1
    if P.modeData.initTimer==872 then
        local mat=P.field._matrix
        local cutHeight=#mat<=5 and 2 or 3
        while #mat>cutHeight do table.remove(mat) end
        P:createMoveEffect(1,cutHeight,P.settings.fieldW,20)
        P:playSound('frenzy')
    elseif P.modeData.initTimer<=0 then
        P.settings.spawnDelay=0
        P.spawnTimer=0
        P.timing=true
        return true
    end
end

local function sequence_weird(P,d,init)
    if init then d.bag,d.bagCount={},0 return end
    if not d.bag[1] then
        d.bagCount=d.bagCount+1
        d.bag={1,2,3,4,5,6,7}
        if d.bagCount>2.6 then
            local r=P:random(4)
            if     r==1 then d.bag[3]=19 -- J5
            elseif r==2 then d.bag[4]=20 -- L5
            elseif r==3 then d.bag[5]=14 -- T5
            elseif r==4 then d.bag[7]=25 -- I5
            end
        end
    end
    return table.remove(d.bag,P:random(#d.bag))
end
local Pentos={8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local easyPentos={10,11,14,19,20,23,24,25} -- P Q T5 J5 L5 N H I5
local hardPentos={8,9,12,13,15,16,17,18,21,22} -- Z5 S5 F E U V W X R Y
---Mixture of bag8_pentoEZ_p4fromBag10_pentoHD and bag18_pento.
---Difficulty curve: 30L/36L\34L
local function sequence_pento_arc(P,d,init)
    if init then
        d.bag1,d.bag2={},{}
        d.bagCount=0
        return
    end
    if not d.bag1[1] then
        d.bagCount=d.bagCount+1
        if d.bagCount>=6 and d.bagCount<=9 then
            TABLE.connect(d.bag1,Pentos)
        else
            TABLE.connect(d.bag1,easyPentos)
            for _=1,4 do
                if not d.bag2[1] then
                    TABLE.connect(d.bag2,hardPentos)
                end
                table.insert(d.bag1,table.remove(d.bag2,P:random(#d.bag2)))
            end
        end
    end
    return table.remove(d.bag1,P:random(#d.bag1))
end

regFuncLib({
    cutField_event_always=cutField_event_always,
    sequence_weird=sequence_weird,
    sequence_pento_arc=sequence_pento_arc,
},'exterior_sequence')


---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('reason')
    end,
    settings={brik={
        dropDelay=1e99,
        lockDelay=1e99,
        readyDelay=0,
        holdSlot=0,
        seqType=sequence_weird,
        event={
            playerInit=function(P)
                P.modeData.target.line=40
                local T=mechLib.common.task
                T.install(P)
                T.add(P,'sequence_flood',   'modeTask_sequence_flood_title',   'modeTask_sequence_flood_desc')
                T.add(P,'sequence_drought', 'modeTask_sequence_drought_title', 'modeTask_sequence_drought_desc')
                T.add(P,'sequence_saw',     'modeTask_sequence_saw_title',     'modeTask_sequence_saw_desc')
                T.add(P,'sequence_rect',    'modeTask_sequence_rect_title',    'modeTask_sequence_rect_desc')
                T.add(P,'sequence_rain',    'modeTask_sequence_rain_title',    'modeTask_sequence_rain_desc')

                if PROGRESS.getExteriorModeScore('sequence','showPento') then
                    T.add(P,'sequence_pento','modeTask_sequence_pento_title','modeTask_sequence_pento_desc')
                else
                    T.add(P,'sequence_pento','modeTask_unknown_title','modeTask_sequence_unknown_desc')
                end
                if PROGRESS.getExteriorModeScore('sequence','showMPH') then
                    T.add(P,'sequence_mph','modeTask_sequence_mph_title','modeTask_sequence_mph_desc')
                end
            end,
            gameStart=function(P) P.timing=false end,
            afterClear={
                function(P)
                    local T=mechLib.common.task

                    -- MPH
                    if P.stat.piece<=4 then
                        if not PROGRESS.getExteriorModeScore('sequence','showMPH') then
                            T.add(P,'sequence_mph','modeTask_sequence_mph_title','modeTask_sequence_mph_desc')
                        end
                        T.set(P,'sequence_mph',true)
                        PROGRESS.setExteriorScore('sequence','showMPH',1,'>')
                        P.modeData.subMode='mph'
                        playBgm('blox')
                        P:setSequenceGen('messy','-clearData')
                        P.settings.nextSlot=0

                    -- Bag
                    elseif P.hand.name=='S' or P.hand.name=='Z' then
                        T.set(P,'sequence_flood',true)
                        P.modeData.subMode='flood'
                        playBgm('reason')
                        P:setSequenceGen('bag7p6_flood','-clearData')
                    elseif P.hand.name=='J' or P.hand.name=='L' then
                        T.set(P,'sequence_drought',true)
                        P.modeData.subMode='drought'
                        playBgm('reason')
                        P:setSequenceGen('bag7p7m2_drought','-clearData')
                    elseif P.hand.name=='T' then
                        T.set(P,'sequence_saw',true)
                        P.modeData.subMode='saw'
                        playBgm('reason')
                        P:setSequenceGen('bag3_saw','-clearData')
                    elseif P.hand.name=='O' then
                        T.set(P,'sequence_rect',true)
                        P.modeData.subMode='rect'
                        playBgm('reason')
                        P:setSequenceGen('bag4_rect','-clearData')
                    elseif P.hand.name=='I' then
                        T.set(P,'sequence_rain',true)
                        P.modeData.subMode='rain'
                        playBgm('race')
                        P:setSequenceGen('bag3_sea','-clearData')

                    -- Pento
                    elseif MATH.between(P.hand.shape,8,25) then
                        T.set(P,'sequence_pento',true)
                        T.setTitle(P,'sequence_pento','modeTask_sequence_pento_title','modeTask_sequence_pento_desc')
                        PROGRESS.setExteriorScore('sequence','showPento',1,'>')
                        P.modeData.subMode='pento'
                        playBgm('beat5th')
                        P:setSequenceGen(sequence_pento_arc,'-clearData -clearNext')
                        P.settings.holdSlot=1
                    end

                    if P.modeData.subMode then
                        if P.modeData.subMode=='pento' then
                            P.modeData.target.line=100
                            P.modeData.music.s,P.modeData.music.e=40,70
                        end
                        P.stat.line=0
                        P.settings.dropDelay=1000
                        P.settings.lockDelay=1000
                        mechLib.common.music.set(P,{path='stat.line',s=10,e=30},'afterClear')
                        if #P.field._matrix>3 then
                            P.modeData.initTimer=1260
                            P.settings.spawnDelay=1e99
                            P:addEvent('always',cutField_event_always)
                        else
                            P.timing=true
                        end
                        P:addEvent('drawOnPlayer',mechLib.brik.misc.lineClear_event_drawOnPlayer)
                        return true
                    end
                end,
                mechLib.brik.misc.lineClear_event_afterClear,
            },
            gameOver=function(P,reason)
                if reason=='AC' then
                    PROGRESS.setExteriorScore('sequence',P.modeData.subMode,P.gameTime,'<')

                    local count=0
                    for _,v in next,{'mph','flood','drought','saw','rect','rain'} do
                        if PROGRESS.getExteriorModeScore('sequence',v) then count=count+1 end
                    end
                    if count>=5 then PROGRESS.setExteriorScore('sequence','showPento',1,'>') end
                end
            end
        },
    }},
}
