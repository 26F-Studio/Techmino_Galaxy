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
    data={
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
