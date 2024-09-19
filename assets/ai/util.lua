local rem=table.remove

local Util={}

---@param field Mat<boolean> Field (read)
---@overload fun(field:Mat<boolean>, cx:number): number
---@return number[]
function Util.getColumnHeight(field,cx)
    if cx then
        local y=#field
        while y>0 and not field[y][cx] do y=y-1 end
        return y
    else
        local width=field[1] and #field[1] or 10
        local fieldTop={}
        for x=1,width do
            local y=#field
            while y>0 and not field[y][x] do y=y-1 end
            fieldTop[x]=y
        end
        return fieldTop
    end
end

---@param field Mat<boolean> Field (read)
---@param shape Mat<boolean>
---@param X number
---@return number Y, number[] colH the height of the piece if only check collision with this column
function Util.simulateDrop(field,shape,X)
    local w=#shape[1]
    local shapeBottom,fieldTop={},{}
    for x=1,w do
        local y=0
        while y+1<=#shape and not shape[y+1][x] do y=y+1 end
        shapeBottom[x]=y

        y=#field
        while y>0 and not field[y][X+x-1] do y=y-1 end
        fieldTop[x]=y
    end
    local colH={}
    for i=1,w do
        colH[i]=fieldTop[i]-shapeBottom[i]
    end
    return math.max(unpack(colH))+1,colH
end

---@param field Mat<boolean> Field (write)
---@param shape Mat<boolean>
---@param X number
---@param Y? number
function Util.lockPiece(field,shape,X,Y)
    if not Y then
        Y=Util.simulateDrop(field,shape,X)
    end
    local width=field[1] and #field[1] or 10
    for y=1,#shape do
        if not field[y+Y-1] then
            field[y+Y-1]=TABLE.new(false,width)
        end
        for x=1,#shape[1] do
            field[y+Y-1][x+X-1]=field[y+Y-1][x+X-1] or shape[y][x]
        end
    end
end

---@param field Mat<boolean> Field (write)
---@param startY? number
---@param endY? number
function Util.clearLine(field,startY,endY)
    local width=field[1] and #field[1] or 10

    local clear=0

    for y=endY or #field,startY or 1,-1 do
        if field[y] then
            local full=true
            for x=1,width do
                if not field[y][x] then
                    full=false
                    break
                end
            end
            if full then
                rem(field,y)
                clear=clear+1
            end
        end
    end

    return clear
end

return Util
