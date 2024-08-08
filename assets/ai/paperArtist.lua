local paperArtist={}

---@param F Mat<boolean> Field (read)
---@return number horizontalBoundCross, number verticalBoundCross
function paperArtist.getBoundCount(F)
    local width=F[1] and #F[1] or 10
    local HBC=-2*#F
    for y=1,#F do
        local cur=true
        for x=1,width do
            if cur~=F[y][x] then
                cur=F[y][x]
                HBC=HBC+1
            end
        end
        if cur==false then HBC=HBC+1 end
    end
    local VBC=-width
    for x=1,width do
        local cur=true
        for y=1,#F do
            if cur~=F[y][x] then
                cur=F[y][x]
                VBC=VBC+1
            end
        end
        if cur==true then VBC=VBC+1 end
    end
    return HBC,VBC
end

local simulateDrop=require'assets.ai.util'.simulateDrop
local lockPiece=require'assets.ai.util'.lockPiece
local clearLine=require'assets.ai.util'.clearLine
local getBoundCount=paperArtist.getBoundCount
local directions={'0','R','F','L'}

---@param F Mat<boolean> Field (write)
---@param shape Mat<boolean>
---@return number x, number y, string dir
function paperArtist.findPosition(F,shape)
    local best={
        score=-1e99,
        x=4,y=4,dir='0',
    }
    if not F[1] then F[1]=TABLE.new(false,10) end
    local w=#F[1]
    for d=1,4 do
        for cx=1,w-#shape[1]+1 do
            local F1=TABLE.copy(F,1)
            local cy,colH=simulateDrop(F1,shape,cx)

            lockPiece(F1,shape,cx,cy)
            local clear=clearLine(F1,cy,cy+#shape-1)
            local score
            if #F1==0 then
                -- Nobody can refuse AC
                score=1e99
            else
                local HBC,VBC=getBoundCount(F1)
                score=clear*2-HBC*3-VBC*2-cy
            end

            local minH=math.min(unpack(colH))
            for i=1,#colH do
                score=score-(colH[i]-minH)*1.26
            end

            if score>best.score then
                best.x,best.y,best.dir=cx,cy,directions[d]
                best.score=score
            end
        end
        if d<4 then shape=TABLE.rotate(shape,'R') end
    end
    return best.x,best.y,best.dir
end

return paperArtist
