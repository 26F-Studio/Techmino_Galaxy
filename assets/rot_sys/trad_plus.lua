local centerPos=TABLE.copy(RotationSys._defaultCenterPos)
centerPos[1]={[0]={1,1},{1,0},{1,1},{1,0}}
centerPos[2]={[0]={1,1},{1,0},{1,1},{1,0}}
centerPos[7]={[0]={0,2},{1,0},{0,2},{1,0}}
local Classic_plus={
    centerTex=GC.load{10,10,
        {'setLW',2},
        {'setCL',1,1,1,1},
        {'line',8,9,1,9,1,1,8,1},
        {'fRect',3,3,4,4},
    },
    centerPos=centerPos,
    kickTable=TABLE.new(RotationSys._noKickSet_180,29)
}
return Classic_plus
