local modeLib={}

local MODE={}
function MODE.get(name)
    if modeLib[name] then
        return modeLib[name]
    else
        local path='assets/mode/'..name..'.lua'
        if FILE.isSafe(path) then
            modeLib[name]=FILE.load(path,'-lua')
            return modeLib[name]
        end
    end
end

return MODE
