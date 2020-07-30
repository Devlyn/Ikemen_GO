local options = require('external.script.options')

-- @override defaults reset key settings
function options.f_keyDefault()
    for i = 1, #config.KeyConfig do
        if i == 1 then
            config.KeyConfig[i].Buttons[1]  = 'UP'
            config.KeyConfig[i].Buttons[2]  = 'DOWN'
            config.KeyConfig[i].Buttons[3]  = 'LEFT'
            config.KeyConfig[i].Buttons[4]  = 'RIGHT'
            config.KeyConfig[i].Buttons[5]  = 'q'
            config.KeyConfig[i].Buttons[6]  = 'w'
            config.KeyConfig[i].Buttons[7]  = 'e'
            config.KeyConfig[i].Buttons[8]  = 'a'
            config.KeyConfig[i].Buttons[9]  = 's'
            config.KeyConfig[i].Buttons[10] = 'd'
            config.KeyConfig[i].Buttons[11] = 'RETURN'
            config.KeyConfig[i].Buttons[12] = 'MINUS'
            config.KeyConfig[i].Buttons[13] = 'EQUAL'
            config.KeyConfig[i].Buttons[14] = 'Not used'
        elseif i == 2 then
            config.KeyConfig[i].Buttons[1]  = 'KP_8'
            config.KeyConfig[i].Buttons[2]  = 'KP_2'
            config.KeyConfig[i].Buttons[3]  = 'KP_4'
            config.KeyConfig[i].Buttons[4]  = 'KP_6'
            config.KeyConfig[i].Buttons[5]  = 'i'
            config.KeyConfig[i].Buttons[6]  = 'o'
            config.KeyConfig[i].Buttons[7]  = 'p'
            config.KeyConfig[i].Buttons[8]  = 'j'
            config.KeyConfig[i].Buttons[9]  = 'k'
            config.KeyConfig[i].Buttons[10] = 'l'
            config.KeyConfig[i].Buttons[11] = 'KP_ENTER'
            config.KeyConfig[i].Buttons[12] = 'LEFTBRACKET'
            config.KeyConfig[i].Buttons[13] = 'RIGHTBRACKE'
            config.KeyConfig[i].Buttons[14] = 'Not used'
        elseif i == 3 then
            config.KeyConfig[i].Buttons[1]  = 'r'
            config.KeyConfig[i].Buttons[2]  = 't'
            config.KeyConfig[i].Buttons[3]  = 'y'
            config.KeyConfig[i].Buttons[4]  = 'u'
            config.KeyConfig[i].Buttons[5]  = '1'
            config.KeyConfig[i].Buttons[6]  = '2'
            config.KeyConfig[i].Buttons[7]  = '3'
            config.KeyConfig[i].Buttons[8]  = '4'
            config.KeyConfig[i].Buttons[9]  = '5'
            config.KeyConfig[i].Buttons[10] = '6'
            config.KeyConfig[i].Buttons[11] = 'LCTRL'
            config.KeyConfig[i].Buttons[12] = '7'
            config.KeyConfig[i].Buttons[13] = '8'
            config.KeyConfig[i].Buttons[14] = 'Not used'
        elseif i == 4 then
            config.KeyConfig[i].Buttons[1]  = 'z'
            config.KeyConfig[i].Buttons[2]  = 'x'
            config.KeyConfig[i].Buttons[3]  = 'c'
            config.KeyConfig[i].Buttons[4]  = 'v'
            config.KeyConfig[i].Buttons[5]  = 'f'
            config.KeyConfig[i].Buttons[6]  = 'g'
            config.KeyConfig[i].Buttons[7]  = 'h'
            config.KeyConfig[i].Buttons[8]  = 'b'
            config.KeyConfig[i].Buttons[9]  = 'n'
            config.KeyConfig[i].Buttons[10] = 'm'
            config.KeyConfig[i].Buttons[11] = 'RCTRL'
            config.KeyConfig[i].Buttons[12] = 'COMMA'
            config.KeyConfig[i].Buttons[13] = 'PERIOD'
            config.KeyConfig[i].Buttons[14] = 'Not used'
        else
            for j = 1, #config.KeyConfig[i].Buttons do
                config.KeyConfig[i].Buttons[j] = tostring(motif.option_info.menu_valuename_nokey)
            end
        end
    end
    for i = 1, #config.JoystickConfig do
        config.JoystickConfig[i].Buttons[1]  = '14'
        config.JoystickConfig[i].Buttons[2]  = '16'
        config.JoystickConfig[i].Buttons[3]  = '17'
        config.JoystickConfig[i].Buttons[4]  = '15'
        config.JoystickConfig[i].Buttons[5]  = '2'
        config.JoystickConfig[i].Buttons[6]  = '1'
        config.JoystickConfig[i].Buttons[7]  = '0'
        config.JoystickConfig[i].Buttons[8]  = '3'
        config.JoystickConfig[i].Buttons[9]  = '5'
        config.JoystickConfig[i].Buttons[10] = '4'
        config.JoystickConfig[i].Buttons[11] = '9'
        config.JoystickConfig[i].Buttons[12] = '7'
        config.JoystickConfig[i].Buttons[13] = '6'
        config.JoystickConfig[i].Buttons[14] = 'Not used'
    end
    resetRemapInput()
end

options.t_itemname ['keyboardp1p2'] = function(cursorPosY, moveTxt, item, t)
    if main.f_input(main.t_players, {'pal', 's'}) --[[or getKey() == 'F1']] then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        options.f_keyCfgInit('KeyConfig', t.submenu[t.items[item].itemname].title)
        while true do
            if not options.f_keyCfg('KeyConfig', t.items[item].itemname, 'optionbgdef', false) then
                break
            end
        end
    end
    return true
end

options.t_itemname ['gamepadp1p2'] = function(cursorPosY, moveTxt, item, t)
    if main.f_input(main.t_players, {'pal', 's'}) --[[or getKey() == 'F2']] then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        if main.flags['-nojoy'] == nil then
            options.f_keyCfgInit('JoystickConfig', t.submenu[t.items[item].itemname].title)
            while true do
                if not options.f_keyCfg('JoystickConfig', t.items[item].itemname, 'optionbgdef', false) then
                    break
                end
            end
        end
    end
    return true
end

options.t_itemname ['keyboardp3p4'] = function(cursorPosY, moveTxt, item, t)
    if main.f_input(main.t_players, {'pal', 's'}) --[[or getKey() == 'F1']] then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        options.f_keyCfgInit4p('KeyConfig', t.submenu[t.items[item].itemname].title)
        while true do
            if not options.f_keyCfg4p('KeyConfig', t.items[item].itemname, 'optionbgdef', false) then
                break
            end
        end
    end
    return true
end

options.t_itemname ['gamepadp3p4'] = function(cursorPosY, moveTxt, item, t)
    if main.f_input(main.t_players, {'pal', 's'}) --[[or getKey() == 'F2']] then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        if main.flags['-nojoy'] == nil then
            options.f_keyCfgInit4p('JoystickConfig', t.submenu[t.items[item].itemname].title)
            while true do
                if not options.f_keyCfg4p('JoystickConfig', t.items[item].itemname, 'optionbgdef', false) then
                    break
                end
            end
        end
    end
    return true
end

local function f_keyCfgText()
    return {text:create({}), text:create({}), text:create({}), text:create({})}
end

local t_keyCfg = {
    {data = f_keyCfgText(), itemname = 'empty', displayname = ''},
    {data = f_keyCfgText(), itemname = 'configall', displayname = motif.option_info.menu_itemname_key_all, infodata = f_keyCfgText(), infodisplay = ''},
    {data = f_keyCfgText(), itemname = 'up', displayname = motif.option_info.menu_itemname_key_up, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'down', displayname = motif.option_info.menu_itemname_key_down, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'left', displayname = motif.option_info.menu_itemname_key_left, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'right', displayname = motif.option_info.menu_itemname_key_right, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'a', displayname = motif.option_info.menu_itemname_key_a, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'b', displayname = motif.option_info.menu_itemname_key_b, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'c', displayname = motif.option_info.menu_itemname_key_c, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'x', displayname = motif.option_info.menu_itemname_key_x, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'y', displayname = motif.option_info.menu_itemname_key_y, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'z', displayname = motif.option_info.menu_itemname_key_z, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'start', displayname = motif.option_info.menu_itemname_key_start, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'd', displayname = motif.option_info.menu_itemname_key_d, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'w', displayname = motif.option_info.menu_itemname_key_w, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'menu', displayname = motif.option_info.menu_itemname_key_menu, vardata = f_keyCfgText()},
    {data = f_keyCfgText(), itemname = 'back', displayname = motif.option_info.menu_itemname_key_back, infodata = f_keyCfgText(), infodisplay = ''},
}

local txt_keyController = f_keyCfgText()
local cursorPosY = 2
local item = 2
local item_start = 2
local t_pos = {}
local configall = false
local key = ''
local t_keyList = {}
local t_conflict = {}
local t_savedConfig = {}
local btnReleased = false
local player = 3
local btn = ''
local joyNum = 2
local modified = false

local function f_keyCfgReset4p(cfgType)
    t_keyList = {}
    for i = 1, #config[cfgType] do
        joyNum = config[cfgType][i].Joystick
        if t_keyList[joyNum] == nil then
            t_keyList[joyNum] = {} --creates subtable for each controller (1 for keyboard or at least 2 for gamepads)
            t_conflict[joyNum] = false --set default conflict flag for each controller
        end
        for k, v in pairs(config[cfgType][i].Buttons) do
            v = tostring(v)
            t_keyCfg[k + item_start]['vardisplay' .. i] = v --assign vardisplay entry (assigned button name) in t_keyCfg table
            if v ~= tostring(motif.option_info.menu_valuename_nokey) then --if button is not disabled
                if t_keyList[joyNum][v] == nil then
                    t_keyList[joyNum][v] = 1
                else
                    t_keyList[joyNum][v] = t_keyList[joyNum][v] + 1
                end
            end
        end
    end
end

function options.f_keyCfgInit4p(cfgType, title)
    resetKey()
    main.f_cmdInput()
    cursorPosY = 2
    item = 2
    item_start = 2
    t_pos = {'', '', motif.option_info.menu_key_p3_pos, motif.option_info.menu_key_p4_pos}
    configall = false
    key = ''
    t_conflict = {}
    t_savedConfig = main.f_tableCopy(config[cfgType])
    btnReleased = false
    player = 3
    btn = tostring(config[cfgType][player].Buttons[item - item_start])
    options.txt_title:update({text = title})
    f_keyCfgReset4p(cfgType)
    joyNum = config[cfgType][player].Joystick
end

function options.f_keyCfg4p(cfgType, controller, bgdef, skipClear)
    local t = t_keyCfg
    --Config all
    if configall then
        --esc (reset mapping)
        if esc() --[[or main.f_input(main.t_players, {'m'})]] then
            sndPlay(motif.files.snd_data, motif.option_info.cancel_snd[1], motif.option_info.cancel_snd[2])
            esc(false)
            config[cfgType][player] = main.f_tableCopy(t_savedConfig[player])
            for pn = 1, #config[cfgType] do
                setKeyConfig(pn, config[cfgType][pn].Joystick, config[cfgType][pn].Buttons)
            end
            options.f_keyCfgReset(cfgType)
            item = item_start
            cursorPosY = item_start
            configall = false
            commandBufReset(main.t_cmd[1])
            commandBufReset(main.t_cmd[2])
            --spacebar (disable key)
        elseif getKey() == 'SPACE' then
            key = 'SPACE'
            --keyboard key detection
        elseif cfgType == 'KeyConfig' then
            key = getKey()
            --gamepad key detection
        else
            local tmp = getJoystickKey(joyNum)
            if tonumber(tmp) == nil then
                btnReleased = true
            elseif btnReleased then
                key = tmp
                btnReleased = false
            end
            key = tostring(key)
        end
        --other keyboard or gamepad key
        if key ~= '' then
            if key == 'SPACE' then
                sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
                --decrease old button count
                if t_keyList[joyNum][btn] ~= nil and t_keyList[joyNum][btn] > 1 then
                    t_keyList[joyNum][btn] = t_keyList[joyNum][btn] - 1
                else
                    t_keyList[joyNum][btn] = nil
                end
                --update vardisplay / config data
                t[item]['vardisplay' .. player] = motif.option_info.menu_valuename_nokey
                config[cfgType][player].Buttons[item - item_start] = tostring(motif.option_info.menu_valuename_nokey)
                modified = true
            elseif cfgType == 'KeyConfig' or (cfgType == 'JoystickConfig' and tonumber(key) ~= nil) then
                sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
                --decrease old button count
                if t_keyList[joyNum][btn] ~= nil and t_keyList[joyNum][btn] > 1 then
                    t_keyList[joyNum][btn] = t_keyList[joyNum][btn] - 1
                else
                    t_keyList[joyNum][btn] = nil
                end
                --remove previous button assignment if already set
                for k, v in ipairs(t) do
                    if v['vardisplay' .. player] == key then
                        v['vardisplay' .. player] = 'Not used'
                        config[cfgType][player].Buttons[k - item_start] = 'Not used'
                        if t_keyList[joyNum][key] ~= nil and t_keyList[joyNum][key] > 1 then
                            t_keyList[joyNum][key] = t_keyList[joyNum][key] - 1
                        else
                            t_keyList[joyNum][key] = nil
                        end
                    end
                end
                --increase new button count
                if t_keyList[joyNum][key] == nil then
                    t_keyList[joyNum][key] = 1
                else
                    t_keyList[joyNum][key] = t_keyList[joyNum][key] + 1
                end
                --update vardisplay / config data
                t[item]['vardisplay' .. player] = key
                config[cfgType][player].Buttons[item - item_start] = key
                modified = true
            end
            --move to the next position
            item = item + 1
            cursorPosY = cursorPosY + 1
            if item > #t or t[item].itemname == 'back' then
                item = item_start
                cursorPosY = item_start
                configall = false
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
                for pn = 1, #config[cfgType] do
                    setKeyConfig(pn, config[cfgType][pn].Joystick, config[cfgType][pn].Buttons)
                end
            end
            key = ''
        end
        resetKey()
        --move left / right
    elseif main.f_input(main.t_players, {'$F', '$B'}) then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        if player == 3 then
            player = 4
        else
            player = 3
        end
        joyNum = config[cfgType][player].Joystick
        --move up / down
    elseif main.f_input(main.t_players, {'$U', '$D'}) then
        sndPlay(motif.files.snd_data, motif.option_info.cursor_move_snd[1], motif.option_info.cursor_move_snd[2])
        if cursorPosY == item_start then
            cursorPosY = #t
            item = #t
        else
            cursorPosY = item_start
            item = item_start
        end
    end
    btn = tostring(config[cfgType][player].Buttons[item - item_start])
    if configall == false then
        if esc() or main.f_input(main.t_players, {'m'}) or (t[item].itemname == 'back' and main.f_input(main.t_players, {'pal', 's'})) then
            if t_conflict[joyNum] then
                if not main.f_warning(main.f_extractText(motif.warning_info.text_keys_text), motif.option_info, motif.optionbgdef) then
                    options.txt_title:update({text = motif.option_info.title_input_text})
                    config[cfgType] = main.f_tableCopy(t_savedConfig)
                    for pn = 1, #config[cfgType] do
                        setKeyConfig(pn, config[cfgType][pn].Joystick, config[cfgType][pn].Buttons)
                    end
                    menu.itemname = ''
                    return false
                end
            else
                sndPlay(motif.files.snd_data, motif.option_info.cancel_snd[1], motif.option_info.cancel_snd[2])
                options.txt_title:update({text = motif.option_info.title_input_text})
                for pn = 1, #config[cfgType] do
                    setKeyConfig(pn, config[cfgType][pn].Joystick, config[cfgType][pn].Buttons)
                end
                menu.itemname = ''
                return false
            end
            --Config all
        elseif (t[item].itemname == 'configall' and main.f_input(main.t_players, {'pal', 's'})) or getKey() == 'F1' or getKey() == 'F2' then
            sndPlay(motif.files.snd_data, motif.option_info.cursor_done_snd[1], motif.option_info.cursor_done_snd[2])
            if getKey() == 'F3' then
                player = 3
            elseif getKey() == 'F4' then
                player = 4
            end
            if cfgType == 'JoystickConfig' and getJoystickPresent(joyNum) == false then
                main.f_warning(main.f_extractText(motif.warning_info.text_pad_text), motif.option_info, motif.optionbgdef)
                item = item_start
                cursorPosY = item_start
            else
                item = item_start + 1
                cursorPosY = item_start + 1
                btnReleased = false
                configall = true
            end
            resetKey()
        end
    end
    t_conflict[joyNum] = false
    --draw clearcolor
    if not skipClear then
        clearColor(motif[bgdef].bgclearcolor[1], motif[bgdef].bgclearcolor[2], motif[bgdef].bgclearcolor[3])
    end
    --draw layerno = 0 backgrounds
    bgDraw(motif[bgdef].bg, false)
    --draw player num
    for i = 3, 4 do
        txt_keyController[i]:update({
            font =   motif.option_info['menu_item_key_p' .. i .. '_font'][1],
            bank =   motif.option_info['menu_item_key_p' .. i .. '_font'][2],
            align =  motif.option_info['menu_item_key_p' .. i .. '_font'][3],
            text =   motif.option_info.menu_itemname_key_playerno .. ' ' .. i,
            x =      motif.option_info['menu_item_p' .. i .. '_pos'][1],
            y =      motif.option_info['menu_item_p' .. i .. '_pos'][2],
            scaleX = motif.option_info['menu_item_key_p' .. i .. '_font_scale'][1],
            scaleY = motif.option_info['menu_item_key_p' .. i .. '_font_scale'][2],
            r =      motif.option_info['menu_item_key_p' .. i .. '_font'][4],
            g =      motif.option_info['menu_item_key_p' .. i .. '_font'][5],
            b =      motif.option_info['menu_item_key_p' .. i .. '_font'][6],
            src =    motif.option_info['menu_item_key_p' .. i .. '_font'][7],
            dst =    motif.option_info['menu_item_key_p' .. i .. '_font'][8],
            height = motif.option_info['menu_item_key_p' .. i .. '_font_height'],
            defsc =  motif.defaultOptions
        })
        txt_keyController[i]:draw()
    end
    --draw menu box
    if motif.option_info.menu_boxbg_visible == 1 then
        for i = 3, 4 do
            fillRect(
                    t_pos[i][1] + motif.option_info.menu_key_boxcursor_coords[1],
                    t_pos[i][2] + motif.option_info.menu_key_boxcursor_coords[2],
                    motif.option_info.menu_key_boxcursor_coords[3] - motif.option_info.menu_key_boxcursor_coords[1] + 1,
                    #t * (motif.option_info.menu_key_boxcursor_coords[4] - motif.option_info.menu_key_boxcursor_coords[2] + 1) + main.f_oddRounding(motif.option_info.menu_key_boxcursor_coords[2]),
                    motif.option_info.menu_boxbg_col[1],
                    motif.option_info.menu_boxbg_col[2],
                    motif.option_info.menu_boxbg_col[3],
                    motif.option_info.menu_boxbg_alpha[1],
                    motif.option_info.menu_boxbg_alpha[2],
                    motif.defaultOptions,
                    false
            )
        end
    end
    --draw title
    options.txt_title:draw()
    --draw menu items
    for i = 1, #t do
        for j = 3, 4 do
            if i > item - cursorPosY then
                if j == 3 then --player1 side (left)
                    if t[i].itemname == 'configall' then
                        t[i].infodisplay = motif.option_info.menu_valuename_f3
                    elseif t[i].itemname == 'back' then
                        t[i].infodisplay = motif.option_info.menu_valuename_esc
                    end
                else --player2 side (right)
                    if t[i].itemname == 'configall' then
                        t[i].infodisplay = motif.option_info.menu_valuename_f4
                    elseif t[i].itemname == 'back' then
                        t[i].infodisplay = motif.option_info.menu_valuename_esc --menu_valuename_next
                    end
                end
                if i == item and j == player then --active item
                    --draw displayname
                    t[i].data[j]:update({
                        font =   motif.option_info.menu_item_active_font[1],
                        bank =   motif.option_info.menu_item_active_font[2],
                        align =  motif.option_info.menu_item_active_font[3],
                        text =   t[i].displayname,
                        x =      t_pos[j][1],
                        y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                        scaleX = motif.option_info.menu_item_active_font_scale[1],
                        scaleY = motif.option_info.menu_item_active_font_scale[2],
                        r =      motif.option_info.menu_item_active_font[4],
                        g =      motif.option_info.menu_item_active_font[5],
                        b =      motif.option_info.menu_item_active_font[6],
                        src =    motif.option_info.menu_item_active_font[7],
                        dst =    motif.option_info.menu_item_active_font[8],
                        height = motif.option_info.menu_item_active_font_height,
                        defsc =  motif.defaultOptions
                    })
                    t[i].data[j]:draw()
                    --draw vardata
                    if t[i].vardata ~= nil then
                        if t_keyList[joyNum][tostring(t[i]['vardisplay' .. j])] ~= nil and t_keyList[joyNum][tostring(t[i]['vardisplay' .. j])] > 1 then
                            t[i].vardata[j]:update({
                                font =   motif.option_info.menu_item_value_conflict_font[1],
                                bank =   motif.option_info.menu_item_value_conflict_font[2],
                                align =  motif.option_info.menu_item_value_conflict_font[3],
                                text =   t[i]['vardisplay' .. j],
                                x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                                y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                                scaleX = motif.option_info.menu_item_value_conflict_font_scale[1],
                                scaleY = motif.option_info.menu_item_value_conflict_font_scale[2],
                                r =      motif.option_info.menu_item_value_conflict_font[4],
                                g =      motif.option_info.menu_item_value_conflict_font[5],
                                b =      motif.option_info.menu_item_value_conflict_font[6],
                                src =    motif.option_info.menu_item_value_conflict_font[7],
                                dst =    motif.option_info.menu_item_value_conflict_font[8],
                                height = motif.option_info.menu_item_value_conflict_font_height,
                                defsc =  motif.defaultOptions
                            })
                            t[i].vardata[j]:draw()
                            t_conflict[joyNum] = true
                        else
                            t[i].vardata[j]:update({
                                font =   motif.option_info.menu_item_value_active_font[1],
                                bank =   motif.option_info.menu_item_value_active_font[2],
                                align =  motif.option_info.menu_item_value_active_font[3],
                                text =   t[i]['vardisplay' .. j],
                                x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                                y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                                scaleX = motif.option_info.menu_item_value_active_font_scale[1],
                                scaleY = motif.option_info.menu_item_value_active_font_scale[2],
                                r =      motif.option_info.menu_item_value_active_font[4],
                                g =      motif.option_info.menu_item_value_active_font[5],
                                b =      motif.option_info.menu_item_value_active_font[6],
                                src =    motif.option_info.menu_item_value_active_font[7],
                                dst =    motif.option_info.menu_item_value_active_font[8],
                                height = motif.option_info.menu_item_value_active_font_height,
                                defsc =  motif.defaultOptions
                            })
                            t[i].vardata[j]:draw()
                        end
                        --draw infodata
                    elseif t[i].infodata ~= nil then
                        t[i].infodata[j]:update({
                            font =   motif.option_info.menu_item_info_active_font[1],
                            bank =   motif.option_info.menu_item_info_active_font[2],
                            align =  motif.option_info.menu_item_info_active_font[3],
                            text =   t[i].infodisplay,
                            x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                            y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                            scaleX = motif.option_info.menu_item_value_active_font_scale[1],
                            scaleY = motif.option_info.menu_item_value_active_font_scale[2],
                            r =      motif.option_info.menu_item_info_active_font[4],
                            g =      motif.option_info.menu_item_info_active_font[5],
                            b =      motif.option_info.menu_item_info_active_font[6],
                            src =    motif.option_info.menu_item_info_active_font[7],
                            dst =    motif.option_info.menu_item_info_active_font[8],
                            height = motif.option_info.menu_item_info_active_font_height,
                            defsc =  motif.defaultOptions
                        })
                        t[i].infodata[j]:draw()
                    end
                else --inactive item
                    --draw displayname
                    t[i].data[j]:update({
                        font =   motif.option_info.menu_item_font[1],
                        bank =   motif.option_info.menu_item_font[2],
                        align =  motif.option_info.menu_item_font[3],
                        text =   t[i].displayname,
                        x =      t_pos[j][1],
                        y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                        scaleX = motif.option_info.menu_item_font_scale[1],
                        scaleY = motif.option_info.menu_item_font_scale[2],
                        r =      motif.option_info.menu_item_font[4],
                        g =      motif.option_info.menu_item_font[5],
                        b =      motif.option_info.menu_item_font[6],
                        src =    motif.option_info.menu_item_font[7],
                        dst =    motif.option_info.menu_item_font[8],
                        height = motif.option_info.menu_item_font_height,
                        defsc =  motif.defaultOptions
                    })
                    t[i].data[j]:draw()
                    --draw vardata
                    if t[i].vardata ~= nil then
                        if t_keyList[joyNum][tostring(t[i]['vardisplay' .. j])] ~= nil and t_keyList[joyNum][tostring(t[i]['vardisplay' .. j])] > 1 then
                            t[i].vardata[j]:update({
                                font =   motif.option_info.menu_item_value_conflict_font[1],
                                bank =   motif.option_info.menu_item_value_conflict_font[2],
                                align =  motif.option_info.menu_item_value_conflict_font[3],
                                text =   t[i]['vardisplay' .. j],
                                x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                                y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                                scaleX = motif.option_info.menu_item_value_conflict_font_scale[1],
                                scaleY = motif.option_info.menu_item_value_conflict_font_scale[2],
                                r =      motif.option_info.menu_item_value_conflict_font[4],
                                g =      motif.option_info.menu_item_value_conflict_font[5],
                                b =      motif.option_info.menu_item_value_conflict_font[6],
                                src =    motif.option_info.menu_item_value_conflict_font[7],
                                dst =    motif.option_info.menu_item_value_conflict_font[8],
                                height = motif.option_info.menu_item_value_conflict_font_height,
                                defsc =  motif.defaultOptions
                            })
                            t[i].vardata[j]:draw()
                            t_conflict[joyNum] = true
                        else
                            t[i].vardata[j]:update({
                                font =   motif.option_info.menu_item_value_font[1],
                                bank =   motif.option_info.menu_item_value_font[2],
                                align =  motif.option_info.menu_item_value_font[3],
                                text =   t[i]['vardisplay' .. j],
                                x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                                y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                                scaleX = motif.option_info.menu_item_value_font_scale[1],
                                scaleY = motif.option_info.menu_item_value_font_scale[2],
                                r =      motif.option_info.menu_item_value_font[4],
                                g =      motif.option_info.menu_item_value_font[5],
                                b =      motif.option_info.menu_item_value_font[6],
                                src =    motif.option_info.menu_item_value_font[7],
                                dst =    motif.option_info.menu_item_value_font[8],
                                height = motif.option_info.menu_item_value_font_height,
                                defsc =  motif.defaultOptions
                            })
                            t[i].vardata[j]:draw()
                        end
                        --draw infodata
                    elseif t[i].infodata ~= nil then
                        t[i].infodata[j]:update({
                            font =   motif.option_info.menu_item_info_font[1],
                            bank =   motif.option_info.menu_item_info_font[2],
                            align =  motif.option_info.menu_item_info_font[3],
                            text =   t[i].infodisplay,
                            x =      t_pos[j][1] + motif.option_info.menu_key_item_spacing[1],
                            y =      t_pos[j][2] + (i - 1) * motif.option_info.menu_key_item_spacing[2],
                            scaleX = motif.option_info.menu_item_value_active_font_scale[1],
                            scaleY = motif.option_info.menu_item_value_active_font_scale[2],
                            r =      motif.option_info.menu_item_info_font[4],
                            g =      motif.option_info.menu_item_info_font[5],
                            b =      motif.option_info.menu_item_info_font[6],
                            src =    motif.option_info.menu_item_info_font[7],
                            dst =    motif.option_info.menu_item_info_font[8],
                            height = motif.option_info.menu_item_info_font_height,
                            defsc =  motif.defaultOptions
                        })
                        t[i].infodata[j]:draw()
                    end
                end
            end
        end
    end
    --draw menu cursor
    if motif.option_info.menu_boxcursor_visible == 1 then
        local src, dst = main.f_boxcursorAlpha(
                motif.option_info.menu_boxcursor_alpharange[1],
                motif.option_info.menu_boxcursor_alpharange[2],
                motif.option_info.menu_boxcursor_alpharange[3],
                motif.option_info.menu_boxcursor_alpharange[4],
                motif.option_info.menu_boxcursor_alpharange[5],
                motif.option_info.menu_boxcursor_alpharange[6]
        )
        for i = 3, 4 do
            if i == player then
                fillRect(
                        t_pos[i][1] + motif.option_info.menu_key_boxcursor_coords[1],
                        t_pos[i][2] + motif.option_info.menu_key_boxcursor_coords[2] + (cursorPosY - 1) * motif.option_info.menu_key_item_spacing[2],
                        motif.option_info.menu_key_boxcursor_coords[3] - motif.option_info.menu_key_boxcursor_coords[1] + 1,
                        motif.option_info.menu_key_boxcursor_coords[4] - motif.option_info.menu_key_boxcursor_coords[2] + 1 + main.f_oddRounding(motif.option_info.menu_key_boxcursor_coords[2]),
                        motif.option_info.menu_boxcursor_col[1],
                        motif.option_info.menu_boxcursor_col[2],
                        motif.option_info.menu_boxcursor_col[3],
                        src,
                        dst,
                        motif.defaultOptions,
                        false
                )
            end
        end
    end
    --draw layerno = 1 backgrounds
    bgDraw(motif[bgdef].bg, true)
    main.f_cmdInput()
    if not skipClear then
        refresh()
    end
    return true
end