local gc=love.graphics
local min,max=math.min,math.max

---@type Techmino.Mech.mino
local marathon={}

local levels={-- par: drop interval
    {drop=1000,lock=1000,spawn=150, par=999},
    {drop=730, lock=1000,spawn=150, par=909},
    {drop=533, lock=1000,spawn=150, par=833},
    {drop=389, lock=1000,spawn=150, par=714},
    {drop=284, lock=1000,spawn=150, par=666},
    {drop=207, lock=800 ,spawn=130, par=625},
    {drop=151, lock=800 ,spawn=130, par=588},
    {drop=110, lock=800 ,spawn=130, par=555},
    {drop=81,  lock=800 ,spawn=130, par=526},
    {drop=59,  lock=800 ,spawn=130, par=500},
    {drop=43,  lock=700 ,spawn=110, par=454},
    {drop=31,  lock=700 ,spawn=110, par=416},
    {drop=23,  lock=700 ,spawn=110, par=384},
    {drop=17,  lock=700 ,spawn=110, par=357},
    {drop=12,  lock=700 ,spawn=110, par=333},
    {drop=9,   lock=600 ,spawn=90,  par=312},
    {drop=7,   lock=580 ,spawn=90,  par=294},
    {drop=5,   lock=560 ,spawn=90,  par=277},
    {drop=3,   lock=540 ,spawn=90,  par=263},
    {drop=2,   lock=520 ,spawn=90,  par=250},
    {drop=0,   lock=500 ,spawn=75,  par=238},
    {drop=0,   lock=480 ,spawn=75,  par=227},
    {drop=0,   lock=460 ,spawn=75,  par=217},
    {drop=0,   lock=440 ,spawn=75,  par=200},
    {drop=0,   lock=420 ,spawn=75,  par=189},
    {drop=0,   lock=400 ,spawn=70,  par=179},
    {drop=0,   lock=380 ,spawn=70,  par=169},
    {drop=0,   lock=360 ,spawn=70,  par=161},
    {drop=0,   lock=340 ,spawn=70,  par=154},
    {drop=0,   lock=320 ,spawn=70,  par=143},
}

function marathon.event_playerInit_auto(P)
    marathon.event_playerInit(P)
    P:addEvent('afterLock',marathon.event_afterLock)
    P:addEvent('afterClear',marathon.event_afterClear)
    P:addEvent('drawOnPlayer',marathon.event_drawOnPlayer)
end
function marathon.event_playerInit(P)
    P.settings.asd=max(P.settings.asd,100)
    P.settings.asp=max(P.settings.asp,20)

    P.settings.dropDelay=levels[1].drop
    P.settings.lockDelay=levels[1].lock
    P.settings.spawnDelay=levels[1].spawn

    P.modeData.transition1=1e99
    P.modeData.transition2=1e99
    P.modeData.lineTarget=10

    P.modeData.level=1
    P.modeData.ascend=0
    P.modeData.levelStartTime=0
    P.modeData.levelPieces=0
end
function marathon.event_afterLock(P)
    P.modeData.levelPieces=P.modeData.levelPieces+1
end
function marathon.event_afterClear(P)
    local md=P.modeData
    while md.stat.line>=md.lineTarget do
        if md.lineTarget<200 then
            if md.level<30 then
                local autoLevel=md.level
                -- Ignore spawn delay, Assume clear 3 times
                local averageDropTime=(P.gameTime-md.levelStartTime-P.settings.clearDelay*3)/md.levelPieces-P.settings.spawnDelay
                while averageDropTime<levels[autoLevel].par and autoLevel<30 do
                    autoLevel=autoLevel+1
                end
                local _level=md.level
                md.level=min(max(md.level+1,min(md.level+3,autoLevel)),30)
                if _level<=10 and md.level>10 then
                    md.transition1=#P.dropHistory
                elseif _level<=20 and md.level>20 then
                    md.transition2=#P.dropHistory
                end

                P.settings.dropDelay=levels[md.level].drop
                P.settings.lockDelay=levels[md.level].lock
                P.settings.spawnDelay=levels[md.level].spawn
            else
                md.ascend=md.ascend+1
                if md.ascend>=4 then
                    P.settings.lockDelay=max(P.settings.lockDelay-40,200)
                    P.settings.spawnDelay=max(P.settings.spawnDelay-25,0)
                end
            end
            md.lineTarget=md.lineTarget+10
            md.levelPieces=0
            md.levelStartTime=P.gameTime
            P:playSound('reach')
        else
            P:finish('AC')
            return
        end
    end
end
function marathon.event_drawOnPlayer(P)
    P:drawInfoPanel(-380,-85,160,200)

    FONT.set(70)
    GC.mStr(min(P.modeData.stat.line,200),-300,-90)
    gc.rectangle('fill',-375,-2,150,4)
    GC.mStr(P.modeData.lineTarget,-300,-5)
    FONT.set(30,'bold')
    gc.setColor(P.modeData.level<=10 and COLOR.G or P.modeData.level<=20 and COLOR.Y or COLOR.R)
    GC.mStr(P.modeData.level,-300,70)
end

return marathon
