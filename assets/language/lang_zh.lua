---@class Techmino.I18N
local L={
    -- Info
    sureText={
        back="再按一次返回",
        quit="再按一次退出",
        reset="再按一次重置",
        enter="再按一次进入",
    },
    setting_needRestart="该设置需要重启后生效",
    noMode="无法加载模式 '$1': $2",
    interior_crash="沙箱意外退出:性能评分越界",
    booting_changed="引导程序已更改",
    musicroom_lowVolume="请调高音乐音量（开关在右下角）",
    bgm_collected="收集到音乐: $1",
    autoGC="[Auto GC] 设备内存过低",

    -- In-Game
    clearName={
        "Single",
        "Double",
        "Triple",
        "Techrash",
        "Pentacrash",
        "Hexacrash",
        "Heptacrash",
        "Octacrash",
        "Nonacrash",
        "Decacrash",
        "Undecacrash",
        "Dodecacrash",
        "Tridecacrash",
        "Tetradecacrash",
        "Pentadecacrash",
        "Hexadecacrash",
        "Heptadecacrash",
        "Octadecacrash",
        "Nonadecacrash",
        "Ultracrash",
        "Impossicrash",
    },
    clearLines="$1 Lines",

    combo_small="$1 Combo",
    combo_large="$1 Combo!",
    mega_combo="MEGACMB",

    charge="CHG",
    spin='$1-spin',
    tuck='Tuck',

    allClear='ALL CLEAR',
    halfClear='Half Clear',

    target_piece="块数",
    target_line="行数",
    target_time="时间",
    target_ac="全消",
    target_hc="半全消",
    target_tsd="TSD",
    target_tspin="T-Spin",
    target_techrash="消四",
    target_wave="波数",

    -- About-Game
    pause="暂停",

    goal_reached="要求已达成",

    -- Widget texts
    button_back="返回",

    simulation_title="模拟",
    graph_brik_title="M-图谱", -- 翻译注意：取自“知识图谱”(人工智能领域)
    settings_title="设置",

    setting_asd="自动移动延迟",
    setting_asp="自动重复周期",
    setting_ash="自动移动阻止",
    setting_softdropSkipAsd="跳过软降延迟",
    setting_shakeness="场地晃动",
    setting_hitWavePower="冲击波强度",

    setting_mainVol="主音量",
    setting_bgm="音乐",
    setting_sfx="音效",
    setting_vib="振动",
    setting_handling="控制参数...",
    setting_keymapping="键位绑定...",
    setting_enableTouching="启用触屏控制",
    setting_touching="触屏控制...",
    setting_test="测试",
    setting_tryTestInGame="不能在游戏中途测试",
    setting_tryApplyAudioInGame="不能在游戏中途应用",

    setting_sysCursor="使用外部光标",
    setting_clickFX="点击动画",
    setting_power="终端状态",
    setting_clean="显存回收加速",
    setting_fullscreen="全屏",
    setting_portrait="竖屏",
    setting_autoMute="闲时静音",
    setting_showTouch="显示触摸位置",

    setting_maxFPS="最大帧数",
    setting_updRate="更新比率",
    setting_drawRate="绘制比率",
    setting_msaa="抗锯齿",
    setting_fmod_maxChannel="最大音频数",
    setting_fmod_DSPBufferCount="DSP缓冲区数量",
    setting_fmod_DSPBufferLength="DSP缓冲区长度",
    setting_apply="应用",

    lang_note="中文是本游戏的原始语言\n翻译由志愿者贡献，不保证100%准确\n部分术语可能没有翻译，请查阅词典获取更多信息",

    keyset_title="键位绑定",
    keyset_brik_moveLeft=   "左移",
    keyset_brik_moveRight=  "右移",
    keyset_brik_rotateCW=   "顺时针旋转",
    keyset_brik_rotateCCW=  "逆时针旋转",
    keyset_brik_rotate180=  "180°旋转",
    keyset_brik_softDrop=   "软降",
    keyset_brik_hardDrop=   "硬降",
    keyset_brik_holdPiece=  "暂存",
    keyset_brik_skip=       "跳过",

    keyset_gela_moveLeft=   "左移",
    keyset_gela_moveRight=  "右移",
    keyset_gela_rotateCW=   "顺时针旋转",
    keyset_gela_rotateCCW=  "逆时针旋转",
    keyset_gela_rotate180=  "180°旋转",
    keyset_gela_softDrop=   "软降",
    keyset_gela_hardDrop=   "硬降",
    keyset_gela_skip=       "跳过",

    keyset_acry_swapLeft=    "向左换",
    keyset_acry_swapRight=   "向右换",
    keyset_acry_swapUp=      "向上换",
    keyset_acry_swapDown=    "向下换",
    keyset_acry_twistCW=     "顺时针旋转",
    keyset_acry_twistCCW=    "逆时针旋转",
    keyset_acry_twist180=    "180°旋转",
    keyset_acry_moveLeft=    "光标左移",
    keyset_acry_moveRight=   "光标右移",
    keyset_acry_moveUp=      "光标上移",
    keyset_acry_moveDown=    "光标下移",
    keyset_acry_skip=        "跳过",

    keyset_func1= "功能 1",
    keyset_func2= "功能 2",
    keyset_func3= "功能 3",
    keyset_func4= "功能 4",
    keyset_func5= "功能 5",

    keyset_sys_view=    "视野调整",
    keyset_sys_restart= "重新开始",
    keyset_sys_chat=    "开启聊天框",
    keyset_sys_back=    "菜单返回",
    keyset_sys_quit=    "结束游戏",
    keyset_sys_setting= "菜单设置",
    keyset_sys_help=    "快速帮助",
    keyset_sys_up=      "菜单上",
    keyset_sys_down=    "菜单下",
    keyset_sys_left=    "菜单左",
    keyset_sys_right=   "菜单右",
    keyset_sys_select=  "菜单确定",

    keyset_pressKey="按下要设置的键",
    keyset_deleted= "*已删除*",
    keyset_info=    "[Esc]: 取消\n[Backspace]: 删除\n[Double Esc]: 设置为Esc",

    stick2_switch="2向摇杆",
    stick4_switch="4向摇杆",
    setting_touch_button="增减虚拟按键",
    setting_touch_buttonSize="按键尺寸",
    setting_touch_buttonShape="更改形状",
    setting_touch_iconSize="图标尺寸",
    setting_touch_stickSize="摇杆尺寸",
    setting_touch_ballSize="摇把尺寸",

    main_in_dig="挖掘练习",
    main_in_sprint="40行",
    main_in_marathon="马拉松",
    main_in_tutorial="教程",
    main_in_sandbox="沙盒",
    main_in_settings="设置",

    main_out_settings="设置",
    main_out_stat="统计",
    main_out_dict="词典",
    main_out_lang="语言",
    main_out_about="系统信息",
    main_out_single="单机",
    main_out_multi="联机",

    musicroom_title="音乐室",
    musicroom_fullband='全频带',
    musicroom_autoplay="自动切换",

    about_title="关于",
    about_module="模块:",
    about_toolchain="工具链:",
    about_peopleLost="你弄丢了 $1 !",

    -- Mode name
    exteriorModeInfo={
        sprint=           {"竞速","速度即一切"},
        sequence=         {"序列","面对令人诧异的方块序列"},
        hidden=           {"隐形","方块在落下后会不可见"},
        tspin=            {"T旋","构建特殊的地形"},
        marathon=         {"马拉松","对抗逐渐增加的重力"},
        allclear=         {"全消","可控的全消并非不可能"},
        combo=            {"连击","没有人能拒绝连击"},
        hypersonic=       {"超音速","打破重力的极限"},
        dig=              {"挖掘","处理整齐的垃圾行"},
        excavate=         {"发掘","处理标准的垃圾行"},
        drill=            {"钻掘","处理复杂的垃圾行"},
        survivor=         {"生存","在压力下生存"},
        backfire=         {"反效","自给自足"},

        chain=            {"连锁","同一个颜色才能消"},
        action=           {"动作","键鼠搭配更佳"},
    },

    -- Level
    tutorial_basic="基本规则",
    tutorial_sequence="预览&暂存",
    tutorial_piece="方块形状",
    tutorial_stackBasic="堆叠(基础)",
    tutorial_twoRotatingKey="双旋",
    tutorial_rotating="旋转练习",

    tutorial_notpass="Failed",
    tutorial_pass="PASS",

    tutorial_basic_1="欢迎来到Techmino",
    tutorial_basic_2="1. 基本规则",
    tutorial_basic_3="用左/右键移动当前方块",
    tutorial_basic_4="按下硬降键放置当前方块",
    tutorial_basic_5="你也可以旋转当前方块",

    tutorial_sequence_1="2. 预览&暂存",
    tutorial_sequence_2="哎呀 这个块的形状和坑对不上",
    tutorial_sequence_3="现在你可以看到之后会来什么块了",
    tutorial_sequence_4="使用暂存键来调整方块的顺序",

    tutorial_shape_1="3. 方块形状",
    tutorial_shape_2="选择更贴合地形的那个方块",

    tutorial_stackBasic_1="4.堆叠(基础)",
    tutorial_stackBasic_m1="请按照提示摆块",
    tutorial_stackBasic_m2="刚开始学习时，一般都推荐尽量“让地形平坦”",
    tutorial_stackBasic_m3="方块通常会尽量摆成平躺的方向，很少竖着",
    tutorial_stackBasic_m4="保持地形的顶部平坦比较好持续，不容易出现空洞",
    tutorial_stackBasic_m5="通常的规则里用棍子一次消四行往往会有较大的收益，再做一个消四试试看",
    tutorial_stackBasic_m6="尝试不借助提示把消四最后几块补完整吧",

    tutorial_twoRotatingKey_1="5. 双旋",
    tutorial_twoRotatingKey_m1="如果可以逆时针旋转一次到位，那么就不需要顺时针转三次",
    tutorial_twoRotatingKey_m2="不仅浪费力气，还会减慢操作速度",
    tutorial_twoRotatingKey_m3="你需要先想好放在哪然后开始操作，而不是依赖影子去对地形",
    tutorial_twoRotatingKey_m4="请按照提示摆块，但旋转的次数必须尽可能少",
    tutorial_twoRotatingKey_unnecessaryRotation="多余旋转",

    tutorial_rotating_1="6. 旋转练习",
    tutorial_rotating_2="请将上面的方块旋转成下面的朝向",
}
return L
