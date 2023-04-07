local gc=love.graphics
local lineTarget=40
local bgmTransBegin,bgmTransFinish=10,30

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        dropDelay=20,
        lockDelay=2600,
        das=126,
        arr=26,
        freshCount=1e99,
        event={
            playerInit=function(P)
                P.modeData.line=0
                P.modeData.windTargetStrength=(P:random()<.5 and -1 or 1)*P:random(1260,1600)
                P.modeData.windStrength=0
                P.modeData.windCounter=0

                P.modeData.invertTimes={}
                for i=1,P:random(4,6) do
                    P.modeData.invertTimes[i]=P:random(2,38)
                end
                table.sort(P.modeData.invertTimes)
            end,
            always=function(P)
                if not P.timing then return end
                local md=P.modeData
                md.windStrength=md.windStrength+MATH.sign(md.windTargetStrength-md.windStrength)
                md.windCounter=md.windCounter+md.windStrength
                if math.abs(md.windCounter)>=62000 then
                    if P.hand then
                        P[md.windCounter<0 and 'moveLeft' or 'moveRight'](P)
                    end
                    md.windCounter=md.windCounter-MATH.sign(md.windCounter)*62000
                end
            end,
            afterClear=function(P,clear)
                local md=P.modeData
                md.line=math.min(md.line+clear.line,lineTarget)
                if #md.invertTimes>0 and md.line>md.invertTimes[1] then
                    while #md.invertTimes>0 and md.line>md.invertTimes[1] do
                        table.remove(md.invertTimes,1)
                    end
                    md.windTargetStrength=-MATH.sign(md.windTargetStrength)*P:random(1260,1600)
                end
                if md.line>=lineTarget then
                    P:finish('AC')
                end
                if md.line>bgmTransBegin and md.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((md.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-lineTarget)*40-2,P.settings.fieldW*40,4)

                gc.setLineWidth(4)
                gc.setColor(1,.626,.626,.626)
                gc.circle('fill',P.settings.fieldW*(20+P.modeData.windStrength/100),-400,P.modeData.windStrength/60,6)
                gc.setLineWidth(8)
                gc.setColor(1,.942,.942,.42)
                gc.line(P.settings.fieldW*20,-400,P.settings.fieldW*(20+P.modeData.windStrength/100),-400)
            end,
            drawOnPlayer=function(P)
                P:drawInfoPanel(-380,-60,160,120)
                FONT.set(80) GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
