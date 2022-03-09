local gc=love.graphics

local F={}
setmetatable(F,{__index=require'assets.player.basePlayer'})

--------------------------------------------------------------
-- Methods
function F:getNewLine(v)
    return TABLE.new(v or false,self.width)
end
--------------------------------------------------------------
-- Builder
local _fieldMeta={__index=function(self,k)
    if type(k)=='number' then
        if k<=1e3 then
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
        field=setmetatable({},_fieldMeta),
    }
    setmetatable(f,{__index=F})

    return f
end
--------------------------------------------------------------

return F
