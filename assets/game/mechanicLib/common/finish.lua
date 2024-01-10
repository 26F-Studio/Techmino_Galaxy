return setmetatable({},{__index=function(self,k)
    assert(TABLE.find(k,{'AC','TLE','UKE'}),'Invalid finish type')
    self[k]=function(P) P:finish(k) end
    return self[k]
end})
