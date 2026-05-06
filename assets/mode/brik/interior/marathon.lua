local gc=love.graphics
local dropSpeed={1000,833,666,500,400,300,200,150,100,70,50,30,22,16,12,8,7,6,5,4}

---@type Techmino.Mode
return {
    initialize=function()
        GAME.newPlayer(1,'brik')
        GAME.setMain(1)
        PlayBGM('push')
    end,
    settings={brik={
        skin='brik_interior',
        clearMovement='teleBack',
        particles=false,
        spawnDelay=130,
        clearDelay=300,
        deathDelay=0,
        soundEvent={
            countDown=mechLib.brik.misc.interior_soundEvent_countDown,
            drop=GameSndFunc.drop_old,
        },
        event={
            playerInit=function(P)
                P.settings.asd=math.max(P.settings.asd,100)
                P.settings.asp=math.max(P.settings.asp,20)

                P.settings.dropDelay=dropSpeed[1]
                P.modeData.lineTarget=10
            end,
            beforePress=mechLib.brik.misc.skipReadyWithHardDrop_beforePress,
            afterClear=function(P)
                local md=P.modeData
                while P.stat.line>=md.lineTarget do
                    if md.lineTarget<200 then
                        if P.isMain and PROGRESS.get('main')>=2 and md.lineTarget<=150 then
                            FMOD.music.setParam('intensity',(md.lineTarget/150)^2)
                        end
                        P.settings.dropDelay=dropSpeed[md.lineTarget/10+1]
                        md.lineTarget=md.lineTarget+10
                        P:playSound('beep_rise')
                    else
                        -- TODO
                        P.stat.line=200
                        P:finish('win')
                        return
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(70)
                GC.mStr(P.stat.line,-300,-90)
                gc.rectangle('fill',-375,-2,150,4)
                GC.mStr(P.modeData.lineTarget,-300,-5)
            end,
        },
    }},
    result=function()
        local P=GAME.mainPlayer
        if not P then return end
        PROGRESS.setInteriorScore('sprint',MATH.clamp(P.stat.line*4/3,0,40))
        PROGRESS.setInteriorScore('marathon',MATH.lLerp({0,40,90,120,160},MATH.ilLerp({0,40,80,130,200},P.stat.line)))
    end,
    resultPage=function(time)
        local P=GAME.mainPlayer
        if not P then return end

        local line=math.min(P.stat.line,math.floor(math.max(time-.26,0)*162),200)

        -- XX/200
        FONT.set(100)
        GC.setColor(COLOR.L)
        GC.mStr(line.." / 200",800,350)

        -- Bar frame
        GC.setLineWidth(6)
        GC.rectangle('line',800-400-15,550-50-15,800+30,100+30)

        -- Filling bar
        GC.setColor(.2,.4,1,.8)
        GC.rectangle('fill',800-400,550-50,math.floor(line/10)*10/200*800,100)
    end,
}
