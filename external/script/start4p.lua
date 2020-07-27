local start = require('external.script.start')
local motif = require('external.script.motif4p')
local startconfig = start.getStartConfig()

startconfig.motif = motif
local start4p = {}

startconfig.p3RowOffset = 0
startconfig.p4RowOffset = 0
startconfig.p3FaceX = 0
startconfig.p3FaceY = 0
startconfig.p4FaceX = 0
startconfig.p4FaceY = 0
startconfig.t_p3Cursor = {}
startconfig.t_p4Cursor = {}
startconfig.p3RestoreCursor = false
startconfig.p4RestoreCursor = false
startconfig.p3TeamMenu = 0
startconfig.p4TeamMenu = 0
startconfig.p3TeamEnd = true
startconfig.p4TeamEnd = true
startconfig.p3SelEnd = false
startconfig.p4SelEnd = false
startconfig.p3FaceOffset = 0
startconfig.p4FaceOffset = 0
startconfig.p3NumChars = 1
startconfig.p4NumChars = 1
startconfig.p3SelX = 0
startconfig.p3SelY = 0
startconfig.p4SelX = 0
startconfig.p4SelY = 0
startconfig.p3Cell = false
startconfig.p4Cell = false
start.p1TeamMode = 1
start.p2TeamMode = 1

startconfig.txt_p3Name = text:create({
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
startconfig.txt_p4Name = text:create({
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

startconfig.p3RandomCount = motif.select_info.cell_random_switchtime
startconfig.p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
startconfig.p4RandomCount = motif.select_info.cell_random_switchtime
startconfig.p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]

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
    elseif startconfig.p1TeamMode == 0 then --Single
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
    elseif startconfig.p1TeamMode == 1 then --Simul
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
        for i = 3, startconfig.p1NumChars * 2 do
            if i % 2 ~= 0 then --odd value
                remapInput(i, 1) --P3/5/7 character uses P1 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif startconfig.p1TeamMode == 2 then --Turns
        for i = 1, startconfig.p1NumChars * 2 do
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
        for i = 1, startconfig.p1NumChars * 2 do
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
    if startconfig.p2TeamMode == 0 then --Single
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
    elseif startconfig.p2TeamMode == 1 then --Simul
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
        for i = 4, startconfig.p2NumChars * 2 do
            if i % 2 == 0 then --even value
                remapInput(i, 2) --P4/6/8 character uses P2 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif startconfig.p2TeamMode == 2 then --Turns
        for i = 2, startconfig.p2NumChars * 2 do
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
        for i = 2, startconfig.p2NumChars * 2 do
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
            if main.t_selChars[startconfig.t_p1Selected[1].ref + 1].ratiomatches ~= nil and main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"] ~= nil then --custom settings exists as char param
                t = main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"]
            else --default settings
                t = main.t_selOptions.arcaderatiomatches
            end
        elseif startconfig.p2TeamMode == 0 then --Single
            if main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.arcademaxmatches, t_static)
            end
        else --Simul / Turns / Tag
            if main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
            end
        end
        --4PCoop
    elseif gameMode('4pcoop') then
        t_static = main.t_orderChars
        if main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
        end
        --Survival
    elseif gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
        t_static = main.t_orderSurvival
        if main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startconfig.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.survivalmaxmatches, t_static)
        end
        --Boss Rush
    elseif gamemode('bossrush') then
        t_static = {main.t_bossChars}
        for i = 1, math.ceil(#main.t_bossChars / startconfig.p2NumChars) do --generate ratiomatches style table
            table.insert(t, {['rmin'] = startconfig.p2NumChars, ['rmax'] = startconfig.p2NumChars, ['order'] = 1})
        end
        --VS 100 Kumite
    elseif gamemode('vs100kumite') then
        t_static = {main.t_randomChars}
        for i = 1, 100 do --generate ratiomatches style table for 100 matches
            table.insert(t, {['rmin'] = startconfig.p2NumChars, ['rmax'] = startconfig.p2NumChars, ['order'] = 1})
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
    startconfig.t_drawFace = {}
    for row = 1, motif.select_info.rows do
        for col = 1, motif.select_info.columns do
            -- Note to anyone editing this function:
            -- The "elseif" chain is important if a "end" is added in the middle it could break the character icon display.

            --1Pのランダムセル表示位置 / 1P random cell display position
            if startconfig.t_grid[row + startconfig.p1RowOffset][col].char == 'randomselect' or startconfig.t_grid[row + startconfig.p1RowOffset][col].hidden == 3 then
                table.insert(startconfig.t_drawFace, {
                    d = 1,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --1Pのキャラ表示位置 / 1P character display position
            elseif startconfig.t_grid[row + startconfig.p1RowOffset][col].char ~= nil and startconfig.t_grid[row + startconfig.p1RowOffset][col].hidden == 0 then
                table.insert(startconfig.t_drawFace, {
                    d = 2,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startconfig.t_drawFace, {
                    d = 0,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --2Pのランダムセル表示位置 / 2P random cell display position
            if startconfig.t_grid[row + startconfig.p2RowOffset][col].char == 'randomselect' or startconfig.t_grid[row + startconfig.p2RowOffset][col].hidden == 3 then
                table.insert(startconfig.t_drawFace, {
                    d = 11,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --2Pのキャラ表示位置 / 2P character display position
            elseif startconfig.t_grid[row + startconfig.p2RowOffset][col].char ~= nil and startconfig.t_grid[row + startconfig.p2RowOffset][col].hidden == 0 then
                table.insert(startconfig.t_drawFace, {
                    d = 12,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startconfig.t_drawFace, {
                    d = 10,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --3P random cell display position
            if startconfig.t_grid[row + startconfig.p3RowOffset][col].char == 'randomselect' or startconfig.t_grid[row + startconfig.p3RowOffset][col].hidden == 3 then
                table.insert(startconfig.t_drawFace, {
                    d = 1,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --3P character display position
            elseif startconfig.t_grid[row + startconfig.p3RowOffset][col].char ~= nil and startconfig.t_grid[row + startconfig.p3RowOffset][col].hidden == 0 then
                table.insert(startconfig.t_drawFace, {
                    d = 2,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startconfig.t_drawFace, {
                    d = 0,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --4P random cell display position
            if startconfig.t_grid[row + startconfig.p4RowOffset][col].char == 'randomselect' or startconfig.t_grid[row + startconfig.p4RowOffset][col].hidden == 3 then
                table.insert(startconfig.t_drawFace, {
                    d = 11,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --4P character display position
            elseif startconfig.t_grid[row + startconfig.p4RowOffset][col].char ~= nil and startconfig.t_grid[row + startconfig.p4RowOffset][col].hidden == 0 then
                table.insert(startconfig.t_drawFace, {
                    d = 12,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startconfig.t_drawFace, {
                    d = 10,
                    p1 = startconfig.t_grid[row + startconfig.p1RowOffset][col].char_ref,
                    p2 = startconfig.t_grid[row + startconfig.p2RowOffset][col].char_ref,
                    p3 = startconfig.t_grid[row + startconfig.p3RowOffset][col].char_ref,
                    p4 = startconfig.t_grid[row + startconfig.p4RowOffset][col].char_ref,
                    x1 = startconfig.p1FaceX + startconfig.t_grid[row][col].x,
                    x2 = startconfig.p2FaceX + startconfig.t_grid[row][col].x,
                    x3 = startconfig.p3FaceX + startconfig.t_grid[row][col].x,
                    x4 = startconfig.p4FaceX + startconfig.t_grid[row][col].x,
                    y1 = startconfig.p1FaceY + startconfig.t_grid[row][col].y,
                    y2 = startconfig.p2FaceY + startconfig.t_grid[row][col].y,
                    y3 = startconfig.p3FaceY + startconfig.t_grid[row][col].y,
                    y4 = startconfig.p4FaceY + startconfig.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end
        end
    end
    --if main.debugLog then main.f_printTable(startconfig.t_drawFace, 'debug/t_drawFace.txt') end
end

-- @override
function start.f_selectPal(ref, palno)
    local t_assignedKeys = {}
    for i = 1, #startconfig.t_p1Selected do
        if startconfig.t_p1Selected[i].ref == ref then
            t_assignedKeys[startconfig.t_p1Selected[i].pal] = ''
        end
    end
    for i = 1, #startconfig.t_p2Selected do
        if startconfig.t_p2Selected[i].ref == ref then
            t_assignedKeys[startconfig.t_p2Selected[i].pal] = ''
        end
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        for i = 1, #startconfig.t_p3Selected do
            if startconfig.t_p3Selected[i].ref == ref then
                t_assignedKeys[startconfig.t_p3Selected[i].pal] = ''
            end
        end
        for i = 1, #startconfig.t_p4Selected do
            if startconfig.t_p4Selected[i].ref == ref then
                t_assignedKeys[startconfig.t_p4Selected[i].pal] = ''
            end
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
        startconfig.p1SelY = motif.select_info.p1_cursor_startcell[1]
    else
        startconfig.p1SelY = 0
    end
    if motif.select_info.p2_cursor_startcell[1] < motif.select_info.rows then
        startconfig.p2SelY = motif.select_info.p2_cursor_startcell[1]
    else
        startconfig.p2SelY = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[1] < motif.select_info.rows then
            startconfig.p3SelY = motif.select_info.p3_cursor_startcell[1]
        else
            startconfig.p3SelY = 0
        end
        if motif.select_info.p4_cursor_startcell[1] < motif.select_info.rows then
            startconfig.p4SelY = motif.select_info.p4_cursor_startcell[1]
        else
            startconfig.p4SelY = 0
        end
    end
    --starting column
    if motif.select_info.p1_cursor_startcell[2] < motif.select_info.columns then
        startconfig.p1SelX = motif.select_info.p1_cursor_startcell[2]
    else
        startconfig.p1SelX = 0
    end
    if motif.select_info.p2_cursor_startcell[2] < motif.select_info.columns then
        startconfig.p2SelX = motif.select_info.p2_cursor_startcell[2]
    else
        startconfig.p2SelX = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[2] < motif.select_info.columns then
            startconfig.p3SelX = motif.select_info.p3_cursor_startcell[2]
        else
            startconfig.p3SelX = 0
        end
        if motif.select_info.p4_cursor_startcell[2] < motif.select_info.columns then
            startconfig.p4SelX = motif.select_info.p4_cursor_startcell[2]
        else
            startconfig.p4SelX = 0
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
            startconfig.t_grid[row][col].char = start.f_selGrid(i).char
            startconfig.t_grid[row][col].char_ref = start.f_selGrid(i).char_ref
            start.f_resetGrid()
        end
        col = col + 1
    end
    if main.p2Faces and motif.select_info.doubleselect_enabled == 1 then
        startconfig.p1FaceX = motif.select_info.pos[1] + motif.select_info.p1_doubleselect_offset[1]
        startconfig.p1FaceY = motif.select_info.pos[2] + motif.select_info.p1_doubleselect_offset[2]
        startconfig.p2FaceX = motif.select_info.pos[1] + motif.select_info.p2_doubleselect_offset[1]
        startconfig.p2FaceY = motif.select_info.pos[2] + motif.select_info.p2_doubleselect_offset[2]
    else
        startconfig.p1FaceX = motif.select_info.pos[1]
        startconfig.p1FaceY = motif.select_info.pos[2]
        startconfig.p2FaceX = motif.select_info.pos[1]
        startconfig.p2FaceY = motif.select_info.pos[2]
        startconfig.p3FaceX = motif.select_info.pos[1]
        startconfig.p3FaceY = motif.select_info.pos[2]
        startconfig.p4FaceX = motif.select_info.pos[1]
        startconfig.p4FaceY = motif.select_info.pos[2]
    end
    start.f_resetGrid()
    if gamemode('netplayversus') or gamemode('netplayteamcoop') or gamemode('netplaysurvivalcoop') then
        startconfig.p1TeamMode = 0
        startconfig.p2TeamMode = 0
        startconfig.stageNo = 0
        startconfig.stageList = 0
    end
    startconfig.p1Cell = nil
    startconfig.p2Cell = nil
    startconfig.p3Cell = nil
    startconfig.p4Cell = nil
    startconfig.t_p1Selected = {}
    startconfig.t_p2Selected = {}
    startconfig.t_p3Selected = {}
    startconfig.t_p4Selected = {}
    startconfig.p1TeamEnd = false
    if gamemode('4pversus') then
        startconfig.p1TeamEnd = true
    end
    startconfig.p1SelEnd = false
    startconfig.p1Ratio = false
    startconfig.p2TeamEnd = false
    if gamemode('4pversus') then
        startconfig.p2TeamEnd = true
    end
    startconfig.p2SelEnd = false
    startconfig.p2Ratio = false
    startconfig.p3TeamEnd = true -- p3 Never has team mode
    startconfig.p3SelEnd = false
    startconfig.p3Ratio = false
    startconfig.p4TeamEnd = true -- p4 Never has team mode
    startconfig.p4SelEnd = false
    startconfig.p4Ratio = false
    if main.t_pIn[2] == 1 then
        startconfig.p2TeamEnd = true
        startconfig.p2SelEnd = true
    elseif main.coop then
        startconfig.p1TeamEnd = true
        startconfig.p2TeamEnd = true
        startconfig.p3TeamEnd = true
        startconfig.p4TeamEnd = true
    end
    if not main.p2SelectMenu and not (gamemode('4pversus') or gamemode('4pcoop')) then
        startconfig.p2SelEnd = true
    end
    startconfig.selScreenEnd = false
    startconfig.stageEnd = false
    startconfig.coopEnd = false
    startconfig.restoreTeam = false
    startconfig.continueData = false
    startconfig.p1NumChars = 1
    startconfig.p2NumChars = 1
    startconfig.p3NumChars = 1
    startconfig.p4NumChars = 1
    startconfig.winner = 0
    startconfig.winCnt = 0
    startconfig.loseCnt = 0
    startconfig.matchNo = 0
    if not challenger then
        startconfig.t_savedData = {
            ['win'] = {0, 0},
            ['lose'] = {0, 0},
            ['time'] = {['total'] = 0, ['matches'] = {}},
            ['score'] = {['total'] = {0, 0}, ['matches'] = {}},
            ['consecutive'] = {0, 0},
        }
    end
    startconfig.t_recordText = start.f_getRecordText()
    setMatchNo(startconfig.matchNo)
    menu.movelistChar = 1
end


function start4p.f_select4pScreen()
    startconfig.p1NumChars = 1
    startconfig.p2NumChars = 1
    startconfig.p3NumChars = 1
    startconfig.p4NumChars = 1

    -- Need to set team mode to be able to get proper amount of characters
    -- todo	Dev refactor start.lua
    if gamemode('4pversus') then
        startconfig.p1TeamMode = 1
        startconfig.p2TeamMode = 1
        setTeamMode(1, startconfig.p1TeamMode, startconfig.p1NumChars + startconfig.p3NumChars)
        setTeamMode(2, startconfig.p2TeamMode, startconfig.p2NumChars + startconfig.p4NumChars)
    elseif gamemode('4pcoop') then
        startconfig.p1TeamMode = 1
        startconfig.p2TeamMode = 1
        setTeamMode(1, startconfig.p1TeamMode, startconfig.p1NumChars + startconfig.p2NumChars + startconfig.p3NumChars + startconfig.p4NumChars)
        setTeamMode(2, startconfig.p2TeamMode, startconfig.p1NumChars + startconfig.p2NumChars + startconfig.p3NumChars + startconfig.p4NumChars)
    end

    if startconfig.selScreenEnd then
        return true
    end
    main.f_bgReset(motif.selectbgdef.bg)
    main.f_playBGM(true, motif.music.select_bgm, motif.music.select_bgm_loop, motif.music.select_bgm_volume, motif.music.select_bgm_loopstart, motif.music.select_bgm_loopend)
    local t_enemySelected = {}
    local numChars = startconfig.p2NumChars
    if main.coop and startconfig.matchNo > 0 then --coop swap after first match
        t_enemySelected = main.f_tableCopy(startconfig.t_p2Selected)
        startconfig.t_p2Selected = {}
        startconfig.p2SelEnd = false
    end
    startconfig.timerSelect = 0
    while not startconfig.selScreenEnd do
        if esc() or main.f_input(main.t_players, {'m'}) then
            return false
        end
        --draw clearcolor
        clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
        --draw layerno = 0 backgrounds
        bgDraw(motif.selectbgdef.bg, false)
        --draw title
        main.txt_mainSelect:draw()
        if startconfig.p1Cell then
            --draw p1 portrait
            local t_portrait = {}
            if #startconfig.t_p1Selected < startconfig.p1NumChars then
                if start.f_selGrid(startconfig.p1Cell + 1).char == 'randomselect' or start.f_selGrid(startconfig.p1Cell + 1).hidden == 3 then
                    if startconfig.p1RandomCount < motif.select_info.cell_random_switchtime then
                        startconfig.p1RandomCount = startconfig.p1RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        startconfig.p1RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startconfig.p1RandomCount = 0
                    end
                    t_portrait[1] = startconfig.p1RandomPortrait
                elseif start.f_selGrid(startconfig.p1Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startconfig.p1Cell + 1).char_ref
                end
            end
            for i = #startconfig.t_p1Selected, 1, -1 do
                if #t_portrait < motif.select_info.p1_face_num then
                    table.insert(t_portrait, startconfig.t_p1Selected[i].ref)
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
        if startconfig.p2Cell then
            --draw p2 portrait
            local t_portrait = {}
            if #startconfig.t_p2Selected < startconfig.p2NumChars then
                if start.f_selGrid(startconfig.p2Cell + 1).char == 'randomselect' or start.f_selGrid(startconfig.p2Cell + 1).hidden == 3 then
                    if startconfig.p2RandomCount < motif.select_info.cell_random_switchtime then
                        startconfig.p2RandomCount = startconfig.p2RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        startconfig.p2RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startconfig.p2RandomCount = 0
                    end
                    t_portrait[1] = startconfig.p2RandomPortrait
                elseif start.f_selGrid(startconfig.p2Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startconfig.p2Cell + 1).char_ref
                end
            end
            for i = #startconfig.t_p2Selected, 1, -1 do
                if #t_portrait < motif.select_info.p2_face_num then
                    table.insert(t_portrait, startconfig.t_p2Selected[i].ref)
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
        if startconfig.p3Cell then
            --draw p3 portrait
            local t_portrait = {}
            if #startconfig.t_p3Selected < startconfig.p3NumChars then
                if start.f_selGrid(startconfig.p3Cell + 1).char == 'randomselect' or start.f_selGrid(startconfig.p3Cell + 1).hidden == 3 then
                    if startconfig.p3RandomCount < motif.select_info.cell_random_switchtime then
                        startconfig.p3RandomCount = startconfig.p3RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        startconfig.p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startconfig.p3RandomCount = 0
                    end
                    t_portrait[1] = startconfig.p3RandomPortrait
                elseif start.f_selGrid(startconfig.p3Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startconfig.p3Cell + 1).char_ref
                end
            end
            for i = #startconfig.t_p3Selected, 1, -1 do
                if #t_portrait < motif.select_info.p3_face_num then
                    table.insert(t_portrait, startconfig.t_p3Selected[i].ref)
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
        if startconfig.p4Cell then
            --draw p4 portrait
            local t_portrait = {}
            if #startconfig.t_p4Selected < startconfig.p4NumChars then
                if start.f_selGrid(startconfig.p4Cell + 1).char == 'randomselect' or start.f_selGrid(startconfig.p4Cell + 1).hidden == 3 then
                    if startconfig.p4RandomCount < motif.select_info.cell_random_switchtime then
                        startconfig.p4RandomCount = startconfig.p4RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        startconfig.p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startconfig.p4RandomCount = 0
                    end
                    t_portrait[1] = startconfig.p4RandomPortrait
                elseif start.f_selGrid(startconfig.p4Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startconfig.p4Cell + 1).char_ref
                end
            end
            for i = #startconfig.t_p4Selected, 1, -1 do
                if #t_portrait < motif.select_info.p4_face_num then
                    table.insert(t_portrait, startconfig.t_p4Selected[i].ref)
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
        for i = 1, #startconfig.t_drawFace do
            --P1 side check before drawing
            if startconfig.t_drawFace[i].d <= 2 then
                --draw cell background
                main.f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        startconfig.t_drawFace[i].x1,
                        startconfig.t_drawFace[i].y1,
                        (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if startconfig.t_drawFace[i].d == 1 then
                    main.f_animPosDraw(
                            motif.select_info.cell_random_data,
                            startconfig.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            startconfig.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif startconfig.t_drawFace[i].d == 2 then
                    drawPortraitChar(
                            startconfig.t_drawFace[i].p1,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            startconfig.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            startconfig.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1),
                            motif.select_info.portrait_scale[2]
                    )
                end
            end
            --P2 side check before drawing (double select only)
            if main.p2Faces and motif.select_info.doubleselect_enabled == 1 and startconfig.t_drawFace[i].d >= 10 then
                --draw cell background
                main.f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        startconfig.t_drawFace[i].x2,
                        startconfig.t_drawFace[i].y2,
                        (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if startconfig.t_drawFace[i].d == 11 then
                    main.f_animPosDraw(
                            motif.select_info.cell_random_data,
                            startconfig.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            startconfig.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif startconfig.t_drawFace[i].d == 12 then
                    drawPortraitChar(
                            startconfig.t_drawFace[i].p2,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            startconfig.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            startconfig.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. startconfig.t_drawFace[i].col .. '_' .. startconfig.t_drawFace[i].row .. '_facing'] or 1),
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
        for i = 1, #startconfig.t_p1Selected do
            if startconfig.t_p1Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p1_cursor_done_data,
                        startconfig.t_p1Selected[i].cursor[1],
                        startconfig.t_p1Selected[i].cursor[2],
                        startconfig.t_p1Selected[i].cursor[4]
                )
            end
        end
        --draw p2 done cursor
        for i = 1, #startconfig.t_p2Selected do
            if startconfig.t_p2Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p2_cursor_done_data,
                        startconfig.t_p2Selected[i].cursor[1],
                        startconfig.t_p2Selected[i].cursor[2],
                        startconfig.t_p2Selected[i].cursor[4]
                )
            end
        end
        --draw p3 done cursor
        for i = 1, #startconfig.t_p3Selected do
            if startconfig.t_p3Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p3_cursor_done_data,
                        startconfig.t_p3Selected[i].cursor[1],
                        startconfig.t_p3Selected[i].cursor[2],
                        startconfig.t_p3Selected[i].cursor[4]
                )
            end
        end
        --draw p4 done cursor
        for i = 1, #startconfig.t_p4Selected do
            if startconfig.t_p4Selected[i].cursor ~= nil then
                main.f_animPosDraw(
                        motif.select_info.p4_cursor_done_data,
                        startconfig.t_p4Selected[i].cursor[1],
                        startconfig.t_p4Selected[i].cursor[2],
                        startconfig.t_p4Selected[i].cursor[4]
                )
            end
        end
        --Player1 team menu
        if not startconfig.p1TeamEnd then
            start.f_p1TeamMenu()
            --Player1 select
        elseif main.t_pIn[1] > 0 or main.p1Char ~= nil then
            start.f_p1SelectMenu()
        end
        --Player2 team menu
        if not startconfig.p2TeamEnd then
            start.f_p2TeamMenu()
            --Player2 select
        elseif main.t_pIn[2] > 0 or main.p2Char ~= nil then
            start.f_p2SelectMenu()
        end
        --Player3 team menu
        if not startconfig.p1TeamEnd then
            start4p.f_p3TeamMenu()
            --Player3 select
        elseif main.t_pIn[3] > 0 or main.p3Char ~= nil then
            start4p.f_p3SelectMenu()
        end
        --Player4 team menu
        if not startconfig.p2TeamEnd then
            start4p.f_p4TeamMenu()
            --Player4 select
        elseif main.t_pIn[4] > 0 or main.p4Char ~= nil then
            start4p.f_p4SelectMenu()
        end
        if startconfig.p1Cell then
            --draw p1 name
            local t_name = {}
            for i = 1, #startconfig.t_p1Selected do
                table.insert(t_name, {['ref'] = startconfig.t_p1Selected[i].ref})
            end
            if #startconfig.t_p1Selected < startconfig.p1NumChars then
                if start.f_selGrid(startconfig.p1Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startconfig.p1Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startconfig.txt_p1Name,
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
        if startconfig.p2Cell then
            --draw p2 name
            local t_name = {}
            for i = 1, #startconfig.t_p2Selected do
                table.insert(t_name, {['ref'] = startconfig.t_p2Selected[i].ref})
            end
            if #startconfig.t_p2Selected < startconfig.p2NumChars then
                if start.f_selGrid(startconfig.p2Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startconfig.p2Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startconfig.txt_p2Name,
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
        if startconfig.p3Cell then
            --draw p3 name
            local t_name = {}
            for i = 1, #startconfig.t_p3Selected do
                table.insert(t_name, {['ref'] = startconfig.t_p3Selected[i].ref})
            end
            if #startconfig.t_p3Selected < startconfig.p3NumChars then
                if start.f_selGrid(startconfig.p3Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startconfig.p3Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startconfig.txt_p3Name,
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
        if startconfig.p4Cell then
            --draw p4 name
            local t_name = {}
            for i = 1, #startconfig.t_p4Selected do
                table.insert(t_name, {['ref'] = startconfig.t_p4Selected[i].ref})
            end
            if #startconfig.t_p4Selected < startconfig.p4NumChars then
                if start.f_selGrid(startconfig.p4Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startconfig.p4Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startconfig.txt_p4Name,
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
        if motif.select_info.timer_enabled == 1 and startconfig.p1TeamEnd and (startconfig.p2TeamEnd or not main.p2SelectMenu) then
            local num = math.floor((motif.select_info.timer_count * motif.select_info.timer_framespercount - startconfig.timerSelect + motif.select_info.timer_displaytime) / motif.select_info.timer_framespercount + 0.5)
            if num <= -1 then
                startconfig.timerSelect = -1
                startconfig.txt_timerSelect:update({text = 0})
            else
                startconfig.timerSelect = startconfig.timerSelect + 1
                startconfig.txt_timerSelect:update({text = math.max(0, num)})
            end
            if startconfig.timerSelect >= motif.select_info.timer_displaytime then
                startconfig.txt_timerSelect:draw()
            end
        end
        --draw record text
        for i = 1, #startconfig.t_recordText do
            startconfig.txt_recordSelect:update({
                text = startconfig.t_recordText[i],
                y = motif.select_info.record_offset[2] + main.f_ySpacing(motif.select_info, 'record_font') * (i - 1),
            })
            startconfig.txt_recordSelect:draw()
        end
        --team and character selection complete
        if startconfig.p1SelEnd and startconfig.p2SelEnd and startconfig.p3SelEnd and startconfig.p4SelEnd and startconfig.p1TeamEnd and startconfig.p2TeamEnd then
            if gamemode("4pversus") then
                -- In versus P3 selection belongs in p1 roster
                -- todo	Dev: Need to refactor this to be more clear
                if #startconfig.t_p1Selected < 2 then
                    print("Inserting P3 character to p1 table for VS")
                    table.insert(startconfig.t_p1Selected, {
                        ref = startconfig.t_p3Selected[1].ref,
                        pal = startconfig.t_p3Selected[1].pal,
                        cursor = startconfig.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })
                end
                -- P4 selections belongs in p2 roster
                if #startconfig.t_p2Selected < 2 then
                    print("Inserting P4 character to p2 table for VS")
                    table.insert(startconfig.t_p2Selected, {
                        ref = startconfig.t_p4Selected[1].ref,
                        pal = startconfig.t_p4Selected[1].pal,
                        cursor = startconfig.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end

            elseif gamemode('4pcoop') then
                -- In coop all selected characters belong to player one roster
                -- todo: Dev: Need to update this to work seperately
                if #startconfig.t_p1Selected < 4 then
                    print("Inserting P2 character to p1 table for coop")
                    table.insert(startconfig.t_p1Selected, {
                        ref = startconfig.t_p2Selected[1].ref,
                        pal = startconfig.t_p2Selected[1].pal,
                        cursor = startconfig.t_p2Selected[1].cursor,
                        ratio = start.f_setRatio(2)
                    })

                    print("Inserting P3 character to p1 table for coop")
                    table.insert(startconfig.t_p1Selected, {
                        ref = startconfig.t_p3Selected[1].ref,
                        pal = startconfig.t_p3Selected[1].pal,
                        cursor = startconfig.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })

                    print("Inserting P4 character to p1 table for coop")
                    table.insert(startconfig.t_p1Selected, {
                        ref = startconfig.t_p4Selected[1].ref,
                        pal = startconfig.t_p4Selected[1].pal,
                        cursor = startconfig.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end
            end

            startconfig.p1RestoreCursor = true
            startconfig.p2RestoreCursor = true
            startconfig.p3RestoreCursor = true
            startconfig.p4RestoreCursor = true

            if main.stageMenu and not startconfig.stageEnd then --Stage select
                start.f_stageMenu()
            elseif main.coop and not startconfig.coopEnd then
                startconfig.coopEnd = true
                startconfig.p2TeamEnd = false
            elseif startconfig.fadeType == 'fadein' then
                main.fadeStart = getFrameCount()
                startconfig.fadeType = 'fadeout'
            end
        end
        --draw layerno = 1 backgrounds
        bgDraw(motif.selectbgdef.bg, true)
        --draw fadein / fadeout
        main.fadeActive = fadeColor(
                startconfig.fadeType,
                main.fadeStart,
                motif.select_info[startconfig.fadeType .. '_time'],
                motif.select_info[startconfig.fadeType .. '_col'][1],
                motif.select_info[startconfig.fadeType .. '_col'][2],
                motif.select_info[startconfig.fadeType .. '_col'][3]
        )
        --frame transition
        if main.fadeActive then
            commandBufReset(main.t_cmd[1])
        elseif startconfig.fadeType == 'fadeout' then
            commandBufReset(main.t_cmd[1])
            startconfig.selScreenEnd = true
            break --skip last frame rendering
        else
            main.f_cmdInput()
        end
        main.f_refresh()
    end
    if startconfig.matchNo == 0 then --team mode set
        if main.coop then --coop swap before first match
            startconfig.p1NumChars = 4
            startconfig.t_p1Selected[2] = {ref = startconfig.t_p2Selected[1].ref, pal = startconfig.t_p2Selected[1].pal}
            startconfig.t_p1Selected[3] = {ref = startconfig.t_p3Selected[1].ref, pal = startconfig.t_p3Selected[1].pal}
            startconfig.t_p1Selected[4] = {ref = startconfig.t_p4Selected[1].ref, pal = startconfig.t_p4Selected[1].pal}
            startconfig.t_p2Selected = {}
        end
        --setTeamMode(1, start.p1TeamMode, p1NumChars)
        --setTeamMode(2, start.p2TeamMode, p2NumChars)
    elseif main.coop then --coop swap after first match
        startconfig.p1NumChars = 4
        startconfig.p2NumChars = numChars
        startconfig.t_p1Selected[2] = {ref = startconfig.t_p2Selected[1].ref, pal = startconfig.t_p2Selected[1].pal}
        startconfig.t_p1Selected[2] = {ref = startconfig.t_p3Selected[1].ref, pal = startconfig.t_p3Selected[1].pal}
        startconfig.t_p1Selected[2] = {ref = startconfig.t_p4Selected[1].ref, pal = startconfig.t_p4Selected[1].pal}
        startconfig.t_p2Selected = t_enemySelected
    end
    return true
end


function start4p.f_select4pSimple()
    start.f_startCell()
    startconfig.t_p1Cursor = {}
    startconfig.t_p2Cursor = {}
    startconfig.t_p3Cursor = {}
    startconfig.t_p4Cursor = {}
    startconfig.p1RestoreCursor = false
    startconfig.p2RestoreCursor = false
    startconfig.p3RestoreCursor = false
    startconfig.p4RestoreCursor = false
    startconfig.p1TeamMenu = 0
    startconfig.p2TeamMenu = 0
    startconfig.p3TeamMenu = 0
    startconfig.p4TeamMenu = 0
    startconfig.p3TeamEnd = true
    startconfig.p4TeamEnd = true
    startconfig.p1FaceOffset = 0
    startconfig.p2FaceOffset = 0
    startconfig.p3FaceOffset = 0
    startconfig.p4FaceOffset = 0
    startconfig.p1RowOffset = 0
    startconfig.p2RowOffset = 0
    startconfig.p3RowOffset = 0
    startconfig.p4RowOffset = 0
    startconfig.stageList = 0
    while true do --outer loop (moved back here after pressing ESC)
        start.f_selectReset()
        while true do --inner loop
            startconfig.fadeType = 'fadein'
            selectStart()
            if not start4p.f_select4pScreen() then
                sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
                main.f_bgReset(motif.titlebgdef.bg)
                main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
                return
            end
            if gamemode('4pcoop') then
                --first match
                if startconfig.matchNo == 0 then
                    --generate roster
                    startconfig.t_roster = start.f_makeRoster()
                    startconfig.lastMatch = #startconfig.t_roster
                    startconfig.matchNo = 1
                    --generate AI ramping table
                    start.f_aiRamp(1)
                end
                --assign enemy team
                if #startconfig.t_p2Selected == 0 then
                    local shuffle = true
                    for i = 1, #startconfig.t_roster[startconfig.matchNo] do
                        table.insert(startconfig.t_p2Selected, {ref = startconfig.t_roster[startconfig.matchNo][i], pal = start.f_selectPal(startconfig.t_roster[startconfig.matchNo][i]), ratio = start.f_setRatio(2)})
                        if shuffle then
                            main.f_tableShuffle(startconfig.t_p2Selected)
                        end
                    end
                end
            end
            --fight initialization
            start.f_overrideCharData()
            start.f_remapAI()
            start.f_setRounds()
            startconfig.stageNo = start.f_setStage(startconfig.stageNo)
            start.f_setMusic(startconfig.stageNo)
            if start4p.f_select4pVersus() == nil then break end
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            loadStart()
            startconfig.winner, startconfig.t_gameStats = game()
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            if gameend() then
                os.exit()
            end
            start.f_saveData()
            if startconfig.challenger then
                return
            end
            if startconfig.winner == -1 then break end --player exit the game via ESC
            start.f_storeSavedData(gamemode(), startconfig.winner == 1)
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
    if not main.versusScreen or not main.t_charparam.vsscreen or (main.t_charparam.rivals and start.f_rivalsMatch('vsscreen', 0)) or main.t_selChars[startconfig.t_p1Selected[1].ref + 1].vsscreen == 0 then
        start.f_selectChar(1, startconfig.t_p1Selected)
        start.f_selectChar(2, startconfig.t_p2Selected)
        return true
    else
        local text = main.f_extractText(motif.vs_screen.match_text, matchNo)
        startconfig.txt_matchNo:update({text = text[1]})
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
        if main.t_pIn[1] == 1 and main.t_pIn[2] == 2 and (#startconfig.t_p1Selected > 1 or #startconfig.t_p2Selected > 1) and not main.coop then
            orderTime = math.max(#startconfig.t_p1Selected, #startconfig.t_p2Selected) - 1 * motif.vs_screen.time_order
            if #startconfig.t_p1Selected == 1 then
                start.f_selectChar(1, startconfig.t_p1Selected)
                p1Confirmed = true
            end
            if #startconfig.t_p2Selected == 1 then
                start.f_selectChar(2, startconfig.t_p2Selected)
                p2Confirmed = true
            end
        elseif #startconfig.t_p1Selected > 1 and not main.coop then
            orderTime = #startconfig.t_p1Selected - 1 * motif.vs_screen.time_order
        else
            start.f_selectChar(1, startconfig.t_p1Selected)
            p1Confirmed = true
            start.f_selectChar(2, startconfig.t_p2Selected)
            p2Confirmed = true
        end
        --main.f_cmdInput()
        main.fadeStart = getFrameCount()
        local counter = 0 - motif.vs_screen.fadein_time
        startconfig.fadeType = 'fadein'
        while true do
            if counter == motif.vs_screen.stage_time then
                start.f_playWave(startconfig.stageNo, 'stage', motif.vs_screen.stage_snd[1], motif.vs_screen.stage_snd[2])
            end
            if esc() or main.f_input(main.t_players, {'m'}) then
                --main.f_cmdInput()
                return nil
            elseif p1Confirmed and p2Confirmed then
                if startconfig.fadeType == 'fadein' and (counter >= motif.vs_screen.time or main.f_input({1}, {'pal', 's'})) then
                    main.fadeStart = getFrameCount()
                    startconfig.fadeType = 'fadeout'
                end
            elseif counter >= motif.vs_screen.time + orderTime then
                if not p1Confirmed then
                    start.f_selectChar(1, startconfig.t_p1Selected)
                    p1Confirmed = true
                end
                if not p2Confirmed then
                    start.f_selectChar(2, startconfig.t_p2Selected)
                    p2Confirmed = true
                end
            else
                --if Player1 has not confirmed the order yet
                if not p1Confirmed then
                    if main.f_input({1}, {'pal', 's'}) then
                        if not p1Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_done_snd[1], motif.vs_screen.p1_cursor_done_snd[2])
                            start.f_selectChar(1, startconfig.t_p1Selected)
                            p1Confirmed = true
                        end
                        if main.t_pIn[2] ~= 2 then
                            if not p2Confirmed then
                                start.f_selectChar(2, startconfig.t_p2Selected)
                                p2Confirmed = true
                            end
                        end
                    elseif main.f_input({1}, {'$U'}) then
                        if #startconfig.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            if p1Row == 0 then p1Row = #startconfig.t_p1Selected end
                        end
                    elseif main.f_input({1}, {'$D'}) then
                        if #startconfig.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            if p1Row > #startconfig.t_p1Selected then p1Row = 1 end
                        end
                    elseif main.f_input({1}, {'$B'}) then
                        if p1Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            t_tmp = {}
                            t_tmp[p1Row] = startconfig.t_p1Selected[p1Row + 1]
                            for i = 1, #startconfig.t_p1Selected do
                                for j = 1, #startconfig.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row + 1 then
                                        t_tmp[j] = startconfig.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            startconfig.t_p1Selected = t_tmp
                        end
                    elseif main.f_input({1}, {'$F'}) then
                        if p1Row + 1 <= #startconfig.t_p1Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            t_tmp = {}
                            t_tmp[p1Row] = startconfig.t_p1Selected[p1Row - 1]
                            for i = 1, #startconfig.t_p1Selected do
                                for j = 1, #startconfig.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row - 1 then
                                        t_tmp[j] = startconfig.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            startconfig.t_p1Selected = t_tmp
                        end
                    end
                end
                --if Player2 has not confirmed the order yet and is not controlled by Player1
                if not p2Confirmed and main.t_pIn[2] ~= 1 then
                    if main.f_input({2}, {'pal', 's'}) then
                        if not p2Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_done_snd[1], motif.vs_screen.p2_cursor_done_snd[2])
                            start.f_selectChar(2, startconfig.t_p2Selected)
                            p2Confirmed = true
                        end
                    elseif main.f_input({2}, {'$U'}) then
                        if #startconfig.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            if p2Row == 0 then p2Row = #startconfig.t_p2Selected end
                        end
                    elseif main.f_input({2}, {'$D'}) then
                        if #startconfig.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            if p2Row > #startconfig.t_p2Selected then p2Row = 1 end
                        end
                    elseif main.f_input({2}, {'$B'}) then
                        if p2Row + 1 <= #startconfig.t_p2Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            t_tmp = {}
                            t_tmp[p2Row] = startconfig.t_p2Selected[p2Row - 1]
                            for i = 1, #startconfig.t_p2Selected do
                                for j = 1, #startconfig.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row - 1 then
                                        t_tmp[j] = startconfig.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            startconfig.t_p2Selected = t_tmp
                        end
                    elseif main.f_input({2}, {'$F'}) then
                        if p2Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            t_tmp = {}
                            t_tmp[p2Row] = startconfig.t_p2Selected[p2Row + 1]
                            for i = 1, #startconfig.t_p2Selected do
                                for j = 1, #startconfig.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row + 1 then
                                        t_tmp[j] = startconfig.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            startconfig.t_p2Selected = t_tmp
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
            for i = 1, #startconfig.t_p1Selected do
                if #t_portrait < motif.vs_screen.p1_num then
                    table.insert(t_portrait, startconfig.t_p1Selected[i].ref)
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
            for i = 1, #startconfig.t_p2Selected do
                if #t_portrait < motif.vs_screen.p2_num then
                    table.insert(t_portrait, startconfig.t_p2Selected[i].ref)
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
                    startconfig.t_p1Selected,
                    startconfig.txt_p1NameVS,
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
                    startconfig.t_p2Selected,
                    startconfig.txt_p2NameVS,
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
            if startconfig.matchNo > 0 then
                startconfig.txt_matchNo:draw()
            end
            --draw layerno = 1 backgrounds
            bgDraw(motif.versusbgdef.bg, true)
            --draw fadein / fadeout
            main.fadeActive = fadeColor(
                    startconfig.fadeType,
                    main.fadeStart,
                    motif.vs_screen[startconfig.fadeType .. '_time'],
                    motif.vs_screen[startconfig.fadeType .. '_col'][1],
                    motif.vs_screen[startconfig.fadeType .. '_col'][2],
                    motif.vs_screen[startconfig.fadeType .. '_col'][3]
            )
            --frame transition
            if main.fadeActive then
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
            elseif startconfig.fadeType == 'fadeout' then
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
            startconfig.t_p3Selected[i] = {
                ref = main.p3Char[i],
                pal = start.f_selectPal(main.p3Char[i])
            }
        end
        startconfig.p3SelEnd = true
        return
        --manual selection
    elseif not startconfig.p3SelEnd then
        resetgrid = false
        --cell movement
        if startconfig.p3RestoreCursor and startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected] ~= nil then --restore saved position
            startconfig.p3SelX = startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected][1]
            startconfig.p3SelY = startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected][2]
            startconfig.p3FaceOffset = startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected][3]
            startconfig.p3RowOffset = startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected][4]
            startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected] = nil
        else --calculate current position
            startconfig.p3SelX, startconfig.p3SelY, startconfig.p3FaceOffset, startconfig.p3RowOffset = start.f_cellMovement(startconfig.p3SelX, startconfig.p3SelY, 3, startconfig.p3FaceOffset, startconfig.p3RowOffset, motif.select_info.p3_cursor_move_snd)
        end
        startconfig.p3Cell = startconfig.p3SelX + motif.select_info.columns * startconfig.p3SelY
        --draw active cursor
        local cursorX = startconfig.p3FaceX + startconfig.p3SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startconfig.p3SelX + 1, startconfig.p3SelY + 1, 1)
        local cursorY = startconfig.p3FaceY + (startconfig.p3SelY - startconfig.p3RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startconfig.p3SelX + 1, startconfig.p3SelY + 1, 2)
        if startconfig.resetgrid == true then
            start.f_resetGrid()
        end
        if start.f_selGrid(startconfig.p3Cell + 1).hidden ~= 1 then
            main.f_animPosDraw(
                    motif.select_info.p3_cursor_active_data,
                    cursorX,
                    cursorY,
                    (motif.select_info['cell_' .. startconfig.p3SelX + 1 .. '_' .. startconfig.p3SelY + 1 .. '_facing'] or 1)
            )
        end
        --cell selected
        if start.f_slotSelected(startconfig.p3Cell + 1, 3, startconfig.p3SelX, startconfig.p3SelY) and start.f_selGrid(startconfig.p3Cell + 1).char ~= nil and start.f_selGrid(startconfig.p3Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(startconfig.p3Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
            table.insert(startconfig.t_p3Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[3])),
                cursor = {cursorX, cursorY, startconfig.p3RowOffset, (motif.select_info['cell_' .. startconfig.p3SelX + 1 .. '_' .. startconfig.p3SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(1)
            })
            startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected + 1] = {startconfig.p3SelX, startconfig.p3SelY, startconfig.p3FaceOffset, startconfig.p3RowOffset}
            if #startconfig.t_p3Selected == startconfig.p3NumChars or (#startconfig.t_p3Selected == 1 and main.coop) then --if all characters have been chosen
                if main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                    startconfig.p2TeamEnd = false
                    startconfig.p2SelEnd = false
                    --commandBufReset(main.t_cmd[2])
                end
                startconfig.p3SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(startconfig.p3Cell + 1).char_ref
            local rand = false
            for i = #startconfig.t_p3Selected + 1, startconfig.p3NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
                end
                rand = true
                table.insert(startconfig.t_p3Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, startconfig.p3RowOffset, (motif.select_info['cell_' .. startconfig.p3SelX + 1 .. '_' .. startconfig.p3SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(1)
                })
                startconfig.t_p3Cursor[startconfig.p3NumChars - #startconfig.t_p3Selected + 1] = {startconfig.p3SelX, startconfig.p3SelY, startconfig.p3FaceOffset, startconfig.p3RowOffset}
            end
            if main.p2SelectMenu and main.t_pIn[2] == 1 and matchNo == 0 then --if player1 is allowed to select p2 characters
                start.p2TeamMode = start.p3TeamMode
                startconfig.p2NumChars = startconfig.p3NumChars
                setTeamMode(2, startconfig.p2TeamMode, startconfig.p2NumChars)
                startconfig.p2Cell = startconfig.p3Cell
                startconfig.p2SelX = startconfig.p3SelX
                startconfig.p2SelY = startconfig.p3SelY
                startconfig.p2FaceOffset = startconfig.p3FaceOffset
                startconfig.p2RowOffset = startconfig.p3RowOffset
                for i = 1, startconfig.p2NumChars do
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                    table.insert(startconfig.t_p2Selected, {
                        ref = selected,
                        pal = start.f_selectPal(selected),
                        cursor = {cursorX, cursorY, startconfig.p2RowOffset, (motif.select_info['cell_' .. startconfig.p2SelX + 1 .. '_' .. startconfig.p2SelY + 1 .. '_facing'] or 1)},
                        ratio = start.f_setRatio(2)
                    })
                    startconfig.t_p2Cursor[startconfig.p2NumChars - #startconfig.t_p2Selected + 1] = {startconfig.p2SelX, startconfig.p2SelY, startconfig.p2FaceOffset, startconfig.p2RowOffset}
                end
            end
            startconfig.p3SelEnd = true
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
            startconfig.t_p4Selected[i] = {
                ref = main.p4Char[i],
                pal = start.f_selectPal(main.p4Char[i])
            }
        end
        startconfig.p4SelEnd = true
        return
        --p4 selection disabled
    elseif not main.p4SelectMenu then
        startconfig.p4SelEnd = true
        return
        --manual selection
    elseif not startconfig.p4SelEnd then
        startconfig.resetgrid = false
        --cell movement
        if startconfig.p4RestoreCursor and startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected] ~= nil then --restore saved position
            startconfig.p4SelX = startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected][1]
            startconfig.p4SelY = startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected][2]
            startconfig.p4FaceOffset = startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected][3]
            startconfig.p4RowOffset = startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected][4]
            startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected] = nil
        else --calculate current position
            startconfig.p4SelX, startconfig.p4SelY, startconfig.p4FaceOffset, startconfig.p4RowOffset = start.f_cellMovement(startconfig.p4SelX, startconfig.p4SelY, 4, startconfig.p4FaceOffset, startconfig.p4RowOffset, motif.select_info.p4_cursor_move_snd)
        end
        startconfig.p4Cell = startconfig.p4SelX + motif.select_info.columns * startconfig.p4SelY
        --draw active cursor
        local cursorX = startconfig.p4FaceX + startconfig.p4SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startconfig.p4SelX + 1, startconfig.p4SelY + 1, 1)
        local cursorY = startconfig.p4FaceY + (startconfig.p4SelY - startconfig.p4RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startconfig.p4SelX + 1, startconfig.p4SelY + 1, 2)
        if startconfig.resetgrid == true then
            start.f_resetGrid()
        end
        main.f_animPosDraw(
                motif.select_info.p4_cursor_active_data,
                cursorX,
                cursorY,
                (motif.select_info['cell_' .. startconfig.p4SelX + 1 .. '_' .. startconfig.p4SelY + 1 .. '_facing'] or 1)
        )
        --cell selected
        if start.f_slotSelected(startconfig.p4Cell + 1, 4, startconfig.p4SelX, startconfig.p4SelY) and start.f_selGrid(startconfig.p4Cell + 1).char ~= nil and start.f_selGrid(startconfig.p4Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(startconfig.p4Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
            table.insert(startconfig.t_p4Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[4])),
                cursor = {cursorX, cursorY, startconfig.p4RowOffset, (motif.select_info['cell_' .. startconfig.p4SelX + 1 .. '_' .. startconfig.p4SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(2)
            })
            startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected + 1] = {startconfig.p4SelX, startconfig.p4SelY, startconfig.p4FaceOffset, startconfig.p4RowOffset}
            if #startconfig.t_p4Selected == startconfig.p4NumChars then
               startconfig.p4SelEnd = true
            end
            main.f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and startconfig.timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(startconfig.p4Cell + 1).char_ref
            local rand = false
            for i = #startconfig.t_p4Selected + 1, startconfig.p4NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
                end
                rand = true
                table.insert(startconfig.t_p4Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, startconfig.p4RowOffset, (motif.select_info['cell_' .. startconfig.p4SelX + 1 .. '_' .. startconfig.p4SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(2)
                })
                startconfig.t_p4Cursor[startconfig.p4NumChars - #startconfig.t_p4Selected + 1] = {startconfig.p4SelX, startconfig.p4SelY, startconfig.p4FaceOffset, startconfig.p4RowOffset}
            end
            startconfig.p4SelEnd = true
        end
    end
end


return start4p