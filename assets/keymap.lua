local Map={}
Map.__index=Map

function Map:import(data)
    if not data then return end
    for i=1,#self do
        if data[i] then
            self[i].keys=TABLE.shift(data[i],0)
        end
    end
end

function Map:export()
    local data={}
    for i=1,#self do
        data[i]=TABLE.shift(self[i].keys,0)
    end
    return data
end

function Map:getKeys(action)
    for i=1,#self do
        if self[i].act==action then
            return self[i].keys
        end
    end
end

function Map:getAction(key)
    for i=1,#self do
        local l=self[i].keys
        for j=1,#l do
            if l[j]==key then
                return self[i].act
            end
        end
    end
end

function Map:remKey(key)
    for j=1,#self do
        local k=TABLE.find(self[j].keys,key)
        if k then
            table.remove(self[j].keys,k)
        end
    end
end

function Map:addKey(act,key)
    for i=1,#self do
        if self[i].act==act then
            table.insert(self[i].keys,key)
            while #self[i].keys>=5 do
                table.remove(self[i].keys,1)
            end
            break
        end
    end
end

function Map.new(l)
    return setmetatable(l or {},Map)
end

return Map
