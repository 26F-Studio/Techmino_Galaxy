local gc=love.graphics

local F={}
setmetatable(F,{__index=require'assets.player.basePlayer'})

--------------------------------------------------------------
-- Methods
function F:getNewLine(v)
    return TABLE.new(v or false,self.width)
end
function F:export_string_simp()
    local str=''

    for y=1,#self.matrix do
        local buf=''
        for x=1,#self.width do
            buf=buf..(self.matrix[y][x] and 'x' or '_')
        end
        str=str..buf..'/'
    end

    return str
end
function F:export_string_color()
    local str=''

    for y=1,#self.matrix do
        local buf=''
        for x=1,#self.width do
            buf=buf..STRING.base64(self.matrix[y][x].color)
        end
        str=str..buf..'/'
    end

    return str
end
function F:export_fumen()
    local str=''

    -- TODO, but anyone interested? I won't
    error('Not implemented yet')

    return str
end
function F:drawThumbnail_simp(step,size)
    if not step then step=40 end
    if not size then size=step end
    local f=self.matrix
    for y=1,#f do
        for x=1,self.width do
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
    local f=self.matrix
    for y=1,#f do
        for x=1,self.width do
            local c=f[y][x]
            if c then
                gc.setColor(ColorTable[c.color])
                gc.rectangle('fill',(x-1)*step,-y*step,size,size)
            end
        end
    end
end
--------------------------------------------------------------
-- Builder
local voidLine=setmetatable({},{__index=function() return false end,__newindex=NULL})
local _fieldMeta={__index=function(self,k)
    if type(k)=='number' then
        if k<=1260 then
            for i=#self+1,k do
                self[i]=self._f:getNewLine(false)
            end
            return self[k]
        else
            return voidLine
        end
    else
        error(STRING.repD("Invalid field index type '$1'",type(k)))
    end
end}
function F.new(width,height)
    assert(type(width)=='number' and type(height)=='number','[Field].new(width,height): width and height must be number')
    local f={
        width=width,
        height=height,-- Attention: this height is not the limit of actual field's height
        matrix=setmetatable({},_fieldMeta),
    }
    f.matrix._f=f
    setmetatable(f,{__index=F})

    return f
end
--------------------------------------------------------------

return F
