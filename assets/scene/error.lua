local time,err,img
local imgW,imgH
local texts={
    "Techmino ran into a problem and needs to restart. You can send the error log to the developers.",
    "Une erreur est survenue et Techmino doit redémarrer. Des informations concernant l’erreur ont été créées, et vous pouvez les envoyer au créateur.",
    "Ha ocurrido un error y Techmino necesita reiniciarse. Se creó un registro de error, puedes enviarlo al autor.",
    "Techmino mengalami eror dan harus memuat ulang. Anda bisa mengirim log eror ke developer.",
    "問題が発生！ゲームを再起動してください、できるならエラーログを開発者に送ってください。",
    "Techmino遭受了雷击，需要重新启动。我们已收集了一些错误信息，你可以向作者进行反馈。",
}
local scene={}

function scene.enter()
    time=0
    err=Zenitha.getErr('#')
    if not err then
        GC.setDefaultFilter('nearest','nearest')
        err={
            scene="NULL",
            mes={"??????????????????????????","","TRACEFORWARD","??????","?????","????","???","??","?"},
            shot=GC.load{200,120,
                {'setLW',2},
                {'setCL',1,1,1,.2},
                {'fRect',0,0,200,120},
                {'setCL',COLOR.L},
                {'setFT',60},
                {'print','?',118,95,MATH.pi},
            },
        }
        GC.setDefaultFilter('linear','linear')
    end
    table.insert(err.mes,"")
    table.insert(err.mes,SYSTEM.."-"..VERSION.appVer)
    table.insert(err.mes,"Scene: "..err.scene)
    Zenitha.setVersionText("")
end

function scene.update(dt)
    if not img and time<5 then
        time=time+dt
        img=err.shot
        if img then
            imgW,imgH=img:getWidth(),img:getHeight()
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
    GC.rectangle('fill',-35,-240,70,270)
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
    FONT.set(20,'thin')
    GC.printf(err.mes[1],SCR.safeX+20,20,626)
    for i=3,#err.mes do
        GC.print(err.mes[i],SCR.safeX+20,30+20*i)
    end

    -- Screenshot
    if img then
        GC.replaceTransform(SCR.xOy_ur)
        GC.setColor(1,1,1,.26)
        GC.draw(img,0,0,nil,16*36/imgW,9*36/imgH,imgW,0)
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={.5,1},x=-130,y=-100,w=220,h=100,fontSize=75,text=CHAR.icon.console,code=WIDGET.c_goScn'_console'},
    WIDGET.new{type='button',pos={.5,1},x=130,y=-100,w=220,h=100,fontSize=70,text=CHAR.icon.cross_big,code=love.event.quit},
}

return scene
