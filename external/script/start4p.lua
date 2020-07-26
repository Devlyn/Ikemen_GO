local start = require('external.script.start')
local motif = require('external.script.motif4p')
local start4p = {}

local p1RowOffset = 0
local p2RowOffset = 0
local p3RowOffset = 0
local p4RowOffset = 0
local p1FaceX = 0
local p1FaceY = 0
local p2FaceX = 0
local p2FaceY = 0
local p3FaceX = 0
local p3FaceY = 0
local p4FaceX = 0
local p4FaceY = 0
local t_p1Cursor = {}
local t_p2Cursor = {}
local t_p3Cursor = {}
local t_p4Cursor = {}
local p1RestoreCursor = false
local p2RestoreCursor = false
local p3RestoreCursor = false
local p4RestoreCursor = false
local p1TeamMenu = 0
local p2TeamMenu = 0
local p3TeamMenu = 0
local p4TeamMenu = 0
local p1TeamEnd = false
local p2TeamEnd = false
local p3TeamEnd = true
local p4TeamEnd = true
local p1SelEnd = false
local p2SelEnd = false
local p3SelEnd = false
local p4SelEnd = false
local p1FaceOffset = 0
local p2FaceOffset = 0
local p3FaceOffset = 0
local p4FaceOffset = 0
local p1NumChars = 1
local p2NumChars = 1
local p3NumChars = 1
local p4NumChars = 1
local p1SelX = 0
local p1SelY = 0
local p2SelX = 0
local p2SelY = 0
local p3SelX = 0
local p3SelY = 0
local p4SelX = 0
local p4SelY = 0
local p1Cell = false
local p2Cell = false
local p3Cell = false
local p4Cell = false
local lastMatch = 0
local stageList = 0
local t_gameStats = {}
local t_savedData = {
    win = {0, 0},
    lose = {0, 0},
    time = {total = 0, matches = {}},
    score = {total = {0, 0}, matches = {}},
    consecutive = {0, 0},
}
start.p1TeamMode = 1
start.p2TeamMode = 1

local txt_p1Name = text:create({
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
local txt_p2Name = text:create({
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
local txt_p3Name = text:create({
    font =   motif.select_info.p3_name_font[1],
    bank =   motif.select_info.p3_name_font[2],
    align =  motif.select_info.p3_name_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.select_info.p3_name_font_scale[1],
    scaleY = motif.select_info.p3_name_font_scale[2],
    r =      motif.select_info.p3_name_font[4],
    g =      motif.select_info.p3_name_font[5],
    b =      motif.select_info.p3_name_font[6],
    src =    motif.select_info.p3_name_font[7],
    dst =    motif.select_info.p3_name_font[8],
    height = motif.select_info.p3_name_font_height,
})
local txt_p4Name = text:create({
    font =   motif.select_info.p4_name_font[1],
    bank =   motif.select_info.p4_name_font[2],
    align =  motif.select_info.p4_name_font[3],
    text =   '',
    x =      0,
    y =      0,
    scaleX = motif.select_info.p4_name_font_scale[1],
    scaleY = motif.select_info.p4_name_font_scale[2],
    r =      motif.select_info.p4_name_font[4],
    g =      motif.select_info.p4_name_font[5],
    b =      motif.select_info.p4_name_font[6],
    src =    motif.select_info.p4_name_font[7],
    dst =    motif.select_info.p4_name_font[8],
    height = motif.select_info.p4_name_font_height,
})

local txt_p1NameVS = text:create({
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
local txt_p2NameVS = text:create({
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
local txt_matchNo = text:create({
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

local p1RandomCount = motif.select_info.cell_random_switchtime
local p1RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
local p2RandomCount = motif.select_info.cell_random_switchtime
local p2RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
local p3RandomCount = motif.select_info.cell_random_switchtime
local p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
local p4RandomCount = motif.select_info.cell_random_switchtime
local p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]

-- @override assigns AI level
function start.f_remapAI()
    --Offset
    local offset = 0
    if config.AIRamping and (gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') or gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop')) then
        offset = t_aiRamp[matchNo] - config.Difficulty
    end
    --Player 1
    if main.coop then
        remapInput(3, 2) --P3 character uses P2 controls
        setCom(1, 0)
        setCom(3, 0)
    elseif start.p1TeamMode == 0 then --Single
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
    elseif start.p1TeamMode == 1 then --Simul
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
        for i = 3, p1NumChars * 2 do
            if i % 2 ~= 0 then --odd value
                remapInput(i, 1) --P3/5/7 character uses P1 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif start.p1TeamMode == 2 then --Turns
        for i = 1, p1NumChars * 2 do
            if i % 2 ~= 0 then --odd value
                if main.t_pIn[1] == 1 and not main.aiFight then
                    remapInput(i, 1) --P1/3/5/7 character uses P1 controls
                    setCom(i, 0)
                else
                    setCom(i, start.f_difficulty(i, offset))
                end
            end
        end
    else --Tag
        for i = 1, p1NumChars * 2 do
            if i % 2 ~= 0 then --odd value
                if main.t_pIn[1] == 1 and not main.aiFight then
                    remapInput(i, 1) --P1/3/5/7 character uses P1 controls
                    setCom(i, 0)
                else
                    setCom(i, start.f_difficulty(i, offset))
                end
            end
        end
    end
    --Player 2
    if start.p2TeamMode == 0 then --Single
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
    elseif start.p2TeamMode == 1 then --Simul
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
        for i = 4, p2NumChars * 2 do
            if i % 2 == 0 then --even value
                remapInput(i, 2) --P4/6/8 character uses P2 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif start.p2TeamMode == 2 then --Turns
        for i = 2, p2NumChars * 2 do
            if i % 2 == 0 then --even value
                if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
                    remapInput(i, 2) --P2/4/6/8 character uses P2 controls
                    setCom(i, 0)
                else
                    setCom(i, start.f_difficulty(i, offset))
                end
            end
        end
    else --Tag
        for i = 2, p2NumChars * 2 do
            if i % 2 == 0 then --even value
                if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
                    remapInput(i, 2) --P2/4/6/8 character uses P2 controls
                    setCom(i, 0)
                else
                    setCom(i, start.f_difficulty(i, offset))
                end
            end
        end
    end
    -- For this mode we expect that there are 4 actual players
    if (gamemode('4pversus')) then
        remapInput(3, 3) --Player 3 get's 3rd character
        setCom(3,0) --Turning off the comp
        remapInput(4, 4) --Player 4 get's 4th character
        setCom(4,0) --Turning off the comp
    end
    -- For this mode we expect that there are 4 actual players
    if (gamemode('4pcoop')) then
        remapInput(3, 2)
        setCom(3,0)
        remapInput(5, 3)
        setCom(5,0)
        remapInput(7, 4)
        setCom(7,0)
    end
end

-- @override generates roster table
function start.f_makeRoster(t_ret)
    t_ret = t_ret or {}
    --prepare correct settings tables
    local t = {}
    local t_static = {}
    local t_removable = {}
    --Arcade / Time Attack
    if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') or gamemode('timeattack') then
        t_static = main.t_orderChars
        if p2Ratio then --Ratio
            if main.t_selChars[start.t_p1Selected[1].ref + 1].ratiomatches ~= nil and main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"] ~= nil then --custom settings exists as char param
                t = main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"]
            else --default settings
                t = main.t_selOptions.arcaderatiomatches
            end
        elseif start.p2TeamMode == 0 then --Single
            if main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.arcademaxmatches, t_static)
            end
        else --Simul / Turns / Tag
            if main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
            end
        end
        --4PCoop
    elseif gameMode('4pcoop') then
        t_static = main.t_orderChars
        if main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
        end
        --Survival
    elseif gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
        t_static = main.t_orderSurvival
        if main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[start.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.survivalmaxmatches, t_static)
        end
        --Boss Rush
    elseif gamemode('bossrush') then
        t_static = {main.t_bossChars}
        for i = 1, math.ceil(#main.t_bossChars / p2NumChars) do --generate ratiomatches style table
            table.insert(t, {['rmin'] = p2NumChars, ['rmax'] = p2NumChars, ['order'] = 1})
        end
        --VS 100 Kumite
    elseif gamemode('vs100kumite') then
        t_static = {main.t_randomChars}
        for i = 1, 100 do --generate ratiomatches style table for 100 matches
            table.insert(t, {['rmin'] = p2NumChars, ['rmax'] = p2NumChars, ['order'] = 1})
        end
    else
        panicError('LUA ERROR: ' .. gamemode() .. ' game mode unrecognized by start.f_makeRoster()')
    end
    --generate roster
    t_removable = main.f_tableCopy(t_static) --copy into editable order table
    for i = 1, #t do --for each match number
        if t[i].order == -1 then --infinite matches for this order detected
            table.insert(t_ret, {-1}) --append infinite matches flag at the end
            break
        end
        if t_removable[t[i].order] ~= nil then
            if #t_removable[t[i].order] == 0 and gamemode('vs100kumite') then
                t_removable = main.f_tableCopy(t_static) --ensure that there will be at least 100 matches in VS 100 Kumite mode
            end
            if #t_removable[t[i].order] >= 1 then --there is at least 1 character with this order available
                local remaining = t[i].rmin - #t_removable[t[i].order]
                table.insert(t_ret, {}) --append roster table with new subtable
                for j = 1, math.random(math.min(t[i].rmin, #t_removable[t[i].order]), math.min(t[i].rmax, #t_removable[t[i].order])) do --for randomized characters count
                    local rand = math.random(1, #t_removable[t[i].order]) --randomize which character will be taken
                    table.insert(t_ret[#t_ret], t_removable[t[i].order][rand]) --add such character into roster subtable
                    table.remove(t_removable[t[i].order], rand) --and remove it from the available character pool
                end
                --fill the remaining slots randomly if there are not enough players available with this order
                while remaining > 0 do
                    table.insert(t_ret[#t_ret], t_static[t[i].order][math.random(1, #t_static[t[i].order])])
                    remaining = remaining - 1
                end
            end
        end
    end
    if main.debugLog then main.f_printTable(t_ret, 'debug/t_roster.txt') end
    return t_ret
end

-- @override generates table with cell coordinates
function start.f_resetGrid()
    start.t_drawFace = {}
    for row = 1, motif.select_info.rows do
        for col = 1, motif.select_info.columns do
            -- Note to anyone editing this function:
            -- The "elseif" chain is important if a "end" is added in the middle it could break the character icon display.

            --1Pのランダムセル表示位置 / 1P random cell display position
            if start.t_grid[row + p1RowOffset][col].char == 'randomselect' or start.t_grid[row + p1RowOffset][col].hidden == 3 then
                table.insert(start.t_drawFace, {
                    d = 1,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --1Pのキャラ表示位置 / 1P character display position
            elseif start.t_grid[row + p1RowOffset][col].char ~= nil and start.t_grid[row + p1RowOffset][col].hidden == 0 then
                table.insert(start.t_drawFace, {
                    d = 2,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(start.t_drawFace, {
                    d = 0,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --2Pのランダムセル表示位置 / 2P random cell display position
            if start.t_grid[row + p2RowOffset][col].char == 'randomselect' or start.t_grid[row + p2RowOffset][col].hidden == 3 then
                table.insert(start.t_drawFace, {
                    d = 11,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --2Pのキャラ表示位置 / 2P character display position
            elseif start.t_grid[row + p2RowOffset][col].char ~= nil and start.t_grid[row + p2RowOffset][col].hidden == 0 then
                table.insert(start.t_drawFace, {
                    d = 12,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(start.t_drawFace, {
                    d = 10,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --3P random cell display position
            if start.t_grid[row + p3RowOffset][col].char == 'randomselect' or start.t_grid[row + p3RowOffset][col].hidden == 3 then
                table.insert(start.t_drawFace, {
                    d = 1,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --3P character display position
            elseif start.t_grid[row + p3RowOffset][col].char ~= nil and start.t_grid[row + p3RowOffset][col].hidden == 0 then
                table.insert(start.t_drawFace, {
                    d = 2,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(start.t_drawFace, {
                    d = 0,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --4P random cell display position
            if start.t_grid[row + p4RowOffset][col].char == 'randomselect' or start.t_grid[row + p4RowOffset][col].hidden == 3 then
                table.insert(start.t_drawFace, {
                    d = 11,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --4P character display position
            elseif start.t_grid[row + p4RowOffset][col].char ~= nil and start.t_grid[row + p4RowOffset][col].hidden == 0 then
                table.insert(start.t_drawFace, {
                    d = 12,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(start.t_drawFace, {
                    d = 10,
                    p1 = start.t_grid[row + p1RowOffset][col].char_ref,
                    p2 = start.t_grid[row + p2RowOffset][col].char_ref,
                    p3 = start.t_grid[row + p3RowOffset][col].char_ref,
                    p4 = start.t_grid[row + p4RowOffset][col].char_ref,
                    x1 = p1FaceX + start.t_grid[row][col].x,
                    x2 = p2FaceX + start.t_grid[row][col].x,
                    x3 = p3FaceX + start.t_grid[row][col].x,
                    x4 = p4FaceX + start.t_grid[row][col].x,
                    y1 = p1FaceY + start.t_grid[row][col].y,
                    y2 = p2FaceY + start.t_grid[row][col].y,
                    y3 = p3FaceY + start.t_grid[row][col].y,
                    y4 = p4FaceY + start.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end
        end
    end
    --if main.debugLog then main.f_printTable(start.t_drawFace, 'debug/t_drawFace.txt') end
end

-- @override
function start.f_selectPal(ref, palno)
    local t_assignedKeys = {}
    for i = 1, #start.t_p1Selected do
        if start.t_p1Selected[i].ref == ref then
            t_assignedKeys[start.t_p1Selected[i].pal] = ''
        end
    end
    for i = 1, #start.t_p2Selected do
        if start.t_p2Selected[i].ref == ref then
            t_assignedKeys[start.t_p2Selected[i].pal] = ''
        end
    end
    for i = 1, #start.t_p3Selected do
        if start.t_p3Selected[i].ref == ref then
            t_assignedKeys[start.t_p3Selected[i].pal] = ''
        end
    end
    for i = 1, #start.t_p4Selected do
        if start.t_p4Selected[i].ref == ref then
            t_assignedKeys[start.t_p4Selected[i].pal] = ''
        end
    end
    local t = {}
    --selected palette
    if palno ~= nil then
        t = main.f_tableCopy(main.t_selChars[ref + 1].pal)
        if t_assignedKeys[start.f_reampPal(ref, palno)] == nil then
            return start.f_reampPal(ref, palno)
        else
            local wrap = 0
            for k, v in ipairs(t) do
                if start.f_reampPal(ref, v) == start.f_reampPal(ref, palno) then
                    wrap = #t - k
                    break
                end
            end
            main.f_tableWrap(t, wrap)
            for k, v in ipairs(t) do
                if t_assignedKeys[start.f_reampPal(ref, v)] == nil then
                    return start.f_reampPal(ref, v)
                end
            end
        end
        --default palette
    elseif not config.AIRandomColor then
        t = main.f_tableCopy(main.t_selChars[ref + 1].pal_defaults)
        palno = main.t_selChars[ref + 1].pal_defaults[1]
        if t_assignedKeys[palno] == nil then
            return palno
        else
            local wrap = 0
            for k, v in ipairs(t) do
                if v == palno then
                    wrap = #t - k
                    break
                end
            end
            main.f_tableWrap(t, wrap)
            for k, v in ipairs(t) do
                if t_assignedKeys[v] == nil then
                    return v
                end
            end
        end
    end
    --random palette
    t = main.f_tableCopy(main.t_selChars[ref + 1].pal)
    if #t_assignedKeys >= #t then --not enough palettes for unique selection
        return math.random(1, #t)
    end
    main.f_tableShuffle(t)
    for k, v in ipairs(t) do
        if t_assignedKeys[v] == nil then
            return v
        end
    end
end

-- @override sets correct start cell
function start.f_startCell()
    --starting row
    if motif.select_info.p1_cursor_startcell[1] < motif.select_info.rows then
        p1SelY = motif.select_info.p1_cursor_startcell[1]
    else
        p1SelY = 0
    end
    if motif.select_info.p2_cursor_startcell[1] < motif.select_info.rows then
        p2SelY = motif.select_info.p2_cursor_startcell[1]
    else
        p2SelY = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[1] < motif.select_info.rows then
            p3SelY = motif.select_info.p3_cursor_startcell[1]
        else
            p3SelY = 0
        end
        if motif.select_info.p4_cursor_startcell[1] < motif.select_info.rows then
            p4SelY = motif.select_info.p4_cursor_startcell[1]
        else
            p4SelY = 0
        end
    end
    --starting column
    if motif.select_info.p1_cursor_startcell[2] < motif.select_info.columns then
        p1SelX = motif.select_info.p1_cursor_startcell[2]
    else
        p1SelX = 0
    end
    if motif.select_info.p2_cursor_startcell[2] < motif.select_info.columns then
        p2SelX = motif.select_info.p2_cursor_startcell[2]
    else
        p2SelX = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[2] < motif.select_info.columns then
            p3SelX = motif.select_info.p3_cursor_startcell[2]
        else
            p3SelX = 0
        end
        if motif.select_info.p4_cursor_startcell[2] < motif.select_info.columns then
            p4SelX = motif.select_info.p4_cursor_startcell[2]
        else
            p4SelX = 0
        end
    end
end

-- @override resets various data
function start.f_selectReset()
    main.f_cmdInput()
    local col = 1
    local row = 1
    for i = 1, #main.t_selGrid do
        if i > motif.select_info.columns * row then
            row = row + 1
            col = 1
        end
        if main.t_selGrid[i].slot ~= 1 then
            main.t_selGrid[i].slot = 1
            start.t_grid[row][col].char = start.f_selGrid(i).char
            start.t_grid[row][col].char_ref = start.f_selGrid(i).char_ref
            start.f_resetGrid()
        end
        col = col + 1
    end
    if main.p2Faces and motif.select_info.doubleselect_enabled == 1 then
        p1FaceX = motif.select_info.pos[1] + motif.select_info.p1_doubleselect_offset[1]
        p1FaceY = motif.select_info.pos[2] + motif.select_info.p1_doubleselect_offset[2]
        p2FaceX = motif.select_info.pos[1] + motif.select_info.p2_doubleselect_offset[1]
        p2FaceY = motif.select_info.pos[2] + motif.select_info.p2_doubleselect_offset[2]
    else
        p1FaceX = motif.select_info.pos[1]
        p1FaceY = motif.select_info.pos[2]
        p2FaceX = motif.select_info.pos[1]
        p2FaceY = motif.select_info.pos[2]
        p3FaceX = motif.select_info.pos[1]
        p3FaceY = motif.select_info.pos[2]
        p4FaceX = motif.select_info.pos[1]
        p4FaceY = motif.select_info.pos[2]
    end
    start.f_resetGrid()
    if gamemode('netplayversus') or gamemode('netplayteamcoop') or gamemode('netplaysurvivalcoop') then
        start.p1TeamMode = 0
        start.p2TeamMode = 0
        stageNo = 0
        stageList = 0
    end
    p1Cell = nil
    p2Cell = nil
    p3Cell = nil
    p4Cell = nil
    start.t_p1Selected = {}
    start.t_p2Selected = {}
    start.t_p3Selected = {}
    start.t_p4Selected = {}
    p1TeamEnd = false
    if gamemode('4pversus') then
        p1TeamEnd = true
    end
    p1SelEnd = false
    p1Ratio = false
    p2TeamEnd = false
    if gamemode('4pversus') then
        p2TeamEnd = true
    end
    p2SelEnd = false
    p2Ratio = false
    p3TeamEnd = true -- p3 Never has team mode
    p3SelEnd = false
    p3Ratio = false
    p4TeamEnd = true -- p4 Never has team mode
    p4SelEnd = false
    p4Ratio = false
    if main.t_pIn[2] == 1 then
        p2TeamEnd = true
        p2SelEnd = true
    elseif main.coop then
        p1TeamEnd = true
        p2TeamEnd = true
        p3TeamEnd = true
        p4TeamEnd = true
    end
    if not main.p2SelectMenu and not (gamemode('4pversus') or gamemode('4pcoop')) then
        p2SelEnd = true
    end
    selScreenEnd = false
    stageEnd = false
    coopEnd = false
    restoreTeam = false
    continueData = false
    p1NumChars = 1
    p2NumChars = 1
    p3NumChars = 1
    p4NumChars = 1
    winner = 0
    winCnt = 0
    loseCnt = 0
    matchNo = 0
    if not challenger then
        t_savedData = {
            ['win'] = {0, 0},
            ['lose'] = {0, 0},
            ['time'] = {['total'] = 0, ['matches'] = {}},
            ['score'] = {['total'] = {0, 0}, ['matches'] = {}},
            ['consecutive'] = {0, 0},
        }
    end
    t_recordText = start.f_getRecordText()
    setMatchNo(matchNo)
    menu.movelistChar = 1
end

-- @override
local txt_selStage = text:create({
    font = motif.select_info.stage_active_font[1],
    height = motif.select_info.stage_active_font_height
})

local stageActiveCount = 0
local stageActiveType = 'stage_active'

-- @override
function start.f_stageMenu()
    if main.f_input(main.t_players, {'$B'}) then
        sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
        stageList = stageList - 1
        if stageList < 0 then stageList = #main.t_includeStage[2] end
    elseif main.f_input(main.t_players, {'$F'}) then
        sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
        stageList = stageList + 1
        if stageList > #main.t_includeStage[2] then stageList = 0 end
    elseif main.f_input(main.t_players, {'$U'}) then
        sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
        for i = 1, 10 do
            stageList = stageList - 1
            if stageList < 0 then stageList = #main.t_includeStage[2] end
        end
    elseif main.f_input(main.t_players, {'$D'}) then
        sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
        for i = 1, 10 do
            stageList = stageList + 1
            if stageList > #main.t_includeStage[2] then stageList = 0 end
        end
    end
    if stageList == 0 then --draw random stage portrait loaded from screenpack SFF
        main.t_animUpdate[motif.select_info.stage_portrait_random_data] = 1
        animDraw(motif.select_info.stage_portrait_random_data)
    else --draw stage portrait loaded from stage SFF
        drawPortraitStage(
                stageList,
                motif.select_info.stage_portrait_spr[1],
                motif.select_info.stage_portrait_spr[2],
                motif.select_info.stage_pos[1] + motif.select_info.stage_portrait_offset[1],
                motif.select_info.stage_pos[2] + motif.select_info.stage_portrait_offset[2],
        --[[motif.select_info.stage_portrait_facing * ]]motif.select_info.stage_portrait_scale[1],
                motif.select_info.stage_portrait_scale[2],
                motif.select_info.stage_portrait_window[1],
                motif.select_info.stage_portrait_window[2],
                motif.select_info.stage_portrait_window[3],
                motif.select_info.stage_portrait_window[4]
        )
    end
    if main.f_input(main.t_players, {'pal', 's'}) then
        sndPlay(motif.files.snd_data, motif.select_info.stage_done_snd[1], motif.select_info.stage_done_snd[2])
        if stageList == 0 then
            stageNo = main.t_includeStage[2][math.random(1, #main.t_includeStage[2])]
        else
            stageNo = main.t_includeStage[2][stageList]
        end
        stageActiveType = 'stage_done'
        stageEnd = true
        --main.f_cmdInput()
    else
        if stageActiveCount < 2 then --delay change
            stageActiveCount = stageActiveCount + 1
        elseif stageActiveType == 'stage_active' then
            stageActiveType = 'stage_active2'
            stageActiveCount = 0
        else
            stageActiveType = 'stage_active'
            stageActiveCount = 0
        end
    end
    local t_txt = {}
    if stageList == 0 then
        t_txt[1] = motif.select_info.stage_random_text
    else
        t_txt = main.f_extractText(motif.select_info.stage_text, stageList, getStageName(main.t_includeStage[2][stageList]))
    end
    for i = 1, #t_txt do
        txt_selStage:update({
            font =   motif.select_info[stageActiveType .. '_font'][1],
            bank =   motif.select_info[stageActiveType .. '_font'][2],
            align =  motif.select_info[stageActiveType .. '_font'][3],
            text =   t_txt[i],
            x =      motif.select_info.stage_pos[1] + motif.select_info[stageActiveType .. '_offset'][1],
            y =      motif.select_info.stage_pos[2] + motif.select_info[stageActiveType .. '_offset'][2] + main.f_ySpacing(motif.select_info, stageActiveType .. '_font') * (i - 1),
            scaleX = motif.select_info[stageActiveType .. '_font_scale'][1],
            scaleY = motif.select_info[stageActiveType .. '_font_scale'][2],
            r =      motif.select_info[stageActiveType .. '_font'][4],
            g =      motif.select_info[stageActiveType .. '_font'][5],
            b =      motif.select_info[stageActiveType .. '_font'][6],
            src =    motif.select_info[stageActiveType .. '_font'][7],
            dst =    motif.select_info[stageActiveType .. '_font'][8],
            height = motif.select_info[stageActiveType .. '_font_height'],
        })
        txt_selStage:draw()
    end
end

-- @override save data between matches
function start.f_saveData()
    if main.debugLog then main.f_printTable(t_gameStats, 'debug/t_gameStats.txt') end
    if winner == -1 then
        return
    end
    --win/lose matches count, total score
    if winner == 1 then
        t_savedData.win[1] = t_savedData.win[1] + 1
        t_savedData.lose[2] = t_savedData.lose[2] + 1
        t_savedData.score.total[1] = t_gameStats.p1score
    else --if winner == 2 then
        t_savedData.win[2] = t_savedData.win[2] + 1
        t_savedData.lose[1] = t_savedData.lose[1] + 1
        if main.resetScore then --loosing sets score for the next match to lose count
            t_savedData.score.total[1] = t_savedData.lose[1]
        else
            t_savedData.score.total[1] = t_gameStats.p1score
        end
    end
    t_savedData.score.total[2] = t_gameStats.p2score
    --total time
    t_savedData.time.total = t_savedData.time.total + t_gameStats.matchTime
    --time in each round
    table.insert(t_savedData.time.matches, t_gameStats.timerRounds)
    --score in each round
    table.insert(t_savedData.score.matches, t_gameStats.scoreRounds)
    --individual characters
    local t_cheat = {false, false}
    for round = 1, #t_gameStats.match do
        for c, v in ipairs(t_gameStats.match[round]) do
            --cheat flag
            if v.cheated then
                t_cheat[v.teamside + 1] = true
            end
        end
    end
    --max consecutive wins
    for i = 1, #t_cheat do
        if t_cheat[i] then
            setConsecutiveWins(i, 0)
        elseif getConsecutiveWins(i) > t_savedData.consecutive[i] then
            t_savedData.consecutive[i] = getConsecutiveWins(i)
        end
    end
    if main.debugLog then main.f_printTable(t_savedData, 'debug/t_savedData.txt') end
end

--;===========================================================
--; PLAYER 1 SELECT MENU (Override)
--;===========================================================
function start.f_p1SelectMenu()
    --predefined selection
    if main.p1Char ~= nil then
        local t = {}
        for i = 1, #main.p1Char do
            if t[main.p1Char[i]] == nil then
                t[main.p1Char[i]] = ''
            end
            start.t_p1Selected[i] = {
                ref = main.p1Char[i],
                pal = start.f_selectPal(main.p1Char[i])
            }
        end
        p1SelEnd = true
        return
        --manual selection
    elseif not p1SelEnd then
        resetgrid = false
        --cell movement
        if p1RestoreCursor and t_p1Cursor[p1NumChars - #start.t_p1Selected] ~= nil then --restore saved position
            p1SelX = t_p1Cursor[p1NumChars - #start.t_p1Selected][1]
            p1SelY = t_p1Cursor[p1NumChars - #start.t_p1Selected][2]
            p1FaceOffset = t_p1Cursor[p1NumChars - #start.t_p1Selected][3]
            p1RowOffset = t_p1Cursor[p1NumChars - #start.t_p1Selected][4]
            t_p1Cursor[p1NumChars - #start.t_p1Selected] = nil
        else --calculate current position
            p1SelX, p1SelY, p1FaceOffset, p1RowOffset = start.f_cellMovement(p1SelX, p1SelY, 1, p1FaceOffset, p1RowOffset, motif.select_info.p1_cursor_move_snd)
        end
        p1Cell = p1SelX + motif.select_info.columns * p1SelY
        --draw active cursor
        local cursorX = p1FaceX + p1SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(p1SelX + 1, p1SelY + 1, 1)
        local cursorY = p1FaceY + (p1SelY - p1RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(p1SelX + 1, p1SelY + 1, 2)
        if resetgrid == true then
            start.f_resetGrid()
        end
        if start.f_selGrid(p1Cell + 1).hidden ~= 1 then
            main.f_animPosDraw(
                    motif.select_info.p1_cursor_active_data,
                    cursorX,
                    cursorY,
                    (motif.select_info['cell_' .. p1SelX + 1 .. '_' .. p1SelY + 1 .. '_facing'] or 1)
            )
        end
        --cell selected
        if start.f_slotSelected(p1Cell + 1, 1, p1SelX, p1SelY) and start.f_selGrid(p1Cell + 1).char ~= nil and start.f_selGrid(p1Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p1_cursor_done_snd[1], motif.select_info.p1_cursor_done_snd[2])
            local selected = start.f_selGrid(p1Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p1_select_snd[1], motif.select_info.p1_select_snd[2])
            table.insert(start.t_p1Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[1])),
                cursor = {cursorX, cursorY, p1RowOffset, (motif.select_info['cell_' .. p1SelX + 1 .. '_' .. p1SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(1)
            })
            t_p1Cursor[p1NumChars - #start.t_p1Selected + 1] = {p1SelX, p1SelY, p1FaceOffset, p1RowOffset}
            if #start.t_p1Selected == p1NumChars or (#start.t_p1Selected == 1 and main.coop) then --if all characters have been chosen
                if main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                    p2TeamEnd = false
                    p2SelEnd = false
                    --commandBufReset(main.t_cmd[2])
                end
                p1SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p1_cursor_done_snd[1], motif.select_info.p1_cursor_done_snd[2])
            local selected = start.f_selGrid(p1Cell + 1).char_ref
            local rand = false
            for i = #start.t_p1Selected + 1, p1NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p1_select_snd[1], motif.select_info.p1_select_snd[2])
                end
                rand = true
                table.insert(start.t_p1Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, p1RowOffset, (motif.select_info['cell_' .. p1SelX + 1 .. '_' .. p1SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(1)
                })
                t_p1Cursor[p1NumChars - #start.t_p1Selected + 1] = {p1SelX, p1SelY, p1FaceOffset, p1RowOffset}
            end
            if main.p2SelectMenu and main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                start.p2TeamMode = start.p1TeamMode
                p2NumChars = p1NumChars
                setTeamMode(2, start.p2TeamMode, p2NumChars)
                p2Cell = p1Cell
                p2SelX = p1SelX
                p2SelY = p1SelY
                p2FaceOffset = p1FaceOffset
                p2RowOffset = p1RowOffset
                for i = 1, p2NumChars do
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                    table.insert(start.t_p2Selected, {
                        ref = selected,
                        pal = start.f_selectPal(selected),
                        cursor = {cursorX, cursorY, p2RowOffset, (motif.select_info['cell_' .. p2SelX + 1 .. '_' .. p2SelY + 1 .. '_facing'] or 1)},
                        ratio = start.f_setRatio(2)
                    })
                    t_p2Cursor[p2NumChars - #start.t_p2Selected + 1] = {p2SelX, p2SelY, p2FaceOffset, p2RowOffset}
                end
            end
            if main.stageMenu then
                stageNo = main.t_includeStage[2][math.random(1, #main.t_includeStage[2])]
                stageEnd = true
            end
            p1SelEnd = true
        end
    end
end

--;===========================================================
--; PLAYER 2 SELECT MENU (Override)
--;===========================================================
function start.f_p2SelectMenu()
    --predefined selection
    if main.p2Char ~= nil then
        local t = {}
        for i = 1, #main.p2Char do
            if t[main.p2Char[i]] == nil then
                t[main.p2Char[i]] = ''
            end
            start.t_p2Selected[i] = {
                ref = main.p2Char[i],
                pal = start.f_selectPal(main.p2Char[i])
            }
        end
        p2SelEnd = true
        return
        --p2 selection disabled
    elseif not main.p2SelectMenu then
        p2SelEnd = true
        return
        --manual selection
    elseif not p2SelEnd then
        resetgrid = false
        --cell movement
        if p2RestoreCursor and t_p2Cursor[p2NumChars - #start.t_p2Selected] ~= nil then --restore saved position
            p2SelX = t_p2Cursor[p2NumChars - #start.t_p2Selected][1]
            p2SelY = t_p2Cursor[p2NumChars - #start.t_p2Selected][2]
            p2FaceOffset = t_p2Cursor[p2NumChars - #start.t_p2Selected][3]
            p2RowOffset = t_p2Cursor[p2NumChars - #start.t_p2Selected][4]
            t_p2Cursor[p2NumChars - #start.t_p2Selected] = nil
        else --calculate current position
            p2SelX, p2SelY, p2FaceOffset, p2RowOffset = start.f_cellMovement(p2SelX, p2SelY, 2, p2FaceOffset, p2RowOffset, motif.select_info.p2_cursor_move_snd)
        end
        p2Cell = p2SelX + motif.select_info.columns * p2SelY
        --draw active cursor
        local cursorX = p2FaceX + p2SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(p2SelX + 1, p2SelY + 1, 1)
        local cursorY = p2FaceY + (p2SelY - p2RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(p2SelX + 1, p2SelY + 1, 2)
        if resetgrid == true then
            start.f_resetGrid()
        end
        main.f_animPosDraw(
                motif.select_info.p2_cursor_active_data,
                cursorX,
                cursorY,
                (motif.select_info['cell_' .. p2SelX + 1 .. '_' .. p2SelY + 1 .. '_facing'] or 1)
        )
        --cell selected
        if start.f_slotSelected(p2Cell + 1, 2, p2SelX, p2SelY) and start.f_selGrid(p2Cell + 1).char ~= nil and start.f_selGrid(p2Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p2_cursor_done_snd[1], motif.select_info.p2_cursor_done_snd[2])
            local selected = start.f_selGrid(p2Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p2_select_snd[1], motif.select_info.p2_select_snd[2])
            table.insert(start.t_p2Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[2])),
                cursor = {cursorX, cursorY, p2RowOffset, (motif.select_info['cell_' .. p2SelX + 1 .. '_' .. p2SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(2)
            })
            t_p2Cursor[p2NumChars - #start.t_p2Selected + 1] = {p2SelX, p2SelY, p2FaceOffset, p2RowOffset}
            if #start.t_p2Selected == p2NumChars then
                p2SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p2_cursor_done_snd[1], motif.select_info.p2_cursor_done_snd[2])
            local selected = start.f_selGrid(p2Cell + 1).char_ref
            local rand = false
            for i = #start.t_p2Selected + 1, p2NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p2_select_snd[1], motif.select_info.p2_select_snd[2])
                end
                rand = true
                table.insert(start.t_p2Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, p2RowOffset, (motif.select_info['cell_' .. p2SelX + 1 .. '_' .. p2SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(2)
                })
                t_p2Cursor[p2NumChars - #start.t_p2Selected + 1] = {p2SelX, p2SelY, p2FaceOffset, p2RowOffset}
            end
            p2SelEnd = true
        end
    end
end


function start4p.f_select4pScreen()
    p1NumChars = 1
    p2NumChars = 1
    p3NumChars = 1
    p4NumChars = 1

    -- Need to set team mode to be able to get proper amount of characters
    -- todo	Dev refactor start.lua
    if gamemode('4pversus') then
        p1TeamMode = 1
        p2TeamMode = 1
        setTeamMode(1, p1TeamMode, p1NumChars + p3NumChars)
        setTeamMode(2, p2TeamMode, p2NumChars + p4NumChars)
    elseif gamemode('4pcoop') then
        p1TeamMode = 1
        p2TeamMode = 1
        setTeamMode(1, p1TeamMode, p1NumChars + p2NumChars + p3NumChars + p4NumChars)
        setTeamMode(2, p2TeamMode, p1NumChars + p2NumChars + p3NumChars + p4NumChars)
    end

    if selScreenEnd then
        return true
    end
    main.f_bgReset(motif.selectbgdef.bg)
    main.f_playBGM(true, motif.music.select_bgm, motif.music.select_bgm_loop, motif.music.select_bgm_volume, motif.music.select_bgm_loopstart, motif.music.select_bgm_loopend)
    local t_enemySelected = {}
    local numChars = p2NumChars
    if main.coop and matchNo > 0 then --coop swap after first match
        t_enemySelected = main.f_tableCopy(start.t_p2Selected)
        start.t_p2Selected = {}
        p2SelEnd = false
    end
    timerSelect = 0
    while not selScreenEnd do
        if esc() or main.f_input(main.t_players, {'m'}) then
            return false
        end
        --draw clearcolor
        clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
        --draw layerno = 0 backgrounds
        bgDraw(motif.selectbgdef.bg, false)
        --draw title
        main.txt_mainSelect:draw()
        if p1Cell then
            --draw p1 portrait
            local t_portrait = {}
            if #start.t_p1Selected < p1NumChars then
                if start.f_selGrid(p1Cell + 1).char == 'randomselect' or start.f_selGrid(p1Cell + 1).hidden == 3 then
                    if p1RandomCount < motif.select_info.cell_random_switchtime then
                        p1RandomCount = p1RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        p1RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        p1RandomCount = 0
                    end
                    t_portrait[1] = p1RandomPortrait
                elseif start.f_selGrid(p1Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(p1Cell + 1).char_ref
                end
            end
            for i = #start.t_p1Selected, 1, -1 do
                if #t_portrait < motif.select_info.p1_face_num then
                    table.insert(t_portrait, start.t_p1Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p1_face_spr[1],
                        motif.select_info.p1_face_spr[2],
                        motif.select_info.p1_face_offset[1] + motif.select_info['p1_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p1_face_spacing[1] + main.f_alignOffset(motif.select_info.p1_face_facing),
                        motif.select_info.p1_face_offset[2] + motif.select_info['p1_c' .. n .. '_face_offset'][2] + (n - 1) * motif.select_info.p1_face_spacing[2],
                        motif.select_info.p1_face_facing * motif.select_info.p1_face_scale[1] * motif.select_info['p1_c' .. n .. '_face_scale'][1],
                        motif.select_info.p1_face_scale[2] * motif.select_info['p1_c' .. n .. '_face_scale'][2],
                        motif.select_info.p1_face_window[1],
                        motif.select_info.p1_face_window[2],
                        motif.select_info.p1_face_window[3],
                        motif.select_info.p1_face_window[4]
                )
            end
        end
        if p2Cell then
            --draw p2 portrait
            local t_portrait = {}
            if #start.t_p2Selected < p2NumChars then
                if start.f_selGrid(p2Cell + 1).char == 'randomselect' or start.f_selGrid(p2Cell + 1).hidden == 3 then
                    if p2RandomCount < motif.select_info.cell_random_switchtime then
                        p2RandomCount = p2RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        p2RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        p2RandomCount = 0
                    end
                    t_portrait[1] = p2RandomPortrait
                elseif start.f_selGrid(p2Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(p2Cell + 1).char_ref
                end
            end
            for i = #start.t_p2Selected, 1, -1 do
                if #t_portrait < motif.select_info.p2_face_num then
                    table.insert(t_portrait, start.t_p2Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p2_face_spr[1],
                        motif.select_info.p2_face_spr[2],
                        motif.select_info.p2_face_offset[1] + motif.select_info['p2_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p2_face_spacing[1] + main.f_alignOffset(motif.select_info.p2_face_facing),
                        motif.select_info.p2_face_offset[2] + motif.select_info['p2_c' .. n .. '_face_offset'][2] + (n - 1) * motif.select_info.p2_face_spacing[2],
                        motif.select_info.p2_face_facing * motif.select_info.p2_face_scale[1] * motif.select_info['p2_c' .. n .. '_face_scale'][1],
                        motif.select_info.p2_face_scale[2] * motif.select_info['p2_c' .. n .. '_face_scale'][2],
                        motif.select_info.p2_face_window[1],
                        motif.select_info.p2_face_window[2],
                        motif.select_info.p2_face_window[3],
                        motif.select_info.p2_face_window[4]
                )
            end
        end
        if p3Cell then
            --draw p3 portrait
            local t_portrait = {}
            if #start.t_p3Selected < p3NumChars then
                if start.f_selGrid(p3Cell + 1).char == 'randomselect' or start.f_selGrid(p3Cell + 1).hidden == 3 then
                    if p3RandomCount < motif.select_info.cell_random_switchtime then
                        p3RandomCount = p3RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        p3RandomCount = 0
                    end
                    t_portrait[1] = p3RandomPortrait
                elseif start.f_selGrid(p3Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(p3Cell + 1).char_ref
                end
            end
            for i = #start.t_p3Selected, 1, -1 do
                if #t_portrait < motif.select_info.p3_face_num then
                    table.insert(t_portrait, start.t_p3Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p3_face_spr[1],
                        motif.select_info.p3_face_spr[2],
                        motif.select_info.p3_face_offset[1] + motif.select_info['p3_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p3_face_spacing[1] + main.f_alignOffset(motif.select_info.p3_face_facing),
                        motif.select_info.p3_face_offset[2] + motif.select_info['p3_c' .. n .. '_face_offset'][2] + (n - 1) * motif.select_info.p3_face_spacing[2],
                        motif.select_info.p3_face_facing * motif.select_info.p3_face_scale[1] * motif.select_info['p3_c' .. n .. '_face_scale'][1],
                        motif.select_info.p3_face_scale[2] * motif.select_info['p3_c' .. n .. '_face_scale'][2],
                        motif.select_info.p3_face_window[1],
                        motif.select_info.p3_face_window[2],
                        motif.select_info.p3_face_window[3],
                        motif.select_info.p3_face_window[4]
                )
            end
        end
        if p4Cell then
            --draw p4 portrait
            local t_portrait = {}
            if #start.t_p4Selected < p4NumChars then
                if start.f_selGrid(p4Cell + 1).char == 'randomselect' or start.f_selGrid(p4Cell + 1).hidden == 3 then
                    if p4RandomCount < motif.select_info.cell_random_switchtime then
                        p4RandomCount = p4RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        p4RandomCount = 0
                    end
                    t_portrait[1] = p4RandomPortrait
                elseif start.f_selGrid(p4Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(p4Cell + 1).char_ref
                end
            end
            for i = #start.t_p4Selected, 1, -1 do
                if #t_portrait < motif.select_info.p4_face_num then
                    table.insert(t_portrait, start.t_p4Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p4_face_spr[1],
                        motif.select_info.p4_face_spr[2],
                        motif.select_info.p4_face_offset[1] + motif.select_info['p4_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p4_face_spacing[1] + main.f_alignOffset(motif.select_info.p4_face_facing),
                        motif.select_info.p4_face_offset[2] + motif.select_info['p4_c' .. n .. '_face_offset'][2] + (n - 1) * motif.select_info.p4_face_spacing[2],
                        motif.select_info.p4_face_facing * motif.select_info.p4_face_scale[1] * motif.select_info['p4_c' .. n .. '_face_scale'][1],
                        motif.select_info.p4_face_scale[2] * motif.select_info['p4_c' .. n .. '_face_scale'][2],
                        motif.select_info.p4_face_window[1],
                        motif.select_info.p4_face_window[2],
                        motif.select_info.p4_face_window[3],
                        motif.select_info.p4_face_window[4]
                )
            end
        end
        --draw cell art
        for i = 1, #start.t_drawFace do
            --P1 side check before drawing
            if start.t_drawFace[i].d <= 2 then
                --draw cell background
                main.f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        start.t_drawFace[i].x1,
                        start.t_drawFace[i].y1,
                        (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if start.t_drawFace[i].d == 1 then
                    main.f_animPosDraw(
                            motif.select_info.cell_random_data,
                            start.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            start.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif start.t_drawFace[i].d == 2 then
                    drawPortraitChar(
                            start.t_drawFace[i].p1,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            start.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            start.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1),
                            motif.select_info.portrait_scale[2]
                    )
                end
            end
            --P2 side check before drawing (double select only)
            if main.p2Faces and motif.select_info.doubleselect_enabled == 1 and start.t_drawFace[i].d >= 10 then
                --draw cell background
                main.f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        start.t_drawFace[i].x2,
                        start.t_drawFace[i].y2,
                        (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if start.t_drawFace[i].d == 11 then
                    main.f_animPosDraw(
                            motif.select_info.cell_random_data,
                            start.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            start.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif start.t_drawFace[i].d == 12 then
                    drawPortraitChar(
                            start.t_drawFace[i].p2,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            start.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            start.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. start.t_drawFace[i].col .. '_' .. start.t_drawFace[i].row .. '_facing'] or 1),
                            motif.select_info.portrait_scale[2]
                    )
                end
            end
        end
        --drawFace(p1FaceX, p1FaceY, p1FaceOffset)
        --if main.p2Faces and motif.select_info.doubleselect_enabled == 1 then
        --	drawFace(p2FaceX, p2FaceY, p2FaceOffset)
        --end
        --draw p1 done cursor
        for i = 1, #start.t_p1Selected do
            if start.t_p1Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p1_cursor_done_data,
                        start.t_p1Selected[i].cursor[1],
                        start.t_p1Selected[i].cursor[2],
                        start.t_p1Selected[i].cursor[4]
                )
            end
        end
        --draw p2 done cursor
        for i = 1, #start.t_p2Selected do
            if start.t_p2Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p2_cursor_done_data,
                        start.t_p2Selected[i].cursor[1],
                        start.t_p2Selected[i].cursor[2],
                        start.t_p2Selected[i].cursor[4]
                )
            end
        end
        --draw p3 done cursor
        for i = 1, #start.t_p3Selected do
            if start.t_p3Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p3_cursor_done_data,
                        start.t_p3Selected[i].cursor[1],
                        start.t_p3Selected[i].cursor[2],
                        start.t_p3Selected[i].cursor[4]
                )
            end
        end
        --draw p4 done cursor
        for i = 1, #start.t_p4Selected do
            if start.t_p4Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p4_cursor_done_data,
                        start.t_p4Selected[i].cursor[1],
                        start.t_p4Selected[i].cursor[2],
                        start.t_p4Selected[i].cursor[4]
                )
            end
        end
        --Player1 team menu
        if not p1TeamEnd then
            start.f_p1TeamMenu()
            --Player1 select
        elseif main.t_pIn[1] > 0 or main.p1Char ~= nil then
            start.f_p1SelectMenu()
        end
        --Player2 team menu
        if not p2TeamEnd then
            start.f_p2TeamMenu()
            --Player2 select
        elseif main.t_pIn[2] > 0 or main.p2Char ~= nil then
            start.f_p2SelectMenu()
        end
        --Player3 team menu
        if not p1TeamEnd then
            start4p.f_p3TeamMenu()
            --Player3 select
        elseif main.t_pIn[3] > 0 or main.p3Char ~= nil then
            start4p.f_p3SelectMenu()
        end
        --Player4 team menu
        if not p2TeamEnd then
            start4p.f_p4TeamMenu()
            --Player4 select
        elseif main.t_pIn[4] > 0 or main.p4Char ~= nil then
            start4p.f_p4SelectMenu()
        end
        if p1Cell then
            --draw p1 name
            local t_name = {}
            for i = 1, #start.t_p1Selected do
                table.insert(t_name, {['ref'] = start.t_p1Selected[i].ref})
            end
            if #start.t_p1Selected < p1NumChars then
                if start.f_selGrid(p1Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(p1Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    txt_p1Name,
                    motif.select_info.p1_name_font,
                    motif.select_info.p1_name_offset[1],
                    motif.select_info.p1_name_offset[2],
                    motif.select_info.p1_name_font_scale[1],
                    motif.select_info.p1_name_font_scale[2],
                    motif.select_info.p1_name_font_height,
                    motif.select_info.p1_name_spacing[1],
                    motif.select_info.p1_name_spacing[2]
            )
        end
        if p2Cell then
            --draw p2 name
            local t_name = {}
            for i = 1, #start.t_p2Selected do
                table.insert(t_name, {['ref'] = start.t_p2Selected[i].ref})
            end
            if #start.t_p2Selected < p2NumChars then
                if start.f_selGrid(p2Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(p2Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    txt_p2Name,
                    motif.select_info.p2_name_font,
                    motif.select_info.p2_name_offset[1],
                    motif.select_info.p2_name_offset[2],
                    motif.select_info.p2_name_font_scale[1],
                    motif.select_info.p2_name_font_scale[2],
                    motif.select_info.p2_name_font_height,
                    motif.select_info.p2_name_spacing[1],
                    motif.select_info.p2_name_spacing[2]
            )
        end
        if p3Cell then
            --draw p3 name
            local t_name = {}
            for i = 1, #start.t_p3Selected do
                table.insert(t_name, {['ref'] = start.t_p3Selected[i].ref})
            end
            if #start.t_p3Selected < p3NumChars then
                if start.f_selGrid(p3Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(p3Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    txt_p3Name,
                    motif.select_info.p3_name_font,
                    motif.select_info.p3_name_offset[1],
                    motif.select_info.p3_name_offset[2],
                    motif.select_info.p3_name_font_scale[1],
                    motif.select_info.p3_name_font_scale[2],
                    motif.select_info.p3_name_font_height,
                    motif.select_info.p3_name_spacing[1],
                    motif.select_info.p3_name_spacing[2]
            )
        end
        if p4Cell then
            --draw p4 name
            local t_name = {}
            for i = 1, #start.t_p4Selected do
                table.insert(t_name, {['ref'] = start.t_p4Selected[i].ref})
            end
            if #start.t_p4Selected < p4NumChars then
                if start.f_selGrid(p4Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(p4Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    txt_p4Name,
                    motif.select_info.p4_name_font,
                    motif.select_info.p4_name_offset[1],
                    motif.select_info.p4_name_offset[2],
                    motif.select_info.p4_name_font_scale[1],
                    motif.select_info.p4_name_font_scale[2],
                    motif.select_info.p4_name_font_height,
                    motif.select_info.p4_name_spacing[1],
                    motif.select_info.p4_name_spacing[2]
            )
        end
        --draw timer
        if motif.select_info.timer_enabled == 1 and p1TeamEnd and (p2TeamEnd or not main.p2SelectMenu) then
            local num = math.floor((motif.select_info.timer_count * motif.select_info.timer_framespercount - timerSelect + motif.select_info.timer_displaytime) / motif.select_info.timer_framespercount + 0.5)
            if num <= -1 then
                timerSelect = -1
                txt_timerSelect:update({text = 0})
            else
                timerSelect = timerSelect + 1
                txt_timerSelect:update({text = math.max(0, num)})
            end
            if timerSelect >= motif.select_info.timer_displaytime then
                txt_timerSelect:draw()
            end
        end
        --draw record text
        for i = 1, #t_recordText do
            txt_recordSelect:update({
                text = t_recordText[i],
                y = motif.select_info.record_offset[2] + main.f_ySpacing(motif.select_info, 'record_font') * (i - 1),
            })
            txt_recordSelect:draw()
        end
        --team and character selection complete
        if p1SelEnd and p2SelEnd and p3SelEnd and p4SelEnd and p1TeamEnd and p2TeamEnd then
            if gamemode("4pversus") then
                -- In versus P3 selection belongs in p1 roster
                -- todo	Dev: Need to refactor this to be more clear
                if #start.t_p1Selected < 2 then
                    print("Inserting P3 character to p1 table for VS")
                    table.insert(start.t_p1Selected, {
                        ref = start.t_p3Selected[1].ref,
                        pal = start.t_p3Selected[1].pal,
                        cursor = start.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })
                end
                -- P4 selections belongs in p2 roster
                if #start.t_p2Selected < 2 then
                    print("Inserting P4 character to p2 table for VS")
                    table.insert(start.t_p2Selected, {
                        ref = start.t_p4Selected[1].ref,
                        pal = start.t_p4Selected[1].pal,
                        cursor = start.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end

            elseif gamemode('4pcoop') then
                -- In coop all selected characters belong to player one roster
                -- todo: Dev: Need to update this to work seperately
                if #start.t_p1Selected < 4 then
                    print("Inserting P2 character to p1 table for coop")
                    table.insert(start.t_p1Selected, {
                        ref = start.t_p2Selected[1].ref,
                        pal = start.t_p2Selected[1].pal,
                        cursor = start.t_p2Selected[1].cursor,
                        ratio = start.f_setRatio(2)
                    })

                    print("Inserting P3 character to p1 table for coop")
                    table.insert(start.t_p1Selected, {
                        ref = start.t_p3Selected[1].ref,
                        pal = start.t_p3Selected[1].pal,
                        cursor = start.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })

                    print("Inserting P4 character to p1 table for coop")
                    table.insert(start.t_p1Selected, {
                        ref = start.t_p4Selected[1].ref,
                        pal = start.t_p4Selected[1].pal,
                        cursor = start.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end
            end

            p1RestoreCursor = true
            p2RestoreCursor = true
            p3RestoreCursor = true
            p4RestoreCursor = true

            if main.stageMenu and not stageEnd then --Stage select
                start.f_stageMenu()
            elseif main.coop and not coopEnd then
                coopEnd = true
                p2TeamEnd = false
            elseif fadeType == 'fadein' then
                main.fadeStart = getFrameCount()
                fadeType = 'fadeout'
            end
        end
        --draw layerno = 1 backgrounds
        bgDraw(motif.selectbgdef.bg, true)
        --draw fadein / fadeout
        main.fadeActive = fadeColor(
                fadeType,
                main.fadeStart,
                motif.select_info[fadeType .. '_time'],
                motif.select_info[fadeType .. '_col'][1],
                motif.select_info[fadeType .. '_col'][2],
                motif.select_info[fadeType .. '_col'][3]
        )
        --frame transition
        if main.fadeActive then
            commandBufReset(main.t_cmd[1])
        elseif fadeType == 'fadeout' then
            commandBufReset(main.t_cmd[1])
            selScreenEnd = true
            break --skip last frame rendering
        else
            main.f_cmdInput()
        end
        main.f_refresh()
    end
    if matchNo == 0 then --team mode set
        if main.coop then --coop swap before first match
            p1NumChars = 4
            start.t_p1Selected[2] = {ref = start.t_p2Selected[1].ref, pal = start.t_p2Selected[1].pal}
            start.t_p1Selected[3] = {ref = start.t_p3Selected[1].ref, pal = start.t_p3Selected[1].pal}
            start.t_p1Selected[4] = {ref = start.t_p4Selected[1].ref, pal = start.t_p4Selected[1].pal}
            start.t_p2Selected = {}
        end
        --setTeamMode(1, start.p1TeamMode, p1NumChars)
        --setTeamMode(2, start.p2TeamMode, p2NumChars)
    elseif main.coop then --coop swap after first match
        p1NumChars = 4
        p2NumChars = numChars
        start.t_p1Selected[2] = {ref = start.t_p2Selected[1].ref, pal = start.t_p2Selected[1].pal}
        start.t_p1Selected[2] = {ref = start.t_p3Selected[1].ref, pal = start.t_p3Selected[1].pal}
        start.t_p1Selected[2] = {ref = start.t_p4Selected[1].ref, pal = start.t_p4Selected[1].pal}
        start.t_p2Selected = t_enemySelected
    end
    return true
end


function start4p.f_select4pSimple()
    start.f_startCell()
    t_p1Cursor = {}
    t_p2Cursor = {}
    t_p3Cursor = {}
    t_p4Cursor = {}
    p1RestoreCursor = false
    p2RestoreCursor = false
    p3RestoreCursor = false
    p4RestoreCursor = false
    p1TeamMenu = 0
    p2TeamMenu = 0
    p3TeamMenu = 0
    p4TeamMenu = 0
    p3TeamEnd = true
    p4TeamEnd = true
    p1FaceOffset = 0
    p2FaceOffset = 0
    p3FaceOffset = 0
    p4FaceOffset = 0
    p1RowOffset = 0
    p2RowOffset = 0
    p3RowOffset = 0
    p4RowOffset = 0
    stageList = 0
    while true do --outer loop (moved back here after pressing ESC)
        start.f_selectReset()
        while true do --inner loop
            fadeType = 'fadein'
            selectStart()
            if not start4p.f_select4pScreen() then
                sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
                main.f_bgReset(motif.titlebgdef.bg)
                main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
                return
            end
            if gamemode('4pcoop') then
                --first match
                if matchNo == 0 then
                    --generate roster
                    t_roster = start.f_makeRoster()
                    lastMatch = #t_roster
                    matchNo = 1
                    --generate AI ramping table
                    start.f_aiRamp(1)
                end
                --assign enemy team
                if #start.t_p2Selected == 0 then
                    local shuffle = true
                    for i = 1, #t_roster[matchNo] do
                        table.insert(start.t_p2Selected, {ref = t_roster[matchNo][i], pal = start.f_selectPal(t_roster[matchNo][i]), ratio = start.f_setRatio(2)})
                        if shuffle then
                            main.f_tableShuffle(start.t_p2Selected)
                        end
                    end
                end
            end
            --fight initialization
            start.f_overrideCharData()
            start.f_remapAI()
            start.f_setRounds()
            stageNo = start.f_setStage(stageNo)
            start.f_setMusic(stageNo)
            if start4p.f_select4pVersus() == nil then break end
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            loadStart()
            winner, t_gameStats = game()
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            if gameend() then
                os.exit()
            end
            start.f_saveData()
            if challenger then
                return
            end
            if winner == -1 then break end --player exit the game via ESC
            start.f_storeSavedData(gamemode(), winner == 1)
            start.f_selectReset()
            --main.f_cmdInput()
            refresh()
        end
        esc(false) --reset ESC
        if gamemode('netplayversus') then
            --resetRemapInput()
            --main.reconnect = winner == -1
        end
        if start.exit then
            main.f_bgReset(motif.titlebgdef.bg)
            main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
            start.exit = false
            break
        end
    end
end


function start4p.f_select4pVersus()
    if not main.versusScreen or not main.t_charparam.vsscreen or (main.t_charparam.rivals and start.f_rivalsMatch('vsscreen', 0)) or main.t_selChars[start.t_p1Selected[1].ref + 1].vsscreen == 0 then
        start.f_selectChar(1, start.t_p1Selected)
        start.f_selectChar(2, start.t_p2Selected)
        return true
    else
        local text = main.f_extractText(motif.vs_screen.match_text, matchNo)
        txt_matchNo:update({text = text[1]})
        main.f_bgReset(motif.versusbgdef.bg)
        main.f_playBGM(true, motif.music.vs_bgm, motif.music.vs_bgm_loop, motif.music.vs_bgm_volume, motif.music.vs_bgm_loopstart, motif.music.vs_bgm_loopend)
        local p1Confirmed = false
        local p2Confirmed = false
        local p1Row = 1
        local p2Row = 1
        local t_tmp = {}
        local t_p1_slide_dist = {0, 0}
        local t_p2_slide_dist = {0, 0}
        local orderTime = 0
        if main.t_pIn[1] == 1 and main.t_pIn[2] == 2 and (#start.t_p1Selected > 1 or #start.t_p2Selected > 1) and not main.coop then
            orderTime = math.max(#start.t_p1Selected, #start.t_p2Selected) - 1 * motif.vs_screen.time_order
            if #start.t_p1Selected == 1 then
                start.f_selectChar(1, start.t_p1Selected)
                p1Confirmed = true
            end
            if #start.t_p2Selected == 1 then
                start.f_selectChar(2, start.t_p2Selected)
                p2Confirmed = true
            end
        elseif #start.t_p1Selected > 1 and not main.coop then
            orderTime = #start.t_p1Selected - 1 * motif.vs_screen.time_order
        else
            start.f_selectChar(1, start.t_p1Selected)
            p1Confirmed = true
            start.f_selectChar(2, start.t_p2Selected)
            p2Confirmed = true
        end
        --main.f_cmdInput()
        main.fadeStart = getFrameCount()
        local counter = 0 - motif.vs_screen.fadein_time
        fadeType = 'fadein'
        while true do
            if counter == motif.vs_screen.stage_time then
                start.f_playWave(stageNo, 'stage', motif.vs_screen.stage_snd[1], motif.vs_screen.stage_snd[2])
            end
            if esc() or main.f_input(main.t_players, {'m'}) then
                --main.f_cmdInput()
                return nil
            elseif p1Confirmed and p2Confirmed then
                if fadeType == 'fadein' and (counter >= motif.vs_screen.time or main.f_input({1}, {'pal', 's'})) then
                    main.fadeStart = getFrameCount()
                    fadeType = 'fadeout'
                end
            elseif counter >= motif.vs_screen.time + orderTime then
                if not p1Confirmed then
                    start.f_selectChar(1, start.t_p1Selected)
                    p1Confirmed = true
                end
                if not p2Confirmed then
                    start.f_selectChar(2, start.t_p2Selected)
                    p2Confirmed = true
                end
            else
                --if Player1 has not confirmed the order yet
                if not p1Confirmed then
                    if main.f_input({1}, {'pal', 's'}) then
                        if not p1Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_done_snd[1], motif.vs_screen.p1_cursor_done_snd[2])
                            start.f_selectChar(1, start.t_p1Selected)
                            p1Confirmed = true
                        end
                        if main.t_pIn[2] ~= 2 then
                            if not p2Confirmed then
                                start.f_selectChar(2, start.t_p2Selected)
                                p2Confirmed = true
                            end
                        end
                    elseif main.f_input({1}, {'$U'}) then
                        if #start.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            if p1Row == 0 then p1Row = #start.t_p1Selected end
                        end
                    elseif main.f_input({1}, {'$D'}) then
                        if #start.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            if p1Row > #start.t_p1Selected then p1Row = 1 end
                        end
                    elseif main.f_input({1}, {'$B'}) then
                        if p1Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            t_tmp = {}
                            t_tmp[p1Row] = start.t_p1Selected[p1Row + 1]
                            for i = 1, #start.t_p1Selected do
                                for j = 1, #start.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row + 1 then
                                        t_tmp[j] = start.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            start.t_p1Selected = t_tmp
                        end
                    elseif main.f_input({1}, {'$F'}) then
                        if p1Row + 1 <= #start.t_p1Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            t_tmp = {}
                            t_tmp[p1Row] = start.t_p1Selected[p1Row - 1]
                            for i = 1, #start.t_p1Selected do
                                for j = 1, #start.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row - 1 then
                                        t_tmp[j] = start.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            start.t_p1Selected = t_tmp
                        end
                    end
                end
                --if Player2 has not confirmed the order yet and is not controlled by Player1
                if not p2Confirmed and main.t_pIn[2] ~= 1 then
                    if main.f_input({2}, {'pal', 's'}) then
                        if not p2Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_done_snd[1], motif.vs_screen.p2_cursor_done_snd[2])
                            start.f_selectChar(2, start.t_p2Selected)
                            p2Confirmed = true
                        end
                    elseif main.f_input({2}, {'$U'}) then
                        if #start.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            if p2Row == 0 then p2Row = #start.t_p2Selected end
                        end
                    elseif main.f_input({2}, {'$D'}) then
                        if #start.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            if p2Row > #start.t_p2Selected then p2Row = 1 end
                        end
                    elseif main.f_input({2}, {'$B'}) then
                        if p2Row + 1 <= #start.t_p2Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            t_tmp = {}
                            t_tmp[p2Row] = start.t_p2Selected[p2Row - 1]
                            for i = 1, #start.t_p2Selected do
                                for j = 1, #start.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row - 1 then
                                        t_tmp[j] = start.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            start.t_p2Selected = t_tmp
                        end
                    elseif main.f_input({2}, {'$F'}) then
                        if p2Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            t_tmp = {}
                            t_tmp[p2Row] = start.t_p2Selected[p2Row + 1]
                            for i = 1, #start.t_p2Selected do
                                for j = 1, #start.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row + 1 then
                                        t_tmp[j] = start.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            start.t_p2Selected = t_tmp
                        end
                    end
                end
            end
            counter = counter + 1
            --draw clearcolor
            clearColor(motif.versusbgdef.bgclearcolor[1], motif.versusbgdef.bgclearcolor[2], motif.versusbgdef.bgclearcolor[3])
            --draw layerno = 0 backgrounds
            bgDraw(motif.versusbgdef.bg, false)
            --draw p1 portraits
            local t_portrait = {}
            for i = 1, #start.t_p1Selected do
                if #t_portrait < motif.vs_screen.p1_num then
                    table.insert(t_portrait, start.t_p1Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for i = #t_portrait, 1, -1 do
                for j = 1, 2 do
                    if t_p1_slide_dist[j] < motif.vs_screen['p1_c' .. i .. '_slide_dist'][j] then
                        t_p1_slide_dist[j] = math.min(t_p1_slide_dist[j] + motif.vs_screen['p1_c' .. i .. '_slide_speed'][j], motif.vs_screen['p1_c' .. i .. '_slide_dist'][j])
                    end
                end
                drawPortraitChar(
                        t_portrait[i],
                        motif.vs_screen.p1_spr[1],
                        motif.vs_screen.p1_spr[2],
                        motif.vs_screen.p1_pos[1] + motif.vs_screen.p1_offset[1] + motif.vs_screen['p1_c' .. i .. '_offset'][1] + (i - 1) * motif.vs_screen.p1_spacing[1] + main.f_alignOffset(motif.vs_screen.p1_facing) + math.floor(t_p1_slide_dist[1] + 0.5),
                        motif.vs_screen.p1_pos[2] + motif.vs_screen.p1_offset[2] + motif.vs_screen['p1_c' .. i .. '_offset'][2] + (i - 1) * motif.vs_screen.p1_spacing[2] +  math.floor(t_p1_slide_dist[2] + 0.5),
                        motif.vs_screen.p1_facing * motif.vs_screen.p1_scale[1] * motif.vs_screen['p1_c' .. i .. '_scale'][1],
                        motif.vs_screen.p1_scale[2] * motif.vs_screen['p1_c' .. i .. '_scale'][2],
                        motif.vs_screen.p1_window[1],
                        motif.vs_screen.p1_window[2],
                        motif.vs_screen.p1_window[3],
                        motif.vs_screen.p1_window[4]
                )
            end
            --draw p2 portraits
            t_portrait = {}
            for i = 1, #start.t_p2Selected do
                if #t_portrait < motif.vs_screen.p2_num then
                    table.insert(t_portrait, start.t_p2Selected[i].ref)
                end
            end
            t_portrait = main.f_tableReverse(t_portrait)
            for i = #t_portrait, 1, -1 do
                for j = 1, 2 do
                    if t_p2_slide_dist[j] < motif.vs_screen['p2_c' .. i .. '_slide_dist'][j] then
                        t_p2_slide_dist[j] = math.min(t_p2_slide_dist[j] + motif.vs_screen['p2_c' .. i .. '_slide_speed'][j], motif.vs_screen['p2_c' .. i .. '_slide_dist'][j])
                    end
                end
                drawPortraitChar(
                        t_portrait[i],
                        motif.vs_screen.p2_spr[1],
                        motif.vs_screen.p2_spr[2],
                        motif.vs_screen.p2_pos[1] + motif.vs_screen.p2_offset[1] + motif.vs_screen['p2_c' .. i .. '_offset'][1] + (i - 1) * motif.vs_screen.p2_spacing[1] + main.f_alignOffset(motif.vs_screen.p2_facing) + math.floor(t_p2_slide_dist[1] + 0.5),
                        motif.vs_screen.p2_pos[2] + motif.vs_screen.p2_offset[2] + motif.vs_screen['p2_c' .. i .. '_offset'][2] + (i - 1) * motif.vs_screen.p2_spacing[2] + math.floor(t_p2_slide_dist[2] + 0.5),
                        motif.vs_screen.p2_facing * motif.vs_screen.p2_scale[1] * motif.vs_screen['p2_c' .. i .. '_scale'][1],
                        motif.vs_screen.p2_scale[2] * motif.vs_screen['p2_c' .. i .. '_scale'][2],
                        motif.vs_screen.p2_window[1],
                        motif.vs_screen.p2_window[2],
                        motif.vs_screen.p2_window[3],
                        motif.vs_screen.p2_window[4]
                )
            end
            --draw names
            start.f_drawName(
                    start.t_p1Selected,
                    txt_p1NameVS,
                    motif.vs_screen.p1_name_font,
                    motif.vs_screen.p1_name_pos[1] + motif.vs_screen.p1_name_offset[1],
                    motif.vs_screen.p1_name_pos[2] + motif.vs_screen.p1_name_offset[2],
                    motif.vs_screen.p1_name_font_scale[1],
                    motif.vs_screen.p1_name_font_scale[2],
                    motif.vs_screen.p1_name_font_height,
                    motif.vs_screen.p1_name_spacing[1],
                    motif.vs_screen.p1_name_spacing[2],
                    motif.vs_screen.p1_name_active_font,
                    p1Row
            )
            start.f_drawName(
                    start.t_p2Selected,
                    txt_p2NameVS,
                    motif.vs_screen.p2_name_font,
                    motif.vs_screen.p2_name_pos[1] + motif.vs_screen.p2_name_offset[1],
                    motif.vs_screen.p2_name_pos[2] + motif.vs_screen.p2_name_offset[2],
                    motif.vs_screen.p2_name_font_scale[1],
                    motif.vs_screen.p2_name_font_scale[2],
                    motif.vs_screen.p2_name_font_height,
                    motif.vs_screen.p2_name_spacing[1],
                    motif.vs_screen.p2_name_spacing[2],
                    motif.vs_screen.p2_name_active_font,
                    p2Row
            )
            --draw match counter
            if matchNo > 0 then
                txt_matchNo:draw()
            end
            --draw layerno = 1 backgrounds
            bgDraw(motif.versusbgdef.bg, true)
            --draw fadein / fadeout
            main.fadeActive = fadeColor(
                    fadeType,
                    main.fadeStart,
                    motif.vs_screen[fadeType .. '_time'],
                    motif.vs_screen[fadeType .. '_col'][1],
                    motif.vs_screen[fadeType .. '_col'][2],
                    motif.vs_screen[fadeType .. '_col'][3]
            )
            --frame transition
            if main.fadeActive then
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
            elseif fadeType == 'fadeout' then
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
                clearColor(motif.versusbgdef.bgclearcolor[1], motif.versusbgdef.bgclearcolor[2], motif.versusbgdef.bgclearcolor[3]) --skip last frame rendering
                break
            else
                main.f_cmdInput()
            end
            main.f_refresh()
        end
        return true
    end
end

--;===========================================================
--; PLAYER 3 SELECT MENU
--;===========================================================
function start4p.f_p3SelectMenu()
    --predefined selection
    if main.p3Char ~= nil then
        local t = {}
        for i = 1, #main.p3Char do
            if t[main.p3Char[i]] == nil then
                t[main.p3Char[i]] = ''
            end
            start.t_p3Selected[i] = {
                ref = main.p3Char[i],
                pal = start.f_selectPal(main.p3Char[i])
            }
        end
        p3SelEnd = true
        return
        --manual selection
    elseif not p3SelEnd then
        resetgrid = false
        --cell movement
        if p3RestoreCursor and t_p3Cursor[p3NumChars - #start.t_p3Selected] ~= nil then --restore saved position
            p3SelX = t_p3Cursor[p3NumChars - #start.t_p3Selected][1]
            p3SelY = t_p3Cursor[p3NumChars - #start.t_p3Selected][2]
            p3FaceOffset = t_p3Cursor[p3NumChars - #start.t_p3Selected][3]
            p3RowOffset = t_p3Cursor[p3NumChars - #start.t_p3Selected][4]
            t_p3Cursor[p3NumChars - #start.t_p3Selected] = nil
        else --calculate current position
            p3SelX, p3SelY, p3FaceOffset, p3RowOffset = start.f_cellMovement(p3SelX, p3SelY, 3, p3FaceOffset, p3RowOffset, motif.select_info.p3_cursor_move_snd)
        end
        p3Cell = p3SelX + motif.select_info.columns * p3SelY
        --draw active cursor
        local cursorX = p3FaceX + p3SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(p3SelX + 1, p3SelY + 1, 1)
        local cursorY = p3FaceY + (p3SelY - p3RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(p3SelX + 1, p3SelY + 1, 2)
        if resetgrid == true then
            start.f_resetGrid()
        end
        if start.f_selGrid(p3Cell + 1).hidden ~= 1 then
            main.f_animPosDraw(
                    motif.select_info.p3_cursor_active_data,
                    cursorX,
                    cursorY,
                    (motif.select_info['cell_' .. p3SelX + 1 .. '_' .. p3SelY + 1 .. '_facing'] or 1)
            )
        end
        --cell selected
        if start.f_slotSelected(p3Cell + 1, 3, p3SelX, p3SelY) and start.f_selGrid(p3Cell + 1).char ~= nil and start.f_selGrid(p3Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(p3Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
            table.insert(start.t_p3Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[3])),
                cursor = {cursorX, cursorY, p3RowOffset, (motif.select_info['cell_' .. p3SelX + 1 .. '_' .. p3SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(1)
            })
            t_p3Cursor[p3NumChars - #start.t_p3Selected + 1] = {p3SelX, p3SelY, p3FaceOffset, p3RowOffset}
            if #start.t_p3Selected == p3NumChars or (#start.t_p3Selected == 1 and main.coop) then --if all characters have been chosen
                if main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                    p2TeamEnd = false
                    p2SelEnd = false
                    --commandBufReset(main.t_cmd[2])
                end
                p3SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(p3Cell + 1).char_ref
            local rand = false
            for i = #start.t_p3Selected + 1, p3NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
                end
                rand = true
                table.insert(start.t_p3Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, p3RowOffset, (motif.select_info['cell_' .. p3SelX + 1 .. '_' .. p3SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(1)
                })
                t_p3Cursor[p3NumChars - #start.t_p3Selected + 1] = {p3SelX, p3SelY, p3FaceOffset, p3RowOffset}
            end
            if main.p2SelectMenu and main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                start.p2TeamMode = start.p3TeamMode
                p2NumChars = p3NumChars
                setTeamMode(2, start.p2TeamMode, p2NumChars)
                p2Cell = p3Cell
                p2SelX = p3SelX
                p2SelY = p3SelY
                p2FaceOffset = p3FaceOffset
                p2RowOffset = p3RowOffset
                for i = 1, p2NumChars do
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                    table.insert(start.t_p2Selected, {
                        ref = selected,
                        pal = start.f_selectPal(selected),
                        cursor = {cursorX, cursorY, p2RowOffset, (motif.select_info['cell_' .. p2SelX + 1 .. '_' .. p2SelY + 1 .. '_facing'] or 1)},
                        ratio = start.f_setRatio(2)
                    })
                    t_p2Cursor[p2NumChars - #start.t_p2Selected + 1] = {p2SelX, p2SelY, p2FaceOffset, p2RowOffset}
                end
            end
            p3SelEnd = true
        end
    end
end

--;===========================================================
--; PLAYER 4 SELECT MENU
--;===========================================================
function start4p.f_p4SelectMenu()
    --predefined selection
    if main.p4Char ~= nil then
        local t = {}
        for i = 1, #main.p4Char do
            if t[main.p4Char[i]] == nil then
                t[main.p4Char[i]] = ''
            end
            start.t_p4Selected[i] = {
                ref = main.p4Char[i],
                pal = start.f_selectPal(main.p4Char[i])
            }
        end
        p4SelEnd = true
        return
        --p4 selection disabled
    elseif not main.p4SelectMenu then
        p4SelEnd = true
        return
        --manual selection
    elseif not p4SelEnd then
        resetgrid = false
        --cell movement
        if p4RestoreCursor and t_p4Cursor[p4NumChars - #start.t_p4Selected] ~= nil then --restore saved position
            p4SelX = t_p4Cursor[p4NumChars - #start.t_p4Selected][1]
            p4SelY = t_p4Cursor[p4NumChars - #start.t_p4Selected][2]
            p4FaceOffset = t_p4Cursor[p4NumChars - #start.t_p4Selected][3]
            p4RowOffset = t_p4Cursor[p4NumChars - #start.t_p4Selected][4]
            t_p4Cursor[p4NumChars - #start.t_p4Selected] = nil
        else --calculate current position
            p4SelX, p4SelY, p4FaceOffset, p4RowOffset = start.f_cellMovement(p4SelX, p4SelY, 4, p4FaceOffset, p4RowOffset, motif.select_info.p4_cursor_move_snd)
        end
        p4Cell = p4SelX + motif.select_info.columns * p4SelY
        --draw active cursor
        local cursorX = p4FaceX + p4SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(p4SelX + 1, p4SelY + 1, 1)
        local cursorY = p4FaceY + (p4SelY - p4RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(p4SelX + 1, p4SelY + 1, 2)
        if resetgrid == true then
            start.f_resetGrid()
        end
        main.f_animPosDraw(
                motif.select_info.p4_cursor_active_data,
                cursorX,
                cursorY,
                (motif.select_info['cell_' .. p4SelX + 1 .. '_' .. p4SelY + 1 .. '_facing'] or 1)
        )
        --cell selected
        if start.f_slotSelected(p4Cell + 1, 4, p4SelX, p4SelY) and start.f_selGrid(p4Cell + 1).char ~= nil and start.f_selGrid(p4Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(p4Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
            table.insert(start.t_p4Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[4])),
                cursor = {cursorX, cursorY, p4RowOffset, (motif.select_info['cell_' .. p4SelX + 1 .. '_' .. p4SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(2)
            })
            t_p4Cursor[p4NumChars - #start.t_p4Selected + 1] = {p4SelX, p4SelY, p4FaceOffset, p4RowOffset}
            if #start.t_p4Selected == p4NumChars then
                p4SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(p4Cell + 1).char_ref
            local rand = false
            for i = #start.t_p4Selected + 1, p4NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
                end
                rand = true
                table.insert(start.t_p4Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, p4RowOffset, (motif.select_info['cell_' .. p4SelX + 1 .. '_' .. p4SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(2)
                })
                t_p4Cursor[p4NumChars - #start.t_p4Selected + 1] = {p4SelX, p4SelY, p4FaceOffset, p4RowOffset}
            end
            p4SelEnd = true
        end
    end
end

return start4p