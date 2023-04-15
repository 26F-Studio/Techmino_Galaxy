local baseDict={
    {'about','aboutDict'},
    {'about','aboutDict_hidden',true},
    -- TODO
}

local dictObjMeta={__index=function(obj,k)
    if k=='titleText' then
        obj.titleText=love.graphics.newText(FONT.get(obj.titleSize,'bold'),obj.title)
        return obj.titleText
    end
end}
for _,obj in next,baseDict do
    obj.type,obj[1]=obj[1]
    obj.id,obj[2]=obj[2]
    obj.hidden,obj[3]=obj[3]
    setmetatable(obj,dictObjMeta)
end

return baseDict
