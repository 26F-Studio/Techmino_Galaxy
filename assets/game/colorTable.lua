local c={}

-- 1~64: normal Colors
for i=1,64 do
    c[i]={COLOR.hsv((i-1)/64,.6,.83)}
end

c[0]=COLOR.DL

return c
