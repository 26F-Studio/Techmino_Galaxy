local Brik={}

---@alias Techmino.Brik.Shape Mat<boolean>
---@alias Techmino.Brik.Name 'Z' | 'S' | 'J' | 'L' | 'T' | 'O' | 'I' | 'Z5' | 'S5' | 'P' | 'Q' | 'F' | 'E' | 'T5' | 'U' | 'V' | 'W' | 'X' | 'J5' | 'L5' | 'R' | 'Y' | 'N' | 'H' | 'I5' | 'I3' | 'C' | 'I2' | 'O1' | string
---@alias Techmino.Brik.ID integer

---@class Techmino.Brik
---@field name Techmino.Brik.Name
---@field id Techmino.Brik.ID
---@field shape Techmino.Brik.Shape

---@type Map<Techmino.Brik>
local briks={}

function Brik.registerBrik(name,id,shape)
    local brik={name=name,id=id,shape=shape}
    assert(not briks[name],("Brik name '$1' duplicated"):repD(name))
    assert(not briks[id],("Brik '$1' duplicated"):repD(id))
    briks[name]=brik
    briks[id]=brik
end
do
    local reg=Brik.registerBrik
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

---@param id Techmino.Brik.ID | Techmino.Brik.Name
---@return Techmino.Brik
function Brik.get(id) return assert(briks[id],("Brik '$1' not found"):repD(id)) end
---@param id Techmino.Brik.Name | Techmino.Brik.ID
function Brik.getName(id) return Brik.get(id).name end
---@param id Techmino.Brik.Name | Techmino.Brik.ID
function Brik.getID(id) return Brik.get(id).id end
---@param id Techmino.Brik.Name | Techmino.Brik.ID
function Brik.getShape(id) return Brik.get(id).shape end

---@param shape Techmino.Brik.Shape
---@return number
function Brik._size(shape)
    return #shape+#shape[1]
end

---@param shape Techmino.Brik.Shape
---@return number,string
function Brik._binarize(shape)
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

---@param piece Techmino.Brik.Shape
---@return number,string
function Brik.shapeToID(piece)
    local minNum,minStr=Brik._binarize(piece)
    for _=1,3 do
        piece=TABLE.rotate(piece,'R')
        local num,str=Brik._binarize(piece)
        if pieceComp(str,minStr) then minNum,minStr=num,str end
    end
    return minNum,minStr
end

---@param a Techmino.Brik.Shape
---@param b Techmino.Brik.Shape
---@return boolean
function Brik.samePiece(a,b)
    return Brik.shapeToID(a)==Brik.shapeToID(b)
end

return Brik
