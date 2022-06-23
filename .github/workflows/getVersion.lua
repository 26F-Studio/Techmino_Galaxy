local version = require "version"
local res = ""
if arg[1] == "-appName" then
    res = version.appName
elseif arg[1] == "-versionName" then
    res = version.appVer
elseif arg[1] == "-versionString" then
    res = require "version".verStr
elseif arg[1] == "-versionCode" then
    res = require "version".apkCode
end
print(res)
