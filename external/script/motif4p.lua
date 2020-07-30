local motiffile = require('external.script.motif')
local motif = motiffile.getMotifData()

local function addAdditionDefaults(motif, config)
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

    motif['select_info'].p3_cursor_startcell = {0, 4}
    motif['select_info'].p3_cursor_active_anim = nil
    motif['select_info'].p3_cursor_active_spr = {}
    motif['select_info'].p3_cursor_active_offset = {0, 0}
    motif['select_info'].p3_cursor_active_facing = 1
    motif['select_info'].p3_cursor_active_scale = {1.0, 1.0}
    motif['select_info'].p3_cursor_done_anim = nil
    motif['select_info'].p3_cursor_done_spr = {}
    motif['select_info'].p3_cursor_done_offset = {0, 0}
    motif['select_info'].p3_cursor_done_facing = 1
    motif['select_info'].p3_cursor_done_scale = {1.0, 1.0}
    motif['select_info'].p3_cursor_blink = 1
    motif['select_info'].p3_cursor_move_snd = {100, 0}
    motif['select_info'].p3_cursor_done_snd = {100, 1}
    motif['select_info'].p3_random_move_snd = {100, 0}

    motif['select_info'].p4_cursor_startcell = {0, 4}
    motif['select_info'].p4_cursor_active_anim = nil
    motif['select_info'].p4_cursor_active_spr = {}
    motif['select_info'].p4_cursor_active_offset = {0, 0}
    motif['select_info'].p4_cursor_active_facing = 1
    motif['select_info'].p4_cursor_active_scale = {0.4, 0.4}
    motif['select_info'].p4_cursor_done_anim = nil
    motif['select_info'].p4_cursor_done_spr = {}
    motif['select_info'].p4_cursor_done_offset = {0, 0}
    motif['select_info'].p4_cursor_done_facing = 1
    motif['select_info'].p4_cursor_done_scale = {1.0, 1.0}
    motif['select_info'].p4_cursor_blink = 1
    motif['select_info'].p4_cursor_move_snd = {100, 0}
    motif['select_info'].p4_cursor_done_snd = {100, 1}
    motif['select_info'].p4_random_move_snd = {100, 0}

    motif['select_info'].p3_face_spr = {9000, 1}
    motif['select_info'].p3_face_offset = {0, 0}
    motif['select_info'].p3_face_facing = 1
    motif['select_info'].p3_face_scale = {1.0, 1.0}
    motif['select_info'].p3_face_window = {0, 0, config.GameWidth, config.GameHeight}
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

    motif['select_info'].p4_face_spr = {9000, 1}
    motif['select_info'].p4_face_offset = {0, 0}
    motif['select_info'].p4_face_facing = -1
    motif['select_info'].p4_face_scale = {1.0, 1.0}
    motif['select_info'].p4_face_window = {0, 0, config.GameWidth, config.GameHeight}
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

    motif['select_info'].p3_name_offset = {0, 0}
    motif['select_info'].p3_name_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0}
    motif['select_info'].p3_name_font_scale = {1.0, 1.0}
    motif['select_info'].p3_name_font_height = -1 --Ikemen feature
    motif['select_info'].p3_name_spacing = {0, 14}
    motif['select_info'].p4_name_offset = {0, 0}
    motif['select_info'].p4_name_font = {'jg.fnt', 1, -1, 255, 255, 255, 255, 0}
    motif['select_info'].p4_name_font_scale = {1.0, 1.0}
    motif['select_info'].p4_name_font_height = -1 --Ikemen feature
    motif['select_info'].p4_name_spacing = {0, 14}

    motif['select_info'].p3_select_snd = {-1, 0} --Ikemen feature
    motif['select_info'].p4_select_snd = {-1, 0} --Ikemen feature
end
addAdditionDefaults(motif, config)

local function updateScreenpackData(t)
    local pos = t
    local pos_sort = main.t_sort
    local def_pos = motif
    t.anim = {}
    local fileDir, fileName = motif.def:match('^(.-)([^/\\]+)$')
    t.fileDir = fileDir
    t.fileName = fileName
    local tmp = ''
    local group = ''
    for line in main.motifData:gmatch('([^\n]*)\n?') do
        line = line:gsub('%s*;.*$', '')
        if line:match('^[^%g]*%s*%[.-%s*%]%s*$') then --matched [] group
            line = line:match('%[(.-)%s*%]%s*$') --match text between []
            line = line:gsub('[%. ]', '_') --change . and space to _
            group = tostring(line:lower())
            if group:match('^begin_action_[0-9]+$') then --matched anim
                group = tonumber(group:match('^begin_action_([0-9]+)$'))
                t.anim[group] = {}
                pos = t.anim[group]
            else --matched other []
                t[group] = {}
                main.t_sort[group] = {}
                pos = t[group]
                pos_sort = main.t_sort[group]
                def_pos = motif[group]
            end
        else --matched non [] line
            local param, value = line:match('^%s*([^=]-)%s*=%s*(.-)%s*$')
            if param ~= nil then
                param = param:gsub('[%. ]', '_') --change param . and space to _
                if group ~= 'glyphs' then
                    param = param:lower() --lowercase param
                end
                if value ~= nil and def_pos ~= nil then --let's check if it's even a valid param
                    if value == '' and (type(def_pos[param]) == 'number' or type(def_pos[param]) == 'table') then --text should remain empty
                        value = nil
                    end
                end
            end
            if param ~= nil and value ~= nil then --param = value pattern matched
                value = value:gsub('"', '') --remove brackets from value
                value = value:gsub('^(%.[0-9])', '0%1') --add 0 before dot if missing at the beginning of matched string
                value = value:gsub('([^0-9])(%.[0-9])', '%10%2') --add 0 before dot if missing anywhere else
                if param:match('^font[0-9]+') then --font declaration param matched
                    if pos.font == nil then
                        pos.font = {}
                        pos.font_height = {}
                    end
                    local num = tonumber(param:match('font([0-9]+)'))
                    if param:match('_height$') then
                        pos.font_height[num] = main.f_dataType(value)
                    else
                        value = value:gsub('\\', '/')
                        pos.font[num] = tostring(value)
                    end
                elseif pos[param] == nil or param:match('_itemname_') or param:match('_font_height$') then --mugen takes into account only first occurrence
                    if param:match('_font$') then --assign default font values if needed (also ensure that there are multiple values in the first place)
                        local _, n = value:gsub(',%s*[0-9]*', '')
                        for i = n + 1, #main.t_fntDefault do
                            value = value:gsub(',?%s*$', ',' .. main.t_fntDefault[i])
                        end
                    end
                    if param:match('_text$') or param:match('_valuename_') then --skip commas detection for strings
                        pos[param] = value
                    elseif param:match('_itemname_') then --skip commas detection and append value to main.t_sort for itemname
                        table.insert(pos_sort, param:match('_itemname_(.+)$'))
                        pos[param] = value
                    elseif value:match('.+,.+') then --multiple values
                        for i, c in ipairs(main.f_strsplit(',', value)) do --split value using "," delimiter
                            if param:match('_anim$') then --mugen recognizes animations even if there are more values
                                pos[param] = main.f_dataType(c)
                                break
                            elseif i == 1 then
                                pos[param] = {}
                                if param:match('_font$') and tonumber(c) ~= -1 then
                                    if t.files ~= nil and t.files.font ~= nil and t.files.font[tonumber(c)] ~= nil then
                                        if pos[param .. '_height'] == nil and t.files.font_height[tonumber(c)] ~= nil then
                                            pos[param .. '_height'] = t.files.font_height[tonumber(c)]
                                        end
                                        c = t.files.font[tonumber(c)]
                                    else
                                        break --use default font values
                                    end
                                end
                            end
                            if c == nil or c == '' then
                                table.insert(pos[param], 0)
                            else
                                table.insert(pos[param], main.f_dataType(c))
                            end
                        end
                    else --single value
                        pos[param] = main.f_dataType(value)
                    end
                end
            elseif param == nil then --only valid lines left are animations
                line = line:lower()
                local value = line:match('^%s*([0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+.-)[,%s]*$') or line:match('^%s*loopstart') or line:match('%s*interpolate [oasb][fncl][fgae][sln][ed]t?')
                if value ~= nil then
                    value = value:gsub(',%s*,', ',0,') --add missing values
                    value = value:gsub(',%s*$', '')
                    table.insert(pos, value)
                end
            end
        end
        main.loadingRefresh()
    end
end
local t = motif.select_info
updateScreenpackData(t)

--merge tables
motif = main.f_tableMerge(motif, t)

local anim = ''
local facing = ''
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







