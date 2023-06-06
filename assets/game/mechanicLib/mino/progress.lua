local floor,clamp=math.floor,MATH.clamp

--- @type Techmino.Mech.mino
local progress={}

function progress.marathon_afterClear(P)
    if not P.modeData.marathon_bgmLevel then P.modeData.marathon_bgmLevel=1 end
    if P.isMain and P.modeData.level>P.modeData.marathon_bgmLevel then
        if P.modeData.marathon_bgmLevel<15 then
            BGM.set(bgmPack('propel','a1','a3','b3'),'volume',math.min(P.modeData.level/15,1)^2)
        end
        if P.modeData.level>=25 and P.modeData.marathon_bgmLevel<25 then
            BGM.set(bgmPack('propel','a1','a3'),'volume',0,26)
        end
        if P.modeData.level>=22 then
            BGM.set('propel/drum','volume',math.min(.2+(P.modeData.level-20)*.8,1),6.26)
            PROGRESS.setMinoModeUnlocked('hypersonic_lo')
        end
        P.modeData.marathon_bgmLevel=P.modeData.level
    end
end

return progress
