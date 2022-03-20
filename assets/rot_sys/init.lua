RotationSys={}

RotationSys._defaultCenterTex=GC.load{1,1}--No texture
RotationSys._defaultCenterPos={--For SRS-like RSs
    --Tetromino
    {[0]={0,1},{1,0},{1,1},{1,1}},--Z
    {[0]={0,1},{1,0},{1,1},{1,1}},--S
    {[0]={0,1},{1,0},{1,1},{1,1}},--J
    {[0]={0,1},{1,0},{1,1},{1,1}},--L
    {[0]={0,1},{1,0},{1,1},{1,1}},--T
    {[0]={.5,.5},{.5,.5},{.5,.5},{.5,.5}},--O
    {[0]={-.5,1.5},{1.5,-.5},{.5,1.5},{1.5,.5}},--I

    --Pentomino
    {[0]={1,1},{1,1},{1,1},{1,1}},--Z5
    {[0]={1,1},{1,1},{1,1},{1,1}},--S5
    {[0]={0,1},{1,0},{1,1},{1,1}},--P
    {[0]={0,1},{1,0},{1,1},{1,1}},--Q
    {[0]={1,1},{1,1},{1,1},{1,1}},--F
    {[0]={1,1},{1,1},{1,1},{1,1}},--E
    {[0]={1,1},{1,1},{1,1},{1,1}},--T5
    {[0]={0,1},{1,0},{1,1},{1,1}},--U
    {[0]={.5,1.5},{.5,.5},{1.5,.5},{1.5,1.5}},--V
    {[0]={1,1},{1,1},{1,1},{1,1}},--W
    {[0]={1,1},{1,1},{1,1},{1,1}},--X
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--J5
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--L5
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--R
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--Y
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--N
    {[0]={.5,1.5},{1.5,.5},{.5,1.5},{1.5,.5}},--H
    {[0]={0,2},{2,0},{0,2},{2,0}},--I5

    --Trimino
    {[0]={0,1},{1,0},{0,1},{1,0}},--I3
    {[0]={.5,.5},{.5,.5},{.5,.5},{.5,.5}},--C

    --Domino
    {[0]={-.5,.5},{.5,-.5},{.5,.5},{.5,.5}},--I2

    --Dot
    {[0]={0,0},{0,0},{0,0},{0,0}},--O1
}

local Zero={{0,0}}
RotationSys._noKickSet={[01]=Zero,[10]=Zero,[03]=Zero,[30]=Zero,[12]=Zero,[21]=Zero,[32]=Zero,[23]=Zero}
RotationSys._noKickSet_180={[01]=Zero,[10]=Zero,[03]=Zero,[30]=Zero,[12]=Zero,[21]=Zero,[32]=Zero,[23]=Zero,[02]=Zero,[20]=Zero,[13]=Zero,[31]=Zero}

function RotationSys._strToVec(list)
    for i,vecStr in next,list do
        list[i]={tonumber(vecStr:sub(1,2)),tonumber(vecStr:sub(3,4))}
    end
    return list
end

--Use this if the block is centrosymmetry, *PTR!!!
function RotationSys._centroSymSet(L)
    L[23]=L[01]L[32]=L[10]
    L[21]=L[03]L[12]=L[30]
    L[20]=L[02]L[31]=L[13]
end

--Use this to copy a symmetry set
function RotationSys._flipList(O)
    if not O then
        return
    end
    local L={}
    for i,s in next,O do
        L[i]=string.char(88-s:byte())..s:sub(2)
    end
    return L
end

function RotationSys._reflect(a)
    return{
        [03]=RotationSys._flipList(a[01]),
        [01]=RotationSys._flipList(a[03]),
        [30]=RotationSys._flipList(a[10]),
        [32]=RotationSys._flipList(a[12]),
        [23]=RotationSys._flipList(a[21]),
        [21]=RotationSys._flipList(a[23]),
        [10]=RotationSys._flipList(a[30]),
        [12]=RotationSys._flipList(a[32]),
        [02]=RotationSys._flipList(a[02]),
        [20]=RotationSys._flipList(a[20]),
        [31]=RotationSys._flipList(a[13]),
        [13]=RotationSys._flipList(a[31]),
    }
end

RotationSys.TRS=      require'assets.rot_sys.trs'
RotationSys.SRS=      require'assets.rot_sys.srs'
RotationSys.SRS_plus= require'assets.rot_sys.srs_plus'
RotationSys.SRS_X=    require'assets.rot_sys.srs_x'-- Attention: Need TRS data
RotationSys.BiRS=     require'assets.rot_sys.birs'
RotationSys.ARS_Z=    require'assets.rot_sys.ars_z'
RotationSys.DRS_weak= require'assets.rot_sys.drs_weak'
RotationSys.ASC=      require'assets.rot_sys.asc'
RotationSys.ASC_plus= require'assets.rot_sys.asc_plus'
RotationSys.C2=       require'assets.rot_sys.c2'
RotationSys.C2_sym=   require'assets.rot_sys.c2_sym'
RotationSys.Trad=     require'assets.rot_sys.trad'
RotationSys.Trad_plus=require'assets.rot_sys.trad_plus'
RotationSys.None=     require'assets.rot_sys.none'
RotationSys.None_plus=require'assets.rot_sys.none_plus'

for k,rs in next,RotationSys do
    if type(k)=='string' and k:sub(1,1)~='_' and type(rs)=='table' then
        if not rs.centerDisp then rs.centerDisp=TABLE.new(true,29)end
        if not rs.centerPos then rs.centerPos=RotationSys._defaultCenterPos end
        if not rs.centerTex then rs.centerTex=RotationSys._defaultCenterTex end

        --Make all string vec to the same table vec
        for _,set in next,rs.kickTable do
            if type(set)=='table'then
                for _,list in next,set do
                    if type(list[1])=='string'then
                        RotationSys._strToVec(list)
                    end
                end
            end
        end
    end
end
