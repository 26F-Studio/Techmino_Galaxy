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

    for y=1,#self.array do
        local buf=''
        for x=1,#self.width do
            buf=buf..(self.array[y][x] and 'x' or '_')
        end
        str=str..buf..'/'
    end

    return str
end
function F:export_string_color()
    local str=''

    for y=1,#self.array do
        local buf=''
        for x=1,#self.width do
            buf=buf..STRING.base64(self.array[y][x].color)
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
    local f=self.array
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
    local f=self.array
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
local _fieldMeta={__index=function(self,k)
    if type(k)=='number' then
        if k<=626 then
            for i=#self+1,k do
                self[i]=self:getNewLine(false)
            end
        else
            error('Too high!')
        end
    else
        error(STRING.repD("Invalid field index type '$1'",type(k)))
    end
end}
function F.new(data)
    assert(type(data)=='table','[Field].new(data): data must be table')
    local f={
        width=data.width or 10,
        height=data.height or 20,-- Attention: this height is not the limit of actual field's height
        array=setmetatable({},_fieldMeta),
    }
    setmetatable(f,{__index=F})

    return f
end
--------------------------------------------------------------

return F
