local SRS={}
SRS.centerPreset='common'
SRS.centerTex=GC.load{w=10,h=10,
    {'setCL',1,1,1,.3},
    {'fCirc',5,5,4},
    {'setCL',1,1,1,.6},
    {'fCirc',5,5,3},
    {'setCL',1,1,1},
    {'fCirc',5,5,2},
}
SRS[1]={ -- This is a BRIKDATA for S piece
    [0]={ -- This is a STATE
        -- If field 'center' exist(center={x,y}, (x=right Y=up) ), will draw spin center and be used for calculate base X/Y bias
        -- You can see ".centerPreset='common'" up there, so no need to set center here

        -- These are MOVE
        -- Default target=([current dir]+1)%4
        -- Default test={'+0+0'}
        -- Can include base='+1+1', override the auto calculated center-offset when rotate if you need
        R={test={'+0+0','-1+0','-1+1','+0-2','-1-2'}},
        L={test={'+0+0','+1+0','+1+1','+0-2','+1-2'}},
        F={},
    },
    [1]={
        R={test={'+0+0','+1+0','+1-1','+0+2','+1+2'}},
        L={test={'+0+0','+1+0','+1-1','+0+2','+1+2'}},
        F={test={'+0+0','+2+0'}},
    },
    [2]={
        R={test={'+0+0','+1+0','+1+1','+0-2','+1-2'}},
        L={test={'+0+0','-1+0','-1+1','+0-2','-1-2'}},
        F={},
    },
    [3]={
        R={test={'+0+0','-1+0','-1-1','+0+2','-1+2'}},
        L={test={'+0+0','-1+0','-1-1','+0+2','-1+2'}},
        F={test={'+0+0','-2+0'}},
    },
}
for i=2,5 do
    SRS[i]=SRS[1] -- Don't worry about duplicating object, I will deep copy all of them later
end
SRS[6]={ -- O
    [0]={R={},L={},F={}},
    [1]={R={},L={},F={}},
    [2]={R={},L={},F={}},
    [3]={R={},L={},F={}},
}
SRS[7]={ -- I
    [0]={
        R={test={'+0+0','-2+0','+1+0','-2-1','+1+2'}},
        L={test={'+0+0','-1+0','+2+0','-1+2','+2-1'}},
        F={test={'+0+0','-3-1','+3-1','-3+0','+3+0'}},
    },
    [1]={
        R={test={'+0+0','-1+0','+2+0','-1+2','+2-1'}},
        L={test={'+0+0','+2+0','-1+0','+2+1','-1-2'}},
        F={test={'+0+0','+0+3','+0-3'}},
    },
    [2]={
        R={test={'+0+0','+2+0','-1+0','+2+1','-1-2'}},
        L={test={'+0+0','+1+0','-2+0','+1-2','-2+1'}},
        F={test={'+0+0','+3+1','-3+1','+3+0','-3+0'}},
    },
    [3]={
        R={test={'+0+0','+1+0','-2+0','+1-2','-2+1'}},
        L={test={'+0+0','-2+0','+1+0','-2-1','+1+2'}},
        F={test={'+0+0','+0-3','+0+3'}},
    },
}
for i=8,29 do SRS[i]=brikRotSys.TRS[i] end -- Add non-tetrominos' rotations

return SRS
