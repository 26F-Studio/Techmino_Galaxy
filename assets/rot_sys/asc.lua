local L={'+0+0','+1+0','+0-1','+1-1','+0-2','+1-2','+2+0','+2-1','+2-2','-1+0','-1-1','+0+1','+1+1','+2+1','-1-2','-2+0','+0+2','+1+2','+2+2','-2-1','-2-2'}
local R=RotationSys._flipList(L)
local F={'+0+0'}
local centerPos=TABLE.copy(RotationSys._defaultCenterPos)
centerPos[6]={[0]={0,0},{1,0},{1,1},{0,1}}
centerPos[7]={[0]={0,1},{2,0},{0,2},{1,0}}
local ASC={
    centerTex=GC.load{10,10,
        {'setLW',2},
        {'setCL',1,1,1,.7},
        {'line',1,1,9,9},
        {'line',1,9,9,1},
        {'setLW',1},
        {'setCL',1,1,1},
        {'line',1,1,9,9},
        {'line',1,9,9,1},
    },
    centerPos=centerPos,
    kickTable=TABLE.new({
        [01]=R,[10]=L,[03]=L,[30]=R,
        [12]=R,[21]=L,[32]=L,[23]=R,
        [02]=F,[20]=F,[13]=F,[31]=F,
    },29)
}
return ASC
