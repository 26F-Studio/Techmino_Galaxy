local scene={}

function scene.enter()
    BG.set('none')
    playBgm('blank','base')
end

function scene.keyDown(key,isRep)
    if isRep then return end
    if key=='return' then
        SCN.go('game_simp',nil,'mino/sprint')
    elseif key=='c' then
        SCN.go('_console')
    elseif key=='escape' then
        sureCheck('quit')
    end
end

function scene.draw()
    GC.replaceTransform(SCR.xOy_m)
    GC.setColor(1,1,1)
    GC.mDraw(IMG.title.techmino,0,-288,0,.53)
    FONT.set(30)
    GC.mStr(VERSION.appVer,0,-180)
end

scene.widgetList={
    WIDGET.new{type='button_fill',pos={.5,.5},x=-400,y=-20,w=360,h=140, color='R',text=LANG'main_1_sprint',  fontSize=40,cornerR=0,code=playMode'mino/sprint'},
    WIDGET.new{type='button_fill',pos={.5,.5},x=0,   y=-20,w=360,h=140, color='R',text=LANG'main_1_marathon',fontSize=40,cornerR=0,code=playMode'mino/marathon'},
    WIDGET.new{type='button_fill',pos={.5,.5},x=400, y=-20,w=360,h=140, color='R',text=LANG'main_1_ultra',   fontSize=40,cornerR=0,code=playMode'mino/ultra'},
    WIDGET.new{type='button_fill',pos={.5,.5},x=-200,y=160,w=360,h=140, color='B',text=LANG'main_1_tutorial',fontSize=40,cornerR=0,code=WIDGET.c_goScn'tutorial_1'},
    WIDGET.new{type='button_fill',pos={.5,.5},x=200, y=160,w=360,h=140, color='Y',text=LANG'main_1_sandbox', fontSize=40,cornerR=0,code=WIDGET.c_goScn'sandbox_1'},

    WIDGET.new{type='button',     pos={.5,.5},x=-400,y=320,w=360,h=100,text=CHAR.icon.language,              fontSize=70,cornerR=0,code=WIDGET.c_goScn'setting_lang'},
    WIDGET.new{type='button',     pos={.5,.5},x=0,   y=320,w=360,h=100,text=LANG'main_1_settings',           fontSize=40,cornerR=0,code=WIDGET.c_goScn'setting_1'},
    WIDGET.new{type='button',     pos={.5,.5},x=400, y=320,w=360,h=100,text=LANG'main_1_musicroom',          fontSize=40,cornerR=0,code=WIDGET.c_goScn'musicroom'},
}
return scene
