MotifData = {
    info =
    {
        name = 'Default',
        author = 'Elecbyte',
        versiondate = '09,01,2009',
        mugenversion = '1.0',
        localcoord = {320, 240},
    },
    files =
    {
        spr = 'data/system.sff',
        snd = 'data/system.snd',
        logo_storyboard = '',
        intro_storyboard = '',
        select = 'data/select.def',
        fight = 'data/fight.def',
        font =
        {
            [1] = 'f-4x6.fnt',
            [2] = 'f-6x9.def',
            [3] = 'jg.fnt',
        },
        font_height = {},
        glyphs = 'data/glyphs.sff', --Ikemen feature
    },
    ja_files = {}, --not used in Ikemen
    music =
    {
        title_bgm = '',
        title_bgm_volume = 100,
        title_bgm_loop = 1,
        title_bgm_loopstart = 0,
        title_bgm_loopend = 0,
        select_bgm = '',
        select_bgm_volume = 100,
        select_bgm_loop = 1,
        select_bgm_loopstart = 0,
        select_bgm_loopend = 0,
        vs_bgm = '',
        vs_bgm_volume = 100,
        vs_bgm_loop = 1,
        vs_bgm_loopstart = 0,
        vs_bgm_loopend = 0,
        victory_bgm = '',
        victory_bgm_volume = 100,
        victory_bgm_loop = 1,
        victory_bgm_loopstart = 0,
        victory_bgm_loopend = 0,
        option_bgm = '', --Ikemen feature
        option_bgm_volume = 100, --Ikemen feature
        option_bgm_loop = 1, --Ikemen feature
        option_bgm_loopstart = 0, --Ikemen feature
        option_bgm_loopend = 0, --Ikemen feature
        replay_bgm = '', --Ikemen feature
        replay_bgm_volume = 100, --Ikemen feature
        replay_bgm_loop = 1, --Ikemen feature
        replay_bgm_loopstart = 0, --Ikemen feature
        replay_bgm_loopend = 0, --Ikemen feature
        continue_bgm = '', --Ikemen feature
        continue_bgm_volume = 100, --Ikemen feature
        continue_bgm_loop = 1, --Ikemen feature
        continue_bgm_loopstart = 0, --Ikemen feature
        continue_bgm_loopend = 0, --Ikemen feature
        continue_end_bgm = '', --Ikemen feature
        continue_end_bgm_volume = 100, --Ikemen feature
        continue_end_bgm_loop = 0, --Ikemen feature
        continue_end_bgm_loopstart = 0, --Ikemen feature
        continue_end_bgm_loopend = 0, --Ikemen feature
        results_bgm = '', --Ikemen feature
        results_bgm_volume = 100, --Ikemen feature
        results_bgm_loop = 1, --Ikemen feature
        results_bgm_loopstart = 0, --Ikemen feature
        results_bgm_loopend = 0, --Ikemen feature
        results_lose_bgm = '', --Ikemen feature
        results_lose_bgm_volume = 100, --Ikemen feature
        results_lose_bgm_loop = 1, --Ikemen feature
        results_lose_bgm_loopstart = 0, --Ikemen feature
        results_lose_bgm_loopend = 0, --Ikemen feature
        tournament_bgm = '', --Ikemen feature
        tournament_bgm_volume = 100, --Ikemen feature
        tournament_bgm_loop = 1, --Ikemen feature
        tournament_bgm_loopstart = 0, --Ikemen feature
        tournament_bgm_loopend = 0, --Ikemen feature
    },
    title_info =
    {
        fadein_time = 10,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 10,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        title_offset = {159, 19}, --Ikemen feature
        title_font = {-1, 0, 0, 255, 255, 255, 255, 0},
        title_font_scale = {1.0, 1.0}, --Ikemen feature
        title_font_height = -1, --Ikemen feature
        title_text = 'MAIN MENU', --Ikemen feature
        loading_font = {'f-4x6.fnt', 0, -1, 191, 191, 191, 255, 0}, --Ikemen feature
        loading_font_scale = {1.0, 1.0}, --Ikemen feature
        loading_font_height = -1, --Ikemen feature
        loading_text = 'LOADING...', --Ikemen feature
        
        footer1_font = {'f-4x6.fnt', 0, 1, 191, 191, 191, 255, 0}, --Ikemen feature
        footer1_font_scale = {1.0, 1.0}, --Ikemen feature
        footer1_font_height = -1, --Ikemen feature
        footer1_text = 'I.K.E.M.E.N. GO', --Ikemen feature
        footer2_font = {'f-4x6.fnt', 0, 0, 191, 191, 191, 255, 0}, --Ikemen feature
        footer2_font_scale = {1.0, 1.0}, --Ikemen feature
        footer2_font_height = -1, --Ikemen feature
        footer2_text = 'Press F1 for info', --Ikemen feature
        footer3_font = {'f-4x6.fnt', 0, -1, 191, 191, 191, 255, 0}, --Ikemen feature
        footer3_font_scale = {1.0, 1.0}, --Ikemen feature
        footer3_font_height = -1, --Ikemen feature
        footer3_text = 'v0.95', --Ikemen feature
        footer_boxbg_visible = 1, --Ikemen feature
        footer_boxbg_col = {0, 0, 64}, --Ikemen feature
        footer_boxbg_alpha = {255, 100}, --Ikemen feature
        connecting_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        connecting_font_scale = {1.0, 1.0}, --Ikemen feature
        connecting_font_height = -1, --Ikemen feature
        connecting_host_text = 'Waiting for player 2... (%s)', --Ikemen feature
        connecting_join_text = 'Now connecting to %s... (%s)', --Ikemen feature
        connecting_boxbg_col = {0, 0, 0}, --Ikemen feature
        connecting_boxbg_alpha = {20, 100}, --Ikemen feature
        input_ip_name_text = 'Enter Host display name, e.g. John.\nExisting entries can be removed with DELETE button.', --Ikemen feature
        input_ip_address_text = 'Enter Host IP address, e.g. 127.0.0.1\nCopied text can be pasted with INSERT button.', --Ikemen feature
        menu_key_next = '$D&$F', --Ikemen feature
        menu_key_previous = '$U&$B', --Ikemen feature
        menu_key_accept = 'a&b&c&x&y&z&s', --Ikemen feature
        menu_pos = {159, 158},
        menu_item_font = {'f-6x9.def', 0, 0, 191, 191, 191, 255, 0},
        menu_item_font_scale = {1.0, 1.0}, --broken parameter in mugen 1.1: http://mugenguild.com/forum/msg.1905756
        menu_item_font_height = -1, --Ikemen feature
        menu_item_active_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        menu_item_active_font_scale = {1.0, 1.0}, --broken parameter in mugen 1.1: http://mugenguild.com/forum/msg.1905756
        menu_item_active_font_height = -1, --Ikemen feature
        menu_item_spacing = {0, 13},
        --menu_itemname_arcade = 'ARCADE',
        --menu_itemname_versus = 'VS MODE',
        --menu_itemname_teamarcade = 'TEAM ARCADE',
        --menu_itemname_teamcoop = 'TEAM CO-OP',
        --menu_itemname_versus = 'VS MODE',
        --menu_itemname_teamversus = 'TEAM VERSUS',
        --menu_itemname_storymode = 'STORY MODE', --Ikemen feature (not implemented yet)
        --menu_itemname_serverhost = 'HOST GAME', --Ikemen feature
        --menu_itemname_serverjoin = 'JOIN GAME', --Ikemen feature
        --menu_itemname_joinadd = 'NEW ADDRESS', --Ikemen feature
        --menu_itemname_netplayversus = 'VERSUS', --Ikemen feature
        --menu_itemname_netplayteamcoop = 'ARCADE CO-OP', --Ikemen feature
        --menu_itemname_netplaysurvivalcoop = 'SURVIVAL CO-OP', --Ikemen feature
        --menu_itemname_tournament32 = 'ROUND OF 32', --Ikemen feature (not implemented yet)
        --menu_itemname_tournament16 = 'ROUND OF 16', --Ikemen feature (not implemented yet)
        --menu_itemname_tournament8 = 'QUARTERFINALS', --Ikemen feature (not implemented yet)
        --menu_itemname_training = 'TRAINING',
        --menu_itemname_freebattle = 'QUICK MATCH', --Ikemen feature
        --menu_itemname_trials = 'TRIALS', --Ikemen feature (not implemented yet)
        --menu_itemname_timeattack = 'TIME ATTACK', --Ikemen feature
        --menu_itemname_survival = 'SURVIVAL',
        --menu_itemname_survivalcoop = 'SURVIVAL CO-OP',
        --menu_itemname_bossrush = 'BOSS RUSH', --Ikemen feature
        --menu_itemname_vs100kumite = 'VS 100 KUMITE', --Ikemen feature
        --menu_itemname_timechallenge = 'TIME CHALLENGE', --Ikemen feature
        --menu_itemname_scorechallenge = 'SCORE CHALLENGE', --Ikemen feature
        --menu_itemname_bonusgames = 'BONUS GAMES', --Ikemen feature
        --menu_itemname_watch = 'AI MATCH',
        --menu_itemname_randomtest = 'RANDOMTEST', --Ikemen feature
        --menu_itemname_replay = 'REPLAY', --Ikemen feature
        --menu_itemname_records = 'RECORDS', --Ikemen feature (not implemented yet)
        --menu_itemname_ranking = 'RANKING', --Ikemen feature (not implemented yet)
        --menu_itemname_options = 'OPTIONS',
        --menu_itemname_back = 'BACK', --Ikemen feature
        --menu_itemname_exit = 'EXIT',
        menu_window_margins_y = {12, 8},
        menu_window_visibleitems = 5,
        --menu_arrow_up_anim = nil, --Ikemen feature
        menu_arrow_up_spr = {}, --Ikemen feature
        menu_arrow_up_offset = {0, 0}, --Ikemen feature
        menu_arrow_up_facing = 1, --Ikemen feature
        menu_arrow_up_scale = {1.0, 1.0}, --Ikemen feature
        --menu_arrow_down_anim = nil, --Ikemen feature
        menu_arrow_down_spr = {}, --Ikemen feature
        menu_arrow_down_offset = {0, 0}, --Ikemen feature
        menu_arrow_down_facing = 1, --Ikemen feature
        menu_arrow_down_scale = {1.0, 1.0}, --Ikemen feature
        menu_boxcursor_visible = 1,
        menu_boxcursor_coords = {-40, -10, 39, 2},
        menu_boxcursor_col = {255, 255, 255}, --Ikemen feature
        menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0}, --Ikemen feature
        menu_boxbg_visible = 0, --Ikemen feature
        menu_boxbg_col = {0, 0, 0}, --Ikemen feature
        menu_boxbg_alpha = {20, 100}, --Ikemen feature
        menu_title_uppercase = 1, --Ikemen feature
        cursor_move_snd = {100, 0},
        cursor_done_snd = {100, 1},
        cancel_snd = {100, 2},
    },
    titlebgdef =
    {
        spr = '',
        bgclearcolor = {0, 0, 0},
    },
    infobox =
    {
        title = '', --Ikemen feature
        title_pos = {159, 19}, --Ikemen feature
        title_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        title_font_scale = {1.0, 1.0}, --Ikemen feature
        title_font_height = -1, --Ikemen feature
        text = "Welcome to SUEHIRO's I.K.E.M.E.N GO engine!\n\n* This is a public development release, for testing purposes.\n* This build may contain bugs and incomplete features.\n* Your help and cooperation are appreciated!\n* I.K.E.M.E.N GO source code: https://osdn.net/users/supersuehiro/\n* Feedback: https://mugenguild.com/forum/topics/ikemen-go-184152.0.html", --Ikemen feature (requires new 'text = ' entry under [Infobox] section)
        text_pos = {25, 32}, --Ikemen feature
        text_font = {'f-4x6.fnt', 0, 1, 191, 191, 191, 255, 0},
        text_font_scale = {1.0, 1.0}, --Ikemen feature
        text_font_height = -1, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
    },
    infobox_text = '', --not used in Ikemen
    ja_infobox_text = '', --not used in Ikemen
    select_info =
    {
        fadein_time = 10,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 10,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        rows = 2,
        columns = 5,
        rows_scrolling = 0, --Ikemen feature
        wrapping = 0,
        wrapping_x = 1, --Ikemen feature
        wrapping_y = 1, --Ikemen feature
        pos = {90, 170},
        doubleselect_enabled = 0, --Ikemen feature
        p1_doubleselect_offset = {-80, 0}, --Ikemen feature
        p2_doubleselect_offset = {-1, 0}, --Ikemen feature
        showemptyboxes = 0,
        moveoveremptyboxes = 0,
        searchemptyboxesup = 0, --Ikemen feature
        searchemptyboxesdown = 0, --Ikemen feature
        cell_size = {27, 27},
        cell_spacing = {2, 2}, --Ikemen feature (optionally accepts x, y values instead of a single one for both coordinates)
        --cell_bg_anim = nil,
        cell_bg_spr = {},
        cell_bg_offset = {0, 0},
        cell_bg_facing = 1,
        cell_bg_scale = {1.0, 1.0},
        --cell_random_anim = nil,
        cell_random_spr = {},
        cell_random_offset = {0, 0},
        cell_random_facing = 1,
        cell_random_scale = {1.0, 1.0},
        cell_random_switchtime = 4,
        --cell_<col>_<row>_offset = {0, 0}, --Ikemen feature
        --cell_<col>_<row>_facing = 1, --Ikemen feature
        p1_cursor_startcell = {0, 0},
        --p1_cursor_active_anim = nil,
        p1_cursor_active_spr = {},
        p1_cursor_active_offset = {0, 0},
        p1_cursor_active_facing = 1,
        p1_cursor_active_scale = {1.0, 1.0},
        --p1_cursor_done_anim = nil,
        p1_cursor_done_spr = {},
        p1_cursor_done_offset = {0, 0},
        p1_cursor_done_facing = 1,
        p1_cursor_done_scale = {1.0, 1.0},
        p1_cursor_move_snd = {100, 0},
        p1_cursor_done_snd = {100, 1},
        p1_random_move_snd = {100, 0},
        p2_cursor_startcell = {0, 4},
        --p2_cursor_active_anim = nil,
        p2_cursor_active_spr = {},
        p2_cursor_active_offset = {0, 0},
        p2_cursor_active_facing = 1,
        p2_cursor_active_scale = {1.0, 1.0},
        --p2_cursor_done_anim = nil,
        p2_cursor_done_spr = {},
        p2_cursor_done_offset = {0, 0},
        p2_cursor_done_facing = 1,
        p2_cursor_done_scale = {1.0, 1.0},
        p2_cursor_blink = 1,
        p2_cursor_move_snd = {100, 0},
        p2_cursor_done_snd = {100, 1},
        p2_random_move_snd = {100, 0},
        random_move_snd_cancel = 0,
        stage_move_snd = {100, 0},
        stage_done_snd = {100, 1},
        cancel_snd = {100, 2},
        portrait_spr = {9000, 0},
        portrait_offset = {0, 0},
        portrait_scale = {1.0, 1.0},
        title_offset = {0, 0},
        title_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0},
        title_font_scale = {1.0, 1.0},
        title_font_height = -1, --Ikemen feature
        title_arcade_text = 'Arcade', --Ikemen feature
        title_teamarcade_text = 'Team Arcade', --Ikemen feature
        title_teamcoop_text = 'Team Cooperative', --Ikemen feature
        title_versus_text = 'Versus Mode', --Ikemen feature
        title_teamversus_text = 'Team Versus', --Ikemen feature
        title_storymode_text = 'Story Mode', --Ikemen feature (not implemented yet)
        title_netplayversus_text = 'Online Versus', --Ikemen feature
        title_netplayteamcoop_text = 'Online Cooperative', --Ikemen feature
        title_netplaysurvivalcoop_text = 'Online Survival', --Ikemen feature
        title_tournament32_text = 'Tournament Mode', --Ikemen feature (not implemented yet)
        title_tournament16_text = 'Tournament Mode', --Ikemen feature (not implemented yet)
        title_tournament8_text = 'Tournament Mode', --Ikemen feature (not implemented yet)
        title_training_text = 'Training Mode', --Ikemen feature
        title_freebattle_text = 'Quick Match', --Ikemen feature
        title_timeattack_text = 'Time Attack', --Ikemen feature
        title_survival_text = 'Survival', --Ikemen feature
        title_survivalcoop_text = 'Survival Cooperative', --Ikemen feature
        title_bossrush_text = 'Boss Rush', --Ikemen feature
        title_vs100kumite_text = 'VS 100 Kumite', --Ikemen feature
        title_timechallenge_text = 'Time Challenge', --Ikemen feature
        title_scorechallenge_text = 'Score Challenge', --Ikemen feature
        title_watch_text = 'Watch Mode', --Ikemen feature
        --title_replay_text = 'Replay', --Ikemen feature
        p1_face_spr = {9000, 1},
        p1_face_offset = {0, 0},
        p1_face_facing = 1,
        p1_face_scale = {1.0, 1.0},
        p1_face_num = 1, --Ikemen feature
        p1_face_spacing = {0, 0}, --Ikemen feature
        p1_c1_face_offset = {0, 0}, --Ikemen feature
        p1_c1_face_scale = {1.0, 1.0}, --Ikemen feature
        p1_c2_face_offset = {0, 0}, --Ikemen feature
        p1_c2_face_scale = {1.0, 1.0}, --Ikemen feature
        p1_c3_face_offset = {0, 0}, --Ikemen feature
        p1_c3_face_scale = {1.0, 1.0}, --Ikemen feature
        p1_c4_face_offset = {0, 0}, --Ikemen feature
        p1_c4_face_scale = {1.0, 1.0}, --Ikemen feature
        p2_face_spr = {9000, 1},
        p2_face_offset = {0, 0},
        p2_face_facing = -1,
        p2_face_scale = {1.0, 1.0},         
        
        p2_face_num = 1, --Ikemen feature
        p2_face_spacing = {0, 0}, --Ikemen feature
        p2_c1_face_offset = {0, 0}, --Ikemen feature
        p2_c1_face_scale = {1.0, 1.0}, --Ikemen feature
        p2_c2_face_offset = {0, 0}, --Ikemen feature
        p2_c2_face_scale = {1.0, 1.0}, --Ikemen feature
        p2_c3_face_offset = {0, 0}, --Ikemen feature
        p2_c3_face_scale = {1.0, 1.0}, --Ikemen feature
        p2_c4_face_offset = {0, 0}, --Ikemen feature
        p2_c4_face_scale = {1.0, 1.0}, --Ikemen feature
        p1_name_offset = {0, 0},
        p1_name_font = {'jg.fnt', 4, 1, 255, 255, 255, 255, 0},
        p1_name_font_scale = {1.0, 1.0},
        p1_name_font_height = -1, --Ikemen feature
        p1_name_spacing = {0, 14},
        p2_name_offset = {0, 0},
        p2_name_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0},
        p2_name_font_scale = {1.0, 1.0},
        p2_name_font_height = -1, --Ikemen feature
        p2_name_spacing = {0, 14},
        stage_pos = {0, 0},
        stage_active_offset = {0, 0}, --Ikemen feature
        stage_active_font = {'f-4x6.fnt', 0, 0, 255, 255, 255, 255, 0},
        stage_active_font_scale = {1.0, 1.0},
        stage_active_font_height = -1, --Ikemen feature
        stage_active2_offset = {0, 0}, --Ikemen feature
        stage_active2_font = {'f-4x6.fnt', 0, 0, 255, 255, 255, 255, 0},
        stage_active2_font_scale = {1.0, 1.0},
        stage_active2_font_height = -1, --Ikemen feature
        stage_done_offset = {0, 0}, --Ikemen feature
        stage_done_font = {'f-4x6.fnt', 0, 0, 255, 255, 255, 255, 0},
        stage_done_font_scale = {1.0, 1.0},
        stage_done_font_height = -1, --Ikemen feature
        stage_text = 'Stage %i: %s', --Ikemen feature
        stage_random_text = 'Stage: Random', --Ikemen feature
        stage_portrait_spr = {9000, 0}, --Ikemen feature
        stage_portrait_offset = {0, 0}, --Ikemen feature
        stage_portrait_scale = {1.0, 1.0}, --Ikemen feature
        stage_portrait_random_spr = {}, --Ikemen feature
        --stage_portrait_random_anim = nil, --Ikemen feature
        stage_portrait_random_offset = {0, 0}, --Ikemen feature
        stage_portrait_random_scale = {1.0, 1.0}, --Ikemen feature
        
        teammenu_key_next = '$D', --Ikemen feature
        teammenu_key_previous = '$U', --Ikemen feature
        teammenu_key_add = '$F', --Ikemen feature
        teammenu_key_subtract = '$B', --Ikemen feature
        teammenu_key_accept = 'a&b&c&x&y&z&s', --Ikemen feature
        teammenu_move_wrapping = 1,
        teammenu_itemname_single = 'Single', --Ikemen feature
        teammenu_itemname_simul = 'Simul', --Ikemen feature
        teammenu_itemname_turns = 'Turns', --Ikemen feature
        teammenu_itemname_tag = '', --Ikemen feature (Tag)
        teammenu_itemname_ratio = '', --Ikemen feature (Ratio)
        p1_teammenu_pos = {0, 0},
        --p1_teammenu_bg_anim = nil,
        p1_teammenu_bg_spr = {},
        p1_teammenu_bg_offset = {0, 0},
        p1_teammenu_bg_facing = 1,
        p1_teammenu_bg_scale = {1.0, 1.0},
        --p1_teammenu_bg_single_anim = nil, --Ikemen feature
        p1_teammenu_bg_single_spr = {}, --Ikemen feature
        p1_teammenu_bg_single_offset = {0, 0}, --Ikemen feature
        p1_teammenu_bg_single_facing = 1, --Ikemen feature
        p1_teammenu_bg_single_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_bg_simul_anim = nil, --Ikemen feature
        p1_teammenu_bg_simul_spr = {}, --Ikemen feature
        p1_teammenu_bg_simul_offset = {0, 0}, --Ikemen feature
        p1_teammenu_bg_simul_facing = 1, --Ikemen feature
        p1_teammenu_bg_simul_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_bg_turns_anim = nil, --Ikemen feature
        p1_teammenu_bg_turns_spr = {}, --Ikemen feature
        p1_teammenu_bg_turns_offset = {0, 0}, --Ikemen feature
        p1_teammenu_bg_turns_facing = 1, --Ikemen feature
        p1_teammenu_bg_turns_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_bg_tag_anim = nil, --Ikemen feature
        p1_teammenu_bg_tag_spr = {}, --Ikemen feature
        p1_teammenu_bg_tag_offset = {0, 0}, --Ikemen feature
        p1_teammenu_bg_tag_facing = 1, --Ikemen feature
        p1_teammenu_bg_tag_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_bg_ratio_anim = nil, --Ikemen feature
        p1_teammenu_bg_ratio_spr = {}, --Ikemen feature
        p1_teammenu_bg_ratio_offset = {0, 0}, --Ikemen feature
        p1_teammenu_bg_ratio_facing = 1, --Ikemen feature
        p1_teammenu_bg_ratio_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_selftitle_anim = nil,
        p1_teammenu_selftitle_spr = {},
        p1_teammenu_selftitle_offset = {0, 0},
        p1_teammenu_selftitle_facing = 1,
        p1_teammenu_selftitle_scale = {1.0, 1.0},
        p1_teammenu_selftitle_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0},
        p1_teammenu_selftitle_font_scale = {1.0, 1.0},
        p1_teammenu_selftitle_font_height = -1, --Ikemen feature
        p1_teammenu_selftitle_text = '',
        --p1_teammenu_enemytitle_anim = nil,
        p1_teammenu_enemytitle_spr = {},
        p1_teammenu_enemytitle_offset = {0, 0},
        p1_teammenu_enemytitle_facing = 1,
        p1_teammenu_enemytitle_scale = {1.0, 1.0},
        p1_teammenu_enemytitle_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0},
        p1_teammenu_enemytitle_font_scale = {1.0, 1.0},
        p1_teammenu_enemytitle_font_height = -1, --Ikemen feature
        p1_teammenu_enemytitle_text = '',
        p1_teammenu_move_snd = {100, 0},
        p1_teammenu_value_snd = {100, 0},
        p1_teammenu_done_snd = {100, 1},
        p1_teammenu_item_offset = {0, 0},
        p1_teammenu_item_spacing = {0, 15},
        p1_teammenu_item_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0},
        p1_teammenu_item_font_scale = {1.0, 1.0},
        p1_teammenu_item_font_height = -1, --Ikemen feature
        p1_teammenu_item_active_font = {'jg.fnt', 3, 1, 255, 255, 255, 255, 0},
        p1_teammenu_item_active_font_scale = {1.0, 1.0},
        p1_teammenu_item_active_font_height = -1, --Ikemen feature
        p1_teammenu_item_active2_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0},
        p1_teammenu_item_active2_font_scale = {1.0, 1.0},
        p1_teammenu_item_active2_font_height = -1, --Ikemen feature
        --p1_teammenu_item_cursor_anim = nil,
        p1_teammenu_item_cursor_spr = {},
        p1_teammenu_item_cursor_offset = {0, 0},
        p1_teammenu_item_cursor_facing = 1,
        p1_teammenu_item_cursor_scale = {1.0, 1.0},
        --p1_teammenu_value_icon_anim = nil,
        p1_teammenu_value_icon_spr = {},
        p1_teammenu_value_icon_offset = {0, 0},
        p1_teammenu_value_icon_facing = 1,
        p1_teammenu_value_icon_scale = {1.0, 1.0},
        --p1_teammenu_value_empty_icon_anim = nil,
        p1_teammenu_value_empty_icon_spr = {},
        p1_teammenu_value_empty_icon_offset = {0, 0},
        p1_teammenu_value_empty_icon_facing = 1,
        p1_teammenu_value_empty_icon_scale = {1.0, 1.0},
        p1_teammenu_value_spacing = {6, 0},
        --p1_teammenu_ratio1_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio1_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio1_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio1_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio1_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio2_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio2_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio2_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio2_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio2_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio3_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio3_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio3_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio3_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio3_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio4_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio4_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio4_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio4_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio4_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio5_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio5_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio5_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio5_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio5_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio6_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio6_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio6_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio6_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio6_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p1_teammenu_ratio7_icon_anim = nil, --Ikemen feature
        p1_teammenu_ratio7_icon_spr = {}, --Ikemen feature
        p1_teammenu_ratio7_icon_offset = {0, 0}, --Ikemen feature
        p1_teammenu_ratio7_icon_facing = 1, --Ikemen feature
        p1_teammenu_ratio7_icon_scale = {1.0, 1.0}, --Ikemen feature
        p2_teammenu_pos = {0, 0},
        --p2_teammenu_bg_anim = nil,
        p2_teammenu_bg_spr = {},
        p2_teammenu_bg_offset = {0, 0},
        p2_teammenu_bg_facing = 1,
        p2_teammenu_bg_scale = {1.0, 1.0},
        --p2_teammenu_bg_single_anim = nil, --Ikemen feature
        p2_teammenu_bg_single_spr = {}, --Ikemen feature
        p2_teammenu_bg_single_offset = {0, 0}, --Ikemen feature
        p2_teammenu_bg_single_facing = 1, --Ikemen feature
        p2_teammenu_bg_single_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_bg_simul_anim = nil, --Ikemen feature
        p2_teammenu_bg_simul_spr = {}, --Ikemen feature
        p2_teammenu_bg_simul_offset = {0, 0}, --Ikemen feature
        p2_teammenu_bg_simul_facing = 1, --Ikemen feature
        p2_teammenu_bg_simul_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_bg_turns_anim = nil, --Ikemen feature
        p2_teammenu_bg_turns_spr = {}, --Ikemen feature
        p2_teammenu_bg_turns_offset = {0, 0}, --Ikemen feature
        p2_teammenu_bg_turns_facing = 1, --Ikemen feature
        p2_teammenu_bg_turns_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_bg_tag_anim = nil, --Ikemen feature
        p2_teammenu_bg_tag_spr = {}, --Ikemen feature
        p2_teammenu_bg_tag_offset = {0, 0}, --Ikemen feature
        p2_teammenu_bg_tag_facing = 1, --Ikemen feature
        p2_teammenu_bg_tag_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_bg_ratio_anim = nil, --Ikemen feature
        p2_teammenu_bg_ratio_spr = {}, --Ikemen feature
        p2_teammenu_bg_ratio_offset = {0, 0}, --Ikemen feature
        p2_teammenu_bg_ratio_facing = 1, --Ikemen feature
        p2_teammenu_bg_ratio_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_selftitle_anim = nil,
        p2_teammenu_selftitle_spr = {},
        p2_teammenu_selftitle_offset = {0, 0},
        p2_teammenu_selftitle_facing = 1,
        p2_teammenu_selftitle_scale = {1.0, 1.0},
        p2_teammenu_selftitle_font = {'jg.fnt', 0, -1, 255, 255, 255, 255, 0},
        p2_teammenu_selftitle_font_scale = {1.0, 1.0},
        p2_teammenu_selftitle_font_height = -1, --Ikemen feature
        p2_teammenu_selftitle_text = '',
        --p2_teammenu_enemytitle_anim = nil,
        p2_teammenu_enemytitle_spr = {},
        p2_teammenu_enemytitle_offset = {0, 0},
        p2_teammenu_enemytitle_facing = 1,
        p2_teammenu_enemytitle_scale = {1.0, 1.0},
        p2_teammenu_enemytitle_font = {'jg.fnt', 0, -1, 255, 255, 255, 255, 0},
        p2_teammenu_enemytitle_font_scale = {1.0, 1.0},
        p2_teammenu_enemytitle_font_height = -1, --Ikemen feature
        p2_teammenu_enemytitle_text = '',
        p2_teammenu_move_snd = {100, 0},
        p2_teammenu_value_snd = {100, 0},
        p2_teammenu_done_snd = {100, 1},
        p2_teammenu_item_offset = {0, 0},
        p2_teammenu_item_spacing = {0, 15},
        p2_teammenu_item_font = {'jg.fnt', 0, -1, 255, 255, 255, 255, 0},
        p2_teammenu_item_font_scale = {1.0, 1.0},
        p2_teammenu_item_font_height = -1, --Ikemen feature
        p2_teammenu_item_active_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0},
        p2_teammenu_item_active_font_scale = {1.0, 1.0},
        p2_teammenu_item_active_font_height = -1, --Ikemen feature
        p2_teammenu_item_active2_font = {'jg.fnt', 0, -1, 255, 255, 255, 255, 0},
        p2_teammenu_item_active2_font_scale = {1.0, 1.0},
        p2_teammenu_item_active2_font_height = -1, --Ikemen feature
        --p2_teammenu_item_cursor_anim = nil,
        p2_teammenu_item_cursor_spr = {},
        p2_teammenu_item_cursor_offset = {0, 0},
        p2_teammenu_item_cursor_facing = 1,
        p2_teammenu_item_cursor_scale = {1.0, 1.0},
        --p2_teammenu_value_icon_anim = nil,
        p2_teammenu_value_icon_spr = {},
        p2_teammenu_value_icon_offset = {0, 0},
        p2_teammenu_value_icon_facing = 1,
        p2_teammenu_value_icon_scale = {1.0, 1.0},
        --p2_teammenu_value_empty_icon_anim = nil,
        p2_teammenu_value_empty_icon_spr = {},
        p2_teammenu_value_empty_icon_offset = {0, 0},
        p2_teammenu_value_empty_icon_facing = 1,
        p2_teammenu_value_empty_icon_scale = {1.0, 1.0},
        p2_teammenu_value_spacing = {-6, 0},
        --p2_teammenu_ratio1_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio1_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio1_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio1_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio1_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio2_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio2_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio2_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio2_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio2_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio3_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio3_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio3_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio3_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio3_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio4_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio4_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio4_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio4_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio4_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio5_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio5_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio5_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio5_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio5_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio6_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio6_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio6_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio6_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio6_icon_scale = {1.0, 1.0}, --Ikemen feature
        --p2_teammenu_ratio7_icon_anim = nil, --Ikemen feature
        p2_teammenu_ratio7_icon_spr = {}, --Ikemen feature
        p2_teammenu_ratio7_icon_offset = {0, 0}, --Ikemen feature
        p2_teammenu_ratio7_icon_facing = 1, --Ikemen feature
        p2_teammenu_ratio7_icon_scale = {1.0, 1.0}, --Ikemen feature
        timer_enabled = 0, --Ikemen feature
        timer_offset = {0, 0}, --Ikemen feature
        timer_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        timer_font_scale = {1.0, 1.0}, --Ikemen feature
        timer_font_height = -1, --Ikemen feature
        timer_count = 99, --Ikemen feature
        timer_framespercount = 60, --Ikemen feature
        timer_displaytime = 10, --Ikemen feature
        record_offset = {0, 0}, --Ikemen feature
        record_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        record_font_scale = {1.0, 1.0}, --Ikemen feature
        record_font_height = -1, --Ikemen feature
        record_scorechallenge_text = '', --Ikemen feature
        record_timechallenge_text = '', --Ikemen feature
        p1_select_snd = {-1, 0}, --Ikemen feature
        p2_select_snd = {-1, 0}, --Ikemen feature
    },
    selectbgdef =
    {
        spr = '',
        bgclearcolor = {0, 0, 0},
    },
    vs_screen =
    {
        fadein_time = 15,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 15,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        time = 150,
        time_order = 60, --Ikemen feature
        match_text = 'Match %i',
        match_offset = {159, 12},
        match_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0},
        match_font_scale = {1.0, 1.0},
        match_font_height = -1, --Ikemen feature
        p1_pos = {0, 0},
        p1_spr = {9000, 1},
        p1_offset = {0, 0},
        p1_facing = 1,
        p1_scale = {1.0, 1.0},
        
        p1_num = 1, --Ikemen feature
        p1_spacing = {0, 0}, --Ikemen feature
        p1_c1_offset = {0, 0}, --Ikemen feature
        p1_c1_scale = {1.0, 1.0}, --Ikemen feature
        p1_c1_slide_speed = {0, 0}, --Ikemen feature
        p1_c1_slide_dist = {0, 0}, --Ikemen feature
        p1_c2_offset = {0, 0}, --Ikemen feature
        p1_c2_scale = {1.0, 1.0}, --Ikemen feature
        p1_c2_slide_speed = {0, 0}, --Ikemen feature
        p1_c2_slide_dist = {0, 0}, --Ikemen feature
        p1_c3_offset = {0, 0}, --Ikemen feature
        p1_c3_scale = {1.0, 1.0}, --Ikemen feature
        p1_c3_slide_speed = {0, 0}, --Ikemen feature
        p1_c3_slide_dist = {0, 0}, --Ikemen feature
        p1_c4_offset = {0, 0}, --Ikemen feature
        p1_c4_scale = {1.0, 1.0}, --Ikemen feature
        p1_c4_slide_speed = {0, 0}, --Ikemen feature
        p1_c4_slide_dist = {0, 0}, --Ikemen feature
        p2_pos = {0, 0},
        p2_spr = {9000, 1},
        p2_offset = {0, 0},
        p2_facing = -1,
        p2_scale = {1.0, 1.0},
        
        p2_num = 1, --Ikemen feature
        p2_spacing = {0, 0}, --Ikemen feature
        p2_c1_offset = {0, 0}, --Ikemen feature
        p2_c1_scale = {1.0, 1.0}, --Ikemen feature
        p2_c1_slide_speed = {0, 0}, --Ikemen feature
        p2_c1_slide_dist = {0, 0}, --Ikemen feature
        p2_c2_offset = {0, 0}, --Ikemen feature
        p2_c2_scale = {1.0, 1.0}, --Ikemen feature
        p2_c2_slide_speed = {0, 0}, --Ikemen feature
        p2_c2_slide_dist = {0, 0}, --Ikemen feature
        p2_c3_offset = {0, 0}, --Ikemen feature
        p2_c3_scale = {1.0, 1.0}, --Ikemen feature
        p2_c3_slide_speed = {0, 0}, --Ikemen feature
        p2_c3_slide_dist = {0, 0}, --Ikemen feature
        p2_c4_offset = {0, 0}, --Ikemen feature
        p2_c4_scale = {1.0, 1.0}, --Ikemen feature
        p2_c4_slide_speed = {0, 0}, --Ikemen feature
        p2_c4_slide_dist = {0, 0}, --Ikemen feature
        p1_name_pos = {0, 0},
        p1_name_offset = {0, 0},
        p1_name_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0},
        p1_name_font_scale = {1.0, 1.0},
        p1_name_font_height = -1, --Ikemen feature
        p1_name_spacing = {0, 14},
        p2_name_pos = {0, 0},
        p2_name_offset = {0, 0},
        p2_name_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0},
        p2_name_font_scale = {1.0, 1.0},
        p2_name_font_height = -1, --Ikemen feature
        p2_name_spacing = {0, 14},
        --p1_name_active_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        --p1_name_active_font_scale = {1.0, 1.0}, --Ikemen feature
        --p1_name_active_font_height = -1, --Ikemen feature
        --p2_name_active_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        --p2_name_active_font_scale = {1.0, 1.0}, --Ikemen feature
        --p2_name_active_font_height = -1, --Ikemen feature
        p1_cursor_move_snd = {100, 0}, --Ikemen feature
        p1_cursor_done_snd = {100, 1}, --Ikemen feature
        p2_cursor_move_snd = {100, 0}, --Ikemen feature
        p2_cursor_done_snd = {100, 1}, --Ikemen feature
        stage_snd = {9000, 0}, --Ikemen feature
        stage_time = 0, --Ikemen feature
    },
    versusbgdef =
    {
        spr = '',
        bgclearcolor = {0, 0, 0},
    },
    demo_mode =
    {
        enabled = 1,
        select_enabled = 0, --not used in ikemen
        vsscreen_enabled = 0, --not used in ikemen
        title_waittime = 600,
        fight_endtime = 1500,
        fight_playbgm = 0,
        fight_stopbgm = 0,
        fight_bars_display = 0,
        intro_waitcycles = 1,
        debuginfo = 0,
        fadein_time = 50, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 50, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
    },
    continue_screen =
    {
        --parameters used by both legacy and animated continue screens
        enabled = 1,
        animated_continue = 0, --Ikemen feature
        external_gameover = 1, --Ikemen feature
        fadein_time = 8, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 120, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_continue = {5500, 5300}, --Ikemen feature
        p1_statedef_yes = {5510, 180}, --Ikemen feature
        p1_statedef_no = {5520, 170}, --Ikemen feature
        p2_statedef_continue = {}, --Ikemen feature
        p2_statedef_yes = {}, --Ikemen feature
        p2_statedef_no = {}, --Ikemen feature
        --legacy continue screen (used only if animated.continue = 0)
        pos = {160, 40},
        continue_text = 'Continue?',
        continue_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        continue_font_scale = {1.0, 1.0},
        continue_font_height = -1, --Ikemen feature
        continue_offset = {0, 0},
        yes_text = 'Yes',
        yes_font = {'f-6x9.def', 0, 0, 191, 191, 191, 255, 0},
        yes_font_scale = {1.0, 1.0},
        yes_font_height = -1, --Ikemen feature
        yes_offset = {-17, 20},
        yes_active_text = 'Yes',
        yes_active_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        yes_active_font_scale = {1.0, 1.0},
        yes_active_font_height = -1, --Ikemen feature
        yes_active_offset = {-17, 20},
        no_text = 'No',
        no_font = {'f-6x9.def', 0, 0, 191, 191, 191, 255, 0},
        no_font_scale = {1.0, 1.0},
        no_font_height = -1, --Ikemen feature
        no_offset = {15, 20},
        no_active_text = 'No',
        no_active_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        no_active_font_scale = {1.0, 1.0},
        no_active_font_height = -1, --Ikemen feature
        no_active_offset = {15, 20},
        move_snd = {100, 0}, --Ikemen feature
        done_snd = {100, 1}, --Ikemen feature
        cancel_snd = {100, 2}, --Ikemen feature
        --animated continue screen (used only if animated.continue = 1)
        endtime = 0, --Ikemen feature
        continue_starttime = 0, --Ikemen feature
        --continue_anim = nil, --Ikemen feature
        continue_offset = {0, 0}, --Ikemen feature
        continue_scale = {1.0, 1.0}, --Ikemen feature
        continue_skipstart = 0, --Ikemen feature
        continue_9_skiptime = 0, --Ikemen feature
        continue_9_snd = {0, 0}, --Ikemen feature
        continue_8_skiptime = 0, --Ikemen feature
        continue_8_snd = {0, 0}, --Ikemen feature
        continue_7_skiptime = 0, --Ikemen feature
        continue_7_snd = {0, 0}, --Ikemen feature
        continue_6_skiptime = 0, --Ikemen feature
        continue_6_snd = {0, 0}, --Ikemen feature
        continue_5_skiptime = 0, --Ikemen feature
        continue_5_snd = {0, 0}, --Ikemen feature
        continue_4_skiptime = 0, --Ikemen feature
        continue_4_snd = {0, 0}, --Ikemen feature
        continue_3_skiptime = 0, --Ikemen feature
        continue_3_snd = {0, 0}, --Ikemen feature
        continue_2_skiptime = 0, --Ikemen feature
        continue_2_snd = {0, 0}, --Ikemen feature
        continue_1_skiptime = 0, --Ikemen feature
        continue_1_snd = {0, 0}, --Ikemen feature
        continue_0_skiptime = 0, --Ikemen feature
        continue_0_snd = {0, 0}, --Ikemen feature
        continue_end_skiptime = 0, --Ikemen feature
        continue_end_snd = {0, 0}, --Ikemen feature
        credits_text = 'Credits: %i', --Ikemen feature
        credits_offset = {0, 0}, --Ikemen feature
        credits_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        credits_font_scale = {1.0, 1.0}, --Ikemen feature
        credits_font_height = -1, --Ikemen feature
    },
    continuebgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    },
    game_over_screen =
    {
        enabled = 1,
        storyboard = '',
    },
    victory_screen =
    {
        enabled = 0,
        cpu_enabled = 1, --Ikemen feature
        vs_enabled = 1, --Ikemen feature
        loser_name_enabled = 0, --Ikemen feature
        winner_teamko_enabled = 0, --Ikemen feature
        time = 300,
        fadein_time = 0,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 15,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        p1_pos = {0, 0},
        p1_spr = {9000, 2},
        p1_offset = {100, 20},
        p1_facing = 1,
        p1_scale = {1.0, 1.0},
        
        p1_num = 1, --Ikemen feature
        p1_c1_spr = {9000, 2}, --Ikemen feature
        p1_c1_offset = {0, 0}, --Ikemen feature
        p1_c1_scale = {1.0, 1.0}, --Ikemen feature
        p1_c1_slide_speed = {0, 0}, --Ikemen feature
        p1_c1_slide_dist = {0, 0}, --Ikemen feature
        p1_c2_spr = {9000, 2}, --Ikemen feature
        p1_c2_offset = {0, 0}, --Ikemen feature
        p1_c2_scale = {1.0, 1.0}, --Ikemen feature
        p1_c2_slide_speed = {0, 0}, --Ikemen feature
        p1_c2_slide_dist = {0, 0}, --Ikemen feature
        p1_c3_spr = {9000, 2}, --Ikemen feature
        p1_c3_offset = {0, 0}, --Ikemen feature
        p1_c3_scale = {1.0, 1.0}, --Ikemen feature
        p1_c3_slide_speed = {0, 0}, --Ikemen feature
        p1_c3_slide_dist = {0, 0}, --Ikemen feature
        p1_c4_spr = {9000, 2}, --Ikemen feature
        p1_c4_offset = {0, 0}, --Ikemen feature
        p1_c4_scale = {1.0, 1.0}, --Ikemen feature
        p1_c4_slide_speed = {0, 0}, --Ikemen feature
        p1_c4_slide_dist = {0, 0}, --Ikemen feature
        p1_name_offset = {20, 180},
        p1_name_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0},
        p1_name_font_scale = {1.0, 1.0},
        p1_name_font_height = -1, --Ikemen feature
        p2_pos = {0, 0}, --Ikemen feature
        p2_spr = {9000, 2}, --Ikemen feature
        p2_offset = {100, 20}, --Ikemen feature
        p2_facing = 1, --Ikemen feature
        p2_scale = {1.0, 1.0}, --Ikemen feature
        
        p2_num = 0, --Ikemen feature
        p2_c1_spr = {9000, 2}, --Ikemen feature
        p2_c1_offset = {0, 0}, --Ikemen feature
        p2_c1_scale = {1.0, 1.0}, --Ikemen feature
        p2_c1_slide_speed = {0, 0}, --Ikemen feature
        p2_c1_slide_dist = {0, 0}, --Ikemen feature
        p2_c2_spr = {9000, 2}, --Ikemen feature
        p2_c2_offset = {0, 0}, --Ikemen feature
        p2_c2_scale = {1.0, 1.0}, --Ikemen feature
        p2_c2_slide_speed = {0, 0}, --Ikemen feature
        p2_c2_slide_dist = {0, 0}, --Ikemen feature
        p2_c3_spr = {9000, 2}, --Ikemen feature
        p2_c3_offset = {0, 0}, --Ikemen feature
        p2_c3_scale = {1.0, 1.0}, --Ikemen feature
        p2_c3_slide_speed = {0, 0}, --Ikemen feature
        p2_c3_slide_dist = {0, 0}, --Ikemen feature
        p2_c4_spr = {9000, 2}, --Ikemen feature
        p2_c4_offset = {0, 0}, --Ikemen feature
        p2_c4_scale = {1.0, 1.0}, --Ikemen feature
        p2_c4_slide_speed = {0, 0}, --Ikemen feature
        p2_c4_slide_dist = {0, 0}, --Ikemen feature
        p2_name_offset = {20, 180}, --Ikemen feature
        p2_name_font = {'jg.fnt', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        p2_name_font_scale = {1.0, 1.0}, --Ikemen feature
        p2_name_font_height = -1, --Ikemen feature
        winquote_text = 'Winner!',
        winquote_offset = {20, 192},
        winquote_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0},
        winquote_font_scale = {1.0, 1.0},
        winquote_font_height = -1, --Ikemen feature
        winquote_delay = 2, --Ikemen feature
        winquote_textwrap = 'w', --default wrapping when winquote.length is not set
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
    },
    victorybgdef =
    {
        spr = '',
        bgclearcolor = {0, 0, 0},
    },
    win_screen =
    {
        enabled = 1,
        time = 300, --Ikemen feature
        fadein_time = 0,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        pose_time = 300,
        wintext_text = 'Congratulations!',
        wintext_offset = {159, 70},
        wintext_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        wintext_font_scale = {1.0, 1.0},
        wintext_font_height = -1, --Ikemen feature
        wintext_displaytime = -1,
        wintext_layerno = 2,
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef = {180}, --Ikemen feature
        p2_statedef = {}, --Ikemen feature
    },
    default_ending =
    {
        enabled = 0,
        storyboard = '',
    },
    end_credits =
    {
        enabled = 0,
        storyboard = '',
    },
    survival_results_screen =
    {
        enabled = 1,
        time = 300, --Ikemen feature
        fadein_time = 0,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300,
        winstext_text = 'Rounds survived: %i',
        winstext_offset = {159, 70},
        winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0},
        winstext_font_scale = {1.0, 1.0},
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1,
        winstext_layerno = 2,
        roundstowin = 5,
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_win = {180}, --Ikemen feature
        p1_statedef_lose = {175, 170}, --Ikemen feature
        p2_statedef_win = {}, --Ikemen feature
        p2_statedef_lose = {}, --Ikemen feature
    },
    vs100_kumite_results_screen =
    {
        enabled = 1, --Ikemen feature
        time = 300, --Ikemen feature
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300, --Ikemen feature
        winstext_text = 'Wins: %i\nLoses: %i', --Ikemen feature
        winstext_offset = {159, 70}, --Ikemen feature
        winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        winstext_font_scale = {1.0, 1.0}, --Ikemen feature
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1, --Ikemen feature
        winstext_layerno = 2, --Ikemen feature
        roundstowin = 51, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_win = {180}, --Ikemen feature
        p1_statedef_lose = {175, 170}, --Ikemen feature
        p2_statedef_win = {}, --Ikemen feature
        p2_statedef_lose = {}, --Ikemen feature
    },
    time_attack_results_screen =
    {
        enabled = 1, --Ikemen feature
        time = 300, --Ikemen feature
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300, --Ikemen feature
        winstext_text = 'Clear Time: %m:%s.%x', --Ikemen feature
        winstext_offset = {159, 70}, --Ikemen feature
        winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        winstext_font_scale = {1.0, 1.0}, --Ikemen feature
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1, --Ikemen feature
        winstext_layerno = 2, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_win = {180}, --Ikemen feature
        p1_statedef_lose = {175, 170}, --Ikemen feature
        p2_statedef_win = {}, --Ikemen feature
        p2_statedef_lose = {}, --Ikemen feature
    },
    time_challenge_results_screen =
    {
        enabled = 1, --Ikemen feature
        time = 300, --Ikemen feature
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300, --Ikemen feature
        winstext_text = 'Clear Time: %m:%s.%x', --Ikemen feature
        winstext_offset = {159, 70}, --Ikemen feature
        winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        winstext_font_scale = {1.0, 1.0}, --Ikemen feature
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1, --Ikemen feature
        winstext_layerno = 2, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_win = {180}, --Ikemen feature
        p1_statedef_lose = {175, 170}, --Ikemen feature
        p2_statedef_win = {}, --Ikemen feature
        p2_statedef_lose = {}, --Ikemen feature
    },
    score_challenge_results_screen =
    {
        enabled = 1, --Ikemen feature
        time = 300, --Ikemen feature
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300, --Ikemen feature
        winstext_text = 'Score: %i', --Ikemen feature
        winstext_offset = {159, 70}, --Ikemen feature
        winstext_font = {'jg.fnt', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        winstext_font_scale = {1.0, 1.0}, --Ikemen feature
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1, --Ikemen feature
        winstext_layerno = 2, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef_win = {180}, --Ikemen feature
        p1_statedef_lose = {175, 170}, --Ikemen feature
        p2_statedef_win = {}, --Ikemen feature
        p2_statedef_lose = {}, --Ikemen feature
    },
    boss_rush_results_screen =
    {
        enabled = 1, --Ikemen feature
        time = 300, --Ikemen feature
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 64, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        show_time = 300, --Ikemen feature
        winstext_text = 'Congratulations!', --Ikemen feature
        winstext_offset = {159, 70}, --Ikemen feature
        winstext_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        winstext_font_scale = {1.0, 1.0}, --Ikemen feature
        winstext_font_height = -1, --Ikemen feature
        winstext_displaytime = -1, --Ikemen feature
        winstext_layerno = 2, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        p1_statedef = {180}, --Ikemen feature
        p2_statedef = {}, --Ikemen feature
    },
    resultsbgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature (disabled to not cover game screen)
    },
    option_info =
    {
        fadein_time = 10,
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 10,
        fadeout_col = {0, 0, 0}, --Ikemen feature
        title_offset = {159, 19},
        title_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
        title_font_scale = {1.0, 1.0},
        title_font_height = -1, --Ikemen feature
        title_text = 'OPTIONS', --Ikemen feature
        menu_pos = {85, 33}, --Ikemen feature
        menu_item_font = {'f-6x9.def', 0, 1, 191, 191, 191, 255, 0}, --Ikemen feature
        menu_item_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_font_height = -1, --Ikemen feature
        menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        menu_item_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_active_font_height = -1, --Ikemen feature
        menu_item_selected_font = {'f-6x9.def', 0, 1, 0, 247, 247, 255, 0}, --Ikemen feature
        menu_item_selected_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_selected_font_height = -1, --Ikemen feature
        menu_item_selected_active_font = {'f-6x9.def', 0, 1, 0, 247, 247, 255, 0}, --Ikemen feature
        menu_item_selected_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_selected_active_font_height = -1, --Ikemen feature
        menu_item_value_font = {'f-6x9.def', 0, -1, 191, 191, 191, 255, 0}, --Ikemen feature
        menu_item_value_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_value_font_height = -1, --Ikemen feature
        menu_item_value_active_font = {'f-6x9.def', 0, -1, 255, 255, 255, 255, 0}, --Ikemen feature
        menu_item_value_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_value_active_font_height = -1, --Ikemen feature
        menu_item_value_conflict_font = {'f-6x9.def', 0, -1, 247, 0, 0, 255, 0}, --Ikemen feature
        menu_item_value_conflict_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_value_conflict_font_height = -1, --Ikemen feature
        menu_item_spacing = {150, 13}, --Ikemen feature
        --menu_itemname_roundtime = 'Time Limit', --Ikemen feature
        --menu_itemname_roundsnumsingle = 'Rounds to Win Single', --Ikemen feature
        --menu_itemname_roundsnumteam = 'Rounds to Win Simul/Tag', --Ikemen feature
        --menu_itemname_maxdrawgames = 'Max Draw Games', --Ikemen feature
        --menu_itemname_difficulty = 'Difficulty Level', --Ikemen feature
        --menu_itemname_credits = 'Credits', --Ikemen feature
        --menu_itemname_quickcontinue = 'Quick Continue', --Ikemen feature
        --menu_itemname_airamping = 'AI Ramping', --Ikemen feature
        --menu_itemname_aipalette = 'AI Palette', --Ikemen feature
        --menu_itemname_resolution = 'Resolution', --Ikemen feature
        --menu_itemname_customres = 'Custom', --Ikemen feature
        --menu_itemname_fullscreen = 'Fullscreen', --Ikemen feature
        --menu_itemname_vretrace = 'VSync', --Ikemen feature
        --menu_itemname_msaa = 'MSAA', --Ikemen feature
        --menu_itemname_shaders = 'Shaders', --Ikemen feature
        --menu_itemname_noshader = 'Disable', --Ikemen feature
        --menu_itemname_mastervolume = 'Master Volume', --Ikemen feature
        --menu_itemname_bgmvolume = 'BGM Volume', --Ikemen feature
        --menu_itemname_sfxvolume = 'SFX Volume', --Ikemen feature
        --menu_itemname_audioducking = 'Audio Ducking', --Ikemen feature
        --menu_itemname_keyboard = 'Key Config', --Ikemen feature
        --menu_itemname_gamepad = 'Joystick Config', --Ikemen feature
        --menu_itemname_inputdefault = 'Default', --Ikemen feature
        --menu_itemname_lifemul = 'Life', --Ikemen feature
        --menu_itemname_gamespeed = 'Game Speed', --Ikemen feature
        --menu_itemname_autoguard = 'Auto-Guard', --Ikemen feature
        --menu_itemname_singlevsteamlife = 'Single VS Team Life', --Ikemen feature
        --menu_itemname_teamlifeadjustment = 'Team Life Adjustment', --Ikemen feature
        --menu_itemname_teampowershare = 'Team Power Share', --Ikemen feature
        --menu_itemname_losekosimul = 'Simul Player KOed Lose', --Ikemen feature
        --menu_itemname_losekotag = 'Tag Partner KOed Lose', --Ikemen feature
        --menu_itemname_turnsrecoverybase = 'Turns Recovery Base', --Ikemen feature
        --menu_itemname_turnsrecoverybonus = 'Turns Recovery Bonus', --Ikemen feature
        --menu_itemname_ratio1life = 'Ratio 1 Life', --Ikemen feature
        --menu_itemname_ratio1attack = 'Ratio 1 Damage', --Ikemen feature
        --menu_itemname_ratio2life = 'Ratio 2 Life', --Ikemen feature
        --menu_itemname_ratio2attack = 'Ratio 2 Damage', --Ikemen feature
        --menu_itemname_ratio3life = 'Ratio 3 Life', --Ikemen feature
        --menu_itemname_ratio3attack = 'Ratio 3 Damage', --Ikemen feature
        --menu_itemname_ratio4life = 'Ratio 4 Life', --Ikemen feature
        --menu_itemname_ratio4attack = 'Ratio 4 Damage', --Ikemen feature
        --menu_itemname_minturns = 'Min Turns Chars', --Ikemen feature
        --menu_itemname_maxturns = 'Max Turns Chars', --Ikemen feature
        --menu_itemname_minsimul = 'Min Simul Chars', --Ikemen feature
        --menu_itemname_maxsimul = 'Max Simul Chars', --Ikemen feature
        --menu_itemname_mintag = 'Min Tag Chars', --Ikemen feature
        --menu_itemname_maxtag = 'Max Tag Chars', --Ikemen feature
        --menu_itemname_debugkeys = 'Debug Keys', --Ikemen feature
        --menu_itemname_helpermax = 'HelperMax', --Ikemen feature
        --menu_itemname_projectilemax = 'PlayerProjectileMax', --Ikemen feature
        --menu_itemname_explodmax = 'ExplodMax', --Ikemen feature
        --menu_itemname_afterimagemax = 'AfterImageMax', --Ikemen feature
        --menu_itemname_portchange = 'Port Change', --Ikemen feature
        --menu_itemname_default = 'Default Values', --Ikemen feature
        --menu_itemname_empty = '', --Ikemen feature
        --menu_itemname_back = 'Back', --Ikemen feature
        --menu_itemname_savereturn = 'Save and Return', --Ikemen feature
        --menu_itemname_return = 'Return Without Saving', --Ikemen feature
        menu_itemname_key_playerno = 'PLAYER', --Ikemen feature
        menu_itemname_key_all = 'Config all', --Ikemen feature
        menu_itemname_key_up = 'Up', --Ikemen feature
        menu_itemname_key_down = 'Down', --Ikemen feature
        menu_itemname_key_left = 'Left', --Ikemen feature
        menu_itemname_key_right = 'Right', --Ikemen feature
        menu_itemname_key_a = 'A', --Ikemen feature
        menu_itemname_key_b = 'B', --Ikemen feature
        menu_itemname_key_c = 'C', --Ikemen feature
        menu_itemname_key_x = 'X', --Ikemen feature
        menu_itemname_key_y = 'Y', --Ikemen feature
        menu_itemname_key_z = 'Z', --Ikemen feature
        menu_itemname_key_start = 'Start', --Ikemen feature
        menu_itemname_key_d = 'D', --Ikemen feature
        menu_itemname_key_w = 'W', --Ikemen feature
        menu_itemname_key_menu = 'Menu', --Ikemen feature
        menu_itemname_key_back = 'Back', --Ikemen feature
        menu_valuename_none = 'None', --Ikemen feature
        menu_valuename_random = 'Random', --Ikemen feature
        menu_valuename_default = 'Default', --Ikemen feature
        menu_valuename_f1 = '(F1)', --Ikemen feature
        menu_valuename_f2 = '(F2)', --Ikemen feature
        menu_valuename_esc = '(Esc)', --Ikemen feature
        menu_valuename_next = '(Tab)', --Ikemen feature
        menu_valuename_nokey = 'Not used', --Ikemen feature
        menu_valuename_yes = 'Yes', --Ikemen feature
        menu_valuename_no = 'No', --Ikemen feature
        menu_valuename_enabled = 'Enabled', --Ikemen feature
        menu_valuename_disabled = 'Disabled', --Ikemen feature
        menu_window_margins_y = {0, 0}, --Ikemen feature
        menu_window_visibleitems = 16, --Ikemen feature
        --menu_arrow_up_anim = nil, --Ikemen feature
        menu_arrow_up_spr = {}, --Ikemen feature
        menu_arrow_up_offset = {0, 0}, --Ikemen feature
        menu_arrow_up_facing = 1, --Ikemen feature
        menu_arrow_up_scale = {1.0, 1.0}, --Ikemen feature
        --menu_arrow_down_anim = nil, --Ikemen feature
        menu_arrow_down_spr = {}, --Ikemen feature
        menu_arrow_down_offset = {0, 0}, --Ikemen feature
        menu_arrow_down_facing = 1, --Ikemen feature
        menu_arrow_down_scale = {1.0, 1.0}, --Ikemen feature
        menu_boxcursor_visible = 1, --Ikemen feature
        menu_boxcursor_coords = {-5, -10, 154, 2}, --Ikemen feature
        menu_boxcursor_col = {255, 255, 255}, --Ikemen feature
        menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0}, --Ikemen feature
        menu_boxbg_visible = 1, --Ikemen feature
        menu_boxbg_col = {0, 0, 0}, --Ikemen feature
        menu_boxbg_alpha = {20, 100}, --Ikemen feature
        menu_title_uppercase = 1, --Ikemen feature
        menu_item_key_p1_font = {'f-6x9.def', 0, 0, 0, 247, 247, 255, 0}, --Ikemen feature
        menu_item_key_p1_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_key_p1_font_height = -1, --Ikemen feature
        menu_item_key_p2_font = {'f-6x9.def', 0, 0, 247, 0, 0, 255, 0}, --Ikemen feature
        menu_item_key_p2_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_key_p2_font_height = -1, --Ikemen feature
        menu_item_info_font = {'f-6x9.def', 0, -1, 247, 247, 0, 255, 0}, --Ikemen feature
        menu_item_info_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_info_font_height = -1, --Ikemen feature
        menu_item_info_active_font = {'f-6x9.def', 0, -1, 247, 247, 0, 255, 0}, --Ikemen feature
        menu_item_info_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_info_active_font_height = -1, --Ikemen feature
        menu_item_p1_pos = {91, 33}, --Ikemen feature
        menu_item_p2_pos = {230, 33}, --Ikemen feature
        menu_key_p1_pos = {39, 33}, --Ikemen feature
        menu_key_p2_pos = {178, 33}, --Ikemen feature
        menu_key_item_spacing = {101, 12}, --Ikemen feature
        menu_key_boxcursor_coords = {-5, -9, 106, 2}, --Ikemen feature
        input_port_text = 'Type in Host Port, e.g. 7500.\nPress ENTER to accept.\nPress ESC to cancel.', --Ikemen feature
        input_reswidth_text = 'Type in screen width.\nPress ENTER to accept.\nPress ESC to cancel.', --Ikemen feature
        input_resheight_text = 'Type in screen height.\nPress ENTER to accept.\nPress ESC to cancel.', --Ikemen feature
        input_key_text = 'Press a key to assign to entry.\nPress SPACE to disable key.\nPress ESC to cancel.', --Ikemen feature
        cursor_move_snd = {100, 0},
        cursor_done_snd = {100, 1},
        cancel_snd = {100, 2},
    },
    optionbgdef =
    {
        spr = '',
        bgclearcolor = {0, 0, 0},
    },
    replay_info =
    {
        fadein_time = 10, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 10, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        title_offset = {159, 19}, --Ikemen feature
        title_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        title_font_scale = {1.0, 1.0}, --Ikemen feature
        title_font_height = -1, --Ikemen feature
        title_text = 'REPLAY SELECT', --Ikemen feature
        menu_pos = {85, 33}, --Ikemen feature
        menu_item_font = {'f-6x9.def', 0, 1, 191, 191, 191, 255, 0}, --Ikemen feature
        menu_item_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_font_height = -1, --Ikemen feature
        menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        menu_item_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_active_font_height = -1, --Ikemen feature
        menu_item_spacing = {150, 13}, --Ikemen feature
        menu_itemname_back = 'Back', --Ikemen feature
        menu_window_margins_y = {0, 0}, --Ikemen feature
        menu_window_visibleitems = 15, --Ikemen feature
        --menu_arrow_up_anim = nil, --Ikemen feature
        menu_arrow_up_spr = {}, --Ikemen feature
        menu_arrow_up_offset = {0, 0}, --Ikemen feature
        menu_arrow_up_facing = 1, --Ikemen feature
        menu_arrow_up_scale = {1.0, 1.0}, --Ikemen feature
        --menu_arrow_down_anim = nil, --Ikemen feature
        menu_arrow_down_spr = {}, --Ikemen feature
        menu_arrow_down_offset = {0, 0}, --Ikemen feature
        menu_arrow_down_facing = 1, --Ikemen feature
        menu_arrow_down_scale = {1.0, 1.0}, --Ikemen feature
        menu_boxcursor_visible = 1, --Ikemen feature
        menu_boxcursor_coords = {-5, -10, 154, 2}, --Ikemen feature
        menu_boxcursor_col = {255, 255, 255}, --Ikemen feature
        menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0}, --Ikemen feature
        menu_boxbg_visible = 1, --Ikemen feature
        menu_boxbg_col = {0, 0, 0}, --Ikemen feature
        menu_boxbg_alpha = {20, 100}, --Ikemen feature
        menu_title_uppercase = 1, --Ikemen feature
        cursor_move_snd = {100, 0}, --Ikemen feature
        cursor_done_snd = {100, 1}, --Ikemen feature
        cancel_snd = {100, 2}, --Ikemen feature
    },
    replaybgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    },
    menu_info =
    {
        fadein_time = 0, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 0, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
        title_offset = {159, 19}, --Ikemen feature
        title_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        title_font_scale = {1.0, 1.0}, --Ikemen feature
        title_font_height = -1, --Ikemen feature
        title_text = 'PAUSE', --Ikemen feature
        menu_pos = {85, 33}, --Ikemen feature
        menu_item_font = {'f-6x9.def', 0, 1, 191, 191, 191, 255, 0}, --Ikemen feature
        menu_item_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_font_height = -1, --Ikemen feature
        menu_item_active_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        menu_item_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_active_font_height = -1, --Ikemen feature
        menu_item_selected_font = {'f-6x9.def', 0, 1, 0, 247, 247, 255, 0}, --Ikemen feature
        menu_item_selected_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_selected_font_height = -1, --Ikemen feature
        menu_item_selected_active_font = {'f-6x9.def', 0, 1, 0, 247, 247, 255, 0}, --Ikemen feature
        menu_item_selected_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_selected_active_font_height = -1, --Ikemen feature
        menu_item_value_font = {'f-6x9.def', 0, -1, 191, 191, 191, 255, 0}, --Ikemen feature
        menu_item_value_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_value_font_height = -1, --Ikemen feature
        menu_item_value_active_font = {'f-6x9.def', 0, -1, 255, 255, 255, 255, 0}, --Ikemen feature
        menu_item_value_active_font_scale = {1.0, 1.0}, --Ikemen feature
        menu_item_value_active_font_height = -1, --Ikemen feature
        menu_item_spacing = {150, 13}, --Ikemen feature
        --menu_itemname_back = 'Continue', --Ikemen feature
        --menu_itemname_keyboard = 'Key Config', --Ikemen feature
        --menu_itemname_gamepad = 'Joystick Config', --Ikemen feature
        --menu_itemname_inputdefault = 'Default', --Ikemen feature
        --menu_itemname_commandlist = 'Command List', --Ikemen feature
        --menu_itemname_characterchange = 'Character Change', --Ikemen feature
        --menu_itemname_exit = 'Exit', --Ikemen feature
        menu_window_margins_y = {0, 0}, --Ikemen feature
        menu_window_visibleitems = 15, --Ikemen feature
        --menu_arrow_up_anim = nil, --Ikemen feature
        menu_arrow_up_spr = {}, --Ikemen feature
        menu_arrow_up_offset = {0, 0}, --Ikemen feature
        menu_arrow_up_facing = 1, --Ikemen feature
        menu_arrow_up_scale = {1.0, 1.0}, --Ikemen feature
        --menu_arrow_down_anim = nil, --Ikemen feature
        menu_arrow_down_spr = {}, --Ikemen feature
        menu_arrow_down_offset = {0, 0}, --Ikemen feature
        menu_arrow_down_facing = 1, --Ikemen feature
        menu_arrow_down_scale = {1.0, 1.0}, --Ikemen feature
        menu_boxcursor_visible = 1, --Ikemen feature
        menu_boxcursor_coords = {-5, -10, 154, 2}, --Ikemen feature
        menu_boxcursor_col = {255, 255, 255}, --Ikemen feature
        menu_boxcursor_alpharange = {10, 40, 2, 255, 255, 0}, --Ikemen feature
        menu_boxbg_visible = 1, --Ikemen feature
        menu_boxbg_col = {0, 0, 0}, --Ikemen feature
        menu_boxbg_alpha = {20, 100}, --Ikemen feature
        menu_title_uppercase = 1, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
        cursor_move_snd = {100, 0}, --Ikemen feature
        cursor_done_snd = {100, 1}, --Ikemen feature
        cancel_snd = {100, 2}, --Ikemen feature
        enter_snd = {-1, -1}, --Ikemen feature
        movelist_pos = {10, 20}, --Ikemen feature
        movelist_label_offset = {150, 0}, --Ikemen feature
        movelist_label_font = {'Open_Sans.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        movelist_label_font_scale = {0.3, 0.3}, --Ikemen feature
        movelist_label_font_height = -1, --Ikemen feature
        movelist_label_text = '%s', --Ikemen feature
        movelist_label_uppercase = 0, --Ikemen feature
        movelist_text_offset = {0, 12}, --Ikemen feature
        movelist_text_font = {'Open_Sans.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        movelist_text_font_scale = {0.3, 0.3}, --Ikemen feature
        movelist_text_font_height = 36, --Ikemen feature
        movelist_text_spacing = {1, 1}, --Ikemen feature
        movelist_text_text = 'Command List not found.', --Ikemen feature
        movelist_glyphs_offset = {0, 2}, --Ikemen feature
        movelist_glyphs_scale = {1.0, 1.0}, --Ikemen feature
        movelist_glyphs_spacing = {2}, --Ikemen feature
        movelist_window_width = 300, --Ikemen feature
        movelist_window_margins_y = {20, 1}, --Ikemen feature
        movelist_window_visibleitems = 18, --Ikemen feature
        
        movelist_boxbg_col = {0, 0, 0}, --Ikemen feature
        movelist_boxbg_alpha = {20, 100}, --Ikemen feature
        --movelist_arrow_up_anim = nil, --Ikemen feature
        movelist_arrow_up_spr = {}, --Ikemen feature
        movelist_arrow_up_offset = {0, 0}, --Ikemen feature
        movelist_arrow_up_facing = 1, --Ikemen feature
        movelist_arrow_up_scale = {1.0, 1.0}, --Ikemen feature
        --movelist_arrow_down_anim = nil, --Ikemen feature
        movelist_arrow_down_spr = {}, --Ikemen feature
        movelist_arrow_down_offset = {0, 0}, --Ikemen feature
        movelist_arrow_down_facing = 1, --Ikemen feature
        movelist_arrow_down_scale = {1.0, 1.0}, --Ikemen feature
    },
    menubgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    },
    training_info =
    {
        --same default values menu_info
    },
    trainingbgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    },
    glyphs =
    {
        ['^A'] = {1, 0}, --A
        ['^B'] = {2, 0}, --B
        ['^C'] = {3, 0}, --C
        ['^D'] = {4, 0}, --D
        ['^W'] = {23, 0}, --W
        ['^X'] = {24, 0}, --X
        ['^Y'] = {25, 0}, --Y
        ['^Z'] = {26, 0}, --Z
        ['_+'] = {39, 0}, --+ (press at the same time as previous button)
        ['_.'] = {40, 0}, --...
        ['_DB'] = {41, 0}, --Down-Back
        ['_D'] = {42, 0}, --Down
        ['_DF'] = {43, 0}, --Down-Forward
        ['_B'] = {44, 0}, --Back
        ['_0'] = {45, 0}, --Joystick Ball (no direction)
        ['_F'] = {46, 0}, --Forward
        ['_UB'] = {47, 0}, --Up-Back
        ['_U'] = {48, 0}, --Up
        ['_UF'] = {49, 0}, --Up-Forward
        ['^S'] = {51, 0}, --Start
        ['^M'] = {52, 0}, --Menu (Select/Back)
        ['^P'] = {53, 0}, --Any Punch (X / Y / Z)
        ['^K'] = {54, 0}, --Any Kick (A / B / C)
        ['^LP'] = {57, 0}, --Light Punch (X)
        ['^MP'] = {58, 0}, --Middle Punch (Y)
        ['^SP'] = {59, 0}, --Strong Punch (Z)
        ['^LK'] = {60, 0}, --Light Kick (A)
        ['^MK'] = {61, 0}, --Middle Kick (B)
        ['^SK'] = {62, 0}, --Strong Kick (C)
        ['^3K'] = {63, 0}, --3 Kick (A+B+C)
        ['^3P'] = {64, 0}, --3 Punch (X+Y+Z)
        ['^2K'] = {65, 0}, --2 Kick (A+B / B+C / A+C)
        ['^2P'] = {66, 0}, --2 Punch (X+Y / Y+Z / X+Z)
        ['_-'] = {90, 0}, --Arrow (tap following Button immediately - use in combos)
        ['_!'] = {91, 0}, --Continue Arrow (follow with this move)
        ['~DB'] = {92, 0}, --hold Down-Back
        ['~D'] = {93, 0}, --hold Down
        ['~DF'] = {94, 0}, --hold Down-Forward
        ['~B'] = {95, 0}, --hold Back
        ['~F'] = {96, 0}, --hold Forward
        ['~UB'] = {97, 0}, --hold Up-Back
        ['~U'] = {98, 0}, --hold Up
        ['~UF'] = {99, 0}, --hold Up-Forward
        ['_HCB'] = {100, 0}, --1/2 Circle Back
        ['_HUF'] = {101, 0}, --1/2 Circle Forward Up
        ['_HCF'] = {102, 0}, --1/2 Circle Forward
        ['_HUB'] = {103, 0}, --1/2 Circle Back Up
        ['_QFD'] = {104, 0}, --1/4 Circle Forward Down
        ['_QDB'] = {105, 0}, --1/4 Circle Down Back (QCB/QDB)
        ['_QCB'] = {105, 0}, --1/4 Circle Down Back (QCB/QDB)
        ['_QBU'] = {106, 0}, --1/4 Circle Back Up
        ['_QUF'] = {107, 0}, --1/4 Circle Up Forward
        ['_QBD'] = {108, 0}, --1/4 Circle Back Down
        ['_QDF'] = {109, 0}, --1/4 Circle Down Forward (QCF/QDF)
        ['_QCF'] = {109, 0}, --1/4 Circle Down Forward (QCF/QDF)
        ['_QFU'] = {110, 0}, --1/4 Circle Forward Up
        ['_QUB'] = {111, 0}, --1/4 Circle Up Back
        ['_FDF'] = {112, 0}, --Full Clock Forward
        ['_FUB'] = {113, 0}, --Full Clock Back
        ['_FUF'] = {114, 0}, --Full Count Forward
        ['_FDB'] = {115, 0}, --Full Count Back
        ['_XFF'] = {116, 0}, --2x Forward
        ['_XBB'] = {117, 0}, --2x Back
        ['_DSF'] = {118, 0}, --Dragon Screw Forward
        ['_DSB'] = {119, 0}, --Dragon Screw Back
        ['_AIR'] = {121, 0}, --AIR
        ['_TAP'] = {122, 0}, --TAP
        ['_MAX'] = {123, 0}, --MAX
        ['_^'] = {127, 0}, --Air
        ['_='] = {128, 0}, --Squatting
        ['_)'] = {129, 0}, --Close
        ['_('] = {130, 0}, --Away
        ['^Q'] = {133, 0}, --Any Hard Button (A / B / C / X / Y / Z)
        ['_`'] = {135, 0}, --Small Dot
    },
    tournament_info =
    {
        fadein_time = 15, --Ikemen feature
        fadein_col = {0, 0, 0}, --Ikemen feature
        fadeout_time = 15, --Ikemen feature
        fadeout_col = {0, 0, 0}, --Ikemen feature
    },
    tournamentbgdef =
    {
        spr = '', --Ikemen feature
        bgclearcolor = {0, 0, 0}, --Ikemen feature
    },
    warning_info =
    {
        title = 'WARNING', --Ikemen feature
        title_pos = {159, 19}, --Ikemen feature
        title_font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0}, --Ikemen feature
        title_font_scale = {1.0, 1.0}, --Ikemen feature
        title_font_height = -1, --Ikemen feature
        text_chars_text = 'No characters in select.def available for random selection.\nPress any key to exit the program.', --Ikemen feature'
        text_stages_text = 'No stages in select.def available for random selection.\nPress any key to exit the program.', --Ikemen feature
        text_order_text = "Incorrect 'maxmatches' settings detected.\nCheck orders in [Characters] and [Options] sections\nto ensure that at least one battle is possible.\nPress any key to exit the program.", --Ikemen feature
        text_ratio_text = "Incorrect 'arcade.ratiomatches' settings detected.\nRefer to tutorial available in default select.def.", --Ikemen feature
        
        text_rivals_text = " not found.\nCharacter rivals assignment has been nulled.", --Ikemen feature
        text_reload_text = 'Some selected options require Ikemen to be restarted.\nPress any key to exit the program.', --Ikemen feature
        text_noreload_text = 'Some selected options require Ikemen to be restarted.\nPress any key to continue.', --Ikemen feature
        text_res_text = 'Non 4:3 resolutions require stages coded for different\naspect ratio. Change it back to 4:3 if stages look off.', --Ikemen feature
        text_keys_text = 'Conflict between button keys detected.\nAll keys should have unique assignment.\n\nPress any key to continue.\nPress ESC to reset.', --Ikemen feature
        text_pad_text = 'Controller not detected.\nCheck if your controller is plugged in.', --Ikemen feature
        text_options_text = 'No option items detected.\nCheck documentation and default system.def [Option Info]\nsection for a reference how to add option screen menus.', --Ikemen feature
        text_shaders_text = 'No external OpenGL shaders detected.\nIkemen GO supports files with .vert and .frag extensions.\nShaders are loaded from "./external/shaders" directory.', --Ikemen feature
        text_pos = {25, 33}, --Ikemen feature
        text_font = {'f-6x9.def', 0, 1, 255, 255, 255, 255, 0}, --Ikemen feature
        text_font_scale = {1.0, 1.0}, --Ikemen feature
        text_font_height = -1, --Ikemen feature
        
        boxbg_col = {0, 0, 0}, --Ikemen feature
        boxbg_alpha = {20, 100}, --Ikemen feature
    },
    rankings =
    {
        max_entries = 10, --Ikemen feature
    },
    anim = {},
}

function MotifData:initDefaults(configRef, mainRef)
    local config = configRef
    local main = mainRef
    self.def = main.motifDef
    self.title_info.loading_offset = {main.SP_Localcoord[1] - math.floor(10 * main.SP_Localcoord[1] / 320 + 0.5), main.SP_Localcoord[2] - 8} --Ikemen feature (310, 232)
    self.title_info.footer1_offset = {math.floor(2 * main.SP_Localcoord[1] / 320 + 0.5), main.SP_Localcoord[2]} --Ikemen feature (2, 240)
    self.title_info.footer2_offset = {main.SP_Localcoord[1] / 2, main.SP_Localcoord[2]} --Ikemen feature (160, 240)
    self.title_info.footer3_offset = {main.SP_Localcoord[1] - math.floor(2 * main.SP_Localcoord[1] / 320 + 0.5), main.SP_Localcoord[2]} --Ikemen feature (318, 240)
    self.title_info.footer_boxbg_coords = {0, main.SP_Localcoord[2] - 7, main.SP_Localcoord[1] - 1, main.SP_Localcoord[2] - 1} --Ikemen feature (0, 233, 319, 239)
    self.title_info.connecting_offset = {math.floor(10 * main.SP_Localcoord[1] / 320 + 0.5), 40} --Ikemen feature
    self.title_info.connecting_boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.infobox.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.select_info.p1_face_window = {0, 0, config.GameWidth, config.GameHeight}
    self.select_info.p2_face_window = {0, 0, config.GameWidth, config.GameHeight}
    self.select_info.stage_portrait_window = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature
    self.vs_screen.p1_window = {0, 0, config.GameWidth, config.GameHeight}
    self.vs_screen.p2_window = {0, 0, config.GameWidth, config.GameHeight}
    self.continue_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.victory_screen.p1_window = {0, 0, config.GameWidth, config.GameHeight}
    self.victory_screen.p2_window = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature
    self.victory_screen.winquote_window = {0, 0, config.GameWidth, config.GameHeight}
    self.victory_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.win_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)

    self.survival_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.vs100_kumite_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.time_attack_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.time_challenge_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.score_challenge_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.boss_rush_results_screen.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)

    self.menu_info.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.menu_info.movelist_boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)
    self.warning_info.text_training_text = "Training character (" .. config.TrainingChar .. ") not found.\nPress any key to exit the program." --Ikemen feature
    self.warning_info.boxbg_coords = {0, 0, config.GameWidth, config.GameHeight} --Ikemen feature (0, 0, 320, 240)

end

function MotifData:setBaseOptionInfo()
    self.option_info.menu_itemname_menuarcade = "Arcade Settings"
    self.option_info.menu_itemname_menuarcade_roundtime = "Time Limit"
    self.option_info.menu_itemname_menuarcade_roundsnumsingle = "Rounds to Win Single"
    self.option_info.menu_itemname_menuarcade_roundsnumteam = "Rounds to Win Simul/Tag"
    self.option_info.menu_itemname_menuarcade_maxdrawgames = "Max Draw Games"
    self.option_info.menu_itemname_menuarcade_difficulty = "Difficulty Level"
    self.option_info.menu_itemname_menuarcade_credits = "Credits"
    self.option_info.menu_itemname_menuarcade_quickcontinue = "Quick Continue"
    self.option_info.menu_itemname_menuarcade_airamping = "AI Ramping"
    self.option_info.menu_itemname_menuarcade_aipalette = "AI Palette"
    self.option_info.menu_itemname_menuarcade_empty = ""
    self.option_info.menu_itemname_menuarcade_back = "Back"

    self.option_info.menu_itemname_menuvideo = "Video Settings"
    self.option_info.menu_itemname_menuvideo_resolution = "Resolution" --reserved submenu
    -- Resolution is assigned based on values used in itemname suffix (e.g. 320x240)
    self.option_info.menu_itemname_menuvideo_resolution_320x240 = "320x240    (4:3 QVGA)"
    self.option_info.menu_itemname_menuvideo_resolution_640x480 = "640x480    (4:3 VGA)"
    self.option_info.menu_itemname_menuvideo_resolution_960x720 = "960x720    (4:3 HD)"
    self.option_info.menu_itemname_menuvideo_resolution_1280x720 = "1280x720   (16:9 HD)"
    self.option_info.menu_itemname_menuvideo_resolution_1600x900 = "1600x900   (16:9 HD+)"
    self.option_info.menu_itemname_menuvideo_resolution_1920x1080 = "1920x1080  (16:9 FHD)"
    self.option_info.menu_itemname_menuvideo_resolution_empty = ""
    self.option_info.menu_itemname_menuvideo_resolution_customres = "Custom"
    self.option_info.menu_itemname_menuvideo_resolution_back = "Back"
    self.option_info.menu_itemname_menuvideo_fullscreen = "Fullscreen"
    self.option_info.menu_itemname_menuvideo_vretrace = "VSync"
    self.option_info.menu_itemname_menuvideo_msaa = "MSAA"
    self.option_info.menu_itemname_menuvideo_shaders = "Shaders" --reserved submenu
    -- This list is populated with shaders existing in 'external/shaders' directory
    self.option_info.menu_itemname_menuvideo_shaders_empty = ""
    self.option_info.menu_itemname_menuvideo_shaders_noshader = "Disable"
    self.option_info.menu_itemname_menuvideo_shaders_back = "Back"
    self.option_info.menu_itemname_menuvideo_empty = ""
    self.option_info.menu_itemname_menuvideo_back = "Back"

    self.option_info.menu_itemname_menuaudio = "Audio Settings"
    self.option_info.menu_itemname_menuaudio_mastervolume = "Master Volume"
    self.option_info.menu_itemname_menuaudio_bgmvolume = "BGM Volume"
    self.option_info.menu_itemname_menuaudio_sfxvolume = "SFX Volume"
    self.option_info.menu_itemname_menuaudio_audioducking = "Audio Ducking"
    self.option_info.menu_itemname_menuaudio_empty = ""
    self.option_info.menu_itemname_menuaudio_back = "Back"

    self.option_info.menu_itemname_menuinput = "Input Settings"
    self.option_info.menu_itemname_menuinput_keyboard = "Key Config"
    self.option_info.menu_itemname_menuinput_gamepad = "Joystick Config"
    self.option_info.menu_itemname_menuinput_empty = ""
    self.option_info.menu_itemname_menuinput_inputdefault = "Default"
    self.option_info.menu_itemname_menuinput_back = "Back"

    self.option_info.menu_itemname_menugameplay = "Gameplay Settings"
    self.option_info.menu_itemname_menugameplay_lifemul = "Life"
    self.option_info.menu_itemname_menugameplay_gamespeed = "Game Speed"
    self.option_info.menu_itemname_menugameplay_autoguard = "Auto-Guard"
    self.option_info.menu_itemname_menugameplay_guardbar = "Guard Break"
    self.option_info.menu_itemname_menugameplay_stunbar = "Dizzy"
    self.option_info.menu_itemname_menugameplay_redlifebar = "Red Life"
    self.option_info.menu_itemname_menugameplay_empty = ""
    self.option_info.menu_itemname_menugameplay_menuteam = "Team Settings"
    self.option_info.menu_itemname_menugameplay_menuteam_singlevsteamlife = "Single VS Team Life"
    self.option_info.menu_itemname_menugameplay_menuteam_teamlifeadjustment = "Team Life Adjustment"
    self.option_info.menu_itemname_menugameplay_menuteam_teampowershare = "Team Power Share"
    self.option_info.menu_itemname_menugameplay_menuteam_losekosimul = "Simul Player KOed Lose"
    self.option_info.menu_itemname_menugameplay_menuteam_losekotag = "Tag Partner KOed Lose"
    self.option_info.menu_itemname_menugameplay_menuteam_turnsrecoverybase = "Turns Recovery Base"
    self.option_info.menu_itemname_menugameplay_menuteam_turnsrecoverybonus = "Turns Recovery Bonus"
    self.option_info.menu_itemname_menugameplay_menuteam_empty = ""
    self.option_info.menu_itemname_menugameplay_menuteam_minturns = "Min Turns Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_maxturns = "Max Turns Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_minsimul = "Min Simul Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_maxsimul = "Max Simul Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_mintag = "Min Tag Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_maxtag = "Max Tag Chars"
    self.option_info.menu_itemname_menugameplay_menuteam_empty = ""
    self.option_info.menu_itemname_menugameplay_menuteam_back = "Back"
    self.option_info.menu_itemname_menugameplay_menuratio = "Ratio Settings"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio1life = "Ratio 1 Life"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio1attack = "Ratio 1 Damage"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio2life = "Ratio 2 Life"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio2attack = "Ratio 2 Damage"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio3life = "Ratio 3 Life"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio3attack = "Ratio 3 Damage"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio4life = "Ratio 4 Life"
    self.option_info.menu_itemname_menugameplay_menuratio_ratio4attack = "Ratio 4 Damage"
    self.option_info.menu_itemname_menugameplay_menuratio_empty = ""
    self.option_info.menu_itemname_menugameplay_menuratio_back = "Back"
    self.option_info.menu_itemname_menugameplay_back = "Back"

    self.option_info.menu_itemname_menuengine = "Engine Settings"
    self.option_info.menu_itemname_menuengine_debugkeys = "Debug Keys"
    self.option_info.menu_itemname_menuengine_empty = ""
    self.option_info.menu_itemname_menuengine_helpermax = "HelperMax"
    self.option_info.menu_itemname_menuengine_projectilemax = "PlayerProjectileMax"
    self.option_info.menu_itemname_menuengine_explodmax = "ExplodMax"
    self.option_info.menu_itemname_menuengine_afterimagemax = "AfterImageMax"
    self.option_info.menu_itemname_menuengine_empty = ""
    self.option_info.menu_itemname_menuengine_menupreloading = "Pre-loading"
    self.option_info.menu_itemname_menuengine_menupreloading_preloadingsmall = "Small portraits"
    self.option_info.menu_itemname_menuengine_menupreloading_preloadingbig = "Select portraits"
    self.option_info.menu_itemname_menuengine_menupreloading_preloadingversus = "Versus portraits"
    self.option_info.menu_itemname_menuengine_menupreloading_preloadingstage = "Stage portraits"
    self.option_info.menu_itemname_menuengine_back = "Back"

    self.option_info.menu_itemname_empty = ""
    self.option_info.menu_itemname_portchange = "Port Change"
    self.option_info.menu_itemname_default = "Default Values"
    self.option_info.menu_itemname_empty = ""
    self.option_info.menu_itemname_savereturn = "Save and Return"
    self.option_info.menu_itemname_return = "Return Without Saving"
    -- Default options screen order.
    main.t_sort.option_info = {
        "menuarcade",
        "menuarcade_roundtime",
        "menuarcade_roundsnumsingle",
        "menuarcade_roundsnumteam",
        "menuarcade_maxdrawgames",
        "menuarcade_difficulty",
        "menuarcade_credits",
        "menuarcade_quickcontinue",
        "menuarcade_airamping",
        "menuarcade_aipalette",
        "menuarcade_empty",
        "menuarcade_back",
        "menuvideo",
        "menuvideo_resolution",
        "menuvideo_resolution_320x240",
        "menuvideo_resolution_640x480",
        "menuvideo_resolution_960x720",
        "menuvideo_resolution_1280x720",
        "menuvideo_resolution_1600x900",
        "menuvideo_resolution_1920x1080",
        "menuvideo_resolution_empty",
        "menuvideo_resolution_customres",
        "menuvideo_resolution_back",
        "menuvideo_fullscreen",
        "menuvideo_vretrace",
        "menuvideo_msaa",
        "menuvideo_shaders",
        "menuvideo_shaders_empty",
        "menuvideo_shaders_noshader",
        "menuvideo_shaders_back",
        "menuvideo_empty",
        "menuvideo_back",
        "menuaudio",
        "menuaudio_mastervolume",
        "menuaudio_bgmvolume",
        "menuaudio_sfxvolume",
        "menuaudio_audioducking",
        "menuaudio_empty",
        "menuaudio_back",
        "menuinput",
        "menuinput_keyboard",
        "menuinput_gamepad",
        "menuinput_empty",
        "menuinput_inputdefault",
        "menuinput_back",
        "menugameplay",
        "menugameplay_lifemul",
        "menugameplay_gamespeed",
        "menugameplay_autoguard",
        "menugameplay_guardbar",
        "menugameplay_stunbar",
        "menugameplay_redlifebar",
        "menugameplay_empty",
        "menugameplay_menuteam",
        "menugameplay_menuteam_singlevsteamlife",
        "menugameplay_menuteam_teamlifeadjustment",
        "menugameplay_menuteam_teampowershare",
        "menugameplay_menuteam_losekosimul",
        "menugameplay_menuteam_losekotag",
        "menugameplay_menuteam_turnsrecoverybase",
        "menugameplay_menuteam_turnsrecoverybonus",
        "menugameplay_menuteam_empty",
        "menugameplay_menuteam_minturns",
        "menugameplay_menuteam_maxturns",
        "menugameplay_menuteam_minsimul",
        "menugameplay_menuteam_maxsimul",
        "menugameplay_menuteam_mintag",
        "menugameplay_menuteam_maxtag",
        "menugameplay_menuteam_empty",
        "menugameplay_menuteam_back",
        "menugameplay_menuratio",
        "menugameplay_menuratio_ratio1life",
        "menugameplay_menuratio_ratio1attack",
        "menugameplay_menuratio_ratio2life",
        "menugameplay_menuratio_ratio2attack",
        "menugameplay_menuratio_ratio3life",
        "menugameplay_menuratio_ratio3attack",
        "menugameplay_menuratio_ratio4life",
        "menugameplay_menuratio_ratio4attack",
        "menugameplay_menuratio_empty",
        "menugameplay_menuratio_back",
        "menugameplay_back",
        "menuengine",
        "menuengine_debugkeys",
        "menuengine_empty",
        "menuengine_helpermax",
        "menuengine_projectilemax",
        "menuengine_explodmax",
        "menuengine_afterimagemax",
        "menuengine_empty",
        "menuengine_menupreloading",
        "menuengine_menupreloading_preloadingsmall",
        "menuengine_menupreloading_preloadingbig",
        "menuengine_menupreloading_preloadingversus",
        "menuengine_menupreloading_preloadingstage",
        "menuengine_back",
        "empty",
        "portchange",
        "default",
        "empty",
        "savereturn",
        "return",
    }
end

function MotifData:setBaseMenuInfo()
    self.menu_info.menu_itemname_back = "Continue"
    self.menu_info.menu_itemname_menuinput = "Button Config"
    self.menu_info.menu_itemname_menuinput_keyboard = "Key Config"
    self.menu_info.menu_itemname_menuinput_gamepad = "Joystick Config"
    self.menu_info.menu_itemname_menuinput_empty = ""
    self.menu_info.menu_itemname_menuinput_inputdefault = "Default"
    self.menu_info.menu_itemname_menuinput_back = "Back"
    self.menu_info.menu_itemname_commandlist = "Command List"
    self.menu_info.menu_itemname_characterchange = "Character Change"
    self.menu_info.menu_itemname_exit = "Exit"
    main.t_sort.menu_info = {
        "back",
        "menuinput",
        "menuinput_keyboard",
        "menuinput_gamepad",
        "menuinput_empty",
        "menuinput_inputdefault",
        "menuinput_back",
        "commandlist",
        "characterchange",
        "exit",
    }
end

function MotifData:setBaseTrainingInfo()
    self.training_info.menu_itemname_back = "Continue"
    self.training_info.menu_itemname_menuinput = "Button Config"
    self.training_info.menu_itemname_menuinput_keyboard = "Key Config"
    self.training_info.menu_itemname_menuinput_gamepad = "Joystick Config"
    self.training_info.menu_itemname_menuinput_empty = ""
    self.training_info.menu_itemname_menuinput_inputdefault = "Default"
    self.training_info.menu_itemname_menuinput_back = "Back"
    self.training_info.menu_itemname_commandlist = "Command List"
    self.training_info.menu_itemname_characterchange = "Character Change"
    self.training_info.menu_itemname_exit = "Exit"
    main.t_sort.training_info = {
        "back",
        "menuinput",
        "menuinput_keyboard",
        "menuinput_gamepad",
        "menuinput_empty",
        "menuinput_inputdefault",
        "menuinput_back",
        "commandlist",
        "characterchange",
        "exit",
    }
end

-- Constructor
-- @param o initial table if nil wil be created
-- @param configRef a reference to the config.json
-- @param mainRef a reference to the main object <-- not sure what this is.
function MotifData:new(o, configRef, mainRef)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:initDefaults(configRef, mainRef)
    return o
end

return MotifData