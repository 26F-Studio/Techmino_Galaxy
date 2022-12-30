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
        seqType=function(P)-- bag7 with extra 3 S pieces and 3 Z pieces
            local l={}
            while true do
                if not l[1] then
                    for i=1,7 do l[i]=i end
                    l[8],l[9],l[10]=1,1,1
                    l[11],l[12],l[13]=2,2,2
                end
                coroutine.yield(table.remove(l,P.seqRND:random(#l)))
            end
        end,
        event={
            playerInit=function(P)
                P.modeData.line=0
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
                if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                    BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                end
            end,
            drawInField=function(P)
                gc.setColor(1,1,1,.26)
                gc.rectangle('fill',0,(P.modeData.line-lineTarget)*40-2,P.settings.fieldW*40,4)
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
