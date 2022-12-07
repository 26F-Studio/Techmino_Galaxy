local levels={
    {drop=1000,lock=1000,spawn=150},
    {drop=730, lock=1000,spawn=150},
    {drop=533, lock=1000,spawn=150},
    {drop=389, lock=1000,spawn=150},
    {drop=284, lock=1000,spawn=150},
    {drop=207, lock=800 ,spawn=130},
    {drop=151, lock=800 ,spawn=130},
    {drop=110, lock=800 ,spawn=130},
    {drop=81,  lock=800 ,spawn=130},
    {drop=59,  lock=800 ,spawn=130},
    {drop=43,  lock=700 ,spawn=110},
    {drop=31,  lock=700 ,spawn=110},
    {drop=23,  lock=700 ,spawn=110},
    {drop=17,  lock=700 ,spawn=110},
    {drop=12,  lock=700 ,spawn=110},
    {drop=9,   lock=600 ,spawn=90 },
    {drop=7,   lock=600 ,spawn=90 },
    {drop=5,   lock=600 ,spawn=90 },
    {drop=3,   lock=600 ,spawn=90 },
    {drop=2,   lock=600 ,spawn=90 },
    {drop=0,   lock=590 ,spawn=75 },
    {drop=0,   lock=580 ,spawn=75 },
    {drop=0,   lock=570 ,spawn=75 },
    {drop=0,   lock=560 ,spawn=75 },
    {drop=0,   lock=550 ,spawn=75 },
    {drop=0,   lock=540 ,spawn=70 },
    {drop=0,   lock=530 ,spawn=70 },
    {drop=0,   lock=520 ,spawn=70 },
    {drop=0,   lock=510 ,spawn=70 },
    {drop=0,   lock=500 ,spawn=70 },
}
local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('propel','base')
    end,
    settings={mino={
        das=120,
        arr=16,
        sdarr=16,
        spawnDelay=130,
        clearDelay=300,
        event={
            playerInit=function(P)
                P.settings.dropDelay=levels[1].drop
                P.settings.lockDelay=levels[1].lock
                P.settings.spawnDelay=levels[1].spawn
                P.modeData.line=0
                P.modeData.target=10
                P.modeData.level=1
                P.modeData.levelStartTime=0
                P.modeData.levelPieces=0
            end,
            afterLock=function(P)
                P.modeData.levelPieces=P.modeData.levelPieces+1
            end,
            afterClear=function(P)
                P.modeData.line=math.min(P.modeData.line+P.clearHistory[#P.clearHistory].line,200)
                if P.modeData.line>=P.modeData.target then
                    if P.modeData.target<200 then
                        local autoLevel=P.modeData.level
                        local averagePieceTime=(P.gameTime-P.modeData.levelStartTime-P.settings.clearDelay*3)/P.modeData.levelPieces-P.settings.spawnDelay
                        while 1/(levels[autoLevel].drop*15)<averagePieceTime do
                            autoLevel=autoLevel+1
                        end
                        P.modeData.level=math.min(math.max(P.modeData.level+1,math.min(P.modeData.level+5,autoLevel-5)),30)
                        P.settings.dropDelay=levels[P.modeData.level].drop
                        P.settings.lockDelay=levels[P.modeData.level].lock
                        P.settings.spawnDelay=levels[P.modeData.level].spawn

                        P.modeData.target=P.modeData.target+10
                        P.modeData.levelPieces=0
                        P.modeData.levelStartTime=P.gameTime

                        if P.isMain then
                            BGM.set(bgmList['propel'].add,'volume',math.min(P.modeData.level/15,1)^2)
                        end
                        P:playSound('reach')
                    else
                        P:finish('AC')
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.line,-300,-100)
                gc.rectangle('fill',-380,-2,160,4)
                GC.mStr(P.modeData.target,-300,10)
                FONT.set(30,'bold')
                gc.setColor(P.modeData.level<=10 and COLOR.G or P.modeData.level<=20 and COLOR.Y or COLOR.R)
                GC.mStr(P.modeData.level,-300,100)
            end,
        },
    }},
}
