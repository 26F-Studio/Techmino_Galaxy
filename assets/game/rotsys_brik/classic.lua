local Classic={}
Classic.centerPreset='common'
Classic[1]={
    [0]={
        center=false,
        R={target=1,base="+1+0"},
        L={target=1,base="+1+0"},
    },
    [1]={
        center=false,
        R={target=0,base="-1+0"},
        L={target=0,base="-1+0"},
    },
}
Classic[2]=Classic[1]
Classic[7]={
    [0]={
        center=false,
        R={target=1,base="+2-1"},
        L={target=1,base="+2-1"},
    },
    [1]={
        center=false,
        R={target=0,base="-2+1"},
        L={target=0,base="-2+1"},
    },
}
return Classic
