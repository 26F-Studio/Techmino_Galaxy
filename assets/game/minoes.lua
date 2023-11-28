local Mino={}


---@type table<any, Techmino.Mino>
local minoes={}

function Mino.registerMino(name,id,shape)
    local mino={name=name,id=id,shape=shape}
    assert(not minoes[name],("Mino name '$1' duplicated"):repD(name))
    assert(not minoes[id],("Mino '$1' duplicated"):repD(id))
    minoes[name]=mino
    minoes[id]=mino
end
do
    local reg=Mino.registerMino
    local O,_=true,false

    -- Tetromino
    reg('Z',  1,  {{_,O,O},{O,O,_}})
    reg('S',  2,  {{O,O,_},{_,O,O}})
    reg('J',  3,  {{O,O,O},{O,_,_}})
    reg('L',  4,  {{O,O,O},{_,_,O}})
    reg('T',  5,  {{O,O,O},{_,O,_}})
    reg('O',  6,  {{O,O},{O,O}})
    reg('I',  7,  {{O,O,O,O}})

    -- Pentomino
    reg('Z5', 8,  {{_,O,O},{_,O,_},{O,O,_}})
    reg('S5', 9,  {{O,O,_},{_,O,_},{_,O,O}})
    reg('P',  10, {{O,O,O},{O,O,_}})
    reg('Q',  11, {{O,O,O},{_,O,O}})
    reg('F',  12, {{_,O,_},{O,O,O},{O,_,_}})
    reg('E',  13, {{_,O,_},{O,O,O},{_,_,O}})
    reg('T5', 14, {{O,O,O},{_,O,_},{_,O,_}})
    reg('U',  15, {{O,O,O},{O,_,O}})
    reg('V',  16, {{O,O,O},{_,_,O},{_,_,O}})
    reg('W',  17, {{_,O,O},{O,O,_},{O,_,_}})
    reg('X',  18, {{_,O,_},{O,O,O},{_,O,_}})
    reg('J5', 19, {{O,O,O,O},{O,_,_,_}})
    reg('L5', 20, {{O,O,O,O},{_,_,_,O}})
    reg('R',  21, {{O,O,O,O},{_,O,_,_}})
    reg('Y',  22, {{O,O,O,O},{_,_,O,_}})
    reg('N',  23, {{_,O,O,O},{O,O,_,_}})
    reg('H',  24, {{O,O,O,_},{_,_,O,O}})
    reg('I5', 25, {{O,O,O,O,O}})

    -- Trimino
    reg('I3', 26, {{O,O,O}})
    reg('C',  27, {{O,O},{_,O}})

    -- Domino
    reg('I2', 28, {{O,O}})

    -- Dot
    reg('O1', 29, {{O}})
end

---@param id Techmino.Mino.ID|Techmino.Mino.Name
---@return Techmino.Mino
function Mino.get(id) return assert(minoes[id],("Mino '$1' not found"):repD(id)) end
---@param id number|string
function Mino.getName(id) return Mino.get(id).name end
---@param id number|string
function Mino.getID(id) return Mino.get(id).id end
---@param id number|string
function Mino.getShape(id) return Mino.get(id).shape end

---@param shape Techmino.Mino.Shape
---@return number
function Mino._size(shape)
    return #shape+#shape[1]
end

---@param shape Techmino.Mino.Shape
---@return number,string
function Mino._binarize(shape)
    local pNum,pStr=0,""

    local byte=0
    local n1,n2=1,1
    local x,y=1,0
    local h,w=#shape,#shape[1]
    while true do
        x,y=x-1,y+1
        if x<1 or y>h then
            if x+y==w+h then break end
            x,y=x+y,1
        end
        if x<=w and y<=h then
            if shape[y][x] then
                -- print(x,y,n)
                byte=byte+n1
                pNum=pNum+n2
            end
        end
        n1=n1*2
        n2=n2*2
        if n1>128 then
            pStr=string.char(byte)..pStr
            byte=0
            n1=1
        end
    end
    if byte>0 then
        pStr=string.char(byte)..pStr
        print(pStr:byte())
    end
    return pNum,pStr
end

local function pieceComp(a,b)
    if #a==#b then
        return a<b
    else
        return #a<#b
    end
end

---@param piece Techmino.Mino.Shape
---@return number,string
function Mino.shapeToID(piece)
    local minNum,minStr=Mino._binarize(piece)
    for _=1,3 do
        piece=TABLE.rotate(piece,'R')
        local num,str=Mino._binarize(piece)
        if pieceComp(str,minStr) then minNum,minStr=num,str end
    end
    return minNum,minStr
end

---@param a Techmino.Mino.Shape
---@param b Techmino.Mino.Shape
---@return boolean
function Mino.samePiece(a,b)
    return Mino.shapeToID(a)==Mino.shapeToID(b)
end

return Mino
