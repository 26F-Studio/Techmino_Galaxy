local C2_plus={}
C2_plus.centerPreset='common'
C2_plus.centerTex=GC.load{10,10,
    {'setLW',2},
    {'dRect',2,2,6,6},
}
local L={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1','-2+0','+2+0'}
local R=brikRotSys._flipList(L)
local Z={
    [0]={R={test=R},L={test=L},F={test=R}},
    [1]={R={test=R},L={test=L},F={test=L}},
    [2]={R={test=R},L={test=L},F={test=L}},
    [3]={R={test=R},L={test=L},F={test=R}},
}
local S=brikRotSys._reflect(Z)
C2_plus[1]=Z -- Z
C2_plus[2]=S -- S
C2_plus[3]=Z -- J
C2_plus[4]=S -- L
C2_plus[5]=Z -- T
C2_plus[6]=Z -- O
C2_plus[7]=Z -- I
C2_plus[8]=Z -- Z5
C2_plus[9]=S -- S5
C2_plus[10]=Z -- P
C2_plus[11]=S -- Q
C2_plus[12]=Z -- F
C2_plus[13]=S -- E
C2_plus[14]=Z -- T5
C2_plus[15]=Z -- U
C2_plus[16]=Z -- V
C2_plus[17]=Z -- W
C2_plus[18]=Z -- X
C2_plus[19]=Z -- J5
C2_plus[20]=S -- L5
C2_plus[21]=Z -- R
C2_plus[22]=S -- Y
C2_plus[23]=Z -- N
C2_plus[24]=S -- H
C2_plus[25]=Z -- I5
C2_plus[26]=Z -- I3
C2_plus[27]=Z -- C
C2_plus[28]=Z -- I2
C2_plus[29]=Z -- O1
return C2_plus
