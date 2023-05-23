local O,_=true,false

--- @class Techmino.mino
--- @field name string
--- @field id number
--- @field shape boolean[][]

--- @class Techmino.minos
--- @field Z Techmino.mino
--- @field S Techmino.mino
--- @field J Techmino.mino
--- @field L Techmino.mino
--- @field T Techmino.mino
--- @field O Techmino.mino
--- @field I Techmino.mino
--- @field Z5 Techmino.mino
--- @field S5 Techmino.mino
--- @field P Techmino.mino
--- @field Q Techmino.mino
--- @field F Techmino.mino
--- @field E Techmino.mino
--- @field T5 Techmino.mino
--- @field U Techmino.mino
--- @field V Techmino.mino
--- @field W Techmino.mino
--- @field X Techmino.mino
--- @field J5 Techmino.mino
--- @field L5 Techmino.mino
--- @field R Techmino.mino
--- @field Y Techmino.mino
--- @field N Techmino.mino
--- @field H Techmino.mino
--- @field I5 Techmino.mino
--- @field I3 Techmino.mino
--- @field C Techmino.mino
--- @field I2 Techmino.mino
--- @field O1 Techmino.mino
local minoes={
    -- Tetromino
    {name='Z', id=01,shape={{_,O,O},{O,O,_}}},
    {name='S', id=02,shape={{O,O,_},{_,O,O}}},
    {name='J', id=03,shape={{O,O,O},{O,_,_}}},
    {name='L', id=04,shape={{O,O,O},{_,_,O}}},
    {name='T', id=05,shape={{O,O,O},{_,O,_}}},
    {name='O', id=06,shape={{O,O},{O,O}}},
    {name='I', id=07,shape={{O,O,O,O}}},

    -- Pentomino
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

    -- Trimino
    {name='I3',id=26,shape={{O,O,O}}},
    {name='C', id=27,shape={{O,O},{_,O}}},

    -- Domino
    {name='I2',id=28,shape={{O,O}}},

    -- Dot
    {name='O1',id=29,shape={{O}}},
} for i=1,#minoes do minoes[minoes[i].name]=minoes[i] end
return minoes
