local gc=love.graphics
local bgmTransBegin,bgmTransFinish=100,500
local levels={
    {lock=520,fresh=4400,spawn=150,clear=380,das=130,arr=29},
    {lock=450,fresh=4200,spawn=140,clear=340,das=120,arr=28},
    {lock=380,fresh=4000,spawn=130,clear=300,das=110,arr=27},
    {lock=320,fresh=3800,spawn=120,clear=260,das=105,arr=26},
    {lock=270,fresh=3600,spawn=110,clear=220,das=100,arr=25},
    {lock=230,fresh=3400,spawn=100,clear=180,das=96, arr=24},
    {lock=200,fresh=3200,spawn=95, clear=160,das=92, arr=23},
    {lock=180,fresh=3000,spawn=90, clear=140,das=88, arr=22},
    {lock=170,fresh=2800,spawn=85, clear=120,das=84, arr=21},
    {lock=160,fresh=2600,spawn=80, clear=100,das=80, arr=20},
}

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret7th','base')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                P.modeData.point=0
                P.modeData.level=1
                P.modeData.target=100
                P.modeData.storedDas=P.settings.das
                P.modeData.storedArr=P.settings.arr

                P.settings.dropDelay=0
                P.settings.das=math.max(P.modeData.storedDas,levels[1].das)
                P.settings.arr=math.max(P.modeData.storedArr,levels[1].arr)
                P.settings.lockDelay=levels[1].lock
                P.settings.spawnDelay=levels[1].spawn
                P.settings.clearDelay=levels[1].clear
                P.settings.maxFreshTime=levels[1].fresh
            end,
            afterSpawn=function(P)
                local md=P.modeData

                if md.point<md.target-1 then
                    md.point=md.point+1
                    if md.point==md.target-1 then
                        P:playSound('notice')
                    end
                end
                if P.modeData.point>bgmTransBegin and P.modeData.point<bgmTransFinish+10 and P.isMain then
                    BGM.set(bgmList['secret7th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
                end
            end,
            afterClear=function(P)
                local md=P.modeData
                local dScore=math.floor((P.clearHistory[#P.clearHistory].line+1)^2/4)
                md.point=md.point+dScore
                if md.point==md.target-1 then
                    P:playSound('notice')
                elseif md.point>=md.target then
                    if md.level<10 then
                        P:playSound('reach')
                        md.level=md.level+1
                        md.target=100*md.level
                        P.settings.das=math.max(P.modeData.storedDas,levels[md.level].das)
                        P.settings.arr=math.max(P.modeData.storedArr,levels[md.level].arr)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
                        P.settings.clearDelay=levels[md.level].clear
                        P.settings.maxFreshTime=levels[md.level].fresh
                    else
                        P:finish('AC')
                    end
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(P.modeData.point,-300,-100)
                gc.rectangle('fill',-380,-2,160,4)
                GC.mStr(P.modeData.target,-300,10)
            end,
        },
    }},
}