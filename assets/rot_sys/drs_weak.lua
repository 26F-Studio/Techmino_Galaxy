local centerPos=TABLE.copy(RotationSys._defaultCenterPos)
centerPos[1]={[0]={1,1},{1,0},{1,1},{1,1}}--Z
centerPos[2]={[0]={1,1},{1,0},{1,1},{1,1}}--S
centerPos[3]={[0]={1,1},{1,0},{1,1},{1,1}}--L
centerPos[4]={[0]={1,1},{1,0},{1,1},{1,1}}--J
centerPos[5]={[0]={1,1},{1,0},{1,1},{1,1}}--T
centerPos[7]={[0]={.5,1.5},{1.5,-.5},{.5,1.5},{1.5,.5}}--I
centerPos[10]={[0]={1,1},{1,0},{1,1},{1,0}}--P
centerPos[11]={[0]={1,1},{1,1},{1,1},{1,1}}--Q
centerPos[15]={[0]={1,1},{1,0},{1,1},{1,1}}--U
centerPos[16]={[0]={1,1},{1,1},{1,1},{1,1}}--V
centerPos[19]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--J5
centerPos[20]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--L5
centerPos[21]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--R
centerPos[22]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--Y
centerPos[23]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--N
centerPos[24]={[0]={1.5,1.5},{1.5,0.5},{1.5,1.5},{1.5,0.5}}--H
centerPos[26]={[0]={0,1},{0,0},{0,1},{0,0}}--I3
centerPos[28]={[0]={0,1},{0,0},{0,1},{0,0}}--I2

local L={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1'}
local R={'+0+0','+1+0','-1+0','+0-1','+1-1','-1-1'}

local Z={
    [01]=R,[10]=L,[03]=L,[30]=R,
    [12]=R,[21]=L,[32]=L,[23]=R,
    [02]=R,[20]=L,[13]=L,[31]=R,
}
local S=RotationSys._reflect(Z)

local DRS_weak={
    centerTex=GC.load{10,10,
        {'setLW',2},
        {'dRect',1,1,8,8},
        {'fRect',3,3,4,4},
    },
    centerPos=centerPos,
    kickTable={
        Z,S,--Z,S
        Z,S,--J,L
        Z,--T
        RotationSys._noKickSet,--O
        Z,--I

        Z,S,--Z5,S5
        Z,S,--P,Q
        Z,S,--F,E
        Z,Z,Z,Z,--T5,U,V,W
        RotationSys._noKickSet,--X
        Z,S,--J5,L5
        Z,S,--R,Y
        Z,S,--N,H
        Z,--I5

        Z,Z,--I3,C
        Z,Z,--I2,O1
    }
}
return DRS_weak
