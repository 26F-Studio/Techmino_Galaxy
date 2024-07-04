---@type Map<Map<fun(P:Techmino.Player.Gela):any>>
local atkSys={}

-- No attack
atkSys.none={
    init=NULL,
    clear=NULL,
}

-- Classic
atkSys.classic={
    init=function(P)
        P.atkSysData.remainder=0
    end,
    clear=function(P)
        local sizes={}
        for i=1,#P.clearingGroups do
            sizes[i]=TABLE.getSize(P.clearingGroups[i])
        end
        local chip,mult=MATH.sum(sizes)*10,0

        -- Chain Score
        -- 0,8,16,32,64,96,128,160,192,224,256,288,320,352,384,416,448,480,512,...
        mult=mult+(P.chain<=3 and 8*(P.chain-1) or 32*(P.chain-3))

        -- Color (Group) Count Score
        -- 0,3,6,12,24,...
        local colors=#P.clearingGroups
        mult=mult+(
            colors==1 and 0 or
            colors==2 and 3 or
            6*(2^(colors-3))
        )

        -- Group Size Score
        -- 0,0,0,0,2,3,4,5,6,7,10+
        for i=1,#sizes do
            mult=mult+(
                sizes[i]==4 and 0 or
                sizes[i]<=10 and sizes[i]-3 or
                10
            )
        end

        if mult==0 then mult=1 end
        local score=(P.atkSysData.remainder+chip*mult)

        local power=math.floor(score/70)
        P.atkSysData.remainder=score-power*70
        if power>0 then
            return {power=power,time=1000}
        end
    end,
}

for _,sys in next,atkSys do
    setmetatable(sys,{__index=atkSys.none})
end

setmetatable(atkSys.none,{__index=function() return NULL end})

return atkSys
