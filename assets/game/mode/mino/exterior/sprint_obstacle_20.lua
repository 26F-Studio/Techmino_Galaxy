local gc=love.graphics
local lineTarget=20
local bgmTransBegin,bgmTransFinish=5,10
local minDist=3
local maxHeight=3
local extraCount=3

local function generateField(P)
    local F=P.field
    local w=P.settings.fieldW
    local r0,r1=0
    TABLE.cut(F._matrix)
    for y=1,maxHeight do
        F._matrix[y]=TABLE.new(false,w)
        repeat
            r1=P:random(1,w)
        until math.abs(r1-r0)>=minDist;
        F._matrix[y][r1]={color=0,conn={}}
        r0=r1
    end
    for _=1,extraCount do
        local x,y
        repeat
            x=P:random(1,w)
            y=math.floor(P:random()^2.6*(maxHeight-1))+1
        until not F._matrix[y][x]
        F._matrix[y][x]={color=0,conn={}}
    end
    for y=1,maxHeight do
        if TABLE.count(F._matrix[y],false)==w then
            F._matrix[y][P:random(1,w)]=false
        end
    end
end

return {
    initialize=function()
        GAME.newPlayer(1,'mino')
        GAME.setMain(1)
        playBgm('race','base')
    end,
    settings={mino={
        event={
            playerInit={
                mechLib.mino.statistics.event_playerInit,
                generateField,
            },
            afterClear={
                function(P,clear)
                    local score=math.ceil((clear.line+1)/2)
                    P.modeData.line=math.min(P.modeData.line+score,lineTarget)
                    P.texts:add{
                        text="+"..score,
                        fontSize=80,
                        a=.626,
                        duration=.626,
                        inPoint=0,
                        outPoint=1,
                    }
                    generateField(P)
                end,
                mechLib.mino.sprint.event_afterClear[20],
                function(P)
                    if P.modeData.line>bgmTransBegin and P.modeData.line<bgmTransFinish+4 and P.isMain then
                        BGM.set(bgmList['race'].add,'volume',math.min((P.modeData.line-bgmTransBegin)/(bgmTransFinish-bgmTransBegin),1),2.6)
                    end
                end,
            },
            drawInField=mechLib.mino.sprint.event_drawInField[20],
            drawOnPlayer=mechLib.mino.sprint.event_drawOnPlayer[20],
        },
    }},
}
