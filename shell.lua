-- [WARNING] Run before main.lua

function simpRequire(path)
    return function(module) return require(path..module) end
end
local _require=require
local require=simpRequire('Zenitha.')
STRING=require'stringExtend'
TABLE=require'tableExtend'
AE=require'escape'

local stdout=io.stdout
function write(text)
    stdout:write(text)
    stdout:flush()
end
local function sleep(time)
    if love._os=='Linux' then
        os.execute('sleep '..time)
    else
        local fin=os.clock()+time
        repeat until os.clock()>fin
    end
end
local function feed(...)
    local d={...}
    for i=1,#d do
        if type(d[i])=='number' then
            sleep(d[i])
        else
            write(d[i])
        end
    end
end

local rArg=TABLE.sub(arg,(arg[-2]=='love' or arg[-1]=='love') and 2 or 1)

for k,v in next,rArg do print(k,v)end

local option={}

local commands={}
function commands.help()
    option.bootDisabled=true
    feed(
        "\n",
        AE[533].."TechOS"..AE.." help page\n",
        .260,
        "[no args]        "..AE._d"Start default booting process\n",
        "-h, --help       "..AE._d"Show this help message then exit\n",
        "-v, --version    "..AE._d"Show version information then exit\n",
        "-s, --shell      "..AE._d"Start the interactive shell\n",
        .120
    )
end
function commands.version()
    option.bootDisabled=true
    sleep(.1)
    print(("TechOS %s (%s)"):format(_require'version'.appVer,_require'version'.verCode))
end
function commands.shell()
    feed(
        .000,AE[425]..  " _____         _         _          "..AE._d"  _  "..AE[005].."  _____     _",
        .260,AE[425].."\n|_   _|___ ___| |_ _____|_|___ ___  "..AE._d" |_| "..AE[005].." |   __|___| |___ _ _ _ _",
        .120,AE[425].."\n  | | | -_|  _|   |     | |   | . | "..AE._d"  _  "..AE[005].." |  |  | .'| | .'|_'_| | |",
        .120,AE[425].."\n  |_| |___|___|_|_|_|_|_|_|_|_|___| "..AE._d" |_| "..AE[005].." |_____|__,|_|__,|_,_|_  |",
        .120,AE[533].."\n  The ultra-improved version of Techmino, for YOU."..AE[005]..         "            |___|",
        .620,AE.."\n\nWelcome to the TechOS shell!\n",.260
    )
    while true do
        write("\n> ")
        local input=io.read()
        if input~='' then
            local args=STRING.split(input,' ')
            if args[1]=='help' then
                feed(
                    "Available Commands:\n",
                    "help      Show this help message\n",
                    "start     Continue normal booting process\n",
                    "exit      Interrupt booting process and exit shell\n"
                )
            elseif args[1]=='start' then
                if args[2]=='app' then
                    option.launchApplet=args[3]
                end
                feed(.1,"Starting application...\n",.1)
                break
            elseif args[1]=='exit' then
                print("Exiting shell...")
                option.bootDisabled=true
                break
            else
                print("Unknown command. Try 'help'")
            end
        end
    end
end
function commands.unknown()
    print("Unknown switch. Run with '--help' for help.")
    option.bootDisabled=true
end

if     rArg[1]=="-h" or rArg[1]=="--help" then
    commands.help()
elseif rArg[1]=='-s' or rArg[1]=='--shell' then
    commands.shell()
elseif rArg[1]=='-v' or rArg[1]=='--version' then
    commands.version()
else
    commands.unknown()
end

return option
