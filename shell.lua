-- [WARNING] Run before main.lua

function simpRequire(path)
    return function(module) return require(path..module) end
end
local _require=require
local require=simpRequire('Zenitha.')
local rnd=math.random
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
    local lastText=0
    local d={...}
    for i=1,#d do
        if type(d[i])=='number' then
            if d[i]>0 then
                sleep(d[i])
            elseif d[i]==-1 then
                write(("\b"):rep(#lastText))
            end
        elseif type(d[i])=='string' then
            write(d[i])
            lastText=d[i]
        else
            error()
        end
    end
end

local rArg=TABLE.sub(arg,(arg[-2]=='love' or arg[-1]=='love') and 2 or 1)

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
function commands.shell(startArg)
    feed(
        .000,AE[425]..  " _____         _         _          "..AE._d"  _  "..AE[115].."  _____     _",
        .260,AE[425].."\n|_   _|___ ___| |_ _____|_|___ ___  "..AE._d" |_| "..AE[115].." |   __|___| |___ _ _ _ _",
        .120,AE[425].."\n  | | | -_|  _|   |     | |   | . | "..AE._d"  _  "..AE[115].." |  |  | .'| | .'|_'_| | |",
        .120,AE[425].."\n  |_| |___|___|_|_|_|_|_|_|_|_|___| "..AE._d" |_| "..AE[115].." |_____|__,|_|__,|_,_|_  |",
        .120,AE[533].."\n  The ultra-improved version of Techmino, for YOU."..AE[115]..         "            |___|",
        .620,AE.."\n\nWelcome to TechOS shell!\n",.260
    )
    local input
    while true do
        if startArg and startArg[1] then
            input=table.concat(startArg," ")
            write("\n> "..input.."\n")
            startArg=nil
        else
            write("\n> ")
            input=io.read()
        end
        if input~='' then
            local args=STRING.split(input," ")
            if args[1]=='help' then
                feed(
                    "Available Commands:\n",
                    "help      Show this help message\n",
                    "start     Continue normal booting process\n",
                    "exit      Interrupt booting process and exit shell\n"
                )
            elseif args[1]=='start' then
                if args[2]=='app' then option.launchApplet=args[3] end
                math.randomseed(os.time())
                local function OK(n) return AE.U[n].."\r[ "..AE._G"OK"..AE.NL[n] end
                feed(.1,
                    "[    ] Finding boot device\n",          .1,
                    ">zde0n1p1  zde0n1p2\n",.1,
                    OK(2),.1,
                    "[    ] Launching bootloader\n",         .1,
                    ">Zeta_loader\n",.1,
                    OK(2),.1,
                    "[    ] Running bootloader\n",           rnd()*.2,OK(1),.1,
                    "[    ] Initializing root-device\n",     rnd()*.2,OK(1),.1,
                    "[    ] Mounting kernal config\n",       rnd()*.2,OK(1),.1,
                    "[    ] Loading kernel variables\n",     rnd()*.2,OK(1),.1,
                    "[    ] Initializing root-fs\n",         rnd()*.2,OK(1),.1,
                    "[    ] Initializing user-fs\n",         rnd()*.2,OK(1),.1,
                    "[    ] Initializing probes\n",          rnd()*.2,
                    " "..        rnd(20,26).."/260 probes initialized\n",rnd()*.1,
                    AE.PL..(" "..rnd(35,42)  )..AE.NL,rnd()*.1,
                    AE.PL..(" "..rnd(62,94)  )..AE.NL,rnd()*.1,
                    AE.PL..(     rnd(126,162))..AE.NL,rnd()*.1,
                    AE.PL..(     rnd(200,226))..AE.NL,rnd()*.1,
                    AE.PL..(     rnd(242,256))..AE.NL,rnd()*.1,
                    AE.PL..(     260         )..AE.NL,.2,
                    OK(2),.1,
                    "[    ] Establishing direct neurolink\n",.1,
                    "0/8 lobes connected\n",rnd(26,42)/100,
                    AE.PL..(1)..AE.NL,rnd()*.1,
                    AE.PL..(2)..AE.NL,rnd()*.1,
                    AE.PL..(3)..AE.NL,rnd()*.1,
                    AE.PL..(4)..AE.NL,rnd()*.1,
                    AE.PL..(5)..AE.NL,rnd()*.1,
                    AE.PL..(6)..AE.NL,rnd()*.1,
                    AE.PL..(7)..AE.NL,rnd()*.1,
                    AE.PL..(8)..AE.NL,rnd()*.1,
                    OK(2),.1,
                    "[    ] Get direct brain access\n",      .1,
                    "Collecting base signal\n",              .06,
                    "Calibrating signal strength\n",         .04,
                    "Decoding signal pattern\n",             .12,
                    "Transfering authority\n",               .06,
                    "Creating middle layer\n",               .06,
                    OK(6),.1,
                    "[    ] Starting audio manager\n",       .1,
                    "Building virtual audio mixing space\n", .02,
                    "Initializing sound simulating system\n",.04,
                    "Seting up objects in space\n",          .06,
                    OK(4),.1,
                    "[    ] Starting display manager\n",     .1,
                    OK(1),.2,"\n"
                )
                break
            elseif args[1]=='exit' then
                feed("Exiting shell...",.3,"\n")
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
    commands.shell(TABLE.sub(rArg,2))
elseif rArg[1]=='-v' or rArg[1]=='--version' then
    commands.version()
elseif rArg[1] then
    commands.unknown()
end

return option
