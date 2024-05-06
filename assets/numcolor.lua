local NumColor={}

for r=0,9 do for g=0,9 do for b=0,9 do
    NumColor[100*r+10*g+b]={r/9,g/9,b/9}
end end end

return NumColor
