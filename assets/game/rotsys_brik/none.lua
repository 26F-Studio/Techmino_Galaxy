local None={}
None.centerPreset='common'
None.centerTex=GC.load{w=10,h=10,
    {'setLW',2},
    {'line',2,2,6,6},
}
for i=1,29 do
    None[i]={
        [0]={R={},L={},F={}},
        [1]={R={},L={},F={}},
        [2]={R={},L={},F={}},
        [3]={R={},L={},F={}},
    }
end
return None
