RotationSys={}

RotationSys._defaultCenterTex=GC.load{1,1}--No texture
-- RotationSys._defaultCenterPos={--For SRS-like RSs
--     --Tetromino
--     {[0]={0,1},{1,0},{1,1},{1,1}},--Z
--     {[0]={0,1},{1,0},{1,1},{1,1}},--S
--     {[0]={0,1},{1,0},{1,1},{1,1}},--J
--     {[0]={0,1},{1,0},{1,1},{1,1}},--L
--     {[0]={0,1},{1,0},{1,1},{1,1}},--T
--     {[0]={.5,.5},{.5,.5},{.5,.5},{.5,.5}},--O
--     {[0]={-.5,1.5},{1.5,-.5},{.5,1.5},{1.5,.5}},--I

--     --Pentomino
--     {[0]={1,1},{1,1},{1,1},{1,1}},--Z5
--     {[0]={1,1},{1,1},{1,1},{1,1}},--S5
--     {[0]={0,1},{1,0},{1,1},{1,1}},--P
--     {[0]={0,1},{1,0},{1,1},{1,1}},--Q
--     {[0]={1,1},{1,1},{1,1},{1,1}},--F
--     {[0]={1,1},{1,1},{1,1},{1,1}},--E
--     {[0]={1,1},{1,1},{1,1},{1,1}},--T5
--     {[0]={0,1},{1,0},{1,1},{1,1}},--U
--     {[0]={.5,1.5},{.5,.5},{1.5,.5},{1.5,1.5}},--V
--     {[0]={1,1},{1,1},{1,1},{1,1}},--W
--     {[0]={1,1},{1,1},{1,1},{1,1}},--X
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--J5
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--L5
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--R
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--Y
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--N
--     {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--H
--     {[0]={0,2},{2,0},{0,2},{2,0}},--I5

--     --Trimino
--     {[0]={0,1},{1,0},{0,1},{1,0}},--I3
--     {[0]={.5,.5},{.5,.5},{.5,.5},{.5,.5}},--C

--     --Domino
--     {[0]={-.5,.5},{.5,-.5},{.5,.5},{.5,.5}},--I2

--     --Dot
--     {[0]={0,0},{0,0},{0,0},{0,0}},--O1
-- }

function RotationSys._strToVec(vecStr)
    return {tonumber(vecStr:sub(1,2)),tonumber(vecStr:sub(3,4))}
end

function RotationSys._collectVecStr(kick)
    if kick then
        assert(type(kick)=='table',"KICK must be a table")
        assert(kick.target,"where is KICK.target?")

        if kick.base then kick.base=RotationSys._strToVec(kick.base) end
        if not kick.test then kick.test={'+0+0'} end

        assert(type(kick.test)=='table','[KICK].test must be a table')
        for i=1,#kick.test do
            if type(kick.test[i])~='table' then
                assert(type(kick.test[i])=='string','test[n] must be vecStr')
                kick.test[i]=RotationSys._strToVec(kick.test[i])
            end
        end
    end
end

--Use this to copy a symmetry set
function RotationSys._flipList(O)
    if not O then return end
    local L={}
    for i,s in next,O do
        L[i]=(s:sub(1,1)=='+' and '-' or '+')..s:sub(2)
    end
    return L
end

function RotationSys._reflect(m)
    local m2=TABLE.copy(m)
    if m2[0] and m2[1] and m2[2] and m2[3] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test=RotationSys._flipList(m2[0].L.test),RotationSys._flipList(m2[0].R.test),RotationSys._flipList(m2[0].F.test)
        m2[1].R.test,m2[1].L.test,m2[1].F.test=RotationSys._flipList(m2[3].L.test),RotationSys._flipList(m2[3].R.test),RotationSys._flipList(m2[3].F.test)
        m2[2].R.test,m2[2].L.test,m2[2].F.test=RotationSys._flipList(m2[2].L.test),RotationSys._flipList(m2[2].R.test),RotationSys._flipList(m2[2].F.test)
        m2[3].R.test,m2[3].L.test,m2[3].F.test=RotationSys._flipList(m2[1].L.test),RotationSys._flipList(m2[1].R.test),RotationSys._flipList(m2[1].F.test)
    elseif m2[0] and m2[1] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test=RotationSys._flipList(m2[0].L.test),RotationSys._flipList(m2[0].R.test),RotationSys._flipList(m2[0].F.test)
        m2[1].R.test,m2[1].L.test,m2[1].F.test=RotationSys._flipList(m2[1].L.test),RotationSys._flipList(m2[1].R.test),RotationSys._flipList(m2[1].F.test)
    elseif m2[0] then
        m2[0].R.test,m2[0].L.test,m2[0].F.test=RotationSys._flipList(m2[0].L.test),RotationSys._flipList(m2[0].R.test),RotationSys._flipList(m2[0].F.test)
    else
        error("wtf no minoData[0] to reflect")
    end
    return m2
end

RotationSys.TRS=      require'assets.rot_sys.trs'
RotationSys.SRS=      require'assets.rot_sys.srs'
RotationSys.SRS_plus= require'assets.rot_sys.srs_plus'
-- RotationSys.BiRS=     require'assets.rot_sys.birs'
-- RotationSys.ARS_Z=    require'assets.rot_sys.ars_z'
-- RotationSys.DRS_weak= require'assets.rot_sys.drs_weak'
-- RotationSys.ASC=      require'assets.rot_sys.asc'
-- RotationSys.ASC_plus= require'assets.rot_sys.asc_plus'
-- RotationSys.C2=       require'assets.rot_sys.c2'
-- RotationSys.C2_sym=   require'assets.rot_sys.c2_sym'
-- RotationSys.Trad=     require'assets.rot_sys.trad'
-- RotationSys.Trad_plus=require'assets.rot_sys.trad_plus'
-- RotationSys.None=     require'assets.rot_sys.none'
-- RotationSys.None_plus=require'assets.rot_sys.none_plus'

local rsDataMeta={
    __index=function(self,k)
        if type(self.default)=='table' then
            return self.default
        elseif type(self.default)=='function' then
            return self.default(k)
        end
    end
}
for k,rs in next,RotationSys do
    if type(k)=='string' and k:sub(1,1)~='_' and type(rs)=='table' then
        if not rs.centerTex then rs.centerTex=RotationSys._defaultCenterTex end

        --Make all string vec to the same table vec
        for _,minoData in next,rs.data do
            if type(minoData)=='table'then
                for _,state in next,minoData do
                    RotationSys._collectVecStr(state.R)
                    RotationSys._collectVecStr(state.L)
                    RotationSys._collectVecStr(state.F)
                end
            end
        end
        setmetatable(rs.data,rsDataMeta)
    end
end
