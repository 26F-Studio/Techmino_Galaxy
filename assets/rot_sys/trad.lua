local centerPos=TABLE.copy(RotationSys._defaultCenterPos)
centerPos[1]={[0]={1,1},{1,0},{1,1},{1,0}}
centerPos[2]={[0]={1,1},{1,0},{1,1},{1,0}}
centerPos[7]={[0]={0,2},{1,0},{0,2},{1,0}}
local Classic={
    centerTex=GC.load{10,10,
        {'setLW',2},
        {'setCL',1,1,1,.5},
        {'line',8,9,1,9,1,1,8,1},
        {'setCL',1,1,1,1},
        {'line',7,8,2,8,2,2,7,2},
    },
    centerPos=centerPos,
    kickTable=TABLE.new(RotationSys._noKickSet,29)
}
return Classic
