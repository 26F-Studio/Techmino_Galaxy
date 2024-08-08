local ASC={}
ASC.centerPreset='common'
ASC.centerTex=GC.load{w=10,h=10,
    {'setLW',2},
    {'setCL',1,1,1,.7},
    {'line',1,1,9,9},
    {'line',1,9,9,1},
    {'setLW',1},
    {'setCL',1,1,1},
    {'line',1,1,9,9},
    {'line',1,9,9,1},
    {'fCirc',5,5,3},
}
local L={'+0+0','+1+0','+0-1','+1-1','+0-2','+1-2','+2+0','+2-1','+2-2','-1+0','-1-1','+0+1','+1+1','+2+1','-1-2','-2+0','+0+2','+1+2','+2+2','-2-1','-2-2'}
local R=brikRotSys._flipList(L)
local FL={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1','+0-2','-1-2','+1-2','-2+0','+2+0','-2-1','+2-1','-2+1','+2+1','+0+2','-1+2','+1+2'}
local FR=brikRotSys._flipList(FL)
local Z={
    [0]={R={test=R},L={test=L},F={test=FR}},
    [1]={R={test=R},L={test=L},F={test=FL}},
    [2]={R={test=R},L={test=L},F={test=FL}},
    [3]={R={test=R},L={test=L},F={test=FR}},
}
local S=brikRotSys._reflect(Z)

ASC[1]=Z -- Z
ASC[2]=S -- S
ASC[3]=Z -- J
ASC[4]=S -- L
ASC[5]=Z -- T
ASC[6]=Z -- O
ASC[7]={
    [0]={
        center={1.5,0.5},
        R={test=R},L={test=L},F={test=FR}
    },
    [1]={
        center={0.5,2.5},
        R={test=R},L={test=L},F={test=FL}
    },
    [2]={
        center={2.5,0.5},
        R={test=R},L={test=L},F={test=FL}
    },
    [3]={
        center={0.5,1.5},
        R={test=R},L={test=L},F={test=FR}
    },
} -- I
ASC[8]=Z -- Z5
ASC[9]=S -- S5
ASC[10]=Z -- P
ASC[11]=S -- Q
ASC[12]=Z -- F
ASC[13]=S -- E
ASC[14]=Z -- T5
ASC[15]=Z -- U
ASC[16]=Z -- V
ASC[17]=Z -- W
ASC[18]=Z -- X
ASC[19]=Z -- J5
ASC[20]=S -- L5
ASC[21]=Z -- R
ASC[22]=S -- Y
ASC[23]=Z -- N
ASC[24]=S -- H
ASC[25]=Z -- I5
ASC[26]=Z -- I3
ASC[27]=Z -- C
ASC[28]=Z -- I2
ASC[29]=Z -- O1
return ASC
