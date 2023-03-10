local bgmTransBegin,bgmTransFinish=100,300
local levels={
    {lock=1e3,spawn=320,das=200,arr=36},
    {lock=850,spawn=290,das=170,arr=32},
    {lock=700,spawn=260,das=140,arr=28},
    {lock=550,spawn=230,das=120,arr=24},
    {lock=400,spawn=200,das=100,arr=20},
}
local gc=love.graphics

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('secret8th','base')
    end,
    settings={mino={
        spawnDelay=150,
        clearDelay=300,
        event={
            playerInit=function(P)
                P.modeData.storedDas=P.settings.das
                P.modeData.storedArr=P.settings.arr

                P.settings.dropDelay=0
                P.settings.das=math.max(P.modeData.storedDas,levels[1].das)
                P.settings.arr=math.max(P.modeData.storedArr,levels[1].arr)
                P.settings.lockDelay=levels[1].lock
                P.settings.spawnDelay=levels[1].spawn

                P.modeData.point=0
                P.modeData.level=1
                P.modeData.target=100
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
                    BGM.set(bgmList['secret8th'].add,'volume',math.min((P.modeData.point-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),1)
                end
            end,
            afterClear=function(P)
                local md=P.modeData
                local dScore=math.floor((P.clearHistory[#P.clearHistory].line+1)^2/4)
                md.point=md.point+dScore
                if md.point==md.target-1 then
                    P:playSound('notice')
                elseif md.point>=md.target then
                    if md.level<5 then
                        P:playSound('reach')
                        md.level=md.level+1
                        md.target=100*md.level
                        P.settings.das=math.max(P.modeData.storedDas,levels[md.level].das)
                        P.settings.arr=math.max(P.modeData.storedArr,levels[md.level].arr)
                        P.settings.lockDelay=levels[md.level].lock
                        P.settings.spawnDelay=levels[md.level].spawn
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
