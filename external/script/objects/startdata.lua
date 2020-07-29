Startdata = {
    --default team count after starting the game
    p1NumRatio = 1,
    p2NumRatio = 1,
    --default team mode after starting the game
    p1TeamMenu = 1,
    p2TeamMenu = 1,
    --initialize other variables
    t_victoryBGM = {},
    t_roster = {},
    t_aiRamp = {},
    t_p1Cursor = {},
    t_p2Cursor = {},
    p1RestoreCursor = false,
    p2RestoreCursor = false,
    p1Cell = false,
    p2Cell = false,
    p1TeamEnd = false,
    p1SelEnd = false,
    p1Ratio = false,
    p2TeamEnd = false,
    p2SelEnd = false,
    p2Ratio = false,
    selScreenEnd = false,
    stageEnd = false,
    coopEnd = false,
    restoreTeam = false,
    resetgrid = false,
    continueData = false,
    continueFlag = false,
    p1NumChars = 0,
    p2NumChars = 0,
    matchNo = 0,
    stageNo = 0,
    p1SelX = 0,
    p1SelY = 0,
    p2SelX = 0,
    p2SelY = 0,
    p1FaceOffset = 0,
    p2FaceOffset = 0,
    p1RowOffset = 0,
    p2RowOffset = 0,
    winner = 0,
    t_gameStats = {},
    t_recordText = {},
    winCnt = 0,
    loseCnt = 0,
    p1FaceX = 0,
    p1FaceY = 0,
    p2FaceX = 0,
    p2FaceY = 0,
    t_p1Selected = {},
    t_p2Selected = {},
    lastMatch = 0,
    stageList = 0,
    timerSelect = 0,
    t_savedData = {
        win = { 0, 0 },
        lose = { 0, 0 },
        time = { total = 0, matches = {} },
        score = { total = { 0, 0 }, matches = {} },
        consecutive = { 0, 0 },
    },
    t_ratioArray = {
        {2, 1, 1},
        {1, 2, 1},
        {1, 1, 2},
        {2, 2},
        {3, 1},
        {1, 3},
        {4}
    },
    fadeType = 'fadein',
    challenger = false,
    t_sortRanking = {},
    row = 1,
    col = 0,
    
    -- player 1 team menu
    p1TeamActiveCount = 0,
    p1TeamActiveType = 'p1_teammenu_item_active',


    -- player 2 team menu
    p2TeamActiveCount = 0,
    p2TeamActiveType = 'p2_teammenu_item_active',


    -- stage menu
    stageActiveCount = 0,
    stageActiveType = 'stage_active',
    t_grid = {},
}

function Startdata:initTgrid(start, motif)
    local cnt = self.cnt
    local row = self.row
    local col = self.col
    local t_grid = {[row] = {}}
    for i = 1, (motif.select_info.rows + motif.select_info.rows_scrolling) * motif.select_info.columns do
        if i == cnt then
            row = row + 1
            cnt = cnt + motif.select_info.columns
            t_grid[row] = {}
        end
        col = #t_grid[row] + 1
        t_grid[row][col] = {
            x = (col - 1) * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(col, row, 1),
            y = (row - 1) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(col, row, 2)
        }
        if start.f_selGrid(i).char ~= nil then
            t_grid[row][col].char = start.f_selGrid(i).char
            t_grid[row][col].char_ref = start.f_selGrid(i).char_ref
            t_grid[row][col].hidden = start.f_selGrid(i).hidden
        end
    end
    self.t_grid = t_grid
end

function Startdata:initTSortRanking()
    self.t_sortRanking['arcade'] = function(t, a, b) return t[b].score < t[a].score end
    self.t_sortRanking['teamcoop'] = self.t_sortRanking.arcade
    self.t_sortRanking['netplayteamcoop'] = self.t_sortRanking.arcade
    self.t_sortRanking['scorechallenge'] = self.t_sortRanking.arcade
    self.t_sortRanking['timeattack'] = function(t, a, b) return t[b].time > t[a].time end
    self.t_sortRanking['timechallenge'] = self.t_sortRanking.timeattack
    self.t_sortRanking['survival'] = function(t, a, b) return t[b].win < t[a].win or (t[b].win == t[a].win and t[b].score < t[a].score) end
    self.t_sortRanking['survivalcoop'] = self.t_sortRanking.survival
    self.t_sortRanking['netplaysurvivalcoop'] = self.t_sortRanking.survival
    self.t_sortRanking['bossrush'] = self.t_sortRanking.survival
    self.t_sortRanking['vs100kumite'] = self.t_sortRanking.survival
end

function Startdata:initDefaults(motifRef, configRef, mainRef)
    local motif = motifRef
    local config = configRef
    local main = mainRef
    --default team count after starting the game
    self.p1NumTurns = math.max(2, config.NumTurns[1])
    self.p1NumSimul = math.max(2, config.NumSimul[1])
    self.p1NumTag = math.max(2, config.NumTag[1])
    self.p2NumTurns = math.max(2, config.NumTurns[1])
    self.p2NumSimul = math.max(2, config.NumSimul[1])
    self.p2NumTag = math.max(2, config.NumTag[1])
    --
    self.wrappingX = (motif.select_info.wrapping == 1 and motif.select_info.wrapping_x == 1)
    self.wrappingY = (motif.select_info.wrapping == 1 and motif.select_info.wrapping_y == 1)
    self.cnt = motif.select_info.columns + 1
    -- select screen
    self.txt_recordSelect = text:create({
        font =   motif.select_info.record_font[1],
        bank =   motif.select_info.record_font[2],
        align =  motif.select_info.record_font[3],
        text =   '',
        x =      motif.select_info.record_offset[1],
        y =      motif.select_info.record_offset[2],
        scaleX = motif.select_info.record_font_scale[1],
        scaleY = motif.select_info.record_font_scale[2],
        r =      motif.select_info.record_font[4],
        g =      motif.select_info.record_font[5],
        b =      motif.select_info.record_font[6],
        src =    motif.select_info.record_font[7],
        dst =    motif.select_info.record_font[8],
        height = motif.select_info.record_font_height,
    })
    self.txt_timerSelect = text:create({
    font =   motif.select_info.timer_font[1],
    bank =   motif.select_info.timer_font[2],
    align =  motif.select_info.timer_font[3],
    text =   '',
    x =      motif.select_info.timer_offset[1],
    y =      motif.select_info.timer_offset[2],
    scaleX = motif.select_info.timer_font_scale[1],
    scaleY = motif.select_info.timer_font_scale[2],
    r =      motif.select_info.timer_font[4],
    g =      motif.select_info.timer_font[5],
    b =      motif.select_info.timer_font[6],
    src =    motif.select_info.timer_font[7],
    dst =    motif.select_info.timer_font[8],
    height = motif.select_info.timer_font_height,
    })
    self.txt_p1Name = text:create({
    font =   motif.select_info.p1_name_font[1],
    bank =   motif.select_info.p1_name_font[2],
    align =  motif.select_info.p1_name_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.select_info.p1_name_font_scale[1],
    scaleY = motif.select_info.p1_name_font_scale[2],
    r =      motif.select_info.p1_name_font[4],
    g =      motif.select_info.p1_name_font[5],
    b =      motif.select_info.p1_name_font[6],
    src =    motif.select_info.p1_name_font[7],
    dst =    motif.select_info.p1_name_font[8],
    height = motif.select_info.p1_name_font_height,
    })
    self.txt_p2Name = text:create({
    font =   motif.select_info.p2_name_font[1],
    bank =   motif.select_info.p2_name_font[2],
    align =  motif.select_info.p2_name_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.select_info.p2_name_font_scale[1],
    scaleY = motif.select_info.p2_name_font_scale[2],
    r =      motif.select_info.p2_name_font[4],
    g =      motif.select_info.p2_name_font[5],
    b =      motif.select_info.p2_name_font[6],
    src =    motif.select_info.p2_name_font[7],
    dst =    motif.select_info.p2_name_font[8],
    height = motif.select_info.p2_name_font_height,
    })
    self.p1RandomCount = motif.select_info.cell_random_switchtime
    self.p1RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
    self.p2RandomCount = motif.select_info.cell_random_switchtime
    self.p2RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
    -- player 1 team menu
    self.txt_p1TeamSelfTitle = text:create({
        font =   motif.select_info.p1_teammenu_selftitle_font[1],
        bank =   motif.select_info.p1_teammenu_selftitle_font[2],
        align =  motif.select_info.p1_teammenu_selftitle_font[3],
        text =   motif.select_info.p1_teammenu_selftitle_text,
        x =      motif.select_info.p1_teammenu_pos[1] + motif.select_info.p1_teammenu_selftitle_offset[1],
        y =      motif.select_info.p1_teammenu_pos[2] + motif.select_info.p1_teammenu_selftitle_offset[2],
        scaleX = motif.select_info.p1_teammenu_selftitle_font_scale[1],
        scaleY = motif.select_info.p1_teammenu_selftitle_font_scale[2],
        r =      motif.select_info.p1_teammenu_selftitle_font[4],
        g =      motif.select_info.p1_teammenu_selftitle_font[5],
        b =      motif.select_info.p1_teammenu_selftitle_font[6],
        src =    motif.select_info.p1_teammenu_selftitle_font[7],
        dst =    motif.select_info.p1_teammenu_selftitle_font[8],
        height = motif.select_info.p1_teammenu_selftitle_font_height,
    })
    self.txt_p1TeamEnemyTitle = text:create({
    font =   motif.select_info.p1_teammenu_enemytitle_font[1],
    bank =   motif.select_info.p1_teammenu_enemytitle_font[2],
    align =  motif.select_info.p1_teammenu_enemytitle_font[3],
    text =   motif.select_info.p1_teammenu_enemytitle_text,
    x =      motif.select_info.p1_teammenu_pos[1] + motif.select_info.p1_teammenu_enemytitle_offset[1],
    y =      motif.select_info.p1_teammenu_pos[2] + motif.select_info.p1_teammenu_enemytitle_offset[2],
    scaleX = motif.select_info.p1_teammenu_enemytitle_font_scale[1],
    scaleY = motif.select_info.p1_teammenu_enemytitle_font_scale[2],
    r =      motif.select_info.p1_teammenu_enemytitle_font[4],
    g =      motif.select_info.p1_teammenu_enemytitle_font[5],
    b =      motif.select_info.p1_teammenu_enemytitle_font[6],
    src =    motif.select_info.p1_teammenu_enemytitle_font[7],
    dst =    motif.select_info.p1_teammenu_enemytitle_font[8],
    height = motif.select_info.p1_teammenu_enemytitle_font_height,
    })
    -- player 2 team menu
    self.txt_p2TeamSelfTitle = text:create({
        font =   motif.select_info.p2_teammenu_selftitle_font[1],
        bank =   motif.select_info.p2_teammenu_selftitle_font[2],
        align =  motif.select_info.p2_teammenu_selftitle_font[3],
        text =   motif.select_info.p2_teammenu_selftitle_text,
        x =      motif.select_info.p2_teammenu_pos[1] + motif.select_info.p2_teammenu_selftitle_offset[1],
        y =      motif.select_info.p2_teammenu_pos[2] + motif.select_info.p2_teammenu_selftitle_offset[2],
        scaleX = motif.select_info.p2_teammenu_selftitle_font_scale[1],
        scaleY = motif.select_info.p2_teammenu_selftitle_font_scale[2],
        r =      motif.select_info.p2_teammenu_selftitle_font[4],
        g =      motif.select_info.p2_teammenu_selftitle_font[5],
        b =      motif.select_info.p2_teammenu_selftitle_font[6],
        src =    motif.select_info.p2_teammenu_selftitle_font[7],
        dst =    motif.select_info.p2_teammenu_selftitle_font[8],
        height = motif.select_info.p2_teammenu_selftitle_font_height,
    })
    self.txt_p2TeamEnemyTitle = text:create({
    font =   motif.select_info.p2_teammenu_enemytitle_font[1],
    bank =   motif.select_info.p2_teammenu_enemytitle_font[2],
    align =  motif.select_info.p2_teammenu_enemytitle_font[3],
    text =   motif.select_info.p2_teammenu_enemytitle_text,
    x =      motif.select_info.p2_teammenu_pos[1] + motif.select_info.p2_teammenu_enemytitle_offset[1],
    y =      motif.select_info.p2_teammenu_pos[2] + motif.select_info.p2_teammenu_enemytitle_offset[2],
    scaleX = motif.select_info.p2_teammenu_enemytitle_font_scale[1],
    scaleY = motif.select_info.p2_teammenu_enemytitle_font_scale[2],
    r =      motif.select_info.p2_teammenu_enemytitle_font[4],
    g =      motif.select_info.p2_teammenu_enemytitle_font[5],
    b =      motif.select_info.p2_teammenu_enemytitle_font[6],
    src =    motif.select_info.p2_teammenu_enemytitle_font[7],
    dst =    motif.select_info.p2_teammenu_enemytitle_font[8],
    height = motif.select_info.p2_teammenu_enemytitle_font_height,
    })
    -- stage menu
    self.txt_selStage = text:create({
        font = motif.select_info.stage_active_font[1],
        height = motif.select_info.stage_active_font_height
    })
    -- versus screen
    self.txt_p1NameVS = text:create({
        font =   motif.vs_screen.p1_name_font[1],
        bank =   motif.vs_screen.p1_name_font[2],
        align =  motif.vs_screen.p1_name_font[3],
        text =   '',
        x =      0,
        y =      0,
        scaleX = motif.vs_screen.p1_name_font_scale[1],
        scaleY = motif.vs_screen.p1_name_font_scale[2],
        r =      motif.vs_screen.p1_name_font[4],
        g =      motif.vs_screen.p1_name_font[5],
        b =      motif.vs_screen.p1_name_font[6],
        src =    motif.vs_screen.p1_name_font[7],
        dst =    motif.vs_screen.p1_name_font[8],
        height = motif.vs_screen.p1_name_font_height,
    })
    self.txt_p2NameVS = text:create({
    font =   motif.vs_screen.p2_name_font[1],
    bank =   motif.vs_screen.p2_name_font[2],
    align =  motif.vs_screen.p2_name_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.vs_screen.p2_name_font_scale[1],
    scaleY = motif.vs_screen.p2_name_font_scale[2],
    r =      motif.vs_screen.p2_name_font[4],
    g =      motif.vs_screen.p2_name_font[5],
    b =      motif.vs_screen.p2_name_font[6],
    src =    motif.vs_screen.p2_name_font[7],
    dst =    motif.vs_screen.p2_name_font[8],
    height = motif.vs_screen.p2_name_font_height,
    })
    self.txt_matchNo = text:create({
    font =   motif.vs_screen.match_font[1],
    bank =   motif.vs_screen.match_font[2],
    align =  motif.vs_screen.match_font[3],
    text =   '',
    x =      motif.vs_screen.match_offset[1],
    y =      motif.vs_screen.match_offset[2],
    scaleX = motif.vs_screen.match_font_scale[1],
    scaleY = motif.vs_screen.match_font_scale[2],
    r =      motif.vs_screen.match_font[4],
    g =      motif.vs_screen.match_font[5],
    b =      motif.vs_screen.match_font[6],
    src =    motif.vs_screen.match_font[7],
    dst =    motif.vs_screen.match_font[8],
    height = motif.vs_screen.match_font_height,
    })
    -- result screen
    self.txt_winscreen = text:create({
        font =   motif.win_screen.wintext_font[1],
        bank =   motif.win_screen.wintext_font[2],
        align =  motif.win_screen.wintext_font[3],
        text =   motif.win_screen.wintext_text,
        x =      motif.win_screen.wintext_offset[1],
        y =      motif.win_screen.wintext_offset[2],
        scaleX = motif.win_screen.wintext_font_scale[1],
        scaleY = motif.win_screen.wintext_font_scale[2],
        r =      motif.win_screen.wintext_font[4],
        g =      motif.win_screen.wintext_font[5],
        b =      motif.win_screen.wintext_font[6],
        src =    motif.win_screen.wintext_font[7],
        dst =    motif.win_screen.wintext_font[8],
        height = motif.win_screen.wintext_font_height,
    })
    self.txt_resultSurvival = text:create({
    font =   motif.survival_results_screen.winstext_font[1],
    bank =   motif.survival_results_screen.winstext_font[2],
    align =  motif.survival_results_screen.winstext_font[3],
    text =   '',
    x =      motif.survival_results_screen.winstext_offset[1],
    y =      motif.survival_results_screen.winstext_offset[2],
    scaleX = motif.survival_results_screen.winstext_font_scale[1],
    scaleY = motif.survival_results_screen.winstext_font_scale[2],
    r =      motif.survival_results_screen.winstext_font[4],
    g =      motif.survival_results_screen.winstext_font[5],
    b =      motif.survival_results_screen.winstext_font[6],
    src =    motif.survival_results_screen.winstext_font[7],
    dst =    motif.survival_results_screen.winstext_font[8],
    height = motif.survival_results_screen.winstext_font_height,
    })
    self.txt_resultVS100 = text:create({
    font =   motif.vs100_kumite_results_screen.winstext_font[1],
    bank =   motif.vs100_kumite_results_screen.winstext_font[2],
    align =  motif.vs100_kumite_results_screen.winstext_font[3],
    text =   '',
    x =      motif.vs100_kumite_results_screen.winstext_offset[1],
    y =      motif.vs100_kumite_results_screen.winstext_offset[2],
    scaleX = motif.vs100_kumite_results_screen.winstext_font_scale[1],
    scaleY = motif.vs100_kumite_results_screen.winstext_font_scale[2],
    r =      motif.vs100_kumite_results_screen.winstext_font[4],
    g =      motif.vs100_kumite_results_screen.winstext_font[5],
    b =      motif.vs100_kumite_results_screen.winstext_font[6],
    src =    motif.vs100_kumite_results_screen.winstext_font[7],
    dst =    motif.vs100_kumite_results_screen.winstext_font[8],
    height = motif.vs100_kumite_results_screen.winstext_font_height,
    })
    self.txt_resultTimeAttack = text:create({
    font =   motif.time_attack_results_screen.winstext_font[1],
    bank =   motif.time_attack_results_screen.winstext_font[2],
    align =  motif.time_attack_results_screen.winstext_font[3],
    text =   '',
    x =      motif.time_attack_results_screen.winstext_offset[1],
    y =      motif.time_attack_results_screen.winstext_offset[2],
    scaleX = motif.time_attack_results_screen.winstext_font_scale[1],
    scaleY = motif.time_attack_results_screen.winstext_font_scale[2],
    r =      motif.time_attack_results_screen.winstext_font[4],
    g =      motif.time_attack_results_screen.winstext_font[5],
    b =      motif.time_attack_results_screen.winstext_font[6],
    src =    motif.time_attack_results_screen.winstext_font[7],
    dst =    motif.time_attack_results_screen.winstext_font[8],
    height = motif.time_attack_results_screen.winstext_font_height,
    })
    self.txt_resultTimeChallenge = text:create({
    font =   motif.time_challenge_results_screen.winstext_font[1],
    bank =   motif.time_challenge_results_screen.winstext_font[2],
    align =  motif.time_challenge_results_screen.winstext_font[3],
    text =   '',
    x =      motif.time_challenge_results_screen.winstext_offset[1],
    y =      motif.time_challenge_results_screen.winstext_offset[2],
    scaleX = motif.time_challenge_results_screen.winstext_font_scale[1],
    scaleY = motif.time_challenge_results_screen.winstext_font_scale[2],
    r =      motif.time_challenge_results_screen.winstext_font[4],
    g =      motif.time_challenge_results_screen.winstext_font[5],
    b =      motif.time_challenge_results_screen.winstext_font[6],
    src =    motif.time_challenge_results_screen.winstext_font[7],
    dst =    motif.time_challenge_results_screen.winstext_font[8],
    height = motif.time_challenge_results_screen.winstext_font_height,
    })
    self.txt_resultScoreChallenge = text:create({
    font =   motif.score_challenge_results_screen.winstext_font[1],
    bank =   motif.score_challenge_results_screen.winstext_font[2],
    align =  motif.score_challenge_results_screen.winstext_font[3],
    text =   '',
    x =      motif.score_challenge_results_screen.winstext_offset[1],
    y =      motif.score_challenge_results_screen.winstext_offset[2],
    scaleX = motif.score_challenge_results_screen.winstext_font_scale[1],
    scaleY = motif.score_challenge_results_screen.winstext_font_scale[2],
    r =      motif.score_challenge_results_screen.winstext_font[4],
    g =      motif.score_challenge_results_screen.winstext_font[5],
    b =      motif.score_challenge_results_screen.winstext_font[6],
    src =    motif.score_challenge_results_screen.winstext_font[7],
    dst =    motif.score_challenge_results_screen.winstext_font[8],
    height = motif.score_challenge_results_screen.winstext_font_height,
    })
    self.txt_resultBossRush = text:create({
    font =   motif.boss_rush_results_screen.winstext_font[1],
    bank =   motif.boss_rush_results_screen.winstext_font[2],
    align =  motif.boss_rush_results_screen.winstext_font[3],
    text =   motif.boss_rush_results_screen.winstext_text,
    x =      motif.boss_rush_results_screen.winstext_offset[1],
    y =      motif.boss_rush_results_screen.winstext_offset[2],
    scaleX = motif.boss_rush_results_screen.winstext_font_scale[1],
    scaleY = motif.boss_rush_results_screen.winstext_font_scale[2],
    r =      motif.boss_rush_results_screen.winstext_font[4],
    g =      motif.boss_rush_results_screen.winstext_font[5],
    b =      motif.boss_rush_results_screen.winstext_font[6],
    src =    motif.boss_rush_results_screen.winstext_font[7],
    dst =    motif.boss_rush_results_screen.winstext_font[8],
    height = motif.boss_rush_results_screen.winstext_font_height,
    })
    -- victory screen
    self.txt_winquote = text:create({
    font =   motif.victory_screen.winquote_font[1],
    bank =   motif.victory_screen.winquote_font[2],
    align =  motif.victory_screen.winquote_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.victory_screen.winquote_font_scale[1],
    scaleY = motif.victory_screen.winquote_font_scale[2],
    r =      motif.victory_screen.winquote_font[4],
    g =      motif.victory_screen.winquote_font[5],
    b =      motif.victory_screen.winquote_font[6],
    src =    motif.victory_screen.winquote_font[7],
    dst =    motif.victory_screen.winquote_font[8],
    height = motif.victory_screen.winquote_font_height,
    window = motif.victory_screen.winquote_window,
    })
    self.txt_p1_winquoteName = text:create({
    font =   motif.victory_screen.p1_name_font[1],
    bank =   motif.victory_screen.p1_name_font[2],
    align =  motif.victory_screen.p1_name_font[3],
    text =   '',
    x =      motif.victory_screen.p1_name_offset[1],
    y =      motif.victory_screen.p1_name_offset[2],
    scaleX = motif.victory_screen.p1_name_font_scale[1],
    scaleY = motif.victory_screen.p1_name_font_scale[2],
    r =      motif.victory_screen.p1_name_font[4],
    g =      motif.victory_screen.p1_name_font[5],
    b =      motif.victory_screen.p1_name_font[6],
    src =    motif.victory_screen.p1_name_font[7],
    dst =    motif.victory_screen.p1_name_font[8],
    height = motif.victory_screen.p1_name_font_height,
    })
    self.txt_p2_winquoteName = text:create({
    font =   motif.victory_screen.p2_name_font[1],
    bank =   motif.victory_screen.p2_name_font[2],
    align =  motif.victory_screen.p2_name_font[3],
    text =   '',
    x =      motif.victory_screen.p2_name_offset[1],
    y =      motif.victory_screen.p2_name_offset[2],
    scaleX = motif.victory_screen.p2_name_font_scale[1],
    scaleY = motif.victory_screen.p2_name_font_scale[2],
    r =      motif.victory_screen.p2_name_font[4],
    g =      motif.victory_screen.p2_name_font[5],
    b =      motif.victory_screen.p2_name_font[6],
    src =    motif.victory_screen.p2_name_font[7],
    dst =    motif.victory_screen.p2_name_font[8],
    height = motif.victory_screen.p2_name_font_height,
    })
    -- continue screen
    self.txt_credits = text:create({
    font =   motif.continue_screen.credits_font[1],
    bank =   motif.continue_screen.credits_font[2],
    align =  motif.continue_screen.credits_font[3],
    text =   '',
    x =      motif.continue_screen.credits_offset[1],
    y =      motif.continue_screen.credits_offset[2],
    scaleX = motif.continue_screen.credits_font_scale[1],
    scaleY = motif.continue_screen.credits_font_scale[2],
    r =      motif.continue_screen.credits_font[4],
    g =      motif.continue_screen.credits_font[5],
    b =      motif.continue_screen.credits_font[6],
    src =    motif.continue_screen.credits_font[7],
    dst =    motif.continue_screen.credits_font[8],
    height = motif.continue_screen.credits_font_height,
    })
    self.txt_continue = text:create({
    font =   motif.continue_screen.continue_font[1],
    bank =   motif.continue_screen.continue_font[2],
    align =  motif.continue_screen.continue_font[3],
    text =   motif.continue_screen.continue_text,
    x =      motif.continue_screen.pos[1] + motif.continue_screen.continue_offset[1],
    y =      motif.continue_screen.pos[2] + motif.continue_screen.continue_offset[2],
    scaleX = motif.continue_screen.continue_font_scale[1],
    scaleY = motif.continue_screen.continue_font_scale[2],
    r =      motif.continue_screen.continue_font[4],
    g =      motif.continue_screen.continue_font[5],
    b =      motif.continue_screen.continue_font[6],
    src =    motif.continue_screen.continue_font[7],
    dst =    motif.continue_screen.continue_font[8],
    height = motif.continue_screen.continue_font_height,
    })
    self.txt_yes = text:create({})
    self.txt_no = text:create({})

    self.t_p1TeamMenu = {
        {data = text:create({}), itemname = 'single', displayname = motif.select_info.teammenu_itemname_single, mode = 0, chars = 1},
        {data = text:create({}), itemname = 'simul', displayname = motif.select_info.teammenu_itemname_simul, mode = 1, chars = self.p1NumSimul},
        {data = text:create({}), itemname = 'turns', displayname = motif.select_info.teammenu_itemname_turns, mode = 2, chars = self.p1NumTurns},
        {data = text:create({}), itemname = 'tag', displayname = motif.select_info.teammenu_itemname_tag, mode = 3, chars = self.p1NumTag},
        {data = text:create({}), itemname = 'ratio', displayname = motif.select_info.teammenu_itemname_ratio, mode = 2, chars = self.p1NumRatio},
    }

    self.t_p2TeamMenu = {
        {data = text:create({}), itemname = 'single', displayname = motif.select_info.teammenu_itemname_single, mode = 0, chars = 1},
        {data = text:create({}), itemname = 'simul', displayname = motif.select_info.teammenu_itemname_simul, mode = 1, chars = self.p2NumSimul},
        {data = text:create({}), itemname = 'turns', displayname = motif.select_info.teammenu_itemname_turns, mode = 2, chars = self.p2NumTurns},
        {data = text:create({}), itemname = 'tag', displayname = motif.select_info.teammenu_itemname_tag, mode = 3, chars = self.p2NumTag},
        {data = text:create({}), itemname = 'ratio', displayname = motif.select_info.teammenu_itemname_ratio, mode = 2, chars = self.p2NumRatio},
    }
end

-- Constructor
-- @param o initial table if nil wil be created
-- @param motifRef a reference to SystemDef from the screenpack
-- @param configRef a reference to the config.json
-- @param mainRef a reference to the main object <-- not sure what this is.
function Startdata:new(o, motifRef, configRef, mainRef)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self:initTSortRanking()
    self:initDefaults(motifRef, configRef, mainRef)
    return o
end

return Startdata
