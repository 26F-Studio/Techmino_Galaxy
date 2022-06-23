local arg=arg[1]
if arg=="-apkCode"then
    local code=require"version".apkCode
    print(code)
elseif arg=="-code"then
    local str=require"version".verCode
    print(str)
elseif arg=="-name"then
    local str=require"version".appVer
    print(str)
elseif arg=="-release"then
    local str=require"version".verStr
    print(str)
end
