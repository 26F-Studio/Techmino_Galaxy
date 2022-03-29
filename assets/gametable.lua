-- Global color table for minoes
ColorTable={} for i=1,64 do ColorTable[i]={COLOR.hsv((i-1)/64,.9,.9)} end

do--Blocks
    local O,_=true,false
    Blocks={
        --Tetromino
        {name='Z', id=01,shape={{_,O,O},{O,O,_}}},
        {name='S', id=02,shape={{O,O,_},{_,O,O}}},
        {name='J', id=03,shape={{O,O,O},{O,_,_}}},
        {name='L', id=04,shape={{O,O,O},{_,_,O}}},
        {name='T', id=05,shape={{O,O,O},{_,O,_}}},
        {name='O', id=06,shape={{O,O},{O,O}}},
        {name='I', id=07,shape={{O,O,O,O}}},

        --Pentomino
        {name='Z5',id=08,shape={{_,O,O},{_,O,_},{O,O,_}}},
        {name='S5',id=09,shape={{O,O,_},{_,O,_},{_,O,O}}},
        {name='P', id=10,shape={{O,O,O},{O,O,_}}},
        {name='Q', id=11,shape={{O,O,O},{_,O,O}}},
        {name='F', id=12,shape={{_,O,_},{O,O,O},{O,_,_}}},
        {name='E', id=13,shape={{_,O,_},{O,O,O},{_,_,O}}},
        {name='T5',id=14,shape={{O,O,O},{_,O,_},{_,O,_}}},
        {name='U', id=15,shape={{O,O,O},{O,_,O}}},
        {name='V', id=16,shape={{O,O,O},{_,_,O},{_,_,O}}},
        {name='W', id=17,shape={{_,O,O},{O,O,_},{O,_,_}}},
        {name='X', id=18,shape={{_,O,_},{O,O,O},{_,O,_}}},
        {name='J5',id=19,shape={{O,O,O,O},{O,_,_,_}}},
        {name='L5',id=20,shape={{O,O,O,O},{_,_,_,O}}},
        {name='R', id=21,shape={{O,O,O,O},{_,O,_,_}}},
        {name='Y', id=22,shape={{O,O,O,O},{_,_,O,_}}},
        {name='N', id=23,shape={{_,O,O,O},{O,O,_,_}}},
        {name='H', id=24,shape={{O,O,O,_},{_,_,O,O}}},
        {name='I5',id=25,shape={{O,O,O,O,O}}},

        --Trimino
        {name='I3',id=26,shape={{O,O,O}}},
        {name='C', id=27,shape={{O,O},{_,O}}},

        --Domino
        {name='I2',id=28,shape={{O,O}}},

        --Dot
        {name='O1',id=29,shape={{O}}},
    } for i=1,#Blocks do Blocks[Blocks[i].name]=Blocks[i] end
end