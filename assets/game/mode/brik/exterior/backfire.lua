---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        playBgm('echo')
    end,
    settings={brik={
        dropDelay=1000,
        lockDelay=1000,
        readyDelay=0,
        atkSys='nextgen',
        allowCancel=true,
        allowBlock=true,
        event={
            playerInit=function(P)
                P.modeData.target.line=100
                mechLib.common.music.set(P,{path='.stat.line',s=40,e=75},'afterClear')
            end,
            gameStart=function(P) P.timing=false end,
            afterClear=function(P,clear)
                -- TODO: balance
                if clear.line==1 then
                    P.modeData.subMode='cheese'
                    P.settings.dropDelay=1000
                    P.settings.maxFreshChance=15
                    P.settings.maxFreshTime=6200
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_storePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_break_event_beforeSend)
                    playBgm('shift')
                elseif clear.line<=3 then
                    P.modeData.subMode='normal'
                    P.settings.dropDelay=620
                    P.settings.maxFreshChance=12
                    P.settings.maxFreshTime=4200
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_storePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_normal_event_beforeSend)
                    playBgm('storm')
                else
                    P.modeData.subMode='amplify'
                    P.settings.dropDelay=260
                    P.settings.maxFreshChance=10
                    P.settings.maxFreshTime=2600
                    P:addEvent('beforeCancel',mechLib.brik.survivor.backfire_triplePower_event_beforeCancel)
                    P:addEvent('beforeSend',mechLib.brik.survivor.backfire_easy_event_beforeSend)
                    playBgm('supercritical')
                end

                if P.modeData.subMode then
                    P.timing=true
                    P:addEvent('afterClear',mechLib.brik.misc.lineClear_event_afterClear)
                    return true
                end
        end,
            gameOver=function(P)
                if P.modeData.subMode and P.modeData.stat.line>=100 then
                    PROGRESS.setExteriorScore('backfire',P.modeData.subMode,P.gameTime,'<')
                end
            end,
            drawOnPlayer=mechLib.brik.misc.lineClear_event_drawOnPlayer,
        },
    }},
}
