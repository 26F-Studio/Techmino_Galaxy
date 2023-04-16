local baseDict={
    {'intro: aboutDict'},
    {'intro: aboutDict_hidden',hidden=true},
    {'intro: setting_out',hidden=true},
    {'guide: noobGuide'},
    {'term:  20g'},
    {'tech:  hypertap'},
    {'other: 26f_studio'},
    -- TODO
}

local dictObjMeta={__index=function(obj,k)
    if k=='titleText' then
        obj.titleText=love.graphics.newText(FONT.get(obj.titleSize,'bold'),obj.title)
        return obj.titleText
    end
end}
for _,obj in next,baseDict do
    local list=STRING.split(obj[1],':')
    obj[1]=nil
    obj.cat,obj.id=list[1]:trim(),list[2]:trim()
    setmetatable(obj,dictObjMeta)
end

return baseDict
