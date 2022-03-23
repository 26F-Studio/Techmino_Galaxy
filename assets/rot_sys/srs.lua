return{
    centerTex=GC.load{10,10,
        {'setCL',1,1,1,.3},
        {'fCirc',5,5,4},
        {'setCL',1,1,1,.6},
        {'fCirc',5,5,3},
        {'setCL',1,1,1},
        {'fCirc',5,5,2},
    },
    data={
        default={-- This is MINODATA (for SZJLT)
            [0]={-- This is a STATE
                -- If exist, will draw spin center and be used for calculate base X/Y bias
                center={1.5,0.5},

                --These are KICKs, can include base='+1+1' if center not defined
                R={target=1,test={'+0+0','-1+0','-1+1','+0-2','-1-2'}},
                L={target=3,test={'+0+0','+1+0','+1+1','+0-2','+1-2'}},
                F={target=2},
            },
            [1]={
                center={0.5,1.5},
                R={target=2,test={'+0+0','+1+0','+1-1','+0+2','+1+2'}},
                L={target=0,test={'+0+0','+1+0','+1-1','+0+2','+1+2'}},
                F={target=3,test={'+0+0','+2+0'}},
            },
            [2]={
                center={1.5,1.5},
                R={target=3,test={'+0+0','+1+0','+1+1','+0-2','+1-2'}},
                L={target=1,test={'+0+0','-1+0','-1+1','+0-2','-1-2'}},
                F={target=0},
            },
            [3]={
                center={1.5,1.5},
                R={target=0,test={'+0+0','-1+0','-1-1','+0+2','-1+2'}},
                L={target=2,test={'+0+0','-1+0','-1-1','+0+2','-1+2'}},
                F={target=1,test={'+0+0','-2+0'}},
            },
        },
        [6]={--O
            [0]={
                center={1,1},
                R={target=0},
                L={target=0},
                F={target=0},
            },
        },
        [7]={--I
            [0]={
                center={2,0},
                R={target=1,test={'+0+0','-2+0','+1+0','-2-1','+1+2'}},
                L={target=3,test={'+0+0','-1+0','+2+0','-1+2','+2-1'}},
                F={target=2,test={'+0+0','-3-1','+3-1','-3+0','+3+0'}},
            },
            [1]={
                center={0,2},
                R={target=2,test={'+0+0','-1+0','+2+0','-1+2','+2-1'}},
                L={target=0,test={'+0+0','+2+0','-1+0','+2+1','-1-2'}},
                F={target=3,test={'+0+0','+0+3','+0-3'}},
            },
            [2]={
                center={2,1},
                R={target=3,test={'+0+0','+2+0','-1+0','+2+1','-1-2'}},
                L={target=1,test={'+0+0','+1+0','-2+0','+1-2','-2+1'}},
                F={target=0,test={'+0+0','+3+1','-3+1','+3+0','-3+0'}},
            },
            [3]={
                center={1,2},
                R={target=0,test={'+0+0','+1+0','-2+0','+1-2','-2+1'}},
                L={target=2,test={'+0+0','-2+0','+1+0','-2-1','+1+2'}},
                F={target=3,test={'+0+0','+0-3','+0+3'}},
            },
        },
    },
}
