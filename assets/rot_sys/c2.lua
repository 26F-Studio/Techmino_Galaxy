
local C2={}
C2.centerPreset='common'
C2.centerTex=GC.load{10,10,
    {'setLW',2},
    {'dRect',2,2,6,6},
}
local kicks={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1','-2+0','+2+0'}
local state={R={test=kicks},L={test=kicks},F={test=kicks}}
for i=1,29 do C2[i]={[0]=state,[1]=state,[2]=state,[3]=state} end
return C2
