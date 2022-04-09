-- Global color table for minoes
ColorTable={} for i=1,64 do ColorTable[i]={COLOR.hsv((i-1)/64,.9,.9)} end
defaultMinoColor=setmetatable({2,22,42,6,52,12,32},{__index=function() return math.random(64) end})

do-- Minos
    local O,_=true,false
    Minos={
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
    } for i=1,#Minos do Minos[Minos[i].name]=Minos[i] end
end

do
    bgmList={
        ['8-bit happiness']={
            simp={'melody','bass'},
            full={'melody','accompany','bass','drum','sfx'}
        },
        ['8-bit sadness']={
            simp={'melody','bass'},
            full={'melody','decoration','bass','sfx'}
        },
        ['battle']={
            simp={'melody','bass','drum'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['blank']={
            simp={'melody','bass'},
            full={'melody','decoration','bass','drum'},
        },
        ['blox']={
            simp={'melody','decoration1','bass'},
            full={'melody','decoration1','decoration2','bass','drum','sfx'},
        },
        ['distortion']={
            simp={'melody','bass','sfx1','sfx2'},
            full={'melody','accompany1','accompany2','decoration','bass','sfx1','sfx2'},
        },
        ['down']={
            simp={'melody','accompany','bass1'},
            full={'melody','accompany','bass1','bass2','drum','sfx'},
        },
        ['dream']={
            simp={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['echo']={
            simp={'melody1','melody2','bass1'},
            full={'melody1','melody2','bass1','bass2','drum','sfx'},
        },
        ['exploration']={
            simp={'melody2','decoration','bass2','sfx'},
            full={'melody1','melody2','accompany','decoration','bass1','bass2','sfx'},
        },
        ['far']={
            simp={'melody','bass','drum1','drum2'},
            full={'melody','accompany','decoration','bass','drum1','drum2','sfx'},
        },
        ['hope']={
            simp={'melody1','melody2','bass'},
            full={'melody1','melody2','decoration','bass','drum','sfx'},
        },
        ['infinite']={
            simp={'melody1','bass','drum'},
            full={'melody1','melody2','decoration','bass','drum'},
        },
        ['lounge']={
            simp={'bass','drum','sfx'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['minoes']={
            simp={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['moonbeam']={
            simp={'melody','bass'},
            full={'melody','accompany','bass','drum'},
        },
        ['new era']={
            simp={'melody','bass','drum'},
            full={'melody','accompany','decoration','bass','drum'},
        },
        ['overzero']={
            simp={'accompany','bass','sfx'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['oxygen']={
            simp={'melody','accompany','bass','drum'},
            full={'melody','accompany','decoration','bass','drum','sfx'},
        },
        ['peak']={
            simp={'melody','bass','drum'},
            full={'melody','decoration','bass','drum','sfx'},
        },
        ['pressure']={
            simp={'melody1','accompany','decoration','bass','drum1'},
            full={'melody1','melody2','accompany','decoration','bass','drum1','drum2'},
        },
        ['push']={
            simp={'accompany','decoration','bass'},
            full={'melody','accompany','decoration','bass','sfx'},
        },
        ['race']={
            simp={'melody','accompany1','drum'},
            full={'melody','accompany1','accompany2','decoration','drum'},
        },
        ['reason']={
            simp={'melody2','bass'},
            full={'melody1','melody2','bass','drum'},
        },
        ['rectification']={
            simp={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','decoration','bass','drum'},
        },
        ['reminiscence']={
            simp={'melody2','bass','drum'},
            full={'melody1','melody2','melody3','bass','drum'},
        },
        ['secret7th']={
            simp={'melody1','melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['secret8th']={
            simp={'melody1','melody2','bass','drum1'},
            full={'melody1','melody2','melody3','bass','drum1','drum2'},
        },
        ['shining terminal']={
            simp={'melody1','melody2','bass1','drum2'},
            full={'melody1','melody2','decoration','bass1','bass2','drum1','drum2','sfx'},
        },
        ['sine']={
            simp={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum'},
        },
        ['space']={
            simp={'melody1','melody2','bass'},
            full={'melody1','melody2','accompany','decoration','bass'},
        },
        ['spring festival']={
            simp={'melody','accompany','drum1'},
            full={'melody','accompany','bass','drum1','drum2'},
        },
        ['storm']={
            simp={'melody','bass','drum1','sfx'},
            full={'melody','accompany','bass','drum1','drum2','sfx'},
        },
        ['sugar fairy']={
            simp={'melody','bass'},
            full={'melody','accompany','bass','drum'},
        },
        ['supercritical']={
            simp={'melody','accompany','bass','drum1'},
            full={'melody','accompany','decoration','bass','drum1','drum2'},
        },
        ['truth']={
            simp={'melody1','melody2','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx1','sfx2'},
        },
        ['vapor']={
            simp={'melody','bass','drum'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['venus']={
            simp={'melody','accompany','bass'},
            full={'melody','accompany','bass','drum','sfx'},
        },
        ['warped']={
            simp={'melody1','accompany','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['waterfall']={
            simp={'melody1','bass','drum'},
            full={'melody1','melody2','accompany','bass','drum','sfx'},
        },
        ['way']={
            simp={'melody1','bass','drum'},
            full={'melody1','melody2','bass','drum'},
        },
        ['xmas']={
            simp={'melody','bass','drum'},
            full={'melody','accompany1','accompany2','bass','drum'},
        },
    }
    for name,list in next,bgmList do
        for mode,channels in next,list do
            for i=1,#channels do
                channels[i]=name..'/'..channels[i]
            end
        end
    end
end