local gc=love.graphics
local ins,rem=table.insert,table.remove

local map={
    a     ={'a','あ','安','ア','阿',basic=true},
    i     ={'i','い','以','イ','伊',basic=true},
    u     ={'u','う','宇','ウ','宇',basic=true},
    e     ={'e','え','衣','エ','江',basic=true},
    o     ={'o','お','於','オ','於',basic=true},
    ka    ={'ka','か','加','カ','加',basic=true},
    ki    ={'ki','き','幾','キ','幾',basic=true},
    ku    ={'ku','く','久','ク','久',basic=true},
    ke    ={'ke','け','計','ケ','介',basic=true},
    ko    ={'ko','こ','己','コ','己',basic=true},
    sa    ={'sa','さ','左','サ','散',basic=true},
    si    ={'shi','し','之','シ','之',basic=true},
    su    ={'su','す','寸','ス','须',basic=true},
    se    ={'se','せ','世','セ','世',basic=true},
    so    ={'so','そ','曾','ソ','曾',basic=true},
    ta    ={'ta','た','太','タ','多',basic=true},
    ti    ={'chi','ち','知','チ','千',basic=true},
    tu    ={'tsu','つ','川','ツ','川',basic=true},
    te    ={'te','て','天','テ','天',basic=true},
    to    ={'to','と','止','ト','止',basic=true},
    na    ={'na','な','奈','ナ','奈',basic=true},
    ni    ={'ni','に','仁','ニ','二',basic=true},
    nu    ={'nu','ぬ','奴','ヌ','奴',basic=true},
    ne    ={'ne','ね','祢','ネ','祢',basic=true},
    no    ={'no','の','乃','ノ','乃',basic=true},
    ha    ={'ha','は','波','ハ','八',basic=true},
    hi    ={'hi','ひ','比','ヒ','比',basic=true},
    hu    ={'fu','ふ','不','フ','不',basic=true},
    he    ={'he','へ','部','ヘ','部',basic=true},
    ho    ={'ho','ほ','保','ホ','保',basic=true},
    ma    ={'ma','ま','末','マ','矛',basic=true},
    mi    ={'mi','み','美','ミ','三',basic=true},
    mu    ={'mu','む','武','ム','牟',basic=true},
    me    ={'me','め','女','メ','女',basic=true},
    mo    ={'mo','も','毛','モ','毛',basic=true},
    ya    ={'ya','や','也','ヤ','也',basic=true},
    yi    ={'i','い','以','イ','伊',basic=true,ignore=true},
    yu    ={'yu','ゆ','由','ユ','由',basic=true},
    ye    ={'e','え','衣','エ','江',basic=true,ignore=true},
    yo    ={'yo','よ','与','ヨ','与',basic=true},
    ra    ={'ra','ら','良','ラ','良',basic=true},
    ri    ={'ri','り','利','リ','利',basic=true},
    ru    ={'ru','る','留','ル','流',basic=true},
    re    ={'re','れ','礼','レ','礼',basic=true},
    ro    ={'ro','ろ','吕','ロ','吕',basic=true},
    wa    ={'wa','わ','和','ワ','和',basic=true},
    wi    ={'wi','ゐ','为','ヰ','井',basic=true,ignore=true},
    wu    ={'u','う','宇','ウ','宇',basic=true,ignore=true},
    we    ={'we','ゑ','惠','ヱ','惠',basic=true,ignore=true},
    wo    ={'wo','を','远','ヲ','乎',basic=true},
    n     ={'n','ん','无','ン','尓',basic=true},

    ga    ={'ga','が','加','ガ','加'},
    gi    ={'gi','ぎ','幾','ギ','幾'},
    gu    ={'gu','ぐ','久','グ','久'},
    ge    ={'ge','げ','計','ゲ','介'},
    go    ={'go','ご','己','ゴ','己'},
    za    ={'za','ざ','左','ザ','散'},
    zi    ={'ji','じ','之','ジ','之'},
    zu    ={'zu','ず','寸','ズ','须'},
    ze    ={'ze','ぜ','世','ゼ','世'},
    zo    ={'zo','ぞ','曾','ゾ','曾'},
    da    ={'da','だ','太','ダ','多'},
    di    ={'di','ぢ','知','ヂ','千'},
    du    ={'du','づ','川','ヅ','川'},
    de    ={'de','で','天','デ','天'},
    ['do']={'do','ど','止','ド','止'},
    ba    ={'ba','ば','波','バ','八'},
    bi    ={'bi','び','比','ビ','比'},
    bu    ={'bu','ぶ','不','ブ','不'},
    be    ={'be','べ','部','ベ','部'},
    bo    ={'bo','ぼ','保','ボ','保'},
    pa    ={'pa','ぱ','波','パ','八'},
    pi    ={'pi','ぴ','比','ピ','比'},
    pu    ={'pu','ぷ','不','プ','不'},
    pe    ={'pe','ぺ','部','ペ','部'},
    po    ={'po','ぽ','保','ポ','保'},
}
local remap={}
for id,c in next,map do
    if not c.ignore then remap[c[1]]=id end
end

local list={basic={},full={}}
for id,char in next,map do
    if not char.ignore then
        ins(list.full,id)
        if char.basic then ins(list.basic,id) end
    end
end
local ___,____=false,false
local basicMap={
    {'a','ka','sa','ta','na','ha','ma','ya','ra','wa'},
    {'i','ki','si','ti','ni','hi','mi','yi','ri','wi'},
    {'u','ku','su','tu','nu','hu','mu','yu','ru','wu'},
    {'e','ke','se','te','ne','he','me','ye','re','we'},
    {'o','ko','so','to','no','ho','mo','yo','ro','wo','n'},
    {},
    {___,'ga','za','da',____,'ba','pa'},
    {___,'gi','zi','di',____,'bi','pi'},
    {___,'gu','zu','du',____,'bu','pu'},
    {___,'ge','ze','de',____,'be','pe'},
    {___,'go','zo','do',____,'bo','po'},
}

---@type 'map' | 'quest'
local mode
local basic=false
local cap=false
local questID
local input
local lockTimer
local judge
local weights

---@type Zenitha.Scene
local scene={}

function scene.load()
    mode='map'
end

local function newQuest()
    local old=questID
    repeat
        questID=MATH.randFreqAll(weights)
    until questID~=old
    input=""
    lockTimer=false

    for id in next,weights do
        weights[id]=weights[id]+1
    end
    judge=false
end
local function newGame()
    weights=TABLE.getValueSet(basic and list.basic or list.full,260)
    newQuest()
end

function scene.keyDown(key,isRep)
    if isRep then return true end
    if mode=='map' then
        if key=='tab' then
            mode='quest'
            basic,cap=true,false
            newGame()
        elseif key=='1' then
            basic=not basic
        elseif key=='2' then
            cap=not cap
        end
    elseif mode=='quest' then
        if key=='tab' then
            mode='map'
            basic,cap=true,false
            lockTimer=false
        elseif key=='1' then
            basic=not basic
            newGame()
        elseif key=='2' then
            cap=not cap
            newGame()
        elseif key=='backspace' or key=='space' or key=='delete' then
            input=""
        elseif #key==1 and key:find('[a-z]') and not lockTimer then
            if key=='l' then key='r' end
            if key=='v' then key='b' end
            input=input..key
            if input==map[questID][1] then
                FMOD.effect('beep_rise')
                lockTimer=0.26
                judge='T'
                weights[questID]=weights[questID]*.626
            elseif remap[input] and input~='n' or #input>=3 then
                FMOD.effect('beep_drop')
                weights[questID]=weights[questID]+620
                if weights[remap[input]] then weights[remap[input]]=weights[remap[input]]+620 end
                lockTimer=0.626
                judge='F'
            end
        elseif key=='/' then
            if not lockTimer then
                FMOD.effect('beep_notice')
                input=map[questID][1]
                lockTimer=0.626
                judge='H'
                weights[questID]=weights[questID]+2600
            end
        end
    end
    return true
end

function scene.update(dt)
    if lockTimer then
        lockTimer=lockTimer-dt
        if lockTimer<=0 then
            if judge=='F' then
                input=""
                judge=false
                lockTimer=false
            else
                newQuest()
            end
        end
    end
end

local gc_print=gc.print
local setFont=FONT.set
function scene.draw()
    gc.replaceTransform(SCR.xOy_u)
    gc.scale(2)
    if mode=='map' then
        local charIndex=cap and 4 or 2
        for y=1,#basicMap do
            for x=1,#basicMap[y] do
                local c=map[basicMap[y][x]]
                if c then
                    gc.setColor(c.ignore and COLOR.lD or COLOR.L)
                    setFont(30)
                    gc_print(c[charIndex],(x-6.3)*72,y*35)
                    setFont(15)
                    gc_print(c[1],(x-6.3)*72+30,y*35+15)
                end
            end
        end
    else
        gc.setColor(COLOR.L)
        FONT.set(20)
        GC.mStr(basic and '基本' or '全部',-30,100)
        GC.mStr(cap and '片假' or '平假',30,100)

        FONT.set(80,'bold')
        GC.mStr(map[questID][cap and 4 or 2],0,130)
        gc.setColor(lockTimer and (judge=='T' and COLOR.G or judge=='H' and COLOR.Y or COLOR.R) or COLOR.L)
        GC.mStr(input,0,220)

        gc.setColor(COLOR.L)
        FONT.set(10)
        local l=basic and list.basic or list.full
        for i=1,#l do
            gc_print(map[l[i]][2],-400+10*i,420)
            gc.rectangle('fill',-400+1+10*i,420,7,-weights[l[i]]*0.0626)
        end
    end
end

scene.widgetList={
    WIDGET.new{type='button',pos={1,1},x=-120,y=-80,w=160,h=80,sound_trigger='button_back',fontSize=60,text=CHAR.icon.back,code=WIDGET.c_backScn()},
}

return scene
