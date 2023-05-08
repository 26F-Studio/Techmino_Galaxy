local c={}

-- 1~64: normal Colors
for i=1,64 do
    c[i]={COLOR.hsv((i-1)/64,.53,.88)}
end

c[0]=COLOR.DL

return c
