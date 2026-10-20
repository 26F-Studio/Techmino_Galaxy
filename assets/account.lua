local Json=require'assets.online.json'
local Config=require'assets.online.config'
local Session=require'assets.online.session'
local Account={identity=false,identityStatus='signed_out',nextValidation=0,validating=false,closed=false,serial=0}
local function notify(kind,message) MSG(kind,message,6) end
Account.session=Session.new{
    productId='techminoGalaxy',transport='Zenitha.transport',json=Json,config=Config.load(),notify=notify,
    onSession=function(session)
        Account.identity=false
        Account.identityStatus=session:isAuthenticated() and 'validating' or 'signed_out'
        Account.nextValidation=0
        Account.serial=Account.serial+1
    end,
}
local function uuid(value)
    return type(value)=='string' and #value==36 and value:match('^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$')~=nil
end
function Account.configure(config)
    local ok,err=Account.session:configure(config)
    if ok then Config.save(Account.session.config) else notify('error',err) end
    return ok
end
function Account.login() Account.session:beginLogin() end
function Account.cancel() Account.session:cancelLogin() end
function Account.restore()
    return Account.session:refresh()
end
function Account.revoke()
    Account.session:logout(function(ok)
        if ok then Account.identity=false Account.identityStatus='signed_out' notify('check','The Techmino Galaxy device grant was revoked. Techmino grants are unaffected.') end
    end)
end
function Account.website(path)
    local origin=Account.session.config.websiteOrigin
    if origin then love.system.openURL(origin..(path or '/account')) else notify('error','Configure the account website origin first.') end
end
function Account:validateIdentity()
    if self.validating or not self.session:isAuthenticated() then return end
    self.validating=true
    local credential=self.session.accessToken
    self.session:request('cadence','/v1/products/techminoGalaxy/identity','GET',nil,function(identity,err)
        self.validating=false
        self.nextValidation=love.timer.getTime()+3
        if credential~=self.session.accessToken then return end
        if err then
            self.identity=false
            self.identityStatus='validation_unavailable'
            if err.status==401 or err.status==403 then self.session:authorizationEnded() end
            self.session:report(err)
            return
        end
        if type(identity)~='table' or identity.productId~='techminoGalaxy' or not uuid(identity.subject) or identity.subject~=self.session.user.id or identity.grantId~=self.session.grantId then
            self.identity=false
            self.identityStatus='invalid_identity'
            self.session:report{code='INVALID_IDENTITY',message='The game service did not validate this separate Galaxy product grant.'}
            return
        end
        self.identity=identity
        self.identityStatus='active'
        self.identityValidUntil=love.timer.getTime()+5
        self.serial=self.serial+1
    end,true)
end
function Account.update()
    if Account.closed then return end
    Account.session:update()
    if Account.session.client then
        for _=1,64 do
            local event=Account.session.client:poll()
            if not event then break end
            local ok=pcall(Account.session.handle,Account.session,event)
            if not ok then Account.session:report{code='INVALID_RESPONSE',message='A malformed account response was isolated.'} end
        end
    end
    if Account.identity and love.timer.getTime()>Account.identityValidUntil then
        Account.identity=false
        Account.identityStatus='validation_unavailable'
    end
    if love.timer.getTime()>=Account.nextValidation then Account:validateIdentity() end
end
function Account.start()
    Config.removeLegacyCredentials()
    TASK.new(function()
        while not Account.closed do coroutine.yield() Account.update() end
    end)
end
function Account.close()
    Account.closed=true
    Account.session:close()
end
return Account
