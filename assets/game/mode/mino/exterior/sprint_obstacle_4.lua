local gc=love.graphics
local lineTarget=4
local maxHeight=6
local randomCount=6

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','full')
    end,
    settings={mino={
        event={
            playerInit=function(P)
                P.modeData.line=0
                local F=P.field
                local w=P.settings.fieldW
                local r0,r1=0
                for y=1,maxHeight do
                    F._matrix[y]={}
                    for x=1,w do
                        F._matrix[y][x]=false
                    end
                    repeat
                        r1=P.seqRND:random(1,w)
                    until math.abs(r1-r0)>=2;
                    F._matrix[y][r1]={color=0,nearby={}}
                    r0=r1
                end
                for _=1,randomCount do
                    local x,y
                    repeat
                        x,y=P.seqRND:random(1,w),math.floor(P.seqRND:random()^2.6*(maxHeight-1))+1
                    until not F._matrix[y][x]
                    F._matrix[y][x]={color=0,nearby={}}
                end
                for y=1,maxHeight do
                    if TABLE.count(F._matrix[y],false)==w then
                        F._matrix[y][P.seqRND:random(1,w)]=false
                    end
                end
            end,
            afterClear=function(P,movement)
                P.modeData.line=math.min(P.modeData.line+#movement.clear,lineTarget)
                if P.modeData.line>=lineTarget then
                    P:finish('AC')
                end
            end,
            drawOnPlayer=function(P)
                gc.setColor(COLOR.L)
                FONT.set(80)
                GC.mStr(lineTarget-P.modeData.line,-300,-55)
            end,
        },
    }},
}
