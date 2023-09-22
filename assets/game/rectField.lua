local gc=love.graphics

--- @class Techmino.RectField
local F={}

--------------------------------------------------------------
-- Methods
function F:removeLine(h)
    table.remove(self._matrix,h)
end
function F:fresh()
    for y=#self._matrix,1,-1 do
        for i=1,#self._matrix[y] do
            if self._matrix[y][i] then return end
        end
        self:removeLine(y)
    end
end
function F:export_table_simp()
    local t={}

    for y=1,#self._matrix do
        t[y]={}
        for x=1,self._width do
            t[y][x]=self._matrix[y][x] and true or false
        end
    end

    return t
end
function F:export_string_simp()
    local str=''

    for y=1,#self._matrix do
        local buf=''
        for x=1,self._width do
            buf=buf..(self._matrix[y][x] and 'x' or '_')
        end
        str=str..buf..'/'
    end

    return str
end
function F:export_string_color()
    local str=''

    for y=1,#self._matrix do
        local buf=''
        for x=1,self._width do
            buf=buf..STRING.base64[self._matrix[y][x].color]
        end
        str=str..buf..'/'
    end

    return str
end
function F:export_fumen()
    local str=''

    -- Anyone interested? I don't
    error("Not implemented yet")

    return str
end
function F:drawThumbnail_simp(step,size)
    if not step then step=40 end
    if not size then size=step end
    local f=self._matrix
    for y=1,#f do
        for x=1,self._width do
            local c=f[y][x]
            if c then
                gc.rectangle('fill',(x-1)*step,-y*step,size,size)
            end
        end
    end
end
function F:drawThumbnail_color(step,size)
    if not step then step=40 end
    if not size then size=step end
    local f=self._matrix
    for y=1,#f do
        for x=1,self._width do
            local c=f[y][x]
            if c then
                gc.setColor(ColorTable[c.color])
                gc.rectangle('fill',(x-1)*step,-y*step,size,size)
            end
        end
    end
end

--- @return number
function F:getHeight()
    return #self._matrix
end

local wallCell=setmetatable({},{__newIndex=NULL,__metatable=true})
--- @return Techmino.Cell|false
function F:getCell(x,y)
    if x<=0 or x>self._width or y<=0 then return wallCell end
    if y>#self._matrix then return false end
    local line=rawget(self._matrix,y)
    return line and line[x] or false
end
function F:setCell(cell,x,y)
    if not self._matrix[y] then
        if y<=1260 then
            for i=#self._matrix+1,y do
                self._matrix[i]=TABLE.new(false,self._width)
            end
        else
            return-- Too high, do nothing
        end
    end
    self._matrix[y][x]=cell
end
--------------------------------------------------------------
-- Builder
function F.new(width)
    assert(type(width)=='number','[Field].new(width): width must be number')
    local f={
        _width=width,
        _matrix={},
    }
    f._matrix=f
    setmetatable(f,{__index=F,__metatable=true})

    return f
end
--------------------------------------------------------------

return F
