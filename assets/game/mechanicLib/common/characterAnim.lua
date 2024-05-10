---@type Map<Techmino.Mech.Basic>
local anim={}

local introTime,outroTime=260,600
local alpha=.626

---@param P Techmino.Player
function anim.start(P,args)
    local md=P.modeData
    args=args or md.character
    assert(type(args)=='table',"args must be table")

    if not md.charAnims then md.charAnims={} end
    if #md.charAnims==0 then
        P:addEvent('always',anim.event_always)
        P:addEvent('drawOnPlayer',anim.event_drawOnPlayer)
    end
    table.insert(md.charAnims,{
        time=0,
        image=args.image or PAPER,
        duration=args.duration or 2600,
    })
end

function anim.event_always(P)
    local md=P.modeData
    if #md.charAnims==0 then return true end
    local i=1
    repeat
        local a=md.charAnims[i]
        a.time=a.time+1
        if a.time>=a.duration then
            table.remove(md.charAnims,i)
        else
            i=i+1
        end
    until i>#md.charAnims
end

function anim.event_drawOnPlayer(P)
    local md=P.modeData
    if #md.charAnims==0 then return true end
    for i=1,#md.charAnims do
        local a=md.charAnims[i]
        local pos=P.pos
        GC.setColor(1,1,1,math.min(1,a.time/introTime,1-(a.time-a.duration+outroTime)/outroTime)*alpha)
        local dy=(a.time-introTime)*(a.time<introTime and .26 or .0626)
        GC.mDraw(a.image,pos.x,pos.y+dy)
    end
end

return anim
