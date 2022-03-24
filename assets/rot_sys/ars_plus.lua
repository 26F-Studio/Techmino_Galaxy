local ARS_Z={}
ARS_Z.centerPreset='common'
ARS_Z.centerTex=GC.load{10,10,
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
for i=1,29 do ARS_Z[i]=lrSet end
ARS_Z[7]=upSet
ARS_Z[25]=upSet
return ARS_Z
