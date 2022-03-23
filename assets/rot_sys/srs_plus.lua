local SRS_plus={
    centerTex=GC.load{10,10,
        {'setCL',1,1,1,.4},
        {'fCirc',5,5,5},
        {'setCL',1,1,1,.6},
        {'fCirc',5,5,4},
        {'setCL',1,1,1,.9},
        {'fCirc',5,5,3},
        {'setCL',1,1,1},
        {'fCirc',5,5,2},
    },
    data={},
}
SRS_plus.data.default=RotationSys.SRS.data.default
for i=6,29 do SRS_plus.data[i]=RotationSys.TRS.data[i] end

return SRS_plus