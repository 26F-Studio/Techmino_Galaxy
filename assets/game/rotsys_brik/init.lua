brikRotSys={}

brikRotSys._defaultCenterTex=GC.load{1,1} -- No texture
brikRotSys._defaultCenterPos={
    common={ -- For SRS-like RSs
        -- Tetromino
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- Z
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- S
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- J
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- L
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- T
        {[0]={1,1},     [1]={1,1},     [2]={1,1},     [3]={1,1}     }, -- O
        {[0]={2,0},     [1]={0,2},     [2]={2,1},     [3]={1,2}     }, -- I

        -- Pentomino
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- Z5
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- S5
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- P
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- Q
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- F
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- E
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- T5
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- U
        {[0]={2,1},     [1]={1,1},     [2]={1,2},     [3]={2,2}     }, -- V
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- W
        {[0]={1.5,1.5}, [1]={1.5,1.5}, [2]={1.5,1.5}, [3]={1.5,1.5} }, -- X

        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- J5
        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- L5
        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- R
        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- Y
        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- N
        {[0]={2,1},     [1]={1,2},     [2]={2,1},     [3]={1,2}     }, -- H
        {[0]={2.5,0.5}, [1]={0.5,2.5}, [2]={2.5,0.5}, [3]={0.5,2.5} }, -- I5

        -- Trimino
        {[0]={1.5,0.5}, [1]={0.5,1.5}, [2]={1.5,0.5}, [3]={0.5,1.5} }, -- I3
        {[0]={1,1},     [1]={1,1},     [2]={1,1},     [3]={1,1}     }, -- C

        -- Domino
        {[0]={1,0},     [1]={0,1},     [2]={1,1},     [3]={1,1}     }, -- I2

        -- Dot
        {[0]={0.5,0.5}, [1]={0.5,0.5}, [2]={0.5,0.5}, [3]={0.5,0.5} }, -- O1
    },
}

function brikRotSys._strToVec(vecStr)
    return {tonumber(vecStr:sub(1,2)),tonumber(vecStr:sub(3,4))}
end

function brikRotSys._normalizeKick(data,dir,fdir)
    local move=data[dir][fdir]
    if move then
        assert(type(move)=='table',"KICK must be a table")

        if move.base then move.base=brikRotSys._strToVec(move.base) end
        if not move.test then move.test={'+0+0'} end
        if not move.target then
            move.target=(dir+(
                fdir=='R' and 1 or
                fdir=='L' and 3 or
                fdir=='F' and 2 or
                error("WTF why dir isn't R/L/F ("..tostring(dir)..")")
            ))%4
        end

        assert(data[move.target],"Target state ["..move.target.."] not exist")
        assert(type(move.test)=='table',"[KICK].test must be a table")

        for i=1,#move.test do
            if type(move.test[i])~='table' then
                assert(type(move.test[i])=='string',"test[n] must be vecStr")
                move.test[i]=brikRotSys._strToVec(move.test[i])
            end
        end
    end
end

-- Use this to copy a symmetry set
function brikRotSys._flipList(O)
    if not O then return end
    local L={}
    for i,s in next,O do
        L[i]=(s:sub(1,1)=='+' and '-' or '+')..s:sub(2)
    end
    return L
end

function brikRotSys._reflect(m) -- Only available for 4/2/1 state briks
    local m2=TABLE.copyAll(m)
    if m2[0] and m2[1] and m2[2] and m2[3] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test,
        m2[1].R.test,m2[1].L.test,m2[1].F.test,
        m2[2].R.test,m2[2].L.test,m2[2].F.test,
        m2[3].R.test,m2[3].L.test,m2[3].F.test=
        brikRotSys._flipList(m2[0].L.test),brikRotSys._flipList(m2[0].R.test),brikRotSys._flipList(m2[0].F.test),
        brikRotSys._flipList(m2[3].L.test),brikRotSys._flipList(m2[3].R.test),brikRotSys._flipList(m2[3].F.test),
        brikRotSys._flipList(m2[2].L.test),brikRotSys._flipList(m2[2].R.test),brikRotSys._flipList(m2[2].F.test),
        brikRotSys._flipList(m2[1].L.test),brikRotSys._flipList(m2[1].R.test),brikRotSys._flipList(m2[1].F.test);
    elseif m2[0] and m2[1] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test,
        m2[1].R.test,m2[1].L.test,m2[1].F.test=
        brikRotSys._flipList(m2[0].L.test),brikRotSys._flipList(m2[0].R.test),brikRotSys._flipList(m2[0].F.test),
        brikRotSys._flipList(m2[1].L.test),brikRotSys._flipList(m2[1].R.test),brikRotSys._flipList(m2[1].F.test);
    elseif m2[0] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test=brikRotSys._flipList(m2[0].L.test),brikRotSys._flipList(m2[0].R.test),brikRotSys._flipList(m2[0].F.test)
    else
        error("WTF no brikData[0] to reflect")
    end
    return m2
end

---@alias Techmino.Mech.Brik.RotationSysName
---| 'None'
---| 'TRS'
---| 'SRS'
---| 'BiRS'
---| 'C2_plus'
---| 'Classic'
---| 'ASC_plus'
---| 'ARS_plus'
---| 'DRS_weak'
---| 'Physical'

love.graphics.setDefaultFilter('nearest','nearest')
local require=simpRequire('assets.game.')
brikRotSys.None=     require'rotsys_brik.none'
brikRotSys.TRS=      require'rotsys_brik.trs'
brikRotSys.SRS=      require'rotsys_brik.srs'
brikRotSys.BiRS=     require'rotsys_brik.birs'
brikRotSys.C2_plus=  require'rotsys_brik.c2_plus'
brikRotSys.Classic=  require'rotsys_brik.classic'
brikRotSys.ASC_plus= require'rotsys_brik.asc_plus'
brikRotSys.ARS_plus= require'rotsys_brik.ars_plus'
brikRotSys.DRS_weak= require'rotsys_brik.drs_weak'
brikRotSys.Physical= require'rotsys_brik.physical'
love.graphics.setDefaultFilter('linear','linear')

for name,rs in next,brikRotSys do
    if type(name)=='string' and name:sub(1,1)~='_' and type(rs)=='table' then
        for i=1,29 do
            if not rs[i] then
                rs[i]=brikRotSys.None[i]
            end
        end

        rs=TABLE.copyAll(rs)

        if not rs.centerTex then rs.centerTex=brikRotSys._defaultCenterTex end
        if rs.centerPreset then
            local set=brikRotSys._defaultCenterPos[rs.centerPreset]
            for i=1,29 do
                if type(rs[i])=='table' then
                    local brikData=rs[i]
                    for dir,state in next,brikData do
                        if type(state)=='table' and state.center==nil then
                            if not set[i][dir] then
                                error("Preset '"..rs.centerPreset.."' has no center for RS '"..name.."', brik "..i..", dir "..dir)
                            end
                            state.center=TABLE.copyAll(set[i][dir])
                        end
                    end
                end
            end
        end

        -- Make all string vec to the same table vec
        for shapeID,brikData in next,rs do
            if type(shapeID)=='number' then
                assert(type(brikData)=='table',"brikData must be table")
                if brikData.rotate then
                    assert(type(brikData.rotate)=='function',"brikData.rotate must be function if exist")
                    assert(brikData.center==nil or type(brikData.center)=='function',"brikData.center must be function if exist")
                end
                for dir in next,brikData do
                    if type(dir)=='number' then
                        brikRotSys._normalizeKick(brikData,dir,'R')
                        brikRotSys._normalizeKick(brikData,dir,'L')
                        brikRotSys._normalizeKick(brikData,dir,'F')
                    end
                end
            end
        end

    end
    brikRotSys[name]=rs
end
