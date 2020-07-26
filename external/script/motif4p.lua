local motif = require('external.script.motif')
-- todo Dave The loading of the screenpack variables happens before this assignment. which causes these hardcoded values to be overwritten.
-- Need to circumvent the loading or let it happen after this params have been assigned.
motif['option_info'].menu_item_p3_pos = {91, 33}
motif['option_info'].menu_item_p4_pos = {230, 33}
motif['option_info'].menu_key_p3_pos = {39, 33}
motif['option_info'].menu_key_p4_pos = {178, 33}

motif['option_info'].menu_valuename_f3 = '(F3)' --Ikemen feature
motif['option_info'].menu_valuename_f4 = '(F4)' --Ikemen feature

motif['option_info'].menu_item_key_p3_font = {'f-6x9.def', 0, 0, 50, 247, 247, 255, 0} --Ikemen feature
motif['option_info'].menu_item_key_p3_font_scale = {1.0, 1.0} --Ikemen feature
motif['option_info'].menu_item_key_p3_font_height = -1 --Ikemen feature
motif['option_info'].menu_item_key_p4_font = {'f-6x9.def', 0, 0, 247, 100, 0, 255, 0} --Ikemen feature
motif['option_info'].menu_item_key_p4_font_scale = {1.0, 1.0} --Ikemen feature
motif['option_info'].menu_item_key_p4_font_height = -1 --Ikemen feature

--motif['select_info'].p3_cursor_startcell = {0, 4}
--motif['select_info'].p3_cursor_active_anim = nil
motif['select_info'].p3_cursor_active_spr = {}
motif['select_info'].p3_cursor_active_offset = {0, 0}
--motif['select_info'].p3_cursor_active_facing = 1
--motif['select_info'].p3_cursor_active_scale = {1.0, 1.0}
--motif['select_info'].p3_cursor_done_anim = nil
motif['select_info'].p3_cursor_done_spr = {}
motif['select_info'].p3_cursor_done_offset = {0, 0}
--motif['select_info'].p3_cursor_done_facing = 1
--motif['select_info'].p3_cursor_done_scale = {1.0, 1.0}
--motif['select_info'].p3_cursor_blink = 1
--motif['select_info'].p3_cursor_move_snd = {100, 0}
--motif['select_info'].p3_cursor_done_snd = {100, 1}
--motif['select_info'].p3_random_move_snd = {100, 0}

--motif['select_info'].p4_cursor_startcell = {0, 4}
--motif['select_info'].p4_cursor_active_anim = nil
motif['select_info'].p4_cursor_active_spr = {}
motif['select_info'].p4_cursor_active_offset = {0, 0}
--motif['select_info'].p4_cursor_active_facing = 1
--motif['select_info'].p4_cursor_active_scale = {0.4, 0.4}
--motif['select_info'].p4_cursor_done_anim = nil
motif['select_info'].p4_cursor_done_spr = {}
motif['select_info'].p4_cursor_done_offset = {0, 0}
--motif['select_info'].p4_cursor_done_facing = 1
--motif['select_info'].p4_cursor_done_scale = {1.0, 1.0}
--motif['select_info'].p4_cursor_blink = 1
--motif['select_info'].p4_cursor_move_snd = {100, 0}
--motif['select_info'].p4_cursor_done_snd = {100, 1}
--motif['select_info'].p4_random_move_snd = {100, 0}

--motif['select_info'].p3_face_spr = {9000, 1}
--motif['select_info'].p3_face_offset = {0, 0}
--motif['select_info'].p3_face_facing = 1
--motif['select_info'].p3_face_scale = {1.0, 1.0}
--motif['select_info'].p3_face_window = {0, 0, config.GameWidth, config.GameHeight}
motif['select_info'].p3_face_num = 1 --Ikemen feature
motif['select_info'].p3_face_spacing = {0, 0} --Ikemen feature
motif['select_info'].p3_c1_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p3_c1_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p3_c2_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p3_c2_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p3_c3_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p3_c3_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p3_c4_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p3_c4_face_scale = {1.0, 1.0} --Ikemen feature

--motif['select_info'].p4_face_spr = {9000, 1}
--motif['select_info'].p4_face_offset = {0, 0}
--motif['select_info'].p4_face_facing = -1
--motif['select_info'].p4_face_scale = {1.0, 1.0}
--motif['select_info'].p4_face_window = {0, 0, config.GameWidth, config.GameHeight}
motif['select_info'].p4_face_num = 1 --Ikemen feature
motif['select_info'].p4_face_spacing = {0, 0} --Ikemen feature
motif['select_info'].p4_c1_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p4_c1_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p4_c2_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p4_c2_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p4_c3_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p4_c3_face_scale = {1.0, 1.0} --Ikemen feature
motif['select_info'].p4_c4_face_offset = {0, 0} --Ikemen feature
motif['select_info'].p4_c4_face_scale = {1.0, 1.0} --Ikemen feature

--motif['select_info'].p3_name_offset = {0, 0}
--motif['select_info'].p3_name_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0}
motif['select_info'].p3_name_font_scale = {1.0, 1.0}
motif['select_info'].p3_name_font_height = -1 --Ikemen feature
--motif['select_info'].p3_name_spacing = {0, 14}
--motif['select_info'].p4_name_offset = {0, 0}
--motif['select_info'].p4_name_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0}
motif['select_info'].p4_name_font_scale = {1.0, 1.0}
motif['select_info'].p4_name_font_height = -1 --Ikemen feature
--motif['select_info'].p4_name_spacing = {0, 14}

motif['select_info'].p3_select_snd = {-1, 0} --Ikemen feature
motif['select_info'].p4_select_snd = {-1, 0} --Ikemen feature

local function f_facing(var)
    if var == -1 then
        return 'H'
    else
        return nil
    end
end

local function f_loadSprData(t, t_dir)
    for k, v in ipairs(t_dir) do
        --if t[v.s .. 'offset'] == nil then t[v.s .. 'offset'] = {0, 0} end
        --if t[v.s .. 'scale'] == nil then t[v.s .. 'scale'] = {1.0, 1.0} end
        if #t[v.s .. 'spr'] > 0 then --create sprite data
            if #t[v.s .. 'spr'] == 1 then --fix values
                if type(t[v.s .. 'spr'][1]) == 'string' then
                    t[v.s .. 'spr'] = {tonumber(t[v.s .. 'spr'][1]:match('^([0-9]+)')), 0}
                else
                    t[v.s .. 'spr'] = {t[v.s .. 'spr'][1], 0}
                end
            end
            if t[v.s .. 'facing'] == -1 then facing = ', H' else facing = '' end
            anim = t[v.s .. 'spr'][1] .. ', ' .. t[v.s .. 'spr'][2] .. ', ' .. t[v.s .. 'offset'][1] + v.x .. ', ' .. t[v.s .. 'offset'][2] + v.y .. ', -1' .. facing
            t[v.s .. 'data'] = animNew(motif.files.spr_data, anim)
            animSetScale(t[v.s .. 'data'], t[v.s .. 'scale'][1], t[v.s .. 'scale'][2])
            animUpdate(t[v.s .. 'data'])
        elseif t[v.s .. 'anim'] ~= nil and motif.anim[t[v.s .. 'anim']] ~= nil then --create animation data
            t[v.s .. 'data'] = main.f_animFromTable(
                    motif.anim[t[v.s .. 'anim']],
                    motif.files.spr_data,
                    t[v.s .. 'offset'][1] + v.x,
                    t[v.s .. 'offset'][2] + v.y,
                    t[v.s .. 'scale'][1],
                    t[v.s .. 'scale'][2],
                    f_facing(t[v.s .. 'facing'])
            )
        else --create dummy data
            t[v.s .. 'data'] = animNew(motif.files.spr_data, '-1, -1, 0, 0, -1')
            animUpdate(t[v.s .. 'data'])
        end
        animSetWindow(t[v.s .. 'data'], 0, 0, motif.info.localcoord[1], motif.info.localcoord[2])
        main.loadingRefresh()
    end
end

local t = motif.select_info
local t_extended_dir ={
    {s = 'p3_cursor_active_',             x = 0,                                                   y = 0},
    {s = 'p3_cursor_done_',               x = 0,                                                   y = 0},
    {s = 'p4_cursor_active_',             x = 0,                                                   y = 0},
    {s = 'p4_cursor_done_',               x = 0,                                                   y = 0},
    --{s = 'p3_teammenu_bg_',               x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_bg_single_',        x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_bg_simul_',         x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_bg_turns_',         x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_bg_tag_',           x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_bg_ratio_',         x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_selftitle_',        x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_enemytitle_',       x = t.p3_teammenu_pos[1],                                y = t.p3_teammenu_pos[2]},
    --{s = 'p3_teammenu_item_cursor_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_value_icon_',       x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_value_empty_icon_', x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio1_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio2_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio3_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio4_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio5_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio6_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p3_teammenu_ratio7_icon_',      x = t.p3_teammenu_pos[1] + t.p3_teammenu_item_offset[1], y = t.p3_teammenu_pos[2] + t.p3_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_bg_',               x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_bg_single_',        x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_bg_simul_',         x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_bg_turns_',         x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_bg_tag_',           x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_bg_ratio_',         x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_selftitle_',        x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_enemytitle_',       x = t.p4_teammenu_pos[1],                                y = t.p4_teammenu_pos[2]},
    --{s = 'p4_teammenu_item_cursor_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_value_icon_',       x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_value_empty_icon_', x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio1_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio2_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio3_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio4_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio5_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio6_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
    --{s = 'p4_teammenu_ratio7_icon_',      x = t.p4_teammenu_pos[1] + t.p4_teammenu_item_offset[1], y = t.p4_teammenu_pos[2] + t.p4_teammenu_item_offset[2]},
}
f_loadSprData(motif.select_info, t_extended_dir)

return motif







