---@type Zenitha.Scene
local scene={}
local issuer=WIDGET.new{type='inputBox',pos={0,0},x=340,y=180,w=1160,h=60,fontSize=28,maxInputLength=2048}
local cadence=WIDGET.new{type='inputBox',pos={0,0},x=340,y=285,w=1160,h=60,fontSize=28,maxInputLength=2048}
local website=WIDGET.new{type='inputBox',pos={0,0},x=340,y=390,w=1160,h=60,fontSize=28,maxInputLength=2048}
local function configure()
    return ACCOUNT.configure{tesseraOrigin=STRING.trim(issuer:getText()),cadenceOrigin=STRING.trim(cadence:getText()),websiteOrigin=STRING.trim(website:getText()),webRedirectUri=ACCOUNT.session.config.webRedirectUri}
end
local function login()
    if configure() then ACCOUNT.login() end
end
function scene.load()
    BG.set('none')
    local config=ACCOUNT.session.config
    issuer:setText(config.tesseraOrigin or '')
    cadence:setText(config.cadenceOrigin or '')
    website:setText(config.websiteOrigin or '')
end
function scene.unload()
    if ACCOUNT.session.login then ACCOUNT.cancel() end
end
function scene.keyDown(key,isRep)
    if isRep then return true end
    if key=='escape' or KEYMAP.sys:getAction(key)=='back' then ACCOUNT.cancel() SCN.back('fadeHeader')
    elseif key=='return' or key=='kpenter' then if not ACCOUNT.session:isAuthenticated() then login() end
    else return true end
end
function scene.draw()
    PROGRESS.drawExteriorHeader()
    GC.replaceTransform(SCR.xOy)
    GC.setColor(1,1,1)
    FONT.set(28)
    GC.printf('Separate product: techminoGalaxy. Techmino room credentials are never borrowed.\nThe browser owns passwords, email verification, recovery and authorization consent.\nThis account integration does not create Galaxy multiplayer game modes.',70,480,1450,'left')
    GC.printf('Session: '..ACCOUNT.session.status..' / trusted identity: '..ACCOUNT.identityStatus,70,620,1450,'left')
    if ACCOUNT.session.user then
        GC.printf(ACCOUNT.session.user.name..' / '..ACCOUNT.session.user.id,70,670,1450,'left')
        GC.printf('Device grant: '..tostring(ACCOUNT.session.grantId),70,715,1450,'left')
    end
    FONT.set(24)
    GC.printf(ACCOUNT.session:storageNotice(),70,765,1450,'left')
    if ACCOUNT.session.error then GC.setColor(1,.5,.4) GC.printf(ACCOUNT.session.error.code..': '..ACCOUNT.session.error.message,70,805,1450,'left') end
end
scene.widgetList={
    {type='button_fill',pos={0,0},x=120,y=60,w=180,h=70,fillColor='B',cornerR=15,sound_release='button_back',fontSize=40,text=BackText,onClick=WIDGET.c_backScn'fadeHeader'},
    {type='text',pos={0,0},x=250,y=60,alignX='left',fontType='bold',fontSize=45,text='Galaxy account / device session'},
    {type='text',pos={0,0},x=70,y=205,alignX='left',fontSize=30,text='Tessera API'},issuer,
    {type='text',pos={0,0},x=70,y=310,alignX='left',fontSize=30,text='Cadence API'},cadence,
    {type='text',pos={0,0},x=70,y=415,alignX='left',fontSize=30,text='Account website'},website,
    {type='button',pos={0,1},x=270,y=-75,w=380,h=90,fontSize=30,text='Sign in with browser',onClick=login,visibleTick=function() return not ACCOUNT.session.login and not ACCOUNT.session:isAuthenticated() end},
    {type='button',pos={0,1},x=270,y=-75,w=380,h=90,fontSize=30,text='Cancel authorization',onClick=ACCOUNT.cancel,visibleTick=function() return ACCOUNT.session.login~=false end},
    {type='button',pos={0,1},x=270,y=-75,w=380,h=90,fontSize=28,color='R',text='Revoke this Galaxy session',onClick=function()
        if not TASK.lock('confirmGalaxyRevoke',2) then ACCOUNT.revoke() else MSG('warn','Press again within two seconds to revoke this Galaxy device session.',2) end
    end,visibleTick=function() return ACCOUNT.session:isAuthenticated() end},
    {type='button',pos={0,1},x=720,y=-75,w=380,h=90,fontSize=28,text='Restore saved session',onClick=function() if configure() then ACCOUNT.restore() end end,visibleTick=function() return not ACCOUNT.session.login and not ACCOUNT.session:isAuthenticated() end},
    {type='button',pos={0,1},x=720,y=-75,w=380,h=90,fontSize=28,text='Account / grants',onClick=function() ACCOUNT.website('/account') end,visibleTick=function() return ACCOUNT.session:isAuthenticated() end},
    {type='button',pos={0,1},x=1170,y=-75,w=380,h=90,fontSize=28,text='Password recovery',onClick=function() if ACCOUNT.session:isAuthenticated() or configure() then ACCOUNT.website('/account/recover') end end},
}
return scene
