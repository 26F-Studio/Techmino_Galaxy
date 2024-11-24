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
    speedWrite(.08,1,", for YOU")
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
                local t1,t2,t3=.03,.06,.12
                if TABLE.find(args,"overclock") then t1,t2,t3=.01,.03,.05 end
                if TABLE.find(args,"app") then option.launchApplet=args[TABLE.find(args,"app")+1] end
                math.randomseed(os.time())
                local function OK(n) return AE.U[n].."\r[ "..AE._G"OK"..AE.NL[n] end

                feed(t2,
                    "[    ] Finding boot device\n",          t2,
                    ">zde0n1p1  zde0n1p2\n",t2,
                    OK(2),t2,
                    "[    ] Launching bootloader\n",         t2,
                    ">Zeta_loader\n",t2,
                    OK(2),t2,
                    "[    ] Running bootloader\n",           rnd()*t3,OK(1),t2,
                    "[    ] Initializing root-device\n",     rnd()*t3,OK(1),t2,
                    "[    ] Mounting kernal config\n",       rnd()*t3,OK(1),t2,
                    "[    ] Loading kernel variables\n",     rnd()*t3,OK(1),t2,
                    "[    ] Initializing root-fs\n",         rnd()*t3,OK(1),t2,
                    "[    ] Initializing user-fs\n",         rnd()*t3,OK(1),t2,
                    "[    ] Initializing probes\n",          rnd()*t3,
                    " "..        rnd(20,26).."/260 probes initialized\n",rnd()*t2,
                    AE.PL..(" "..rnd(35,42)  )..AE.NL,rnd()*t2,
                    AE.PL..(" "..rnd(62,94)  )..AE.NL,rnd()*t2,
                    AE.PL..(     rnd(126,162))..AE.NL,rnd()*t2,
                    AE.PL..(     rnd(200,226))..AE.NL,rnd()*t2,
                    AE.PL..(     rnd(242,256))..AE.NL,rnd()*t2,
                    AE.PL..(             260 )..AE.NL,t2,
                    OK(2),t2,
                    "[    ] Establishing direct neurolink\n",t2,
                    "0/8 lobes connected\n",rnd(26,42)/100,
                    AE.PL..(1)..AE.NL,rnd()*t2,
                    AE.PL..(2)..AE.NL,rnd()*t2,
                    AE.PL..(3)..AE.NL,rnd()*t2,
                    AE.PL..(4)..AE.NL,rnd()*t2,
                    AE.PL..(5)..AE.NL,rnd()*t2,
                    AE.PL..(6)..AE.NL,rnd()*t2,
                    AE.PL..(7)..AE.NL,rnd()*t2,
                    AE.PL..(8)..AE.NL,rnd()*t2,
                    OK(2),t2,
                    "[    ] Get direct brain access\n",      t2,
                    "Collecting base signal\n",              t2,
                    "Calibrating signal strength\n",         t1,
                    "Decoding signal pattern\n",             t3,
                    "Transfering authority\n",               t2,
                    "Creating middle layer\n",               t2,
                    OK(6),t2,
                    "[    ] Starting audio manager\n",       t2,
                    "Building virtual audio mixing space\n", t1,
                    "Initializing sound simulating system\n",t1,
                    "Seting up objects in space\n",          t2,
                    OK(4),t2,
                    "[    ] Starting display manager\n",     t2,
                    OK(1),t3,"\n"
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
