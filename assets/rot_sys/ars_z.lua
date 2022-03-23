local lrOnly={'+0+0','+1+0','-1+0'}
local upOnly={'+0+0','+0+1','+0+2'}
local lrSet={
    [01]=lrOnly,[10]=lrOnly,[03]=lrOnly,[30]=lrOnly,
    [12]=lrOnly,[21]=lrOnly,[32]=lrOnly,[23]=lrOnly,
    [02]=lrOnly,[20]=lrOnly,[13]=lrOnly,[31]=lrOnly,
}
local upSet={
    [01]=upOnly,[10]=upOnly,[03]=upOnly,[30]=upOnly,
    [12]=upOnly,[21]=upOnly,[32]=upOnly,[23]=upOnly,
    [02]=upOnly,[20]=upOnly,[13]=upOnly,[31]=upOnly,
}

local ARS_Z={
    centerTex=GC.load{10,10,
        {'setLW',2},
        {'setCL',1,1,1,.5},
        {'line',1,9,5,1,9,9},
        {'setCL',1,1,1,1},
        {'line',2,8,5,2,8,8},
    },
    kickTable=TABLE.new(lrSet,29),
}
ARS_Z.kickTable[7]=upSet
ARS_Z.kickTable[25]=upSet
return ARS_Z
