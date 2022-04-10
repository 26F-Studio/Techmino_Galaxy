local SRS_plus={}
SRS_plus.centerPreset='common'
SRS_plus.centerTex=GC.load{10,10,
    {'setCL',1,1,1,.4},
    {'fCirc',5,5,5},
    {'setCL',1,1,1,.6},
    {'fCirc',5,5,4},
    {'setCL',1,1,1,.9},
    {'fCirc',5,5,3},
    {'setCL',1,1,1},
    {'fCirc',5,5,2},
}
for i=1,5 do SRS_plus[i]=RotationSys.SRS[i] end
for i=6,29 do SRS_plus[i]=RotationSys.TRS[i] end

return SRS_plus
