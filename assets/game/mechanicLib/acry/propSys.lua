---@type Map<Map<fun(P:Techmino.Player.Acry,acry:Techmino.Acry.Cell)>>
local propSys={}

propSys.fire={
    clear=function(P,acry)
        -- TODO: 3*3 Explosion
    end,
    always=function(P,acry)
        if acry.propData.fuseBurning then
            acry.propData.fuseTimer=acry.propData.fuseTimer-1
            if acry.propData.fuseTimer<=0 then
                acry._newState='clear'
            end
        end
    end
}

return propSys
