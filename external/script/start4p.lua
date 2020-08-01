local start = require('external.script.start')
local motif = require('external.script.motif4p')
local startdata = start.getStartData()
local start4p = {}

startdata.motif = motif
startdata.p3RowOffset = 0
startdata.p4RowOffset = 0
startdata.p3FaceX = 0
startdata.p3FaceY = 0
startdata.p4FaceX = 0
startdata.p4FaceY = 0
startdata.t_p3Cursor = {}
startdata.t_p4Cursor = {}
startdata.p3RestoreCursor = false
startdata.p4RestoreCursor = false
startdata.p3TeamMenu = 0
startdata.p4TeamMenu = 0
startdata.p3TeamEnd = true
startdata.p4TeamEnd = true
startdata.p3SelEnd = false
startdata.p4SelEnd = false
startdata.p3FaceOffset = 0
startdata.p4FaceOffset = 0
startdata.p3NumChars = 1
startdata.p4NumChars = 1
startdata.p3SelX = 0
startdata.p3SelY = 0
startdata.p4SelX = 0
startdata.p4SelY = 0
startdata.p3Cell = false
startdata.p4Cell = false
startdata.p1TeamMode = 1
startdata.p2TeamMode = 1

startdata.txt_p3Name = text:create({
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
startdata.txt_p4Name = text:create({
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

startdata.p3RandomCount = motif.select_info.cell_random_switchtime
startdata.p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
startdata.p4RandomCount = motif.select_info.cell_random_switchtime
startdata.p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]

-- @override assigns AI level
function start.f_remapAI()
    --Offset
    local offset = 0
    if config.AIRamping and (gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') or gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop')) then
        offset = startdata.t_aiRamp[startdata.matchNo] - config.Difficulty
    end
    --Player 1
    if main.coop then
        remapInput(3, 2) --P3 character uses P2 controls
        setCom(1, 0)
        setCom(3, 0)
    elseif startdata.p1TeamMode == 0 then --Single
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
    elseif startdata.p1TeamMode == 1 then --Simul
        if main.t_pIn[1] == 1 and not main.aiFight then
            setCom(1, 0)
        else
            setCom(1, start.f_difficulty(1, offset))
        end
        for i = 3, startdata.p1NumChars * 2 do
            if i % 2 ~= 0 then --odd value
                remapInput(i, 1) --P3/5/7 character uses P1 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif startdata.p1TeamMode == 2 then --Turns
        for i = 1, startdata.p1NumChars * 2 do
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
        for i = 1, startdata.p1NumChars * 2 do
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
    if startdata.p2TeamMode == 0 then --Single
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
    elseif startdata.p2TeamMode == 1 then --Simul
        if main.t_pIn[2] == 2 and not main.aiFight and not main.coop then
            setCom(2, 0)
        else
            setCom(2, start.f_difficulty(2, offset))
        end
        for i = 4, startdata.p2NumChars * 2 do
            if i % 2 == 0 then --even value
                remapInput(i, 2) --P4/6/8 character uses P2 controls
                setCom(i, start.f_difficulty(i, offset))
            end
        end
    elseif startdata.p2TeamMode == 2 then --Turns
        for i = 2, startdata.p2NumChars * 2 do
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
        for i = 2, startdata.p2NumChars * 2 do
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
            if main.t_selChars[startdata.t_p1Selected[1].ref + 1].ratiomatches ~= nil and main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"] ~= nil then --custom settings exists as char param
                t = main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].ratiomatches .. "_arcaderatiomatches"]
            else --default settings
                t = main.t_selOptions.arcaderatiomatches
            end
        elseif startdata.p2TeamMode == 0 then --Single
            if main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_arcademaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.arcademaxmatches, t_static)
            end
        else --Simul / Turns / Tag
            if main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
                t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
            else --default settings
                t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
            end
        end
        --4PCoop
    elseif gamemode('4pcoop') then
        t_static = main.t_orderChars
        if main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_teammaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.teammaxmatches, t_static)
        end
        --Survival
    elseif gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
        t_static = main.t_orderSurvival
        if main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches ~= nil and main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"] ~= nil then --custom settings exists as char param
            t = start.f_unifySettings(main.t_selOptions[main.t_selChars[startdata.t_p1Selected[1].ref + 1].maxmatches .. "_survivalmaxmatches"], t_static)
        else --default settings
            t = start.f_unifySettings(main.t_selOptions.survivalmaxmatches, t_static)
        end
        --Boss Rush
    elseif gamemode('bossrush') then
        t_static = {main.t_bossChars}
        for i = 1, math.ceil(#main.t_bossChars / startdata.p2NumChars) do --generate ratiomatches style table
            table.insert(t, {['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = 1})
        end
        --VS 100 Kumite
    elseif gamemode('vs100kumite') then
        t_static = {main.t_randomChars}
        for i = 1, 100 do --generate ratiomatches style table for 100 matches
            table.insert(t, {['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = 1})
        end
    else
        panicError('LUA ERROR: ' .. gamemode() .. ' game mode unrecognized by start.f_makeRoster()')
    end
    --generate roster
    t_removable = main:f_tableCopy(t_static) --copy into editable order table
    for i = 1, #t do --for each match number
        if t[i].order == -1 then --infinite matches for this order detected
            table.insert(t_ret, {-1}) --append infinite matches flag at the end
            break
        end
        if t_removable[t[i].order] ~= nil then
            if #t_removable[t[i].order] == 0 and gamemode('vs100kumite') then
                t_removable = main:f_tableCopy(t_static) --ensure that there will be at least 100 matches in VS 100 Kumite mode
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
    if main.debugLog then main:f_printTable(t_ret, 'debug/t_roster.txt') end
    return t_ret
end

-- @override generates table with cell coordinates
function start.f_resetGrid()
    startdata.t_drawFace = {}
    for row = 1, motif.select_info.rows do
        for col = 1, motif.select_info.columns do
            -- Note to anyone editing this function:
            -- The "elseif" chain is important if a "end" is added in the middle it could break the character icon display.

            --1Pのランダムセル表示位置 / 1P random cell display position
            if startdata.t_grid[row + startdata.p1RowOffset][col].char == 'randomselect' or startdata.t_grid[row + startdata.p1RowOffset][col].hidden == 3 then
                table.insert(startdata.t_drawFace, {
                    d = 1,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --1Pのキャラ表示位置 / 1P character display position
            elseif startdata.t_grid[row + startdata.p1RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p1RowOffset][col].hidden == 0 then
                table.insert(startdata.t_drawFace, {
                    d = 2,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startdata.t_drawFace, {
                    d = 0,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --2Pのランダムセル表示位置 / 2P random cell display position
            if startdata.t_grid[row + startdata.p2RowOffset][col].char == 'randomselect' or startdata.t_grid[row + startdata.p2RowOffset][col].hidden == 3 then
                table.insert(startdata.t_drawFace, {
                    d = 11,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --2Pのキャラ表示位置 / 2P character display position
            elseif startdata.t_grid[row + startdata.p2RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p2RowOffset][col].hidden == 0 then
                table.insert(startdata.t_drawFace, {
                    d = 12,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startdata.t_drawFace, {
                    d = 10,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --3P random cell display position
            if startdata.t_grid[row + startdata.p3RowOffset][col].char == 'randomselect' or startdata.t_grid[row + startdata.p3RowOffset][col].hidden == 3 then
                table.insert(startdata.t_drawFace, {
                    d = 1,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --3P character display position
            elseif startdata.t_grid[row + startdata.p3RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p3RowOffset][col].hidden == 0 then
                table.insert(startdata.t_drawFace, {
                    d = 2,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startdata.t_drawFace, {
                    d = 0,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end

            --4P random cell display position
            if startdata.t_grid[row + startdata.p4RowOffset][col].char == 'randomselect' or startdata.t_grid[row + startdata.p4RowOffset][col].hidden == 3 then
                table.insert(startdata.t_drawFace, {
                    d = 11,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --4P character display position
            elseif startdata.t_grid[row + startdata.p4RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p4RowOffset][col].hidden == 0 then
                table.insert(startdata.t_drawFace, {
                    d = 12,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
                --Empty boxes display position
            elseif motif.select_info.showemptyboxes == 1 then
                table.insert(startdata.t_drawFace, {
                    d = 10,
                    p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
                    p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
                    p3 = startdata.t_grid[row + startdata.p3RowOffset][col].char_ref,
                    p4 = startdata.t_grid[row + startdata.p4RowOffset][col].char_ref,
                    x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
                    x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
                    x3 = startdata.p3FaceX + startdata.t_grid[row][col].x,
                    x4 = startdata.p4FaceX + startdata.t_grid[row][col].x,
                    y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
                    y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
                    y3 = startdata.p3FaceY + startdata.t_grid[row][col].y,
                    y4 = startdata.p4FaceY + startdata.t_grid[row][col].y,
                    row = row,
                    col = col
                })
            end
        end
    end
    --if main.debugLog then main:f_printTable(startdata.t_drawFace, 'debug/t_drawFace.txt') end
end

-- @override
function start.f_selectPal(ref, palno)
    local t_assignedKeys = {}
    for i = 1, #startdata.t_p1Selected do
        if startdata.t_p1Selected[i].ref == ref then
            t_assignedKeys[startdata.t_p1Selected[i].pal] = ''
        end
    end
    for i = 1, #startdata.t_p2Selected do
        if startdata.t_p2Selected[i].ref == ref then
            t_assignedKeys[startdata.t_p2Selected[i].pal] = ''
        end
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        for i = 1, #startdata.t_p3Selected do
            if startdata.t_p3Selected[i].ref == ref then
                t_assignedKeys[startdata.t_p3Selected[i].pal] = ''
            end
        end
        for i = 1, #startdata.t_p4Selected do
            if startdata.t_p4Selected[i].ref == ref then
                t_assignedKeys[startdata.t_p4Selected[i].pal] = ''
            end
        end
    end
    local t = {}
    --selected palette
    if palno ~= nil then
        t = main:f_tableCopy(main.t_selChars[ref + 1].pal)
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
            main:f_tableWrap(t, wrap)
            for k, v in ipairs(t) do
                if t_assignedKeys[start.f_reampPal(ref, v)] == nil then
                    return start.f_reampPal(ref, v)
                end
            end
        end
        --default palette
    elseif not config.AIRandomColor then
        t = main:f_tableCopy(main.t_selChars[ref + 1].pal_defaults)
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
            main:f_tableWrap(t, wrap)
            for k, v in ipairs(t) do
                if t_assignedKeys[v] == nil then
                    return v
                end
            end
        end
    end
    --random palette
    t = main:f_tableCopy(main.t_selChars[ref + 1].pal)
    if #t_assignedKeys >= #t then --not enough palettes for unique selection
        return math.random(1, #t)
    end
    main:f_tableShuffle(t)
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
        startdata.p1SelY = motif.select_info.p1_cursor_startcell[1]
    else
        startdata.p1SelY = 0
    end
    if motif.select_info.p2_cursor_startcell[1] < motif.select_info.rows then
        startdata.p2SelY = motif.select_info.p2_cursor_startcell[1]
    else
        startdata.p2SelY = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[1] < motif.select_info.rows then
            startdata.p3SelY = motif.select_info.p3_cursor_startcell[1]
        else
            startdata.p3SelY = 0
        end
        if motif.select_info.p4_cursor_startcell[1] < motif.select_info.rows then
            startdata.p4SelY = motif.select_info.p4_cursor_startcell[1]
        else
            startdata.p4SelY = 0
        end
    end
    --starting column
    if motif.select_info.p1_cursor_startcell[2] < motif.select_info.columns then
        startdata.p1SelX = motif.select_info.p1_cursor_startcell[2]
    else
        startdata.p1SelX = 0
    end
    if motif.select_info.p2_cursor_startcell[2] < motif.select_info.columns then
        startdata.p2SelX = motif.select_info.p2_cursor_startcell[2]
    else
        startdata.p2SelX = 0
    end
    if (gamemode('4pversus') or gamemode('4pcoop')) then
        if motif.select_info.p3_cursor_startcell[2] < motif.select_info.columns then
            startdata.p3SelX = motif.select_info.p3_cursor_startcell[2]
        else
            startdata.p3SelX = 0
        end
        if motif.select_info.p4_cursor_startcell[2] < motif.select_info.columns then
            startdata.p4SelX = motif.select_info.p4_cursor_startcell[2]
        else
            startdata.p4SelX = 0
        end
    end
end

-- @override resets various data
function start.f_selectReset()
    main:f_cmdInput()
    local col = 1
    local row = 1
    for i = 1, #main.t_selGrid do
        if i > motif.select_info.columns * row then
            row = row + 1
            col = 1
        end
        if main.t_selGrid[i].slot ~= 1 then
            main.t_selGrid[i].slot = 1
            startdata.t_grid[row][col].char = start.f_selGrid(i).char
            startdata.t_grid[row][col].char_ref = start.f_selGrid(i).char_ref
            start.f_resetGrid()
        end
        col = col + 1
    end
    if main.p2Faces and motif.select_info.doubleselect_enabled == 1 then
        startdata.p1FaceX = motif.select_info.pos[1] + motif.select_info.p1_doubleselect_offset[1]
        startdata.p1FaceY = motif.select_info.pos[2] + motif.select_info.p1_doubleselect_offset[2]
        startdata.p2FaceX = motif.select_info.pos[1] + motif.select_info.p2_doubleselect_offset[1]
        startdata.p2FaceY = motif.select_info.pos[2] + motif.select_info.p2_doubleselect_offset[2]
    else
        startdata.p1FaceX = motif.select_info.pos[1]
        startdata.p1FaceY = motif.select_info.pos[2]
        startdata.p2FaceX = motif.select_info.pos[1]
        startdata.p2FaceY = motif.select_info.pos[2]
        startdata.p3FaceX = motif.select_info.pos[1]
        startdata.p3FaceY = motif.select_info.pos[2]
        startdata.p4FaceX = motif.select_info.pos[1]
        startdata.p4FaceY = motif.select_info.pos[2]
    end
    start.f_resetGrid()
    if gamemode('netplayversus') or gamemode('netplayteamcoop') or gamemode('netplaysurvivalcoop') then
        startdata.p1TeamMode = 0
        startdata.p2TeamMode = 0
        startdata.stageNo = 0
        startdata.stageList = 0
    end
    startdata.p1Cell = nil
    startdata.p2Cell = nil
    startdata.p3Cell = nil
    startdata.p4Cell = nil
    startdata.t_p1Selected = {}
    startdata.t_p2Selected = {}
    startdata.t_p3Selected = {}
    startdata.t_p4Selected = {}
    startdata.p1TeamEnd = false
    if gamemode('4pversus') then
        startdata.p1TeamEnd = true
    end
    startdata.p1SelEnd = false
    startdata.p1Ratio = false
    startdata.p2TeamEnd = false
    if gamemode('4pversus') then
        startdata.p2TeamEnd = true
    end
    startdata.p2SelEnd = false
    startdata.p2Ratio = false
    startdata.p3TeamEnd = true -- p3 Never has team mode
    startdata.p3SelEnd = false
    startdata.p3Ratio = false
    startdata.p4TeamEnd = true -- p4 Never has team mode
    startdata.p4SelEnd = false
    startdata.p4Ratio = false
    if main.t_pIn[2] == 1 then
        startdata.p2TeamEnd = true
        startdata.p2SelEnd = true
    elseif main.coop then
        startdata.p1TeamEnd = true
        startdata.p2TeamEnd = true
        startdata.p3TeamEnd = true
        startdata.p4TeamEnd = true
    end
    if not main.p2SelectMenu and not (gamemode('4pversus') or gamemode('4pcoop')) then
        startdata.p2SelEnd = true
    end
    startdata.selScreenEnd = false
    startdata.stageEnd = false
    startdata.coopEnd = false
    startdata.restoreTeam = false
    startdata.continueData = false
    startdata.p1NumChars = 1
    startdata.p2NumChars = 1
    startdata.p3NumChars = 1
    startdata.p4NumChars = 1
    startdata.winner = 0
    startdata.winCnt = 0
    startdata.loseCnt = 0
    startdata.matchNo = 0
    if not startdata.challenger then
        startdata.t_savedData = {
            ['win'] = {0, 0},
            ['lose'] = {0, 0},
            ['time'] = {['total'] = 0, ['matches'] = {}},
            ['score'] = {['total'] = {0, 0}, ['matches'] = {}},
            ['consecutive'] = {0, 0},
        }
    end
    startdata.t_recordText = start.f_getRecordText()
    setMatchNo(startdata.matchNo)
    menu.movelistChar = 1
end


function start4p.f_select4pScreen()
    startdata.p1NumChars = 1
    startdata.p2NumChars = 1
    startdata.p3NumChars = 1
    startdata.p4NumChars = 1

    -- Need to set team mode to be able to get proper amount of characters
    -- todo	Dev refactor start.lua
    if gamemode('4pversus') then
        startdata.p1TeamMode = 1
        startdata.p2TeamMode = 1
        setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars + startdata.p3NumChars)
        setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars + startdata.p4NumChars)
    elseif gamemode('4pcoop') then
        startdata.p1TeamMode = 1
        startdata.p2TeamMode = 1
        setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars + startdata.p2NumChars + startdata.p3NumChars + startdata.p4NumChars)
        setTeamMode(2, startdata.p2TeamMode, startdata.p1NumChars + startdata.p2NumChars + startdata.p3NumChars + startdata.p4NumChars)
    end

    if startdata.selScreenEnd then
        return true
    end
    main:f_bgReset(motif.selectbgdef.bg)
    main:f_playBGM(true, motif.music.select_bgm, motif.music.select_bgm_loop, motif.music.select_bgm_volume, motif.music.select_bgm_loopstart, motif.music.select_bgm_loopend)
    local t_enemySelected = {}
    local numChars = startdata.p2NumChars
    if main.coop and startdata.matchNo > 0 then --coop swap after first match
        t_enemySelected = main:f_tableCopy(startdata.t_p2Selected)
        startdata.t_p2Selected = {}
        startdata.p2SelEnd = false
    end
    startdata.timerSelect = 0
    while not startdata.selScreenEnd do
        if esc() or main:f_input(main.t_players, {'m'}) then
            return false
        end
        --draw clearcolor
        clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
        --draw layerno = 0 backgrounds
        bgDraw(motif.selectbgdef.bg, false)
        --draw title
        main.txt_mainSelect:draw()
        if startdata.p1Cell then
            --draw p1 portrait
            local t_portrait = {}
            if #startdata.t_p1Selected < startdata.p1NumChars then
                if start.f_selGrid(startdata.p1Cell + 1).char == 'randomselect' or start.f_selGrid(startdata.p1Cell + 1).hidden == 3 then
                    if startdata.p1RandomCount < motif.select_info.cell_random_switchtime then
                        startdata.p1RandomCount = startdata.p1RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p1_random_move_snd[1], motif.select_info.p1_random_move_snd[2])
                        startdata.p1RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startdata.p1RandomCount = 0
                    end
                    t_portrait[1] = startdata.p1RandomPortrait
                elseif start.f_selGrid(startdata.p1Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startdata.p1Cell + 1).char_ref
                end
            end
            for i = #startdata.t_p1Selected, 1, -1 do
                if (gamemode('4pversus') or gamemode('4pcoop')) then
                    if i == 1 then
                        if #t_portrait < motif.select_info.p1_face_num then
                            table.insert(t_portrait, startdata.t_p1Selected[i].ref)
                        end
                    end
                else
                    if #t_portrait < motif.select_info.p1_face_num then
                        table.insert(t_portrait, startdata.t_p1Selected[i].ref)
                    end
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p1_face_spr[1],
                        motif.select_info.p1_face_spr[2],
                        motif.select_info.p1_face_offset[1] + motif.select_info['p1_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p1_face_spacing[1] + main:f_alignOffset(motif.select_info.p1_face_facing),
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
        if startdata.p2Cell then
            --draw p2 portrait
            local t_portrait = {}
            if #startdata.t_p2Selected < startdata.p2NumChars then
                if start.f_selGrid(startdata.p2Cell + 1).char == 'randomselect' or start.f_selGrid(startdata.p2Cell + 1).hidden == 3 then
                    if startdata.p2RandomCount < motif.select_info.cell_random_switchtime then
                        startdata.p2RandomCount = startdata.p2RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p2_random_move_snd[1], motif.select_info.p2_random_move_snd[2])
                        startdata.p2RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startdata.p2RandomCount = 0
                    end
                    t_portrait[1] = startdata.p2RandomPortrait
                elseif start.f_selGrid(startdata.p2Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startdata.p2Cell + 1).char_ref
                end
            end
            for i = #startdata.t_p2Selected, 1, -1 do
                if (gamemode('4pversus') or gamemode('4pcoop')) then
                    if i == 1 then
                        if #t_portrait < motif.select_info.p2_face_num then
                            table.insert(t_portrait, startdata.t_p2Selected[i].ref)
                        end
                    end
                else
                    if #t_portrait < motif.select_info.p2_face_num then
                        table.insert(t_portrait, startdata.t_p2Selected[i].ref)
                    end
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p2_face_spr[1],
                        motif.select_info.p2_face_spr[2],
                        motif.select_info.p2_face_offset[1] + motif.select_info['p2_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p2_face_spacing[1] + main:f_alignOffset(motif.select_info.p2_face_facing),
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
        if startdata.p3Cell then
            --draw p3 portrait
            local t_portrait = {}
            if #startdata.t_p3Selected < startdata.p3NumChars then
                if start.f_selGrid(startdata.p3Cell + 1).char == 'randomselect' or start.f_selGrid(startdata.p3Cell + 1).hidden == 3 then
                    if startdata.p3RandomCount < motif.select_info.cell_random_switchtime then
                        startdata.p3RandomCount = startdata.p3RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p3_random_move_snd[1], motif.select_info.p3_random_move_snd[2])
                        startdata.p3RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startdata.p3RandomCount = 0
                    end
                    t_portrait[1] = startdata.p3RandomPortrait
                elseif start.f_selGrid(startdata.p3Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startdata.p3Cell + 1).char_ref
                end
            end
            for i = #startdata.t_p3Selected, 1, -1 do
                if #t_portrait < motif.select_info.p3_face_num then
                    table.insert(t_portrait, startdata.t_p3Selected[i].ref)
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p3_face_spr[1],
                        motif.select_info.p3_face_spr[2],
                        motif.select_info.p3_face_offset[1] + motif.select_info['p3_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p3_face_spacing[1] + main:f_alignOffset(motif.select_info.p3_face_facing),
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
        if startdata.p4Cell then
            --draw p4 portrait
            local t_portrait = {}
            if #startdata.t_p4Selected < startdata.p4NumChars then
                if start.f_selGrid(startdata.p4Cell + 1).char == 'randomselect' or start.f_selGrid(startdata.p4Cell + 1).hidden == 3 then
                    if startdata.p4RandomCount < motif.select_info.cell_random_switchtime then
                        startdata.p4RandomCount = startdata.p4RandomCount + 1
                    else
                        if motif.select_info.random_move_snd_cancel == 1 then
                            sndStop(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        end
                        sndPlay(motif.files.snd_data, motif.select_info.p4_random_move_snd[1], motif.select_info.p4_random_move_snd[2])
                        startdata.p4RandomPortrait = main.t_randomChars[math.random(1, #main.t_randomChars)]
                        startdata.p4RandomCount = 0
                    end
                    t_portrait[1] = startdata.p4RandomPortrait
                elseif start.f_selGrid(startdata.p4Cell + 1).hidden ~= 2 then
                    t_portrait[1] = start.f_selGrid(startdata.p4Cell + 1).char_ref
                end
            end
            for i = #startdata.t_p4Selected, 1, -1 do
                if #t_portrait < motif.select_info.p4_face_num then
                    table.insert(t_portrait, startdata.t_p4Selected[i].ref)
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
            for n = #t_portrait, 1, -1 do
                drawPortraitChar(
                        t_portrait[n],
                        motif.select_info.p4_face_spr[1],
                        motif.select_info.p4_face_spr[2],
                        motif.select_info.p4_face_offset[1] + motif.select_info['p4_c' .. n .. '_face_offset'][1] + (n - 1) * motif.select_info.p4_face_spacing[1] + main:f_alignOffset(motif.select_info.p4_face_facing),
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
        for i = 1, #startdata.t_drawFace do
            --P1 side check before drawing
            if startdata.t_drawFace[i].d <= 2 then
                --draw cell background
                main:f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        startdata.t_drawFace[i].x1,
                        startdata.t_drawFace[i].y1,
                        (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if startdata.t_drawFace[i].d == 1 then
                    main:f_animPosDraw(
                            motif.select_info.cell_random_data,
                            startdata.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            startdata.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif startdata.t_drawFace[i].d == 2 then
                    drawPortraitChar(
                            startdata.t_drawFace[i].p1,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            startdata.t_drawFace[i].x1 + motif.select_info.portrait_offset[1],
                            startdata.t_drawFace[i].y1 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1),
                            motif.select_info.portrait_scale[2]
                    )
                end
            end
            --P2 side check before drawing (double select only)
            if main.p2Faces and motif.select_info.doubleselect_enabled == 1 and startdata.t_drawFace[i].d >= 10 then
                --draw cell background
                main:f_animPosDraw(
                        motif.select_info.cell_bg_data,
                        startdata.t_drawFace[i].x2,
                        startdata.t_drawFace[i].y2,
                        (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
                )
                --draw random cell
                if startdata.t_drawFace[i].d == 11 then
                    main:f_animPosDraw(
                            motif.select_info.cell_random_data,
                            startdata.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            startdata.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
                    )
                    --draw face cell
                elseif startdata.t_drawFace[i].d == 12 then
                    drawPortraitChar(
                            startdata.t_drawFace[i].p2,
                            motif.select_info.portrait_spr[1],
                            motif.select_info.portrait_spr[2],
                            startdata.t_drawFace[i].x2 + motif.select_info.portrait_offset[1],
                            startdata.t_drawFace[i].y2 + motif.select_info.portrait_offset[2],
                            motif.select_info.portrait_scale[1] * (motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1),
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
        for i = 1, #startdata.t_p1Selected do
            if startdata.t_p1Selected[i].cursor ~= nil then
                main:f_animPosDraw(
                        motif.select_info.p1_cursor_done_data,
                        startdata.t_p1Selected[i].cursor[1],
                        startdata.t_p1Selected[i].cursor[2],
                        startdata.t_p1Selected[i].cursor[4]
                )
            end
        end
        --draw p2 done cursor
        for i = 1, #startdata.t_p2Selected do
            if startdata.t_p2Selected[i].cursor ~= nil then
                main:f_animPosDraw(
                        motif.select_info.p2_cursor_done_data,
                        startdata.t_p2Selected[i].cursor[1],
                        startdata.t_p2Selected[i].cursor[2],
                        startdata.t_p2Selected[i].cursor[4]
                )
            end
        end
        --draw p3 done cursor
        for i = 1, #startdata.t_p3Selected do
            if startdata.t_p3Selected[i].cursor ~= nil then
                main:f_animPosDraw(
                        motif.select_info.p3_cursor_done_data,
                        startdata.t_p3Selected[i].cursor[1],
                        startdata.t_p3Selected[i].cursor[2],
                        startdata.t_p3Selected[i].cursor[4]
                )
            end
        end
        --draw p4 done cursor
        for i = 1, #startdata.t_p4Selected do
            if startdata.t_p4Selected[i].cursor ~= nil then
                main:f_animPosDraw(
                        motif.select_info.p4_cursor_done_data,
                        startdata.t_p4Selected[i].cursor[1],
                        startdata.t_p4Selected[i].cursor[2],
                        startdata.t_p4Selected[i].cursor[4]
                )
            end
        end
        --Player1 team menu
        if not startdata.p1TeamEnd then
            start.f_p1TeamMenu()
            --Player1 select
        elseif main.t_pIn[1] > 0 or main.p1Char ~= nil then
            start.f_p1SelectMenu()
        end
        --Player2 team menu
        if not startdata.p2TeamEnd then
            start.f_p2TeamMenu()
            --Player2 select
        elseif main.t_pIn[2] > 0 or main.p2Char ~= nil then
            start.f_p2SelectMenu()
        end
        --Player3 team menu
        if not startdata.p1TeamEnd then
            --start4p.f_p3TeamMenu()
            --Player3 select
        elseif main.t_pIn[3] > 0 or main.p3Char ~= nil then
            start4p.f_p3SelectMenu()
        end
        --Player4 team menu
        if not startdata.p2TeamEnd then
            --start4p.f_p4TeamMenu()
            --Player4 select
        elseif main.t_pIn[4] > 0 or main.p4Char ~= nil then
            start4p.f_p4SelectMenu()
        end
        if startdata.p1Cell then
            --draw p1 name
            local t_name = {}
            for i = 1, #startdata.t_p1Selected do
                table.insert(t_name, {['ref'] = startdata.t_p1Selected[i].ref})
            end
            if #startdata.t_p1Selected < startdata.p1NumChars then
                if start.f_selGrid(startdata.p1Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startdata.p1Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startdata.txt_p1Name,
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
        if startdata.p2Cell then
            --draw p2 name
            local t_name = {}
            for i = 1, #startdata.t_p2Selected do
                table.insert(t_name, {['ref'] = startdata.t_p2Selected[i].ref})
            end
            if #startdata.t_p2Selected < startdata.p2NumChars then
                if start.f_selGrid(startdata.p2Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startdata.p2Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startdata.txt_p2Name,
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
        if startdata.p3Cell then
            --draw p3 name
            local t_name = {}
            for i = 1, #startdata.t_p3Selected do
                table.insert(t_name, {['ref'] = startdata.t_p3Selected[i].ref})
            end
            if #startdata.t_p3Selected < startdata.p3NumChars then
                if start.f_selGrid(startdata.p3Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startdata.p3Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startdata.txt_p3Name,
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
        if startdata.p4Cell then
            --draw p4 name
            local t_name = {}
            for i = 1, #startdata.t_p4Selected do
                table.insert(t_name, {['ref'] = startdata.t_p4Selected[i].ref})
            end
            if #startdata.t_p4Selected < startdata.p4NumChars then
                if start.f_selGrid(startdata.p4Cell + 1).char_ref ~= nil then
                    table.insert(t_name, {['ref'] = start.f_selGrid(startdata.p4Cell + 1).char_ref})
                end
            end
            start.f_drawName(
                    t_name,
                    startdata.txt_p4Name,
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
        if motif.select_info.timer_enabled == 1 and startdata.p1TeamEnd and (startdata.p2TeamEnd or not main.p2SelectMenu) then
            local num = math.floor((motif.select_info.timer_count * motif.select_info.timer_framespercount - startdata.timerSelect + motif.select_info.timer_displaytime) / motif.select_info.timer_framespercount + 0.5)
            if num <= -1 then
                startdata.timerSelect = -1
                startdata.txt_timerSelect:update({text = 0})
            else
                startdata.timerSelect = startdata.timerSelect + 1
                startdata.txt_timerSelect:update({text = math.max(0, num)})
            end
            if startdata.timerSelect >= motif.select_info.timer_displaytime then
                startdata.txt_timerSelect:draw()
            end
        end
        --draw record text
        for i = 1, #startdata.t_recordText do
            startdata.txt_recordSelect:update({
                text = startdata.t_recordText[i],
                y = motif.select_info.record_offset[2] + main:f_ySpacing(motif.select_info, 'record_font') * (i - 1),
            })
            startdata.txt_recordSelect:draw()
        end
        --team and character selection complete
        if startdata.p1SelEnd and startdata.p2SelEnd and startdata.p3SelEnd and startdata.p4SelEnd and startdata.p1TeamEnd and startdata.p2TeamEnd then
            if gamemode("4pversus") then
                -- In versus P3 selection belongs in p1 roster
                -- todo	Dev: Need to refactor this to be more clear
                if #startdata.t_p1Selected < 2 then
                    print("Inserting P3 character to P1 table for VS")
                    table.insert(startdata.t_p1Selected, {
                        ref = startdata.t_p3Selected[1].ref,
                        pal = startdata.t_p3Selected[1].pal,
                        cursor = startdata.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })
                end
                -- P4 selections belongs in p2 roster
                if #startdata.t_p2Selected < 2 then
                    print("Inserting P4 character to P2 table for VS")
                    table.insert(startdata.t_p2Selected, {
                        ref = startdata.t_p4Selected[1].ref,
                        pal = startdata.t_p4Selected[1].pal,
                        cursor = startdata.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end

            elseif gamemode('4pcoop') then
                -- In coop all selected characters belong to player one roster
                -- todo: Dev: Need to update this to work seperately
                if #startdata.t_p1Selected < 4 then
                    print("Inserting P2 character to P1 table for coop")
                    table.insert(startdata.t_p1Selected, {
                        ref = startdata.t_p2Selected[1].ref,
                        pal = startdata.t_p2Selected[1].pal,
                        cursor = startdata.t_p2Selected[1].cursor,
                        ratio = start.f_setRatio(2)
                    })

                    print("Inserting P3 character to P1 table for coop")
                    table.insert(startdata.t_p1Selected, {
                        ref = startdata.t_p3Selected[1].ref,
                        pal = startdata.t_p3Selected[1].pal,
                        cursor = startdata.t_p3Selected[1].cursor,
                        ratio = start.f_setRatio(3)
                    })

                    print("Inserting P4 character to P1 table for coop")
                    table.insert(startdata.t_p1Selected, {
                        ref = startdata.t_p4Selected[1].ref,
                        pal = startdata.t_p4Selected[1].pal,
                        cursor = startdata.t_p4Selected[1].cursor,
                        ratio = start.f_setRatio(4)
                    })
                end
            end

            startdata.p1RestoreCursor = true
            startdata.p2RestoreCursor = true
            startdata.p3RestoreCursor = true
            startdata.p4RestoreCursor = true

            if main.stageMenu and not startdata.stageEnd then --Stage select
                start.f_stageMenu()
            elseif main.coop and not startdata.coopEnd then
                startdata.coopEnd = true
                startdata.p2TeamEnd = false
            elseif startdata.fadeType == 'fadein' then
                main.fadeStart = getFrameCount()
                startdata.fadeType = 'fadeout'
            end
        end
        --draw layerno = 1 backgrounds
        bgDraw(motif.selectbgdef.bg, true)
        --draw fadein / fadeout
        main.fadeActive = fadeColor(
                startdata.fadeType,
                main.fadeStart,
                motif.select_info[startdata.fadeType .. '_time'],
                motif.select_info[startdata.fadeType .. '_col'][1],
                motif.select_info[startdata.fadeType .. '_col'][2],
                motif.select_info[startdata.fadeType .. '_col'][3]
        )
        --frame transition
        if main.fadeActive then
            commandBufReset(main.t_cmd[1])
        elseif startdata.fadeType == 'fadeout' then
            commandBufReset(main.t_cmd[1])
            startdata.selScreenEnd = true
            break --skip last frame rendering
        else
            main:f_cmdInput()
        end
        main:f_refresh()
    end
    if startdata.matchNo == 0 then --team mode set
        if main.coop then --coop swap before first match
            startdata.p1NumChars = 4
            startdata.t_p1Selected[2] = {ref = startdata.t_p2Selected[1].ref, pal = startdata.t_p2Selected[1].pal}
            startdata.t_p1Selected[3] = {ref = startdata.t_p3Selected[1].ref, pal = startdata.t_p3Selected[1].pal}
            startdata.t_p1Selected[4] = {ref = startdata.t_p4Selected[1].ref, pal = startdata.t_p4Selected[1].pal}
            startdata.t_p2Selected = {}
        end
        --setTeamMode(1, start.p1TeamMode, p1NumChars)
        --setTeamMode(2, start.p2TeamMode, p2NumChars)
    elseif main.coop then --coop swap after first match
        startdata.p1NumChars = 4
        startdata.p2NumChars = numChars
        startdata.t_p1Selected[2] = {ref = startdata.t_p2Selected[1].ref, pal = startdata.t_p2Selected[1].pal}
        startdata.t_p1Selected[2] = {ref = startdata.t_p3Selected[1].ref, pal = startdata.t_p3Selected[1].pal}
        startdata.t_p1Selected[2] = {ref = startdata.t_p4Selected[1].ref, pal = startdata.t_p4Selected[1].pal}
        startdata.t_p2Selected = t_enemySelected
    end
    return true
end


function start4p.f_select4pSimple()
    start.f_startCell()
    startdata.t_p1Cursor = {}
    startdata.t_p2Cursor = {}
    startdata.t_p3Cursor = {}
    startdata.t_p4Cursor = {}
    startdata.p1RestoreCursor = false
    startdata.p2RestoreCursor = false
    startdata.p3RestoreCursor = false
    startdata.p4RestoreCursor = false
    startdata.p1TeamMenu = 0
    startdata.p2TeamMenu = 0
    startdata.p3TeamMenu = 0
    startdata.p4TeamMenu = 0
    startdata.p3TeamEnd = true
    startdata.p4TeamEnd = true
    startdata.p1FaceOffset = 0
    startdata.p2FaceOffset = 0
    startdata.p3FaceOffset = 0
    startdata.p4FaceOffset = 0
    startdata.p1RowOffset = 0
    startdata.p2RowOffset = 0
    startdata.p3RowOffset = 0
    startdata.p4RowOffset = 0
    startdata.stageList = 0
    while true do --outer loop (moved back here after pressing ESC)
        start.f_selectReset()
        while true do --inner loop
            startdata.fadeType = 'fadein'
            selectStart()
            if not start4p.f_select4pScreen() then
                sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
                main:f_bgReset(motif.titlebgdef.bg)
                main:f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
                return
            end
            if gamemode('4pcoop') then
                --first match
                if startdata.matchNo == 0 then
                    --generate roster
                    startdata.t_roster = start.f_makeRoster()
                    startdata.lastMatch = #startdata.t_roster
                    startdata.matchNo = 1
                    --generate AI ramping table
                    start.f_aiRamp(1)
                end
                --assign enemy team
                if #startdata.t_p2Selected == 0 then
                    local shuffle = true
                    for i = 1, #startdata.t_roster[startdata.matchNo] do
                        table.insert(startdata.t_p2Selected, {ref = startdata.t_roster[startdata.matchNo][i], pal = start.f_selectPal(startdata.t_roster[startdata.matchNo][i]), ratio = start.f_setRatio(2)})
                        if shuffle then
                            main:f_tableShuffle(startdata.t_p2Selected)
                        end
                    end
                end
            end
            --fight initialization
            start.f_overrideCharData()
            start.f_remapAI()
            start.f_setRounds()
            startdata.stageNo = start.f_setStage(startdata.stageNo)
            start.f_setMusic(startdata.stageNo)
            if start4p.f_select4pVersus() == nil then break end
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            loadStart()
            startdata.winner, startdata.t_gameStats = game()
            clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
            if gameend() then
                os.exit()
            end
            start.f_saveData()
            if startdata.challenger then
                return
            end
            if startdata.winner == -1 then break end --player exit the game via ESC
            start.f_storeSavedData(gamemode(), startdata.winner == 1)
            start.f_selectReset()
            --main:f_cmdInput()
            refresh()
        end
        esc(false) --reset ESC
        if gamemode('netplayversus') then
            --resetRemapInput()
            --main.reconnect = winner == -1
        end
        if start.exit then
            main:f_bgReset(motif.titlebgdef.bg)
            main:f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
            start.exit = false
            break
        end
    end
end


function start4p.f_select4pVersus()
    if not main.versusScreen or not main.t_charparam.vsscreen or (main.t_charparam.rivals and start.f_rivalsMatch('vsscreen', 0)) or main.t_selChars[startdata.t_p1Selected[1].ref + 1].vsscreen == 0 then
        start.f_selectChar(1, startdata.t_p1Selected)
        start.f_selectChar(2, startdata.t_p2Selected)
        return true
    else
        local text = main:f_extractText(motif.vs_screen.match_text, startdata.matchNo)
        startdata.txt_matchNo:update({text = text[1]})
        main:f_bgReset(motif.versusbgdef.bg)
        main:f_playBGM(true, motif.music.vs_bgm, motif.music.vs_bgm_loop, motif.music.vs_bgm_volume, motif.music.vs_bgm_loopstart, motif.music.vs_bgm_loopend)
        local p1Confirmed = false
        local p2Confirmed = false
        local p1Row = 1
        local p2Row = 1
        local t_tmp = {}
        local t_p1_slide_dist = {0, 0}
        local t_p2_slide_dist = {0, 0}
        local orderTime = 0
        if main.t_pIn[1] == 1 and main.t_pIn[2] == 2 and (#startdata.t_p1Selected > 1 or #startdata.t_p2Selected > 1) and not main.coop then
            orderTime = math.max(#startdata.t_p1Selected, #startdata.t_p2Selected) - 1 * motif.vs_screen.time_order
            if #startdata.t_p1Selected == 1 then
                start.f_selectChar(1, startdata.t_p1Selected)
                p1Confirmed = true
            end
            if #startdata.t_p2Selected == 1 then
                start.f_selectChar(2, startdata.t_p2Selected)
                p2Confirmed = true
            end
        elseif #startdata.t_p1Selected > 1 and not main.coop then
            orderTime = #startdata.t_p1Selected - 1 * motif.vs_screen.time_order
        else
            start.f_selectChar(1, startdata.t_p1Selected)
            p1Confirmed = true
            start.f_selectChar(2, startdata.t_p2Selected)
            p2Confirmed = true
        end
        --main:f_cmdInput()
        main.fadeStart = getFrameCount()
        local counter = 0 - motif.vs_screen.fadein_time
        startdata.fadeType = 'fadein'
        while true do
            if counter == motif.vs_screen.stage_time then
                start.f_playWave(startdata.stageNo, 'stage', motif.vs_screen.stage_snd[1], motif.vs_screen.stage_snd[2])
            end
            if esc() or main:f_input(main.t_players, {'m'}) then
                --main:f_cmdInput()
                return nil
            elseif p1Confirmed and p2Confirmed then
                if startdata.fadeType == 'fadein' and (counter >= motif.vs_screen.time or main:f_input({1}, {'pal', 's'})) then
                    main.fadeStart = getFrameCount()
                    startdata.fadeType = 'fadeout'
                end
            elseif counter >= motif.vs_screen.time + orderTime then
                if not p1Confirmed then
                    start.f_selectChar(1, startdata.t_p1Selected)
                    p1Confirmed = true
                end
                if not p2Confirmed then
                    start.f_selectChar(2, startdata.t_p2Selected)
                    p2Confirmed = true
                end
            else
                --if Player1 has not confirmed the order yet
                if not p1Confirmed then
                    if main:f_input({1}, {'pal', 's'}) then
                        if not p1Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_done_snd[1], motif.vs_screen.p1_cursor_done_snd[2])
                            start.f_selectChar(1, startdata.t_p1Selected)
                            p1Confirmed = true
                        end
                        if main.t_pIn[2] ~= 2 then
                            if not p2Confirmed then
                                start.f_selectChar(2, startdata.t_p2Selected)
                                p2Confirmed = true
                            end
                        end
                    elseif main:f_input({1}, {'$U'}) then
                        if #startdata.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            if p1Row == 0 then p1Row = #startdata.t_p1Selected end
                        end
                    elseif main:f_input({1}, {'$D'}) then
                        if #startdata.t_p1Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            if p1Row > #startdata.t_p1Selected then p1Row = 1 end
                        end
                    elseif main:f_input({1}, {'$B'}) then
                        if p1Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row - 1
                            t_tmp = {}
                            t_tmp[p1Row] = startdata.t_p1Selected[p1Row + 1]
                            for i = 1, #startdata.t_p1Selected do
                                for j = 1, #startdata.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row + 1 then
                                        t_tmp[j] = startdata.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            startdata.t_p1Selected = t_tmp
                        end
                    elseif main:f_input({1}, {'$F'}) then
                        if p1Row + 1 <= #startdata.t_p1Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
                            p1Row = p1Row + 1
                            t_tmp = {}
                            t_tmp[p1Row] = startdata.t_p1Selected[p1Row - 1]
                            for i = 1, #startdata.t_p1Selected do
                                for j = 1, #startdata.t_p1Selected do
                                    if t_tmp[j] == nil and i ~= p1Row - 1 then
                                        t_tmp[j] = startdata.t_p1Selected[i]
                                        break
                                    end
                                end
                            end
                            startdata.t_p1Selected = t_tmp
                        end
                    end
                end
                --if Player2 has not confirmed the order yet and is not controlled by Player1
                if not p2Confirmed and main.t_pIn[2] ~= 1 then
                    if main:f_input({2}, {'pal', 's'}) then
                        if not p2Confirmed then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_done_snd[1], motif.vs_screen.p2_cursor_done_snd[2])
                            start.f_selectChar(2, startdata.t_p2Selected)
                            p2Confirmed = true
                        end
                    elseif main:f_input({2}, {'$U'}) then
                        if #startdata.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            if p2Row == 0 then p2Row = #startdata.t_p2Selected end
                        end
                    elseif main:f_input({2}, {'$D'}) then
                        if #startdata.t_p2Selected > 1 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            if p2Row > #startdata.t_p2Selected then p2Row = 1 end
                        end
                    elseif main:f_input({2}, {'$B'}) then
                        if p2Row + 1 <= #startdata.t_p2Selected then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row + 1
                            t_tmp = {}
                            t_tmp[p2Row] = startdata.t_p2Selected[p2Row - 1]
                            for i = 1, #startdata.t_p2Selected do
                                for j = 1, #startdata.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row - 1 then
                                        t_tmp[j] = startdata.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            startdata.t_p2Selected = t_tmp
                        end
                    elseif main:f_input({2}, {'$F'}) then
                        if p2Row - 1 > 0 then
                            sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
                            p2Row = p2Row - 1
                            t_tmp = {}
                            t_tmp[p2Row] = startdata.t_p2Selected[p2Row + 1]
                            for i = 1, #startdata.t_p2Selected do
                                for j = 1, #startdata.t_p2Selected do
                                    if t_tmp[j] == nil and i ~= p2Row + 1 then
                                        t_tmp[j] = startdata.t_p2Selected[i]
                                        break
                                    end
                                end
                            end
                            startdata.t_p2Selected = t_tmp
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
            for i = 1, #startdata.t_p1Selected do
                if #t_portrait < motif.vs_screen.p1_num then
                    table.insert(t_portrait, startdata.t_p1Selected[i].ref)
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
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
                        motif.vs_screen.p1_pos[1] + motif.vs_screen.p1_offset[1] + motif.vs_screen['p1_c' .. i .. '_offset'][1] + (i - 1) * motif.vs_screen.p1_spacing[1] + main:f_alignOffset(motif.vs_screen.p1_facing) + math.floor(t_p1_slide_dist[1] + 0.5),
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
            for i = 1, #startdata.t_p2Selected do
                if #t_portrait < motif.vs_screen.p2_num then
                    table.insert(t_portrait, startdata.t_p2Selected[i].ref)
                end
            end
            t_portrait = main:f_tableReverse(t_portrait)
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
                        motif.vs_screen.p2_pos[1] + motif.vs_screen.p2_offset[1] + motif.vs_screen['p2_c' .. i .. '_offset'][1] + (i - 1) * motif.vs_screen.p2_spacing[1] + main:f_alignOffset(motif.vs_screen.p2_facing) + math.floor(t_p2_slide_dist[1] + 0.5),
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
                    startdata.t_p1Selected,
                    startdata.txt_p1NameVS,
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
                    startdata.t_p2Selected,
                    startdata.txt_p2NameVS,
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
            if startdata.matchNo > 0 then
                startdata.txt_matchNo:draw()
            end
            --draw layerno = 1 backgrounds
            bgDraw(motif.versusbgdef.bg, true)
            --draw fadein / fadeout
            main.fadeActive = fadeColor(
                    startdata.fadeType,
                    main.fadeStart,
                    motif.vs_screen[startdata.fadeType .. '_time'],
                    motif.vs_screen[startdata.fadeType .. '_col'][1],
                    motif.vs_screen[startdata.fadeType .. '_col'][2],
                    motif.vs_screen[startdata.fadeType .. '_col'][3]
            )
            --frame transition
            if main.fadeActive then
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
            elseif startdata.fadeType == 'fadeout' then
                commandBufReset(main.t_cmd[1])
                commandBufReset(main.t_cmd[2])
                clearColor(motif.versusbgdef.bgclearcolor[1], motif.versusbgdef.bgclearcolor[2], motif.versusbgdef.bgclearcolor[3]) --skip last frame rendering
                break
            else
                main:f_cmdInput()
            end
            main:f_refresh()
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
            startdata.t_p3Selected[i] = {
                ref = main.p3Char[i],
                pal = start.f_selectPal(main.p3Char[i])
            }
        end
        startdata.p3SelEnd = true
        return
        --manual selection
    elseif not startdata.p3SelEnd then
        startdata.resetgrid = false
        --cell movement
        if startdata.p3RestoreCursor and startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected] ~= nil then --restore saved position
            startdata.p3SelX = startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected][1]
            startdata.p3SelY = startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected][2]
            startdata.p3FaceOffset = startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected][3]
            startdata.p3RowOffset = startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected][4]
            startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected] = nil
        else --calculate current position
            startdata.p3SelX, startdata.p3SelY, startdata.p3FaceOffset, startdata.p3RowOffset = start.f_cellMovement(startdata.p3SelX, startdata.p3SelY, 3, startdata.p3FaceOffset, startdata.p3RowOffset, motif.select_info.p3_cursor_move_snd)
        end
        startdata.p3Cell = startdata.p3SelX + motif.select_info.columns * startdata.p3SelY
        --draw active cursor
        local cursorX = startdata.p3FaceX + startdata.p3SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startdata.p3SelX + 1, startdata.p3SelY + 1, 1)
        local cursorY = startdata.p3FaceY + (startdata.p3SelY - startdata.p3RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startdata.p3SelX + 1, startdata.p3SelY + 1, 2)
        if startdata.resetgrid == true then
            start.f_resetGrid()
        end
        if start.f_selGrid(startdata.p3Cell + 1).hidden ~= 1 then
            main:f_animPosDraw(
                    motif.select_info.p3_cursor_active_data,
                    cursorX,
                    cursorY,
                    (motif.select_info['cell_' .. startdata.p3SelX + 1 .. '_' .. startdata.p3SelY + 1 .. '_facing'] or 1)
            )
        end
        --cell selected
        if start.f_slotSelected(startdata.p3Cell + 1, 3, startdata.p3SelX, startdata.p3SelY) and start.f_selGrid(startdata.p3Cell + 1).char ~= nil and start.f_selGrid(startdata.p3Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(startdata.p3Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
            table.insert(startdata.t_p3Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main:f_btnPalNo(main.t_cmd[3])),
                cursor = {cursorX, cursorY, startdata.p3RowOffset, (motif.select_info['cell_' .. startdata.p3SelX + 1 .. '_' .. startdata.p3SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(1)
            })
            startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected + 1] = {startdata.p3SelX, startdata.p3SelY, startdata.p3FaceOffset, startdata.p3RowOffset}
            if #startdata.t_p3Selected == startdata.p3NumChars or (#startdata.t_p3Selected == 1 and main.coop) then --if all characters have been chosen
                if main.t_pIn[2] == 1 and startdata.matchNo == 0 then --if player1 is allowed to select p2 characters
                    startdata.p2TeamEnd = false
                    startdata.p2SelEnd = false
                    --commandBufReset(main.t_cmd[2])
                end
                startdata.p3SelEnd = true
            end
            main:f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and startdata.timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p3_cursor_done_snd[1], motif.select_info.p3_cursor_done_snd[2])
            local selected = start.f_selGrid(startdata.p3Cell + 1).char_ref
            local rand = false
            for i = #startdata.t_p3Selected + 1, startdata.p3NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p3_select_snd[1], motif.select_info.p3_select_snd[2])
                end
                rand = true
                table.insert(startdata.t_p3Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, startdata.p3RowOffset, (motif.select_info['cell_' .. startdata.p3SelX + 1 .. '_' .. startdata.p3SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(1)
                })
                startdata.t_p3Cursor[startdata.p3NumChars - #startdata.t_p3Selected + 1] = {startdata.p3SelX, startdata.p3SelY, startdata.p3FaceOffset, startdata.p3RowOffset}
            end
            if main.p2SelectMenu and main.t_pIn[2] == 1 and startdata.matchNo == 0 then --if player1 is allowed to select p2 characters
                start.p2TeamMode = start.p3TeamMode
                startdata.p2NumChars = startdata.p3NumChars
                setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
                startdata.p2Cell = startdata.p3Cell
                startdata.p2SelX = startdata.p3SelX
                startdata.p2SelY = startdata.p3SelY
                startdata.p2FaceOffset = startdata.p3FaceOffset
                startdata.p2RowOffset = startdata.p3RowOffset
                for i = 1, startdata.p2NumChars do
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                    table.insert(startdata.t_p2Selected, {
                        ref = selected,
                        pal = start.f_selectPal(selected),
                        cursor = {cursorX, cursorY, startdata.p2RowOffset, (motif.select_info['cell_' .. startdata.p2SelX + 1 .. '_' .. startdata.p2SelY + 1 .. '_facing'] or 1)},
                        ratio = start.f_setRatio(2)
                    })
                    startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected + 1] = {startdata.p2SelX, startdata.p2SelY, startdata.p2FaceOffset, startdata.p2RowOffset}
                end
            end
            startdata.p3SelEnd = true
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
            startdata.t_p4Selected[i] = {
                ref = main.p4Char[i],
                pal = start.f_selectPal(main.p4Char[i])
            }
        end
        startdata.p4SelEnd = true
        return
        --p4 selection disabled
    elseif not main.p4SelectMenu then
        startdata.p4SelEnd = true
        return
        --manual selection
    elseif not startdata.p4SelEnd then
        startdata.resetgrid = false
        --cell movement
        if startdata.p4RestoreCursor and startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected] ~= nil then --restore saved position
            startdata.p4SelX = startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected][1]
            startdata.p4SelY = startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected][2]
            startdata.p4FaceOffset = startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected][3]
            startdata.p4RowOffset = startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected][4]
            startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected] = nil
        else --calculate current position
            startdata.p4SelX, startdata.p4SelY, startdata.p4FaceOffset, startdata.p4RowOffset = start.f_cellMovement(startdata.p4SelX, startdata.p4SelY, 4, startdata.p4FaceOffset, startdata.p4RowOffset, motif.select_info.p4_cursor_move_snd)
        end
        startdata.p4Cell = startdata.p4SelX + motif.select_info.columns * startdata.p4SelY
        --draw active cursor
        local cursorX = startdata.p4FaceX + startdata.p4SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startdata.p4SelX + 1, startdata.p4SelY + 1, 1)
        local cursorY = startdata.p4FaceY + (startdata.p4SelY - startdata.p4RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startdata.p4SelX + 1, startdata.p4SelY + 1, 2)
        if startdata.resetgrid == true then
            start.f_resetGrid()
        end
        main:f_animPosDraw(
                motif.select_info.p4_cursor_active_data,
                cursorX,
                cursorY,
                (motif.select_info['cell_' .. startdata.p4SelX + 1 .. '_' .. startdata.p4SelY + 1 .. '_facing'] or 1)
        )
        --cell selected
        if start.f_slotSelected(startdata.p4Cell + 1, 4, startdata.p4SelX, startdata.p4SelY) and start.f_selGrid(startdata.p4Cell + 1).char ~= nil and start.f_selGrid(startdata.p4Cell + 1).hidden ~= 2 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(startdata.p4Cell + 1).char_ref
            if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
            end
            start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
            table.insert(startdata.t_p4Selected, {
                ref = selected,
                pal = start.f_selectPal(selected, main:f_btnPalNo(main.t_cmd[4])),
                cursor = {cursorX, cursorY, startdata.p4RowOffset, (motif.select_info['cell_' .. startdata.p4SelX + 1 .. '_' .. startdata.p4SelY + 1 .. '_facing'] or 1)},
                ratio = start.f_setRatio(2)
            })
            startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected + 1] = {startdata.p4SelX, startdata.p4SelY, startdata.p4FaceOffset, startdata.p4RowOffset}
            if #startdata.t_p4Selected == startdata.p4NumChars then
               startdata.p4SelEnd = true
            end
            main:f_cmdInput()
            --select screen timer reached 0
        elseif motif.select_info.timer_enabled == 1 and startdata.timerSelect == -1 then
            sndPlay(motif.files.snd_data, motif.select_info.p4_cursor_done_snd[1], motif.select_info.p4_cursor_done_snd[2])
            local selected = start.f_selGrid(startdata.p4Cell + 1).char_ref
            local rand = false
            for i = #startdata.t_p4Selected + 1, startdata.p4NumChars do
                if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
                    selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
                end
                if not rand then --play it just for the first character
                    start.f_playWave(selected, 'cursor', motif.select_info.p4_select_snd[1], motif.select_info.p4_select_snd[2])
                end
                rand = true
                table.insert(startdata.t_p4Selected, {
                    ref = selected,
                    pal = start.f_selectPal(selected),
                    cursor = {cursorX, cursorY, startdata.p4RowOffset, (motif.select_info['cell_' .. startdata.p4SelX + 1 .. '_' .. startdata.p4SelY + 1 .. '_facing'] or 1)},
                    ratio = start.f_setRatio(2)
                })
                startdata.t_p4Cursor[startdata.p4NumChars - #startdata.t_p4Selected + 1] = {startdata.p4SelX, startdata.p4SelY, startdata.p4FaceOffset, startdata.p4RowOffset}
            end
            startdata.p4SelEnd = true
        end
    end
end


return start4p