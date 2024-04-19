-- A macOS-style error scene

local time=0
local err,img
local imgW,imgH
local texts={
    "Techmino ran into a problem and needs to restart. You can send the error log to the developers.",
    "Une erreur est survenue et Techmino doit redémarrer. Des informations concernant l’erreur ont été créées, et vous pouvez les envoyer au créateur.",
    "Ha ocurrido un error y Techmino necesita reiniciarse. Se creó un registro de error, puedes enviarlo al autor.",
    "Techmino mengalami eror dan harus memuat ulang. Anda bisa mengirim log eror ke developer.",
    "問題が発生！ゲームを再起動してください、できるならエラーログを開発者に送ってください。",
    "Techmino终端被高能粒子射线击中产生错误，需要重新启动。你可以将上面的错误信息反馈给作者。",
}
local scene={}

function scene.enter()
    FMOD.music.stop()
    time=0
    err=Zenitha.getErr('#') or {
        scene="NULL",
        msg={"??????????????????????????","","TRACEFORWARD","??????","?????","????","???","??","?"},
        shot=GC.load{200,120,
            {'setLW',2},
            {'setCL',1,1,1,.2},
            {'fRect',0,0,200,120},
            {'setCL',COLOR.L},
            {'setFT',60},
            {'print','?',118,95,MATH.pi},
        },
    }
    table.insert(err.msg,"")
    table.insert(err.msg,SYSTEM.."-"..VERSION.appVer)
    table.insert(err.msg,"Scene: "..err.scene)
    Zenitha.setVersionText("")
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='escape' then
        PROGRESS.quit()
    end
end

function scene.update(dt)
    if time<5 then
        time=time+dt
        if not img then
            img=err.shot
            if img then
                imgW,imgH=img:getWidth(),img:getHeight()
            end
        end
    end
end

function scene.draw()
    GC.clear(.1,.1,.11)

    -- Icon
    GC.replaceTransform(SCR.xOy_m)
    GC.translate(0,62)
    GC.scale(.8)
    GC.setColor(.26,.26,.26)
    GC.circle('fill',0,0,326)
    GC.setColor(.1,.1,.11)
    GC.mRect('fill',0,-105,70,270)
    GC.setLineWidth(70)
    GC.arc('line','open',0,0,210,-.926,3.1415927+.926)

    -- Texts
    GC.replaceTransform(SCR.xOy_m)
    GC.translate(0,62)
    FONT.set(20)
    GC.setColor(COLOR.L)
    for i=1,#texts do
        GC.printf(texts[i],-430,-290+80*i,860)
    end

    GC.replaceTransform(SCR.xOy_ul)

    -- Error infos
    GC.setColor(COLOR.L)
    FONT.set(20)
    GC.printf(err.msg[1],SCR.safeX+20,20,626)
    for i=3,#err.msg do
        GC.print(err.msg[i],SCR.safeX+20,30+20*i)
    end

    -- Screenshot
    if img then
        GC.replaceTransform(SCR.xOy_ur)
        local t=math.max(time-.26,0)*.626
        t=t<.5 and 4*t^3 or 1-4*(1-t)^3 -- EaseInOutCubic
        t=MATH.clamp(t,0,1)
        GC.setColor(1,1,1,MATH.lerp(1,.355,t))
        local kx=MATH.lerp(SCR.w/SCR.k,16*36,t)/imgW
        local ky=MATH.lerp(SCR.h/SCR.k,9*36,t)/imgH
        GC.draw(img,0,0,nil,kx,ky,imgW,0)
    end
end

scene.widgetList={
    {type='button',pos={.5,1},x=-130,y=-100,w=220,h=100,fontSize=75,text=CHAR.icon.console,code=WIDGET.c_goScn'_console',visibleTick=function() return time>1 end},
    {type='button',pos={.5,1},x=130,y=-100,w=220,h=100,fontSize=70,text=CHAR.icon.cross_big,code=WIDGET.c_pressKey'escape',visibleTick=function() return time>1 end},
}

return scene
