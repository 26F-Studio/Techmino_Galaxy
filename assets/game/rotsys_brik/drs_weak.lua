local DRS_weak={}
DRS_weak.centerPreset='common'
DRS_weak.centerTex=GC.load{10,10,
    {'setLW',2},
    {'dRect',1,1,8,8},
    {'fRect',3,3,4,4},
}

local L={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1'}
local R=brikRotSys._flipList(L)
local Z={
    [0]={R={test=R},L={test=L},F={test=R}},
    [1]={R={test=R},L={test=L},F={test=L}},
    [2]={R={test=R},L={test=L},F={test=L}},
    [3]={R={test=R},L={test=L},F={test=R}},
}
local S=brikRotSys._reflect(Z)
DRS_weak[1]=Z -- Z
DRS_weak[2]=S -- S
DRS_weak[3]=Z -- J
DRS_weak[4]=S -- L
DRS_weak[5]=Z -- T
DRS_weak[6]=Z -- O
DRS_weak[7]=Z -- I
DRS_weak[8]=Z -- Z5
DRS_weak[9]=S -- S5
DRS_weak[10]=Z -- P
DRS_weak[11]=S -- Q
DRS_weak[12]=Z -- F
DRS_weak[13]=S -- E
DRS_weak[14]=Z -- T5
DRS_weak[15]=Z -- U
DRS_weak[16]=Z -- V
DRS_weak[17]=Z -- W
DRS_weak[18]=Z -- X
DRS_weak[19]=Z -- J5
DRS_weak[20]=S -- L5
DRS_weak[21]=Z -- R
DRS_weak[22]=S -- Y
DRS_weak[23]=Z -- N
DRS_weak[24]=S -- H
DRS_weak[25]=Z -- I5
DRS_weak[26]=Z -- I3
DRS_weak[27]=Z -- C
DRS_weak[28]=Z -- I2
DRS_weak[29]=Z -- O1

local function _fillCenter(id,list)
    for k,v in next,list do
        DRS_weak[id]=TABLE.copyAll(DRS_weak[id])
        DRS_weak[id][k].center=v
    end
end
_fillCenter(1, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- Z
_fillCenter(2, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- S
_fillCenter(3, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- L
_fillCenter(4, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- J
_fillCenter(5, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- T
_fillCenter(7, {[0]={2,1},{0,2},{2,1},{1,2}}) -- I
_fillCenter(10,{[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{0.5,1.5}}) -- P
_fillCenter(11,{[0]={1.5,1.5},{1.5,1.5},{1.5,1.5},{1.5,1.5}}) -- Q
_fillCenter(15,{[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- U
_fillCenter(16,{[0]={1.5,1.5},{1.5,1.5},{1.5,1.5},{1.5,1.5}}) -- V
_fillCenter(19,{[0]={2,2},{1,2},{2,2},{1,2}}) -- J5
_fillCenter(20,{[0]={2,2},{1,2},{2,2},{1,2}}) -- L5
_fillCenter(21,{[0]={2,2},{1,2},{2,2},{1,2}}) -- R
_fillCenter(22,{[0]={2,2},{1,2},{2,2},{1,2}}) -- Y
_fillCenter(23,{[0]={2,2},{1,2},{2,2},{1,2}}) -- N
_fillCenter(24,{[0]={2,2},{1,2},{2,2},{1,2}}) -- H
_fillCenter(26,{[0]={1.5,0.5},{0.5,0.5},{1.5,0.5},{0.5,0.5}}) -- I3
_fillCenter(28,{[0]={1.5,0.5},{0.5,0.5},{1.5,0.5},{0.5,0.5}}) -- I2

return DRS_weak
