return {
    -- Clearing texts
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

    combo=function(c)
        if     c<=9  then return c.." Combo"
        elseif c<=13 then return c.." Combo!"
        elseif c<=16 then return c.." Combo!!"
        elseif c<=19 then return c.." Combo!!!"
        else              return "MEGACMB"
        end
    end,

    spin='$1-spin',
    tuck='Tuck',

    allClear='ALL CLEAR',
    halfClear='Half Clear',

    -- Widget texts
    main_1_play="开始",
    main_1_setting="设置",

    setting_das="DAS",
    setting_arr="ARR",
    setting_sdarr="SDARR",
    setting_shakeness="场地晃动",

    setting_mainVol="主音量",
    setting_bgm="音乐",
    setting_sfx="音效",

    setting_sysCursor="使用系统光标",
    setting_clickFX="点击动画",
    setting_power="电量和时间",
    setting_clean="绘制优化",
    setting_fullscreen="全屏",
    setting_autoMute="失去焦点自动静音",
    setting_showTouch="显示触摸位置",

    setting_maxFPS="最大帧数",
    setting_updRate="更新比率",
    setting_drawRate="绘制比率",

    setting_test="测试",

    -- Key setting
    key_game_restart=   "游戏: 重新开始",
    key_game_chat=      "游戏: 开启聊天框",
    key_act_moveLeft=   "操作: 左移",
    key_act_moveRight=  "操作: 右移",
    key_act_rotateCW=   "操作: 顺时针旋转",
    key_act_rotateCCW=  "操作: 逆时针旋转",
    key_act_rotate180=  "操作: 180°旋转",
    key_act_holdPiece=  "操作: 硬降",
    key_act_softDrop=   "操作: 软降",
    key_act_hardDrop=   "操作: 暂存",
    key_act_sonicDrop=  "操作: 软降到底",
    key_act_sonicLeft=  "操作: 左瞬移",
    key_act_sonicRight= "操作: 右瞬移",
    key_act_function1=  "操作: Function 1",
    key_act_function2=  "操作: Function 2",
    key_act_function3=  "操作: Function 3",
    key_act_function4=  "操作: Function 4",
    key_act_target1=    "操作: Target1",
    key_act_target2=    "操作: Target2",
    key_act_target3=    "操作: Target3",
    key_act_target4=    "操作: Target4",
    key_menu_up=        "菜单: 上",
    key_menu_down=      "菜单: 下",
    key_menu_left=      "菜单: 左",
    key_menu_right=     "菜单: 右",
    key_menu_confirm=   "菜单: 确定",
    key_menu_back=      "菜单: 返回",
    key_rep_pause=      "回放: 暂停",
    key_rep_prevFrame=  "回放: 上一帧",
    key_rep_nextFrame=  "回放: 下一帧",
    key_rep_speedDown=  "回放: 减速",
    key_rep_speedUp=    "回放: 加速",
    key_rep_speed1_16x= "回放: 调整至1/16倍速",
    key_rep_speed1_6x=  "回放: 调整至1/6倍速",
    key_rep_speed1_2x=  "回放: 调整至1/2倍速",
    key_rep_speed1x=    "回放: 调整至1倍速",
    key_rep_speed2x=    "回放: 调整至2倍速",
    key_rep_speed6x=    "回放: 调整至6倍速",
    key_rep_speed16x=   "回放: 调整至16倍速",
}
