local ARS_plus={}
ARS_plus.centerPreset='common'
ARS_plus.centerTex=GC.load{10,10,
    {'setLW',2},
    {'setCL',1,1,1,.5},
    {'line',1,9,5,1,9,9},
    {'setCL',1,1,1,1},
    {'line',2,8,5,2,8,8},
}
local lrOnly={'+0+0','+1+0','-1+0'}
local upOnly={'+0+0','+0+1','+0+2'}
local lrSet={
    [0]={R={test=lrOnly},L={test=lrOnly},F={test=lrOnly}},
    [1]={R={test=lrOnly},L={test=lrOnly},F={test=lrOnly}},
    [2]={R={test=lrOnly},L={test=lrOnly},F={test=lrOnly}},
    [3]={R={test=lrOnly},L={test=lrOnly},F={test=lrOnly}},
}
local upSet={
    [0]={R={test=upOnly},L={test=upOnly},F={test=upOnly}},
    [1]={R={test=upOnly},L={test=upOnly},F={test=upOnly}},
    [2]={R={test=upOnly},L={test=upOnly},F={test=upOnly}},
    [3]={R={test=upOnly},L={test=upOnly},F={test=upOnly}},
}
for i=1,29 do ARS_plus[i]=lrSet end
ARS_plus[7]=upSet
ARS_plus[25]=upSet

local function _fillCenter(id,list)
    for k,v in next,list do
        ARS_plus[id]=TABLE.copy(ARS_plus[id])
        ARS_plus[id][k].center=v
    end
end
_fillCenter(1, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{0.5,1.5}}) -- Z
_fillCenter(2, {[0]={1.5,1.5},{1.5,1.5},{1.5,1.5},{1.5,1.5}}) -- S
_fillCenter(3, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- L
_fillCenter(4, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- J
_fillCenter(5, {[0]={1.5,1.5},{0.5,1.5},{1.5,1.5},{1.5,1.5}}) -- T
_fillCenter(7, {[0]={2.5,0.5},{0.5,2.5},{2.5,0.5},{0.5,2.5}}) -- I
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
return ARS_plus
