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
local function speedWrite(intvl,spd,text)
    for i=1,#text,spd do
        write(text:sub(i,i+spd-1))
        sleep(intvl)
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

local rArg=TABLE.sub(arg,((arg[1] or ""):sub(1,1)=='-') and 1 or 2)

local option={}

local commands={}
function commands.help()
    option.bootDisabled=true
    print(AE[533].."TechOS"..AE.." help page")
    feed(AE.."[no args]        "..AE._d,.1) speedWrite(.01,3,"Start default booting process\n")
    feed(AE.."-h, --help       "..AE._d,.1) speedWrite(.01,3,"Show this help message then exit\n")
    feed(AE.."-v, --version    "..AE._d,.1) speedWrite(.01,3,"Show version information then exit\n")
    feed(AE.."-s, --shell      "..AE._d,.1) speedWrite(.01,3,"Start the interactive shell\n")
end
function commands.version()
    option.bootDisabled=true
    sleep(.26)
    speedWrite(.02,1,("TechOS %s (%s)\n"):format(_require'version'.appVer,_require'version'.verCode))
end
function commands.shell(startArg)
    startArg=startArg or {}
    feed(
        AE[425],
        " _____         _         _          \n",
        "|_   _|___ ___| |_ _____|_|___ ___  \n",
        "  | | | -_|  _|   |     | |   | . | \n",
        "  |_| |___|___|_|_|_|_|_|_|_|_|___| \n",
        .42,AE[533].." The ultra-improved version of Techmino",
        AE._d..AE.U[4]..'\r'..AE.R[36],
        " _ "..AE.L[3]..AE.D,
        "|_|"..AE.L[3]..AE.D,
        " _ "..AE.L[3]..AE.D,
        "|_|"..AE.D,.626,
        AE.U[4]..AE[115]
    )
    speedWrite(.01,3,"  _____     _")              write(AE.L[13]..AE.D)
    speedWrite(.01,3," |   __|___| |___ _ _ _ _ ") write(AE.L[26]..AE.D)
    speedWrite(.01,3," |  |  | .'| | .'|_'_| | |") write(AE.L[26]..AE.D)
    speedWrite(.01,3," |_____|__,|_|__,|_,_|_  |") write(AE.L[26]..AE.D..(" "):rep(21))
    speedWrite(.01,3,                     "|___|") write(AE.NL..AE.R[39])
    write(AE[533])
    speedWrite(.1,1,", for YOU")
    feed(.42,AE.."\n\nWelcome to TechOS shell (tty1)")

    local input
    while true do
        if startArg[1] then
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
                feed(.06,
                    "[    ] Finding boot device\n",          .06,
                    ">zde0n1p1  zde0n1p2\n",.06,
                    OK(2),.06,
                    "[    ] Launching bootloader\n",         .06,
                    ">Zeta_loader\n",.06,
                    OK(2),.06,
                    "[    ] Running bootloader\n",           rnd()*.1,OK(1),.06,
                    "[    ] Initializing root-device\n",     rnd()*.1,OK(1),.06,
                    "[    ] Mounting kernal config\n",       rnd()*.1,OK(1),.06,
                    "[    ] Loading kernel variables\n",     rnd()*.1,OK(1),.06,
                    "[    ] Initializing root-fs\n",         rnd()*.1,OK(1),.06,
                    "[    ] Initializing user-fs\n",         rnd()*.1,OK(1),.06,
                    "[    ] Initializing probes\n",          rnd()*.1,
                    " "..        rnd(20,26).."/260 probes initialized\n",rnd()*.05,
                    AE.PL..(" "..rnd(35,42)  )..AE.NL,rnd()*.05,
                    AE.PL..(" "..rnd(62,94)  )..AE.NL,rnd()*.05,
                    AE.PL..(     rnd(126,162))..AE.NL,rnd()*.05,
                    AE.PL..(     rnd(200,226))..AE.NL,rnd()*.05,
                    AE.PL..(     rnd(242,256))..AE.NL,rnd()*.05,
                    AE.PL..(     260         )..AE.NL,.06,
                    OK(2),.06,
                    "[    ] Establishing direct neurolink\n",.06,
                    "0/8 lobes connected\n",rnd(26,42)/100,
                    AE.PL..(1)..AE.NL,rnd()*.05,
                    AE.PL..(2)..AE.NL,rnd()*.05,
                    AE.PL..(3)..AE.NL,rnd()*.05,
                    AE.PL..(4)..AE.NL,rnd()*.05,
                    AE.PL..(5)..AE.NL,rnd()*.05,
                    AE.PL..(6)..AE.NL,rnd()*.05,
                    AE.PL..(7)..AE.NL,rnd()*.05,
                    AE.PL..(8)..AE.NL,rnd()*.05,
                    OK(2),.06,
                    "[    ] Get direct brain access\n",      .06,
                    "Collecting base signal\n",              .06,
                    "Calibrating signal strength\n",         .04,
                    "Decoding signal pattern\n",             .12,
                    "Transfering authority\n",               .06,
                    "Creating middle layer\n",               .06,
                    OK(6),.06,
                    "[    ] Starting audio manager\n",       .06,
                    "Building virtual audio mixing space\n", .02,
                    "Initializing sound simulating system\n",.04,
                    "Seting up objects in space\n",          .06,
                    OK(4),.06,
                    "[    ] Starting display manager\n",     .06,
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
