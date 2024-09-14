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

---@param F Mat<boolean> Field (read)
---@param shape Mat<boolean>
---@param X number
function paperArtist.getSimScore(F,shape,X)
    F=TABLE.copy(F,1)
    local cy,colH=simulateDrop(F,shape,X)
    lockPiece(F,shape,X,cy)
    local linesClear=clearLine(F,cy,cy+#shape-1)
    local score
    if #F==0 then
        -- Nobody can refuse AC
        score=1e99
    else
        local HBC,VBC=getBoundCount(F)
        local minH=math.min(unpack(colH))
        local totalH=MATH.sum(colH)
        local shadowCreated=totalH-minH*#colH
        score=2*linesClear-cy-shadowCreated*1.26-HBC*3-VBC*2
    end
    return score,cy
end

local rotate=TABLE.rotate
local getSimScore=paperArtist.getSimScore
local directions={'0','R','F','L'}

local floor=math.floor
local ins,rem=table.insert,table.remove

---@param F Mat<boolean> Field (read)
---@param shape Mat<boolean>
---@return {x:number, y:number, dir:string}[]
function paperArtist.search(F,shape,dirCount,bestCount)
    local posList={{
        score=-1e99,
        x=4,y=4,dir='0',
    }}
    local w=F[1] and #F[1] or 10
    for d=1,dirCount do
        for cx=1,w-#shape[1]+1 do
            local score,cy=getSimScore(F,shape,cx)

            local pos={
                score=score,
                x=cx,y=cy,dir=directions[d],
            }
            local i,j=1,#posList
            while i<=j do
                local m=floor((i+j)/2)
                if pos.score>posList[m].score then
                    j=m-1
                else
                    i=m+1
                end
            end
            ins(posList,i,pos)
            if #posList>bestCount then
                rem(posList)
            end
        end
        if d<4 then shape=rotate(shape,'R') end
    end
    return posList
end

---@param F Mat<boolean> Field (read)
---@param shape Mat<boolean>
---@return number x, number y, string dir
function paperArtist.getBestPosition(F,shape)
    local best=paperArtist.search(F,shape,4,1)[1]
    return best.x,best.y,best.dir
end

return paperArtist
