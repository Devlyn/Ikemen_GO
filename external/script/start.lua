local Startdata = require('external.script.objects.startdata')
local configservice = require('external.script.service.configservice')
local motiffile = require('external.script.motif')
local start = {}
local startdata = Startdata:new(nil, motif, configservice:getConfig(), main)

--;===========================================================
--; COMMON FUNCTIONS
--;===========================================================

--converts '.maxmatches' style table (key = order, value = max matches) to the same structure as '.ratiomatches' (key = match number, value = subtable with char num and order data)
function start.f_unifySettings(t, t_chars)
	local ret = {}
	for i = 1, #t do --for each order number
		if t_chars[i] ~= nil then --only if there are any characters available with this order
			local infinite = false
			local num = t[i]
			if num == -1 then --infinite matches
				num = #t_chars[i] --assign max amount of characters with this order
				infinite = true
			end
			for j = 1, num do --iterate up to max amount of matches versus characters with this order
				if j * startdata.p2NumChars > #t_chars[i] and #ret > 0 then --if there are not enough characters to fill all slots and at least 1 fight is already assigned
					local stop = true
					for k = (j - 1) * startdata.p2NumChars + 1, #t_chars[i] do --loop through characters left for this match
						if main.t_selChars[t_chars[i][k] + 1].single == 1 then --and allow appending if any of the remaining characters has 'single' flag set
							stop = false
						end
					end
					if stop then
						break
					end
				end
				table.insert(ret, { ['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = i})
			end
			if infinite then
				table.insert(ret, { ['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = -1})
				break --no point in appending additional matches
			end
		end
	end
	return ret
end

--generates roster table
function start.f_makeRoster(t_ret)
	t_ret = t_ret or {}
	--prepare correct settings tables
	local t = {}
	local t_static = {}
	local t_removable = {}
	--Arcade / Time Attack
	if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') or gamemode('timeattack') then
		t_static = main.t_orderChars
		if startdata.p2Ratio then --Ratio
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
			table.insert(t, { ['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = 1})
		end
		--VS 100 Kumite
	elseif gamemode('vs100kumite') then
		t_static = {main.t_randomChars}
		for i = 1, 100 do --generate ratiomatches style table for 100 matches
			table.insert(t, { ['rmin'] = startdata.p2NumChars, ['rmax'] = startdata.p2NumChars, ['order'] = 1})
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

--generates AI ramping table
function start.f_aiRamp(currentMatch)
	local start_match = 0
	local start_diff = 0
	local end_match = 0
	local end_diff = 0
	if currentMatch == 1 then
		startdata.t_aiRamp = {}
	end
	--Arcade
	if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') or gamemode('timeattack') then
		if startdata.p2TeamMode == 0 then --Single
			start_match = main.t_selOptions.arcadestart.wins
			start_diff = main.t_selOptions.arcadestart.offset
			end_match =  main.t_selOptions.arcadeend.wins
			end_diff = main.t_selOptions.arcadeend.offset
		elseif startdata.p2Ratio then --Ratio
			start_match = main.t_selOptions.ratiostart.wins
			start_diff = main.t_selOptions.ratiostart.offset
			end_match =  main.t_selOptions.ratioend.wins
			end_diff = main.t_selOptions.ratioend.offset
		else --Simul / Turns / Tag
			start_match = main.t_selOptions.teamstart.wins
			start_diff = main.t_selOptions.teamstart.offset
			end_match =  main.t_selOptions.teamend.wins
			end_diff = main.t_selOptions.teamend.offset
		end
	elseif gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
		start_match = main.t_selOptions.survivalstart.wins
		start_diff = main.t_selOptions.survivalstart.offset
		end_match =  main.t_selOptions.survivalend.wins
		end_diff = main.t_selOptions.survivalend.offset
	end
	local startAI = config.Difficulty + start_diff
	if startAI > 8 then
		startAI = 8
	elseif startAI < 1 then
		startAI = 1
	end
	local endAI = config.Difficulty + end_diff
	if endAI > 8 then
		endAI = 8
	elseif endAI < 1 then
		endAI = 1
	end
	for i = currentMatch, startdata.lastMatch do
		if i - 1 <= start_match then
			table.insert(startdata.t_aiRamp, startAI)
		elseif i - 1 <= end_match then
			local curMatch = i - (start_match + 1)
			table.insert(startdata.t_aiRamp, math.floor(curMatch * (endAI - startAI) / (end_match - start_match) + startAI))
		else
			table.insert(startdata.t_aiRamp, endAI)
		end
	end
	if main.debugLog then main.f_printTable(startdata.t_aiRamp, 'debug/t_aiRamp.txt') end
end

--returns bool depending of rivals match validity
function start.f_rivalsMatch(param, value)
	if main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals ~= nil and main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo] ~= nil then
		if param == nil then --check only if rivals assignment for this match exists at all
			return true
		elseif main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][param] ~= nil then
			if value == nil then --check only if param is assigned for this rival
				return true
			else --check if param equals value
				return main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][param] == value
			end
		end
	end
	return false
end

--calculates AI level
function start.f_difficulty(player, offset)
	local t = {}
	if player % 2 ~= 0 then --odd value (Player1 side)
		local pos = math.floor(player / 2 + 0.5)
		t = main.t_selChars[startdata.t_p1Selected[pos].ref + 1]
	else --even value (Player2 side)
		local pos = math.floor(player / 2)
		if pos == 1 and start.f_rivalsMatch('ai') then --player2 team leader and arcade mode and ai rivals param exists
			t = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo]
		else
			t = main.t_selChars[startdata.t_p2Selected[pos].ref + 1]
		end
	end
	if t.ai ~= nil then
		return t.ai
	else
		return config.Difficulty + offset
	end
end

--assigns AI level
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
					setCom(i, startdata.f_difficulty(i, offset))
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
end

--sets lifebar elements, round time, rounds to win
function start.f_setRounds()
	setLifebarElements(main.t_lifebar)
	--round time
	local frames = main.timeFramesPerCount
	local p1FramesMul = 1
	local p2FramesMul = 1
	if startdata.p1TeamMode == 3 then --Tag
		p1FramesMul = startdata.p1NumChars
	end
	if startdata.p2TeamMode == 3 then --Tag
		p2FramesMul = startdata.p2NumChars
	end
	frames = frames * math.max(p1FramesMul, p2FramesMul)
	setTimeFramesPerCount(frames)
	if main.t_charparam.time and main.t_charparam.rivals and start.f_rivalsMatch('time') then --round time assigned as rivals param
		setRoundTime(math.max(-1, main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].time * frames))
	elseif main.t_charparam.time and main.t_selChars[startdata.t_p2Selected[1].ref + 1].time ~= nil then --round time assigned as character param
		setRoundTime(math.max(-1, main.t_selChars[startdata.t_p2Selected[1].ref + 1].time * frames))
	else --default round time
		setRoundTime(math.max(-1, main.roundTime * frames))
	end
	--rounds to win
	if main.t_charparam.rounds and main.t_charparam.rivals and start.f_rivalsMatch('rounds') then --round num assigned as rivals param
		setMatchWins(main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].rounds)
	elseif main.t_charparam.rounds and main.t_selChars[startdata.t_p2Selected[1].ref + 1].rounds ~= nil then --round num assigned as character param
		setMatchWins(main.t_selChars[startdata.t_p2Selected[1].ref + 1].rounds)
	elseif startdata.p2TeamMode == 0 then --default rounds num (Single mode)
		setMatchWins(main.matchWins[1])
	else --default rounds num (Team mode)
		setMatchWins(main.matchWins[2])
	end
	setMatchMaxDrawGames(main.matchWins[3])
	--timer / score counter
	local timer = 0
	local t_score = {0, 0}
	if not startdata.challenger then
		t_score = { startdata.t_savedData.score.total[1], startdata.t_savedData.score.total[2]}
		timer = startdata.t_savedData.time.total
	end
	setLifebarTimer(timer)
	setLifebarScore(t_score[1], t_score[2])
end

--save data between matches
function start.f_saveData()
	if main.debugLog then main.f_printTable(startdata.t_gameStats, 'debug/t_gameStats.txt') end
	if startdata.winner == -1 then
		return
	end
	--win/lose matches count, total score
	if startdata.winner == 1 then
		startdata.t_savedData.win[1] = startdata.t_savedData.win[1] + 1
		startdata.t_savedData.lose[2] = startdata.t_savedData.lose[2] + 1
		startdata.t_savedData.score.total[1] = startdata.t_gameStats.p1score
	else --if winner == 2 then
		startdata.t_savedData.win[2] = startdata.t_savedData.win[2] + 1
		startdata.t_savedData.lose[1] = startdata.t_savedData.lose[1] + 1
		if main.resetScore then --loosing sets score for the next match to lose count
			startdata.t_savedData.score.total[1] = startdata.t_savedData.lose[1]
		else
			startdata.t_savedData.score.total[1] = startdata.t_gameStats.p1score
		end
	end
	startdata.t_savedData.score.total[2] = startdata.t_gameStats.p2score
	--total time
	startdata.t_savedData.time.total = startdata.t_savedData.time.total + startdata.t_gameStats.matchTime
	--time in each round
	table.insert(startdata.t_savedData.time.matches, startdata.t_gameStats.timerRounds)
	--score in each round
	table.insert(startdata.t_savedData.score.matches, startdata.t_gameStats.scoreRounds)
	--individual characters
	local t_cheat = {false, false}
	for round = 1, #startdata.t_gameStats.match do
		for c, v in ipairs(startdata.t_gameStats.match[round]) do
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
		elseif getConsecutiveWins(i) > startdata.t_savedData.consecutive[i] then
			startdata.t_savedData.consecutive[i] = getConsecutiveWins(i)
		end
	end
	if main.debugLog then main.f_printTable(startdata.t_savedData, 'debug/t_savedData.txt') end
end

--return sorted and capped table
local function f_formattedTable(t, append, f, size)
	local t = t or {}
	local size = size or -1
	local t_tmp = {}
	local tmp = 0
	table.insert(t, append)
	for _, v in main.f_sortKeys(t, f) do
		tmp = tmp + 1
		table.insert(t_tmp, v)
		if tmp == size then
			break
		end
	end
	return t_tmp
end

local function f_listCharRefs(t)
	local ret = {}
	for i = 1, #t do
		table.insert(ret, main.t_selChars[t[i].ref + 1].char:lower())
	end
	return ret
end

--data saving to stats.json
function f_saveStats()
	local file = io.open(main.flags['-stats'], 'w+')
	file:write(json.encode(stats, {indent = true}))
	file:close()
end

--store saved data to stats.json
function start.f_storeSavedData(mode, cleared)
	if stats.modes == nil then
		stats.modes = {}
	end
	stats.playtime = (stats.playtime or 0) + startdata.t_savedData.time.total / 60 --play time
	if stats.modes[mode] == nil then
		stats.modes[mode] = {}
	end
	local t = stats.modes[mode] --mode play time
	t.playtime = (t.playtime or 0) + startdata.t_savedData.time.total / 60
	if startdata.t_sortRanking[mode] == nil then
		f_saveStats()
		return --mode can't be cleared, so further data collecting is not needed
	end
	if cleared then
		t.clear = (t.clear or 0) + 1 --number times cleared
	elseif t.clear == nil then
		t.clear = 0
	end
	if not cleared and (mode == 'bossrush' or mode == 'scorechallenge' or mode == 'timechallenge') then
		return --only winning these modes produces ranking data
	end
	--rankings
	t.ranking = f_formattedTable(
			t.ranking,
			{
				['score'] = startdata.t_savedData.score.total[1],
				['time'] = startdata.t_savedData.time.total / 60,
				['name'] = startdata.t_savedData.name or '',
				['chars'] = f_listCharRefs(startdata.t_p1Selected),
				['tmode'] = startdata.p1TeamMode,
				['ailevel'] = config.Difficulty,
				['win'] = startdata.t_savedData.win[1],
				['lose'] = startdata.t_savedData.lose[1],
				['consecutive'] = startdata.t_savedData.consecutive[1]
			},
			startdata.t_sortRanking[mode],
			motif.rankings.max_entries
	)
	f_saveStats()
end

--sets stage
function start.f_setStage(num)
	num = num or 0
	--stage
	if not main.stageMenu and not startdata.continueData then
		if main.t_charparam.stage and main.t_charparam.rivals and start.f_rivalsMatch('stage') then --stage assigned as rivals param
			num = math.random(1, #main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].stage)
			num = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].stage[num]
		elseif main.t_charparam.stage and main.t_selChars[startdata.t_p2Selected[1].ref + 1].stage ~= nil then --stage assigned as character param
			num = math.random(1, #main.t_selChars[startdata.t_p2Selected[1].ref + 1].stage)
			num = main.t_selChars[startdata.t_p2Selected[1].ref + 1].stage[num]
		elseif (gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop')) and main.t_orderStages[main.t_selChars[startdata.t_p2Selected[1].ref + 1].order] ~= nil then --stage assigned as stage order param
			num = math.random(1, #main.t_orderStages[main.t_selChars[startdata.t_p2Selected[1].ref + 1].order])
			num = main.t_orderStages[main.t_selChars[startdata.t_p2Selected[1].ref + 1].order][num]
		else --stage randomly selected
			num = main.t_includeStage[1][math.random(1, #main.t_includeStage[1])]
		end
	end
	setStage(num)
	selectStage(num)
	return num
end

--sets music
function start.f_setMusic(num)
	startdata.t_music = { music = {}, musicalt = {}, musiclife = {}, musicvictory = {}}
	startdata.t_victoryBGM = {}
	for _, v in ipairs({'music', 'musicalt', 'musiclife', 'musicvictory', 'musicvictory'}) do
		local track = 0
		local music = ''
		local volume = 100
		local loopstart = 0
		local loopend = 0
		if main.stageMenu then --game modes with stage selection screen
			if main.t_selStages[num] ~= nil and main.t_selStages[num][v] ~= nil then --music assigned as stage param
				track = math.random(1, #main.t_selStages[num][v])
				music = main.t_selStages[num][v][track].bgmusic
				volume = main.t_selStages[num][v][track].bgmvolume
				loopstart = main.t_selStages[num][v][track].bgmloopstart
				loopend = main.t_selStages[num][v][track].bgmloopend
			end
		elseif not gamemode('demo') or motif.demo_mode.fight_playbgm == 1 then --game modes other than demo (or demo with stage BGM param enabled)
			if main.t_charparam.music and main.t_charparam.rivals and start.f_rivalsMatch(v) then --music assigned as rivals param
				track = math.random(1, #main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][v])
				music = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][v][track].bgmusic
				volume = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][v][track].bgmvolume
				loopstart = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][v][track].bgmloopstart
				loopend = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo][v][track].bgmloopend
			elseif main.t_charparam.music and main.t_selChars[startdata.t_p2Selected[1].ref + 1][v] ~= nil then --music assigned as character param
				track = math.random(1, #main.t_selChars[startdata.t_p2Selected[1].ref + 1][v])
				music = main.t_selChars[startdata.t_p2Selected[1].ref + 1][v][track].bgmusic
				volume = main.t_selChars[startdata.t_p2Selected[1].ref + 1][v][track].bgmvolume
				loopstart = main.t_selChars[startdata.t_p2Selected[1].ref + 1][v][track].bgmloopstart
				loopend = main.t_selChars[startdata.t_p2Selected[1].ref + 1][v][track].bgmloopend
			elseif main.t_selStages[num] ~= nil and main.t_selStages[num][v] ~= nil then --music assigned as stage param
				track = math.random(1, #main.t_selStages[num][v])
				music = main.t_selStages[num][v][track].bgmusic
				volume = main.t_selStages[num][v][track].bgmvolume
				loopstart = main.t_selStages[num][v][track].bgmloopstart
				loopend = main.t_selStages[num][v][track].bgmloopend
			end
		end
		if v == 'musicvictory' then
			table.insert(startdata.t_victoryBGM, music ~= '')
		end
		if music ~= '' or v == 'music' then
			if v == 'musicvictory' then
				startdata.t_music[v][#startdata.t_victoryBGM] = { bgmusic = music, bgmvolume = volume, bgmloopstart = loopstart, bgmloopend = loopend}
			else
				startdata.t_music[v] = { bgmusic = music, bgmvolume = volume, bgmloopstart = loopstart, bgmloopend = loopend}
			end
		end
	end
	for k, v in pairs({bgmtrigger_alt = 0, bgmratio_life = 30, bgmtrigger_life = 0}) do
		if main.t_selStages[num] ~= nil and main.t_selStages[num][k] ~= nil then
			startdata.t_music[k] = main.t_selStages[num][k]
		else
			startdata.t_music[k] = v
		end
	end
end

--remaps palette based on button press and character's keymap settings
function start.f_reampPal(ref, num)
	if main.t_selChars[ref + 1].pal_keymap[num] ~= nil then
		return main.t_selChars[ref + 1].pal_keymap[num]
	end
	return num
end

--returns palette number
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

--returns ratio level
function start.f_setRatio(player)
	if player == 1 then
		if not startdata.p1Ratio then
			return nil
		end
		return startdata.t_ratioArray[startdata.p1NumRatio][#startdata.t_p1Selected + 1]
	end
	if not startdata.p2Ratio then
		return nil
	end
	if not startdata.continueData and not main.p2SelectMenu and #startdata.t_p2Selected == 0 then
		if startdata.p2NumChars == 3 then
			startdata.p2NumRatio = math.random(1, 3)
		elseif startdata.p2NumChars == 2 then
			startdata.p2NumRatio = math.random(4, 6)
		else
			startdata.p2NumRatio = 7
		end
	end
	return startdata.t_ratioArray[startdata.p2NumRatio][#startdata.t_p2Selected + 1]
end

--sets life recovery and ratio level
function start.f_overrideCharData()
	--round 2+ in survival mode
	if startdata.matchNo >= 2 and (gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop')) then
		local lastRound = #startdata.t_gameStats.match
		local removedNum = 0
		local p1Count = 0
		--Turns
		if startdata.p1TeamMode == 2 then
			local t_p1Keys = {}
			--for each round in the last match
			for round = 1, #startdata.t_gameStats.match do
				--remove character from team if he/she has been defeated
				if not startdata.t_gameStats.match[round][1].win or startdata.t_gameStats.match[round][1].ko then
					table.remove(startdata.t_p1Selected, startdata.t_gameStats.match[round][1].memberNo + 1 - removedNum)
					removedNum = removedNum + 1
					startdata.p1NumChars = startdata.p1NumChars - 1
					--otherwise override character's next match life (done after all rounds have been checked)
				else
					t_p1Keys[startdata.t_gameStats.match[round][1].memberNo] = startdata.t_gameStats.match[round][1].life
				end
			end
			for k, v in pairs(t_p1Keys) do
				p1Count = p1Count + 1
				overrideCharData(p1Count, {['life'] = v})
			end
			--Single / Simul / Tag
		else
			--for each player data in the last round
			for player = 1, #startdata.t_gameStats.match[lastRound] do
				--only check P1 side characters
				if player % 2 ~= 0 and player <= (startdata.p1NumChars + removedNum) * 2 then --odd value, team size check just in case
					--in normal survival remove character from team if he/she has been defeated
					if gamemode('survival') and (not startdata.t_gameStats.match[lastRound][player].win or startdata.t_gameStats.match[lastRound][player].ko) then
						table.remove(startdata.t_p1Selected, startdata.t_gameStats.match[lastRound][player].memberNo + 1 - removedNum)
						removedNum = removedNum + 1
						startdata.p1NumChars = startdata.p1NumChars - 1
						--in coop modes defeated character can still fight
					elseif gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
						local life = startdata.t_gameStats.match[lastRound][player].life
						if life <= 0 then
							life = math.max(1, startdata.t_gameStats.match[lastRound][player].lifeMax * config.TurnsRecoveryBase)
						end
						overrideCharData(player, {['life'] = life})
						--otherwise override character's next match life
					else
						if p1Count == 0 then
							p1Count = 1
						else
							p1Count = p1Count + 2
						end
						overrideCharData(p1Count, {['life'] = startdata.t_gameStats.match[lastRound][player].life})
					end
				end
			end
		end
		if removedNum > 0 then
			setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars)
		end
	end
	--ratio level
	if startdata.p1Ratio then
		for i = 1, #startdata.t_p1Selected do
			setRatioLevel(i * 2 - 1, startdata.t_p1Selected[i].ratio)
			overrideCharData(i * 2 - 1, {['lifeRatio'] = config.RatioLife[startdata.t_p1Selected[i].ratio]})
			overrideCharData(i * 2 - 1, {['attackRatio'] = config.RatioAttack[startdata.t_p1Selected[i].ratio]})
		end
	end
	if startdata.p2Ratio then
		for i = 1, #startdata.t_p2Selected do
			setRatioLevel(i * 2, startdata.t_p2Selected[i].ratio)
			overrideCharData(i * 2, {['lifeRatio'] = config.RatioLife[startdata.t_p2Selected[i].ratio]})
			overrideCharData(i * 2, {['attackRatio'] = config.RatioAttack[startdata.t_p2Selected[i].ratio]})
		end
	end
end

--Convert number to name and get rid of the ""
function start.f_getName(ref)
	local tmp = getCharName(ref)
	if main.t_selChars[ref + 1].hidden == 3 then
		tmp = 'Random'
	elseif main.t_selChars[ref + 1].hidden == 2 then
		tmp = ''
	end
	return tmp
end

--draws character names
function start.f_drawName(t, data, font, offsetX, offsetY, scaleX, scaleY, height, spacingX, spacingY, active_font, active_row)
	for i = 1, #t do
		local x = offsetX
		local f = font
		if active_font and active_row then
			if i == active_row then
				f = active_font
			else
				f = font
			end
		end
		data:update({
			font =   f[1],
			bank =   f[2],
			align =  f[3],
			text =   start.f_getName(t[i].ref),
			x =      x + (i - 1) * spacingX,
			y =      offsetY + (i - 1) * spacingY,
			scaleX = scaleX,
			scaleY = scaleY,
			r =      f[4],
			g =      f[5],
			b =      f[6],
			src =    f[7],
			dst =    f[8],
			height = height,
		})
		data:draw()
	end
end

--returns correct cell position after moving the cursor
function start.f_cellMovement(selX, selY, cmd, faceOffset, rowOffset, snd)
	local tmpX = selX
	local tmpY = selY
	local tmpFace = faceOffset
	local tmpRow = rowOffset
	local found = false
	if main.f_input({cmd}, {'$U'}) then
		for i = 1, motif.select_info.rows + motif.select_info.rows_scrolling do
			selY = selY - 1
			if selY < 0 then
				if startdata.wrappingY then
					faceOffset = motif.select_info.rows_scrolling * motif.select_info.columns
					rowOffset = motif.select_info.rows_scrolling
					selY = motif.select_info.rows + motif.select_info.rows_scrolling - 1
				else
					faceOffset = tmpFace
					rowOffset = tmpRow
					selY = tmpY
				end
			elseif selY < rowOffset then
				faceOffset = faceOffset - motif.select_info.columns
				rowOffset = rowOffset - 1
			end
			if (startdata.t_grid[selY + 1][selX + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2) or motif.select_info.moveoveremptyboxes == 1 then
				break
			elseif motif.select_info.searchemptyboxesup ~= 0 then
				found, selX = start.f_searchEmptyBoxes(motif.select_info.searchemptyboxesup, selX, selY)
				if found then
					break
				end
			end
		end
	elseif main.f_input({cmd}, {'$D'}) then
		for i = 1, motif.select_info.rows + motif.select_info.rows_scrolling do
			selY = selY + 1
			if selY >= motif.select_info.rows + motif.select_info.rows_scrolling then
				if startdata.wrappingY then
					faceOffset = 0
					rowOffset = 0
					selY = 0
				else
					faceOffset = tmpFace
					rowOffset = tmpRow
					selY = tmpY
				end
			elseif selY >= motif.select_info.rows + rowOffset then
				faceOffset = faceOffset + motif.select_info.columns
				rowOffset = rowOffset + 1
			end
			if (startdata.t_grid[selY + 1][selX + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2) or motif.select_info.moveoveremptyboxes == 1 then
				break
			elseif motif.select_info.searchemptyboxesdown ~= 0 then
				found, selX = start.f_searchEmptyBoxes(motif.select_info.searchemptyboxesdown, selX, selY)
				if found then
					break
				end
			end
		end
	elseif main.f_input({cmd}, {'$B'}) then
		for i = 1, motif.select_info.columns do
			selX = selX - 1
			if selX < 0 then
				if startdata.wrappingX then
					selX = motif.select_info.columns - 1
				else
					selX = tmpX
				end
			end
			if (startdata.t_grid[selY + 1][selX + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2) or motif.select_info.moveoveremptyboxes == 1 then
				break
			end
		end
	elseif main.f_input({cmd}, {'$F'}) then
		for i = 1, motif.select_info.columns do
			selX = selX + 1
			if selX >= motif.select_info.columns then
				if startdata.wrappingX then
					selX = 0
				else
					selX = tmpX
				end
			end
			if (startdata.t_grid[selY + 1][selX + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2) or motif.select_info.moveoveremptyboxes == 1 then
				break
			end
		end
	end
	if tmpX ~= selX or tmpY ~= selY then
		startdata.resetgrid = true
		--if tmpRow ~= rowOffset then
		--start.f_resetGrid()
		--end
		sndPlay(motif.files.snd_data, snd[1], snd[2])
	end
	return selX, selY, faceOffset, rowOffset
end

--used by above function to find valid cell in case of dummy character entries
function start.f_searchEmptyBoxes(direction, x, y)
	local selX = x
	local selY = y
	local tmpX = x
	local found = false
	if direction > 0 then --right
		while true do
			x = x + 1
			if x >= motif.select_info.columns then
				x = tmpX
				break
			elseif startdata.t_grid[y + 1][x + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2 then
				found = true
				break
			end
		end
	elseif direction < 0 then --left
		while true do
			x = x - 1
			if x < 0 then
				x = tmpX
				break
			elseif startdata.t_grid[y + 1][x + 1].char ~= nil and startdata.t_grid[selY + 1][selX + 1].hidden ~= 2 then
				found = true
				break
			end
		end
	end
	return found, x
end

--generates table with cell coordinates
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
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
					row = row,
					col = col
				})
				--1Pのキャラ表示位置 / 1P character display position
			elseif startdata.t_grid[row + startdata.p1RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p1RowOffset][col].hidden == 0 then
				table.insert(startdata.t_drawFace, {
					d = 2,
					p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
					p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
					row = row,
					col = col
				})
				--Empty boxes display position
			elseif motif.select_info.showemptyboxes == 1 then
				table.insert(startdata.t_drawFace, {
					d = 0,
					p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
					p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
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
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
					row = row,
					col = col
				})
				--2Pのキャラ表示位置 / 2P character display position
			elseif startdata.t_grid[row + startdata.p2RowOffset][col].char ~= nil and startdata.t_grid[row + startdata.p2RowOffset][col].hidden == 0 then
				table.insert(startdata.t_drawFace, {
					d = 12,
					p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
					p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
					row = row,
					col = col
				})
				--Empty boxes display position
			elseif motif.select_info.showemptyboxes == 1 then
				table.insert(startdata.t_drawFace, {
					d = 10,
					p1 = startdata.t_grid[row + startdata.p1RowOffset][col].char_ref,
					p2 = startdata.t_grid[row + startdata.p2RowOffset][col].char_ref,
					x1 = startdata.p1FaceX + startdata.t_grid[row][col].x,
					x2 = startdata.p2FaceX + startdata.t_grid[row][col].x,
					y1 = startdata.p1FaceY + startdata.t_grid[row][col].y,
					y2 = startdata.p2FaceY + startdata.t_grid[row][col].y,
					row = row,
					col = col
				})
			end
		end
	end
	--if main.debugLog then main.f_printTable(start.t_drawFace, 'debug/t_drawFace.txt') end
end

--sets correct start cell
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
end

--unlocks characters on select screen
function start.f_unlockChar(char, flag)
	main.t_selChars[char + 1].hidden = flag
	startdata.t_grid[main.t_selChars[char + 1].row][main.t_selChars[char + 1].col].hidden = flag
	start.f_resetGrid()
end

--return t_selChars table out of cell number
function start.f_selGrid(cell)
	if #main.t_selGrid[cell].chars == 0 then
		return {}
	end
	return main.t_selChars[main.t_selGrid[cell].chars[main.t_selGrid[cell].slot]]
end

--return true if slot is selected, update start.t_grid
function start.f_slotSelected(cell, cmd, x, y)
	if #main.t_selGrid[cell].chars > 0 then
		for _, cmdType in ipairs({'select', 'next', 'previous'}) do
			if main.t_selGrid[cell][cmdType] ~= nil then
				for k, v in pairs(main.t_selGrid[cell][cmdType]) do
					if main.f_input({cmd}, {k}) then
						if cmdType == 'next' then
							local ok = false
							for i = 1, #v do
								if v[i] > main.t_selGrid[cell].slot then
									main.t_selGrid[cell].slot = v[i]
									ok = true
									break
								end
							end
							if not ok then
								main.t_selGrid[cell].slot = v[1]
								ok = true
							end
						elseif cmdType == 'previous' then
							local ok = false
							for i = #v, 1, -1 do
								if v[i] < main.t_selGrid[cell].slot then
									main.t_selGrid[cell].slot = v[i]
									ok = true
									break
								end
							end
							if not ok then
								main.t_selGrid[cell].slot = v[#v]
								ok = true
							end
						else --select
							main.t_selGrid[cell].slot = v[math.random(1, #v)]
						end
						startdata.t_grid[y + 1][x + 1].char = start.f_selGrid(cell).char
						startdata.t_grid[y + 1][x + 1].char_ref = start.f_selGrid(cell).char_ref
						start.f_resetGrid()
						return cmdType == 'select'
					end
				end
			end
		end
	end
	if main.f_btnPalNo(main.t_cmd[cmd]) == 0 then
		return false
	end
	return true
end

--
function start.f_faceOffset(col, row, key)
	if motif.select_info['cell_' .. col .. '_' .. row .. '_offset'] ~= nil then
		return motif.select_info['cell_' .. col .. '_' .. row .. '_offset'][key] or 0
	end
	return 0
end

startdata:initTgrid(start, motif)

if main.debugLog then main.f_printTable(startdata.t_grid, 'debug/t_grid.txt') end

--return formatted clear time string
function start.f_clearTimeText(text, totalSec)
	local h = tostring(math.floor(totalSec / 3600))
	local m = tostring(math.floor((totalSec / 3600 - h) * 60))
	local s = tostring(math.floor(((totalSec / 3600 - h) * 60 - m) * 60))
	local x = tostring(math.floor((((totalSec / 3600 - h) * 60 - m) * 60 - s) * 100))
	if string.len(m) < 2 then
		m = '0' .. m
	end
	if string.len(s) < 2 then
		s = '0' .. s
	end
	if string.len(x) < 2 then
		x = '0' .. x
	end
	return text:gsub('%%h', h):gsub('%%m', m):gsub('%%s', s):gsub('%%x', x)
end

--return formatted record text table
function start.f_getRecordText()
	if motif.select_info['record_' .. gamemode() .. '_text'] == nil or stats.modes == nil or stats.modes[gamemode()] == nil or stats.modes[gamemode()].ranking == nil or stats.modes[gamemode()].ranking[1] == nil then
		return {}
	end
	local text = motif.select_info['record_' .. gamemode() .. '_text']
	--time
	text = start.f_clearTimeText(text, stats.modes[gamemode()].ranking[1].time)
	--score
	text = text:gsub('%%p', tostring(stats.modes[gamemode()].ranking[1].score))
	--char name
	local name = '?' --in case character being removed from roster
	if main.t_charDef[stats.modes[gamemode()].ranking[1].chars[1]] ~= nil then
		name = main.t_selChars[main.t_charDef[stats.modes[gamemode()].ranking[1].chars[1]] + 1].displayname
	end
	text = text:gsub('%%c', name)
	--player name
	text = text:gsub('%%n', stats.modes[gamemode()].ranking[1].name)
	return main.f_extractText(text)
end

--cursor sound data, play cursor sound
function start.f_playWave(ref, name, g, n, loops)
	if g < 0 or n < 0 then return end
	if name == 'stage' then
		local a = main.t_selStages[ref].attachedChar
		if a == nil or a.sound == nil then
			return
		end
		if main.t_selStages[ref][name .. '_wave_data'] == nil then
			main.t_selStages[ref][name .. '_wave_data'] = getWaveData(a.dir .. a.sound, g, n, loops or -1)
		end
		wavePlay(main.t_selStages[ref][name .. '_wave_data'])
	else
		local sound = getCharSnd(ref)
		if sound == nil or sound == '' then
			return
		end
		if main.t_selChars[ref + 1][name .. '_wave_data'] == nil then
			main.t_selChars[ref + 1][name .. '_wave_data'] = getWaveData(main.t_selChars[ref + 1].dir .. sound, g, n, loops or -1)
		end
		wavePlay(main.t_selChars[ref + 1][name .. '_wave_data'])
	end
end

--resets various data
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
	startdata.t_p1Selected = {}
	startdata.t_p2Selected = {}
	startdata.p1TeamEnd = false
	startdata.p1SelEnd = false
	startdata.p1Ratio = false
	startdata.p2TeamEnd = false
	startdata.p2SelEnd = false
	startdata.p2Ratio = false
	if main.t_pIn[2] == 1 then
		startdata.p2TeamEnd = true
		startdata.p2SelEnd = true
	end
	if not main.p2SelectMenu then
		startdata.p2SelEnd = true
	end
	startdata.selScreenEnd = false
	startdata.stageEnd = false
	startdata.coopEnd = false
	startdata.restoreTeam = false
	startdata.continueData = false
	startdata.p1NumChars = 1
	startdata.p2NumChars = 1
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

--;===========================================================
--; SIMPLE LOOP (VS MODE, TEAM VERSUS, TRAINING, WATCH, BONUS GAMES, TIME CHALLENGE, SCORE CHALLENGE)
--;===========================================================
function start.f_selectSimple()
	start.f_startCell()
	startdata.t_p1Cursor = {}
	startdata.t_p2Cursor = {}
	startdata.p1RestoreCursor = false
	startdata.p2RestoreCursor = false
	startdata.p1TeamMenu = 1
	startdata.p2TeamMenu = 1
	startdata.p1FaceOffset = 0
	startdata.p2FaceOffset = 0
	startdata.p1RowOffset = 0
	startdata.p2RowOffset = 0
	startdata.stageList = 0
	while true do --outer loop (moved back here after pressing ESC)
		start.f_selectReset()
		while true do --inner loop
			startdata.fadeType = 'fadein'
			selectStart()
			if not start.f_selectScreen() then
				sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
				main.f_bgReset(motif.titlebgdef.bg)
				main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				return
			end
			--fight initialization
			start.f_overrideCharData()
			start.f_remapAI()
			start.f_setRounds()
			startdata.stageNo = start.f_setStage(startdata.stageNo)
			start.f_setMusic(startdata.stageNo)
			if start.f_selectVersus() == nil then break end
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

--;===========================================================
--; ARRANGED LOOP (SURVIVAL, SURVIVAL CO-OP, VS 100 KUMITE, BOSS RUSH)
--;===========================================================
function start.f_selectArranged()
	start.f_startCell()
	startdata.t_p1Cursor = {}
	startdata.t_p2Cursor = {}
	startdata.p1RestoreCursor = false
	startdata.p2RestoreCursor = false
	startdata.challenger = false
	startdata.p1TeamMenu = 1
	startdata.p2TeamMenu = 1
	startdata.p1FaceOffset = 0
	startdata.p2FaceOffset = 0
	startdata.p1RowOffset = 0
	startdata.p2RowOffset = 0
	startdata.stageList = 0
	while true do --outer loop (moved back here after pressing ESC)
		start.f_selectReset()
		while true do --inner loop
			startdata.fadeType = 'fadein'
			selectStart()
			if not start.f_selectScreen() then
				sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
				main.f_bgReset(motif.titlebgdef.bg)
				main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				return
			end
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
					table.insert(startdata.t_p2Selected, { ref = startdata.t_roster[startdata.matchNo][i], pal = start.f_selectPal(startdata.t_roster[startdata.matchNo][i]), ratio = start.f_setRatio(2)})
					if shuffle then
						main.f_tableShuffle(startdata.t_p2Selected)
					end
				end
			end
			--fight initialization
			setMatchNo(startdata.matchNo)
			start.f_overrideCharData()
			start.f_remapAI()
			start.f_setRounds()
			startdata.stageNo = start.f_setStage(startdata.stageNo)
			start.f_setMusic(startdata.stageNo)
			if start.f_selectVersus() == nil then break end
			clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
			loadStart()
			startdata.winner, startdata.t_gameStats = game()
			clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
			if gameend() then
				os.exit()
			end
			start.f_saveData()
			if startdata.winner == -1 then break end --player exit the game via ESC
			--player won in any mode or lost/draw in VS 100 Kumite mode
			if startdata.winner == 1 or gamemode('vs100kumite') then
				--infinite matches flag detected
				if startdata.t_roster[startdata.matchNo + 1] ~= nil and startdata.t_roster[startdata.matchNo + 1][1] == -1 then
					--remove flag
					table.remove(startdata.t_roster, startdata.matchNo + 1)
					--append entries to existing roster table
					startdata.t_roster = start.f_makeRoster(startdata.t_roster)
					local lastMatchRamp = startdata.lastMatch + 1
					startdata.lastMatch = #startdata.t_roster
					--append new entries to existing AI ramping table
					start.f_aiRamp(lastMatchRamp)
				end
				--no more matches left
				if startdata.matchNo == startdata.lastMatch then
					--store saved data to stats.json
					start.f_storeSavedData(gamemode(), true)
					--credits
					if motif.end_credits.enabled == 1 and main.f_fileExists(motif.end_credits.storyboard) then
						storyboard.f_storyboard(motif.end_credits.storyboard)
					end
					--game over
					if motif.game_over_screen.enabled == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
						storyboard.f_storyboard(motif.game_over_screen.storyboard)
					end
					--intro
					if motif.files.intro_storyboard ~= '' then
						storyboard.f_storyboard(motif.files.intro_storyboard)
					end
					main.f_bgReset(motif.titlebgdef.bg)
					main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
					return
					--next match available
				else
					startdata.matchNo = startdata.matchNo + 1
					startdata.t_p2Selected = {}
				end
				--player lost
			elseif startdata.winner ~= -1 then
				--store saved data to stats.json
				start.f_storeSavedData(gamemode(), true and gamemode() ~= 'bossrush')
				--game over
				if motif.game_over_screen.enabled == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
					storyboard.f_storyboard(motif.game_over_screen.storyboard)
				end
				--intro
				if motif.files.intro_storyboard ~= '' then
					storyboard.f_storyboard(motif.files.intro_storyboard)
				end
				main.f_bgReset(motif.titlebgdef.bg)
				main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				return
			end
			--main.f_cmdInput()
			refresh()
		end
		esc(false) --reset ESC
		if gamemode('netplaysurvivalcoop') then
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

--;===========================================================
--; ARCADE LOOP (ARCADE, TEAM ARCADE, TEAM CO-OP, TIME ATTACK)
--;===========================================================
function start.f_selectArcade()
	start.f_startCell()
	startdata.t_p1Cursor = {}
	startdata.t_p2Cursor = {}
	startdata.p1RestoreCursor = false
	startdata.p2RestoreCursor = false
	startdata.challenger = false
	startdata.p1TeamMenu = 1
	startdata.p2TeamMenu = 1
	startdata.p1FaceOffset = 0
	startdata.p2FaceOffset = 0
	startdata.p1RowOffset = 0
	startdata.p2RowOffset = 0
	--stageEnd = true
	local teamMode = 0
	local numChars = 0
	while true do --outer loop (moved back here after pressing ESC)
		start.f_selectReset()
		while true do --inner loop
			startdata.fadeType = 'fadein'
			selectStart()
			--select screen
			if not start.f_selectScreen() then
				sndPlay(motif.files.snd_data, motif.select_info.cancel_snd[1], motif.select_info.cancel_snd[2])
				main.f_bgReset(motif.titlebgdef.bg)
				main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				return
			end
			--first match
			if startdata.matchNo == 0 then
				--generate roster
				startdata.t_roster = start.f_makeRoster()
				startdata.lastMatch = #startdata.t_roster
				startdata.matchNo = 1
				--generate AI ramping table
				start.f_aiRamp(1)
				--intro
				if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') then --not timeattack
					local tPos = main.t_selChars[startdata.t_p1Selected[1].ref + 1]
					if tPos.intro ~= nil and main.f_fileExists(tPos.intro) then
						storyboard.f_storyboard(tPos.intro)
					end
				end
			end
			--assign enemy team
			local enemy_ref = 0
			if #startdata.t_p2Selected == 0 then
				if startdata.p2NumChars ~= #startdata.t_roster[startdata.matchNo] then
					startdata.p2NumChars = #startdata.t_roster[startdata.matchNo]
					setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
				end
				local shuffle = true
				for i = 1, #startdata.t_roster[startdata.matchNo] do
					if i == 1 and start.f_rivalsMatch('char_ref') then --enemy assigned as rivals param
						enemy_ref = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].char_ref
						shuffle = false
					else
						enemy_ref = startdata.t_roster[startdata.matchNo][i]
					end
					table.insert(startdata.t_p2Selected, { ref = enemy_ref, pal = start.f_selectPal(enemy_ref), ratio = start.f_setRatio(2)})
					if shuffle then
						main.f_tableShuffle(startdata.t_p2Selected)
					end
				end
			end
			--Team conversion to Single match if single paramvalue on any opponents is detected
			if startdata.p2NumChars > 1 then
				for i = 1, #startdata.t_p2Selected do
					local single = false
					if start.f_rivalsMatch('char_ref') and start.f_rivalsMatch('single', 1) then --team conversion assigned as rivals param
						enemy_ref = main.t_selChars[startdata.t_p1Selected[1].ref + 1].rivals[startdata.matchNo].char_ref
						single = true
					elseif main.t_selChars[startdata.t_p2Selected[i].ref + 1].single == 1 then --team conversion assigned as character param
						enemy_ref = startdata.t_p2Selected[i].ref
						single = true
					end
					if single then
						teamMode = startdata.p2TeamMode
						numChars = startdata.p2NumChars
						startdata.p2TeamMode = 0
						startdata.p2NumChars = 1
						setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
						startdata.t_p2Selected = {}
						startdata.t_p2Selected[1] = { ref = enemy_ref, pal = start.f_selectPal(enemy_ref)}
						startdata.restoreTeam = true
						break
					end
				end
			end
			--fight initialization
			startdata.challenger = false
			setMatchNo(startdata.matchNo)
			start.f_overrideCharData()
			start.f_remapAI()
			start.f_setRounds()
			startdata.stageNo = start.f_setStage(startdata.stageNo)
			start.f_setMusic(startdata.stageNo)
			if start.f_selectVersus() == nil then break end
			clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
			loadStart()
			startdata.winner, startdata.t_gameStats = game()
			clearColor(motif.selectbgdef.bgclearcolor[1], motif.selectbgdef.bgclearcolor[2], motif.selectbgdef.bgclearcolor[3])
			if gameend() then
				os.exit()
			end
			start.f_saveData()
			if startdata.t_gameStats.challenger > 0 then --here comes a new challenger
				start.f_challenger()
			elseif startdata.winner == -1 then --player exit the game via ESC
				break
			elseif startdata.winner == 1 then --player won
				--no more matches left
				if startdata.matchNo == startdata.lastMatch then
					--store saved data to stats.json
					start.f_storeSavedData(gamemode(), true)
					--ending
					if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') then --not timeattack
						local tPos = main.t_selChars[startdata.t_p1Selected[1].ref + 1]
						if tPos.ending ~= nil and main.f_fileExists(tPos.ending) then
							storyboard.f_storyboard(tPos.ending)
						elseif motif.default_ending.enabled == 1 and main.f_fileExists(motif.default_ending.storyboard) then
							storyboard.f_storyboard(motif.default_ending.storyboard)
						end
					end
					--credits
					if motif.end_credits.enabled == 1 and main.f_fileExists(motif.end_credits.storyboard) then
						storyboard.f_storyboard(motif.end_credits.storyboard)
					end
					--game over
					if motif.game_over_screen.enabled == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
						storyboard.f_storyboard(motif.game_over_screen.storyboard)
					end
					--intro
					if motif.files.intro_storyboard ~= '' then
						storyboard.f_storyboard(motif.files.intro_storyboard)
					end
					main.f_bgReset(motif.titlebgdef.bg)
					main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
					return
					--next match available
				else
					startdata.matchNo = startdata.matchNo + 1
					startdata.continueData = false
					startdata.t_p2Selected = {}
				end
				--player lost and doesn't have any credits left
			elseif main.credits == 0 then
				--store saved data to stats.json
				start.f_storeSavedData(gamemode(), false)
				--game over
				if motif.game_over_screen.enabled == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
					storyboard.f_storyboard(motif.game_over_screen.storyboard)
				end
				--intro
				if motif.files.intro_storyboard ~= '' then
					storyboard.f_storyboard(motif.files.intro_storyboard)
				end
				main.f_bgReset(motif.titlebgdef.bg)
				main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
				return
				--player lost but can continue
			else
				--continue screen
				if not gamemode('netplayteamcoop') then
					if not startdata.continueFlag then
						--store saved data to stats.json
						start.f_storeSavedData(gamemode(), false)
						--game over
						if motif.continue_screen.external_gameover == 1 and main.f_fileExists(motif.game_over_screen.storyboard) then
							storyboard.f_storyboard(motif.game_over_screen.storyboard)
						end
						--intro
						if motif.files.intro_storyboard ~= '' then
							storyboard.f_storyboard(motif.files.intro_storyboard)
						end
						main.f_bgReset(motif.titlebgdef.bg)
						main.f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
						return
					end
				end
				--character selection
				if (not main.quickContinue and not config.QuickContinue) or gamemode('netplayteamcoop') then --true if 'Quick Continue' is disabled or we're playing online
					startdata.t_p1Selected = {}
					startdata.p1SelEnd = false
					startdata.selScreenEnd = false
				end
				startdata.continueData = true
			end
			--restore P2 Team settings if needed
			if startdata.restoreTeam then
				startdata.p2TeamMode = teamMode
				startdata.p2NumChars = numChars
				setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
				startdata.restoreTeam = false
			end
			--main.f_cmdInput()
			refresh()
		end
		esc(false) --reset ESC
		if gamemode() == 'netplayteamcoop' then
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

function start.f_challenger()
	esc(false)
	startdata.challenger = true
	--save values
	local t_p1Selected_sav = main.f_tableCopy(startdata.t_p1Selected)
	local t_p2Selected_sav = main.f_tableCopy(startdata.t_p2Selected)
	local p1TeamMenu_sav = main.f_tableCopy(main.p1TeamMenu)
	local p2TeamMenu_sav = main.f_tableCopy(main.p2TeamMenu)
	local t_charparam_sav = main.f_tableCopy(main.t_charparam)
	local p1Ratio_sav = startdata.p1Ratio
	local p2Ratio_sav = startdata.p2Ratio
	local p1NumRatio_sav = startdata.p1NumRatio
	local p2NumRatio_sav = startdata.p2NumRatio
	local p1Cell_sav = startdata.p1Cell
	local p2Cell_sav = startdata.p2Cell
	local winCnt_sav = startdata.winCnt
	local loseCnt_sav = startdata.loseCnt
	local matchNo_sav = startdata.matchNo
	local stageNo_sav = startdata.stageNo
	local restoreTeam_sav = startdata.restoreTeam
	local p1TeamMode_sav = startdata.p1TeamMode
	local p1NumChars_sav = startdata.p1NumChars
	local p2TeamMode_sav = startdata.p2TeamMode
	local p2NumChars_sav = startdata.p2NumChars
	local gameMode = gamemode()
	local p1score_sav = main.t_lifebar.p1score
	local p2score_sav = main.t_lifebar.p2score
	--temp mode data
	main.txt_mainSelect:update({text = motif.select_info.title_teamversus_text})
	setHomeTeam(1)
	startdata.p2NumRatio = 1
	main.t_pIn[2] = 2
	main.p2SelectMenu = true
	main.stageMenu = true
	main.p2Faces = true
	main.p1TeamMenu = {single = true, simul = true, turns = true, tag = true, ratio = true}
	main.p2TeamMenu = {single = true, simul = true, turns = true, tag = true, ratio = true}
	main.t_lifebar.p1score = true
	main.t_lifebar.p2score = true
	main.f_resetCharparam()
	setgamemode('teamversus')
	--start challenger match
	start.f_selectSimple()
	--restore mode data
	main.txt_mainSelect:update({text = motif.select_info.title_arcade_text})
	setHomeTeam(2)
	main.t_pIn[2] = 1
	main.p2SelectMenu = false
	main.stageMenu = false
	main.p2Faces = false
	main.p1TeamMenu = p1TeamMenu_sav
	main.p2TeamMenu = p2TeamMenu_sav
	main.t_lifebar.p1score = p1score_sav
	main.t_lifebar.p2score = p2score_sav
	main.t_charparam = t_charparam_sav
	setgamemode(gameMode)
	if esc() or main.f_input(main.t_players, {'m'}) then
		startdata.challenger = false
		start.f_selectReset()
		return
	end
	if getConsecutiveWins(1) > 0 then
		setConsecutiveWins(1, getConsecutiveWins(1) - 1)
	end
	if startdata.winner == 2 then
		--TODO: when player1 team lose continue playing the arcade mode as player2 team
	end
	--restore values
	startdata.p1TeamEnd = true
	startdata.p2TeamEnd = true
	startdata.p1SelEnd = true
	startdata.p2SelEnd = true
	startdata.t_p1Selected = t_p1Selected_sav
	startdata.t_p2Selected = t_p2Selected_sav
	startdata.p1Ratio = p1Ratio_sav
	startdata.p2Ratio = p2Ratio_sav
	startdata.p1NumRatio = p1NumRatio_sav
	startdata.p2NumRatio = p2NumRatio_sav
	startdata.p1Cell = p1Cell_sav
	startdata.p2Cell = p2Cell_sav
	startdata.winCnt = winCnt_sav
	startdata.loseCnt = loseCnt_sav
	startdata.matchNo = matchNo_sav
	startdata.stageNo = stageNo_sav
	startdata.restoreTeam = restoreTeam_sav
	startdata.p1TeamMode = p1TeamMode_sav
	startdata.p1NumChars = p1NumChars_sav
	setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars)
	startdata.p2TeamMode = p2TeamMode_sav
	startdata.p2NumChars = p2NumChars_sav
	setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
	startdata.continueData = true
end

--;===========================================================
--; TOURNAMENT LOOP
--;===========================================================
function start.f_selectTournament(size)
	return
end

--;===========================================================
--; TOURNAMENT SCREEN
--;===========================================================
function start.f_selectTournamentScreen(size)
	--draw clearcolor
	clearColor(motif.tournamentbgdef.bgclearcolor[1], motif.tournamentbgdef.bgclearcolor[2], motif.tournamentbgdef.bgclearcolor[3])
	--draw layerno = 0 backgrounds
	bgDraw(motif.tournamentbgdef.bg, false)
	--draw layerno = 1 backgrounds
	bgDraw(motif.tournamentbgdef.bg, true)
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
	elseif startdata.fadeType == 'fadeout' then
		commandBufReset(main.t_cmd[1])
		return --skip last frame rendering
	else
		main.f_cmdInput()
	end
	refresh()
end

--;===========================================================
--; SELECT SCREEN
--;===========================================================
function start.f_selectScreen()
	if startdata.selScreenEnd then
		return true
	end
	main.f_bgReset(motif.selectbgdef.bg)
	main.f_playBGM(true, motif.music.select_bgm, motif.music.select_bgm_loop, motif.music.select_bgm_volume, motif.music.select_bgm_loopstart, motif.music.select_bgm_loopend)
	local t_enemySelected = {}
	local numChars = startdata.p2NumChars
	if main.coop and startdata.matchNo > 0 then --coop swap after first match
		t_enemySelected = main.f_tableCopy(startdata.t_p2Selected)
		startdata.p1NumChars = 1
		startdata.p2NumChars = 1
		startdata.t_p2Selected = {}
		startdata.p2SelEnd = false
	end
	startdata.timerSelect = 0
	while not startdata.selScreenEnd do
		if esc() or main.f_input(main.t_players, {'m'}) then
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
				if #t_portrait < motif.select_info.p1_face_num then
					table.insert(t_portrait, startdata.t_p1Selected[i].ref)
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
				if #t_portrait < motif.select_info.p2_face_num then
					table.insert(t_portrait, startdata.t_p2Selected[i].ref)
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
		--draw cell art
		for i = 1, #startdata.t_drawFace do
			--P1 side check before drawing
			if startdata.t_drawFace[i].d <= 2 then
				--draw cell background
				main.f_animPosDraw(
						motif.select_info.cell_bg_data,
						startdata.t_drawFace[i].x1,
						startdata.t_drawFace[i].y1,
						(motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
				)
				--draw random cell
				if startdata.t_drawFace[i].d == 1 then
					main.f_animPosDraw(
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
				main.f_animPosDraw(
						motif.select_info.cell_bg_data,
						startdata.t_drawFace[i].x2,
						startdata.t_drawFace[i].y2,
						(motif.select_info['cell_' .. startdata.t_drawFace[i].col .. '_' .. startdata.t_drawFace[i].row .. '_facing'] or 1)
				)
				--draw random cell
				if startdata.t_drawFace[i].d == 11 then
					main.f_animPosDraw(
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
				main.f_animPosDraw(
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
				main.f_animPosDraw(
						motif.select_info.p2_cursor_done_data,
						startdata.t_p2Selected[i].cursor[1],
						startdata.t_p2Selected[i].cursor[2],
						startdata.t_p2Selected[i].cursor[4]
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
		--draw timer
		if motif.select_info.timer_enabled == 1 and startdata.p1TeamEnd and (startdata.p2TeamEnd or not main.p2SelectMenu) then
			local num = math.floor((motif.select_info.timer_count * motif.select_info.timer_framespercount - startdata.timerSelect + motif.select_info.timer_displaytime) / motif.select_info.timer_framespercount + 0.5)
			if num <= -1 then
				startdata.timerSelect = -1
				startdata.txt_timerSelect:update({ text = 0})
			else
				startdata.timerSelect = startdata.timerSelect + 1
				startdata.txt_timerSelect:update({ text = math.max(0, num)})
			end
			if startdata.timerSelect >= motif.select_info.timer_displaytime then
				startdata.txt_timerSelect:draw()
			end
		end
		--draw record text
		for i = 1, #startdata.t_recordText do
			startdata.txt_recordSelect:update({
				text = startdata.t_recordText[i],
				y = motif.select_info.record_offset[2] + main.f_ySpacing(motif.select_info, 'record_font') * (i - 1),
			})
			startdata.txt_recordSelect:draw()
		end
		--team and character selection complete
		if startdata.p1SelEnd and startdata.p2SelEnd and startdata.p1TeamEnd and startdata.p2TeamEnd then
			startdata.p1RestoreCursor = true
			startdata.p2RestoreCursor = true
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
			main.f_cmdInput()
		end
		main.f_refresh()
	end
	if startdata.matchNo == 0 then --team mode set
		if main.coop then --coop swap before first match
			startdata.p1NumChars = 2
			startdata.t_p1Selected[2] = { ref = startdata.t_p2Selected[1].ref, pal = startdata.t_p2Selected[1].pal}
			startdata.t_p2Selected = {}
		end
		setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars)
		setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
	elseif main.coop then --coop swap after first match
		startdata.p1NumChars = 2
		startdata.p2NumChars = numChars
		startdata.t_p1Selected[2] = { ref = startdata.t_p2Selected[1].ref, pal = startdata.t_p2Selected[1].pal}
		startdata.t_p2Selected = t_enemySelected
	end
	return true
end

--;===========================================================
--; PLAYER 1 TEAM MENU
--;===========================================================
t_p1TeamMenuSorted = main.f_tableClean(startdata.t_p1TeamMenu, main.t_sort.select_info)

function start.f_p1TeamMenu()
	local t = {}
	for k, v in ipairs(t_p1TeamMenuSorted) do
		if main.p1TeamMenu[v.itemname] then
			table.insert(t, v)
		end
	end
	if #t == 0 then --all valid team modes disabled by screenpack
		for k, v in ipairs(startdata.t_p1TeamMenu) do
			if main.p1TeamMenu[v.itemname] then
				table.insert(t, v)
				break
			end
		end
	end
	if #t == 1 then --only 1 team mode available, skip selection
		startdata.p1TeamMode = t[1].mode
		if t[1].itemname.ratio ~= nil then
			startdata.p1NumRatio = t[1].chars
			if startdata.p1NumRatio <= 3 then
				startdata.p1NumChars = 3
			elseif startdata.p1NumRatio <= 6 then
				startdata.p1NumChars = 2
			else
				startdata.p1NumChars = 1
			end
			startdata.p1Ratio = true
		else
			startdata.p1NumChars = t[1].chars
		end
		setTeamMode(1, startdata.p1TeamMode, startdata.p1NumChars)
		startdata.p1TeamEnd = true
	else
		--Calculate team cursor position
		if startdata.p1TeamMenu > #t then
			startdata.p1TeamMenu = 1
		end
		if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_previous)) then
			if startdata.p1TeamMenu > 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_move_snd[1], motif.select_info.p1_teammenu_move_snd[2])
				startdata.p1TeamMenu = startdata.p1TeamMenu - 1
			elseif motif.select_info.teammenu_move_wrapping == 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_move_snd[1], motif.select_info.p1_teammenu_move_snd[2])
				startdata.p1TeamMenu = #t
			end
		elseif main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_next)) then
			if startdata.p1TeamMenu < #t then
				sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_move_snd[1], motif.select_info.p1_teammenu_move_snd[2])
				startdata.p1TeamMenu = startdata.p1TeamMenu + 1
			elseif motif.select_info.teammenu_move_wrapping == 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_move_snd[1], motif.select_info.p1_teammenu_move_snd[2])
				startdata.p1TeamMenu = 1
			end
		elseif not main.coop then
			if t[startdata.p1TeamMenu].itemname == 'simul' then
				if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
					if startdata.p1NumSimul > config.NumSimul[1] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumSimul = startdata.p1NumSimul - 1
					end
				elseif main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
					if startdata.p1NumSimul < config.NumSimul[2] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumSimul = startdata.p1NumSimul + 1
					end
				end
			elseif t[startdata.p1TeamMenu].itemname == 'turns' then
				if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
					if startdata.p1NumTurns > config.NumTurns[1] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumTurns = startdata.p1NumTurns - 1
					end
				elseif main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
					if startdata.p1NumTurns < config.NumTurns[2] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumTurns = startdata.p1NumTurns + 1
					end
				end
			elseif t[startdata.p1TeamMenu].itemname == 'tag' then
				if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
					if startdata.p1NumTag > config.NumTag[1] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumTag = startdata.p1NumTag - 1
					end
				elseif main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
					if startdata.p1NumTag < config.NumTag[2] then
						sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
						startdata.p1NumTag = startdata.p1NumTag + 1
					end
				end
			elseif t[startdata.p1TeamMenu].itemname == 'ratio' then
				if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
					sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
					if startdata.p1NumRatio > 1 then
						startdata.p1NumRatio = startdata.p1NumRatio - 1
					else
						startdata.p1NumRatio = 7
					end
				elseif main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
					sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_value_snd[1], motif.select_info.p1_teammenu_value_snd[2])
					if startdata.p1NumRatio < 7 then
						startdata.p1NumRatio = startdata.p1NumRatio + 1
					else
						startdata.p1NumRatio = 1
					end
				end
			end
		end
		--Draw team background
		main.t_animUpdate[motif.select_info.p1_teammenu_bg_data] = 1
		animDraw(motif.select_info.p1_teammenu_bg_data)
		--Draw team active element background
		main.t_animUpdate[motif.select_info['p1_teammenu_bg_' .. t[startdata.p1TeamMenu].itemname .. '_data']] = 1
		animDraw(motif.select_info['p1_teammenu_bg_' .. t[startdata.p1TeamMenu].itemname .. '_data'])
		--Draw team cursor
		main.f_animPosDraw(
				motif.select_info.p1_teammenu_item_cursor_data,
				(startdata.p1TeamMenu - 1) * motif.select_info.p1_teammenu_item_spacing[1],
				(startdata.p1TeamMenu - 1) * motif.select_info.p1_teammenu_item_spacing[2]
		)
		--Draw team title
		main.t_animUpdate[motif.select_info.p1_teammenu_selftitle_data] = 1
		animDraw(motif.select_info.p1_teammenu_selftitle_data)
		startdata.txt_p1TeamSelfTitle:draw()
		for i = 1, #t do
			if i == startdata.p1TeamMenu then
				if startdata.p1TeamActiveCount < 2 then --delay change
					startdata.p1TeamActiveCount = startdata.p1TeamActiveCount + 1
				elseif startdata.p1TeamActiveType == 'p1_teammenu_item_active' then
					startdata.p1TeamActiveType = 'p1_teammenu_item_active2'
					startdata.p1TeamActiveCount = 0
				else
					startdata.p1TeamActiveType = 'p1_teammenu_item_active'
					startdata.p1TeamActiveCount = 0
				end
				--Draw team active font
				t[i].data:update({
					font =   motif.select_info[startdata.p1TeamActiveType .. '_font'][1],
					bank =   motif.select_info[startdata.p1TeamActiveType .. '_font'][2],
					align =  motif.select_info[startdata.p1TeamActiveType .. '_font'][3], --p1_teammenu_item_font (winmugen ignores active font facing? Fixed in mugen 1.0)
					text =   t[i].displayname,
					x =      motif.select_info.p1_teammenu_pos[1] + motif.select_info.p1_teammenu_item_offset[1] + motif.select_info.p1_teammenu_item_spacing[1] * (i - 1),
					y =      motif.select_info.p1_teammenu_pos[2] + motif.select_info.p1_teammenu_item_offset[2] + motif.select_info.p1_teammenu_item_spacing[2] * (i - 1),
					scaleX = motif.select_info[startdata.p1TeamActiveType .. '_font_scale'][1],
					scaleY = motif.select_info[startdata.p1TeamActiveType .. '_font_scale'][2],
					r =      motif.select_info[startdata.p1TeamActiveType .. '_font'][4],
					g =      motif.select_info[startdata.p1TeamActiveType .. '_font'][5],
					b =      motif.select_info[startdata.p1TeamActiveType .. '_font'][6],
					src =    motif.select_info[startdata.p1TeamActiveType .. '_font'][7],
					dst =    motif.select_info[startdata.p1TeamActiveType .. '_font'][8],
					height = motif.select_info[startdata.p1TeamActiveType .. '_font_height'],
				})
				t[i].data:draw()
			else
				--Draw team not active font
				t[i].data:update({
					font =   motif.select_info.p1_teammenu_item_font[1],
					bank =   motif.select_info.p1_teammenu_item_font[2],
					align =  motif.select_info.p1_teammenu_item_font[3], --p1_teammenu_item_font (winmugen ignores active font facing? Fixed in mugen 1.0)
					text =   t[i].displayname,
					x =      motif.select_info.p1_teammenu_pos[1] + motif.select_info.p1_teammenu_item_offset[1] + motif.select_info.p1_teammenu_item_spacing[1] * (i - 1),
					y =      motif.select_info.p1_teammenu_pos[2] + motif.select_info.p1_teammenu_item_offset[2] + motif.select_info.p1_teammenu_item_spacing[2] * (i - 1),
					scaleX = motif.select_info.p1_teammenu_item_font_scale[1],
					scaleY = motif.select_info.p1_teammenu_item_font_scale[2],
					r =      motif.select_info.p1_teammenu_item_font[4],
					g =      motif.select_info.p1_teammenu_item_font[5],
					b =      motif.select_info.p1_teammenu_item_font[6],
					src =    motif.select_info.p1_teammenu_item_font[7],
					dst =    motif.select_info.p1_teammenu_item_font[8],
					height = motif.select_info.p1_teammenu_item_font_height,
				})
				t[i].data:draw()
			end
			--Draw team icons
			if not main.coop then
				if t[i].itemname == 'simul' then
					for j = 1, config.NumSimul[2] do
						if j <= startdata.p1NumSimul then
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						else
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_empty_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						end
					end
				elseif t[i].itemname == 'turns' then
					for j = 1, config.NumTurns[2] do
						if j <= startdata.p1NumTurns then
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						else
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_empty_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						end
					end
				elseif t[i].itemname == 'tag' then
					for j = 1, config.NumTag[2] do
						if j <= startdata.p1NumTag then
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						else
							main.f_animPosDraw(
									motif.select_info.p1_teammenu_value_empty_icon_data,
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[1],
									(i - 1) * motif.select_info.p1_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p1_teammenu_value_spacing[2]
							)
						end
					end
				elseif t[i].itemname == 'ratio' and startdata.p1TeamMenu == i then
					main.t_animUpdate[motif.select_info['p1_teammenu_ratio' .. startdata.p1NumRatio .. '_icon_data']] = 1
					animDraw(motif.select_info['p1_teammenu_ratio' .. startdata.p1NumRatio .. '_icon_data'])
				end
			end
		end
		--Confirmed team selection
		if main.f_input({1}, main.f_extractKeys(motif.select_info.teammenu_key_accept)) then
			sndPlay(motif.files.snd_data, motif.select_info.p1_teammenu_done_snd[1], motif.select_info.p1_teammenu_done_snd[2])
			if main.coop then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				startdata.p1NumChars = 1
			elseif t[startdata.p1TeamMenu].itemname == 'single' then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				startdata.p1NumChars = 1
			elseif t[startdata.p1TeamMenu].itemname == 'simul' then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				startdata.p1NumChars = startdata.p1NumSimul
			elseif t[startdata.p1TeamMenu].itemname == 'turns' then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				startdata.p1NumChars = startdata.p1NumTurns
			elseif t[startdata.p1TeamMenu].itemname == 'tag' then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				startdata.p1NumChars = startdata.p1NumTag
			elseif t[startdata.p1TeamMenu].itemname == 'ratio' then
				startdata.p1TeamMode = t[startdata.p1TeamMenu].mode
				if startdata.p1NumRatio <= 3 then
					startdata.p1NumChars = 3
				elseif startdata.p1NumRatio <= 6 then
					startdata.p1NumChars = 2
				else
					startdata.p1NumChars = 1
				end
				startdata.p1Ratio = true
			end
			startdata.p1TeamEnd = true
			--main.f_cmdInput()
		end
	end
end

--;===========================================================
--; PLAYER 2 TEAM MENU
--;===========================================================
t_p2TeamMenuSorted = main.f_tableClean(startdata.t_p2TeamMenu, main.t_sort.select_info)

function start.f_p2TeamMenu()
	if main.coop and not startdata.p1TeamEnd then
		return
	end
	local t = {}
	for k, v in ipairs(t_p2TeamMenuSorted) do
		if main.p2TeamMenu[v.itemname] then
			table.insert(t, v)
		end
	end
	if #t == 0 then --all valid team modes disabled by screenpack
		for k, v in ipairs(startdata.t_p2TeamMenu) do
			if main.p2TeamMenu[v.itemname] then
				table.insert(t, v)
				break
			end
		end
	end
	if #t == 1 then --only 1 team mode available, skip selection
		startdata.p2TeamMode = t[1].mode
		if t[1].itemname.ratio ~= nil then
			startdata.p2NumRatio = t[1].chars
			if startdata.p2NumRatio <= 3 then
				startdata.p2NumChars = 3
			elseif startdata.p2NumRatio <= 6 then
				startdata.p2NumChars = 2
			else
				startdata.p2NumChars = 1
			end
			startdata.p2Ratio = true
		else
			startdata.p2NumChars = t[1].chars
		end
		setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
		startdata.p2TeamEnd = true
	else
		--Command swap
		local cmd = 2
		if main.coop then
			cmd = 1
		end
		--Calculate team cursor position
		if startdata.p2TeamMenu > #t then
			startdata.p2TeamMenu = 1
		end
		if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_previous)) then
			if startdata.p2TeamMenu > 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_move_snd[1], motif.select_info.p2_teammenu_move_snd[2])
				startdata.p2TeamMenu = startdata.p2TeamMenu - 1
			elseif motif.select_info.teammenu_move_wrapping == 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_move_snd[1], motif.select_info.p2_teammenu_move_snd[2])
				startdata.p2TeamMenu = #t
			end
		elseif main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_next)) then
			if startdata.p2TeamMenu < #t then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_move_snd[1], motif.select_info.p2_teammenu_move_snd[2])
				startdata.p2TeamMenu = startdata.p2TeamMenu + 1
			elseif motif.select_info.teammenu_move_wrapping == 1 then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_move_snd[1], motif.select_info.p2_teammenu_move_snd[2])
				startdata.p2TeamMenu = 1
			end
		elseif t[startdata.p2TeamMenu].itemname == 'simul' then
			if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
				if startdata.p2NumSimul > config.NumSimul[1] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumSimul = startdata.p2NumSimul - 1
				end
			elseif main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
				if startdata.p2NumSimul < config.NumSimul[2] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumSimul = startdata.p2NumSimul + 1
				end
			end
		elseif t[startdata.p2TeamMenu].itemname == 'turns' then
			if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
				if startdata.p2NumTurns > config.NumTurns[1] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumTurns = startdata.p2NumTurns - 1
				end
			elseif main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
				if startdata.p2NumTurns < config.NumTurns[2] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumTurns = startdata.p2NumTurns + 1
				end
			end
		elseif t[startdata.p2TeamMenu].itemname == 'tag' then
			if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_add)) then
				if startdata.p2NumTag > config.NumTag[1] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumTag = startdata.p2NumTag - 1
				end
			elseif main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) then
				if startdata.p2NumTag < config.NumTag[2] then
					sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
					startdata.p2NumTag = startdata.p2NumTag + 1
				end
			end
		elseif t[startdata.p2TeamMenu].itemname == 'ratio' then
			if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_subtract)) and main.p2SelectMenu then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
				if startdata.p2NumRatio > 1 then
					startdata.p2NumRatio = startdata.p2NumRatio - 1
				else
					startdata.p2NumRatio = 7
				end
			elseif main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_add)) and main.p2SelectMenu then
				sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_value_snd[1], motif.select_info.p2_teammenu_value_snd[2])
				if startdata.p2NumRatio < 7 then
					startdata.p2NumRatio = startdata.p2NumRatio + 1
				else
					startdata.p2NumRatio = 1
				end
			end
		end
		--Draw team background
		main.t_animUpdate[motif.select_info.p2_teammenu_bg_data] = 1
		animDraw(motif.select_info.p2_teammenu_bg_data)
		--Draw team active element background
		main.t_animUpdate[motif.select_info['p2_teammenu_bg_' .. t[startdata.p2TeamMenu].itemname .. '_data']] = 1
		animDraw(motif.select_info['p2_teammenu_bg_' .. t[startdata.p2TeamMenu].itemname .. '_data'])
		--Draw team cursor
		main.f_animPosDraw(
				motif.select_info.p2_teammenu_item_cursor_data,
				(startdata.p2TeamMenu - 1) * motif.select_info.p2_teammenu_item_spacing[1],
				(startdata.p2TeamMenu - 1) * motif.select_info.p2_teammenu_item_spacing[2]
		)
		--Draw team title
		if main.coop or main.t_pIn[2] == 1 then
			main.t_animUpdate[motif.select_info.p2_teammenu_enemytitle_data] = 1
			animDraw(motif.select_info.p2_teammenu_enemytitle_data)
			startdata.txt_p2TeamEnemyTitle:draw()
		else
			main.t_animUpdate[motif.select_info.p2_teammenu_selftitle_data] = 1
			animDraw(motif.select_info.p2_teammenu_selftitle_data)
			startdata.txt_p2TeamSelfTitle:draw()
		end
		for i = 1, #t do
			if i == startdata.p2TeamMenu then
				if startdata.p2TeamActiveCount < 2 then --delay change
					startdata.p2TeamActiveCount = startdata.p2TeamActiveCount + 1
				elseif startdata.p2TeamActiveType == 'p2_teammenu_item_active' then
					startdata.p2TeamActiveType = 'p2_teammenu_item_active2'
					startdata.p2TeamActiveCount = 0
				else
					startdata.p2TeamActiveType = 'p2_teammenu_item_active'
					startdata.p2TeamActiveCount = 0
				end
				--Draw team active font
				t[i].data:update({
					font =   motif.select_info[startdata.p2TeamActiveType .. '_font'][1],
					bank =   motif.select_info[startdata.p2TeamActiveType .. '_font'][2],
					align =  motif.select_info[startdata.p2TeamActiveType .. '_font'][3], --p2_teammenu_item_font (winmugen ignores active font facing? Fixed in mugen 1.0)
					text =   t[i].displayname,
					x =      motif.select_info.p2_teammenu_pos[1] + motif.select_info.p2_teammenu_item_offset[1] + motif.select_info.p2_teammenu_item_spacing[1] * (i - 1),
					y =      motif.select_info.p2_teammenu_pos[2] + motif.select_info.p2_teammenu_item_offset[2] + motif.select_info.p2_teammenu_item_spacing[2] * (i - 1),
					scaleX = motif.select_info[startdata.p2TeamActiveType .. '_font_scale'][1],
					scaleY = motif.select_info[startdata.p2TeamActiveType .. '_font_scale'][2],
					r =      motif.select_info[startdata.p2TeamActiveType .. '_font'][4],
					g =      motif.select_info[startdata.p2TeamActiveType .. '_font'][5],
					b =      motif.select_info[startdata.p2TeamActiveType .. '_font'][6],
					src =    motif.select_info[startdata.p2TeamActiveType .. '_font'][7],
					dst =    motif.select_info[startdata.p2TeamActiveType .. '_font'][8],
					height = motif.select_info[startdata.p2TeamActiveType .. '_font_height'],
				})
				t[i].data:draw()
			else
				--Draw team not active font
				t[i].data:update({
					font =   motif.select_info.p2_teammenu_item_font[1],
					bank =   motif.select_info.p2_teammenu_item_font[2],
					align =  motif.select_info.p2_teammenu_item_font[3], --p2_teammenu_item_font (winmugen ignores active font facing? Fixed in mugen 1.0)
					text =   t[i].displayname,
					x =      motif.select_info.p2_teammenu_pos[1] + motif.select_info.p2_teammenu_item_offset[1] + motif.select_info.p2_teammenu_item_spacing[1] * (i - 1),
					y =      motif.select_info.p2_teammenu_pos[2] + motif.select_info.p2_teammenu_item_offset[2] + motif.select_info.p2_teammenu_item_spacing[2] * (i - 1),
					scaleX = motif.select_info.p2_teammenu_item_font_scale[1],
					scaleY = motif.select_info.p2_teammenu_item_font_scale[2],
					r =      motif.select_info.p2_teammenu_item_font[4],
					g =      motif.select_info.p2_teammenu_item_font[5],
					b =      motif.select_info.p2_teammenu_item_font[6],
					src =    motif.select_info.p2_teammenu_item_font[7],
					dst =    motif.select_info.p2_teammenu_item_font[8],
					height = motif.select_info.p2_teammenu_item_font_height,
				})
				t[i].data:draw()
			end
			--Draw team icons
			if t[i].itemname == 'simul' then
				for j = 1, config.NumSimul[2] do
					if j <= startdata.p2NumSimul then
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					else
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_empty_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					end
				end
			elseif t[i].itemname == 'turns' then
				for j = 1, config.NumTurns[2] do
					if j <= startdata.p2NumTurns then
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					else
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_empty_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					end
				end
			elseif t[i].itemname == 'tag' then
				for j = 1, config.NumTag[2] do
					if j <= startdata.p2NumTag then
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					else
						main.f_animPosDraw(
								motif.select_info.p2_teammenu_value_empty_icon_data,
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[1] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[1],
								(i - 1) * motif.select_info.p2_teammenu_item_spacing[2] + (j - 1) * motif.select_info.p2_teammenu_value_spacing[2]
						)
					end
				end
			elseif t[i].itemname == 'ratio' and startdata.p2TeamMenu == i and main.p2SelectMenu then
				main.t_animUpdate[motif.select_info['p2_teammenu_ratio' .. startdata.p2NumRatio .. '_icon_data']] = 1
				animDraw(motif.select_info['p2_teammenu_ratio' .. startdata.p2NumRatio .. '_icon_data'])
			end
		end
		--Confirmed team selection
		if main.f_input({cmd}, main.f_extractKeys(motif.select_info.teammenu_key_accept)) then
			sndPlay(motif.files.snd_data, motif.select_info.p2_teammenu_done_snd[1], motif.select_info.p2_teammenu_done_snd[2])
			if t[startdata.p2TeamMenu].itemname == 'single' then
				startdata.p2TeamMode = t[startdata.p2TeamMenu].mode
				startdata.p2NumChars = 1
			elseif t[startdata.p2TeamMenu].itemname == 'simul' then
				startdata.p2TeamMode = t[startdata.p2TeamMenu].mode
				startdata.p2NumChars = startdata.p2NumSimul
			elseif t[startdata.p2TeamMenu].itemname == 'turns' then
				startdata.p2TeamMode = t[startdata.p2TeamMenu].mode
				startdata.p2NumChars = startdata.p2NumTurns
			elseif t[startdata.p2TeamMenu].itemname == 'tag' then
				startdata.p2TeamMode = t[startdata.p2TeamMenu].mode
				startdata.p2NumChars = startdata.p2NumTag
			elseif t[startdata.p2TeamMenu].itemname == 'ratio' then
				startdata.p2TeamMode = t[startdata.p2TeamMenu].mode
				if startdata.p2NumRatio <= 3 then
					startdata.p2NumChars = 3
				elseif startdata.p2NumRatio <= 6 then
					startdata.p2NumChars = 2
				else
					startdata.p2NumChars = 1
				end
				startdata.p2Ratio = true
			end
			startdata.p2TeamEnd = true
			--main.f_cmdInput()
		end
	end
end

--;===========================================================
--; PLAYER 1 SELECT MENU
--;===========================================================
function start.f_p1SelectMenu()
	--predefined selection
	if main.p1Char ~= nil then
		local t = {}
		for i = 1, #main.p1Char do
			if t[main.p1Char[i]] == nil then
				t[main.p1Char[i]] = ''
			end
			startdata.t_p1Selected[i] = {
				ref = main.p1Char[i],
				pal = start.f_selectPal(main.p1Char[i])
			}
		end
		startdata.p1SelEnd = true
		return
		--manual selection
	elseif not startdata.p1SelEnd then
		startdata.resetgrid = false
		--cell movement
		if startdata.p1RestoreCursor and startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected] ~= nil then --restore saved position
			startdata.p1SelX = startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected][1]
			startdata.p1SelY = startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected][2]
			startdata.p1FaceOffset = startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected][3]
			startdata.p1RowOffset = startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected][4]
			startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected] = nil
		else --calculate current position
			startdata.p1SelX, startdata.p1SelY, startdata.p1FaceOffset, startdata.p1RowOffset = start.f_cellMovement(startdata.p1SelX, startdata.p1SelY, 1, startdata.p1FaceOffset, startdata.p1RowOffset, motif.select_info.p1_cursor_move_snd)
		end
		startdata.p1Cell = startdata.p1SelX + motif.select_info.columns * startdata.p1SelY
		--draw active cursor
		local cursorX = startdata.p1FaceX + startdata.p1SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startdata.p1SelX + 1, startdata.p1SelY + 1, 1)
		local cursorY = startdata.p1FaceY + (startdata.p1SelY - startdata.p1RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startdata.p1SelX + 1, startdata.p1SelY + 1, 2)
		if startdata.resetgrid == true then
			start.f_resetGrid()
		end
		if start.f_selGrid(startdata.p1Cell + 1).hidden ~= 1 then
			main.f_animPosDraw(
					motif.select_info.p1_cursor_active_data,
					cursorX,
					cursorY,
					(motif.select_info['cell_' .. startdata.p1SelX + 1 .. '_' .. startdata.p1SelY + 1 .. '_facing'] or 1)
			)
		end
		--cell selected
		if start.f_slotSelected(startdata.p1Cell + 1, 1, startdata.p1SelX, startdata.p1SelY) and start.f_selGrid(startdata.p1Cell + 1).char ~= nil and start.f_selGrid(startdata.p1Cell + 1).hidden ~= 2 then
			sndPlay(motif.files.snd_data, motif.select_info.p1_cursor_done_snd[1], motif.select_info.p1_cursor_done_snd[2])
			local selected = start.f_selGrid(startdata.p1Cell + 1).char_ref
			if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
				selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
			end
			start.f_playWave(selected, 'cursor', motif.select_info.p1_select_snd[1], motif.select_info.p1_select_snd[2])
			table.insert(startdata.t_p1Selected, {
				ref = selected,
				pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[1])),
				cursor = { cursorX, cursorY, startdata.p1RowOffset, (motif.select_info['cell_' .. startdata.p1SelX + 1 .. '_' .. startdata.p1SelY + 1 .. '_facing'] or 1)},
				ratio = start.f_setRatio(1)
			})
			startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected + 1] = { startdata.p1SelX, startdata.p1SelY, startdata.p1FaceOffset, startdata.p1RowOffset}
			if #startdata.t_p1Selected == startdata.p1NumChars or (#startdata.t_p1Selected == 1 and main.coop) then --if all characters have been chosen
				if main.t_pIn[2] == 1 and startdata.matchNo == 0 then --if player1 is allowed to select p2 characters
					startdata.p2TeamEnd = false
					startdata.p2SelEnd = false
					--commandBufReset(main.t_cmd[2])
				end
				startdata.p1SelEnd = true
			end
			main.f_cmdInput()
			--select screen timer reached 0
		elseif motif.select_info.timer_enabled == 1 and startdata.timerSelect == -1 then
			sndPlay(motif.files.snd_data, motif.select_info.p1_cursor_done_snd[1], motif.select_info.p1_cursor_done_snd[2])
			local selected = start.f_selGrid(startdata.p1Cell + 1).char_ref
			local rand = false
			for i = #startdata.t_p1Selected + 1, startdata.p1NumChars do
				if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
					selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
				end
				if not rand then --play it just for the first character
					start.f_playWave(selected, 'cursor', motif.select_info.p1_select_snd[1], motif.select_info.p1_select_snd[2])
				end
				rand = true
				table.insert(startdata.t_p1Selected, {
					ref = selected,
					pal = start.f_selectPal(selected),
					cursor = { cursorX, cursorY, startdata.p1RowOffset, (motif.select_info['cell_' .. startdata.p1SelX + 1 .. '_' .. startdata.p1SelY + 1 .. '_facing'] or 1)},
					ratio = start.f_setRatio(1)
				})
				startdata.t_p1Cursor[startdata.p1NumChars - #startdata.t_p1Selected + 1] = { startdata.p1SelX, startdata.p1SelY, startdata.p1FaceOffset, startdata.p1RowOffset}
			end
			if main.p2SelectMenu and main.t_pIn[2] == 1 and startdata.matchNo == 0 then --if player1 is allowed to select p2 characters
				startdata.p2TeamMode = startdata.p1TeamMode
				startdata.p2NumChars = startdata.p1NumChars
				setTeamMode(2, startdata.p2TeamMode, startdata.p2NumChars)
				startdata.p2Cell = startdata.p1Cell
				startdata.p2SelX = startdata.p1SelX
				startdata.p2SelY = startdata.p1SelY
				startdata.p2FaceOffset = startdata.p1FaceOffset
				startdata.p2RowOffset = startdata.p1RowOffset
				for i = 1, startdata.p2NumChars do
					selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
					table.insert(start.t_p2Selected, {
						ref = selected,
						pal = start.f_selectPal(selected),
						cursor = { cursorX, cursorY, startdata.p2RowOffset, (motif.select_info['cell_' .. startdata.p2SelX + 1 .. '_' .. startdata.p2SelY + 1 .. '_facing'] or 1)},
						ratio = start.f_setRatio(2)
					})
					startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected + 1] = { startdata.p2SelX, startdata.p2SelY, startdata.p2FaceOffset, startdata.p2RowOffset}
				end
			end
			if main.stageMenu then
				startdata.stageNo = main.t_includeStage[2][math.random(1, #main.t_includeStage[2])]
				startdata.stageEnd = true
			end
			startdata.p1SelEnd = true
		end
	end
end

--;===========================================================
--; PLAYER 2 SELECT MENU
--;===========================================================
function start.f_p2SelectMenu()
	--predefined selection
	if main.p2Char ~= nil then
		local t = {}
		for i = 1, #main.p2Char do
			if t[main.p2Char[i]] == nil then
				t[main.p2Char[i]] = ''
			end
			startdata.t_p2Selected[i] = {
				ref = main.p2Char[i],
				pal = start.f_selectPal(main.p2Char[i])
			}
		end
		startdata.p2SelEnd = true
		return
		--p2 selection disabled
	elseif not main.p2SelectMenu then
		startdata.p2SelEnd = true
		return
		--manual selection
	elseif not startdata.p2SelEnd then
		startdata.resetgrid = false
		--cell movement
		if startdata.p2RestoreCursor and startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected] ~= nil then --restore saved position
			startdata.p2SelX = startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected][1]
			startdata.p2SelY = startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected][2]
			startdata.p2FaceOffset = startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected][3]
			startdata.p2RowOffset = startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected][4]
			startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected] = nil
		else --calculate current position
			startdata.p2SelX, startdata.p2SelY, startdata.p2FaceOffset, startdata.p2RowOffset = start.f_cellMovement(startdata.p2SelX, startdata.p2SelY, 2, startdata.p2FaceOffset, startdata.p2RowOffset, motif.select_info.p2_cursor_move_snd)
		end
		startdata.p2Cell = startdata.p2SelX + motif.select_info.columns * startdata.p2SelY
		--draw active cursor
		local cursorX = startdata.p2FaceX + startdata.p2SelX * (motif.select_info.cell_size[1] + motif.select_info.cell_spacing[1]) + start.f_faceOffset(startdata.p2SelX + 1, startdata.p2SelY + 1, 1)
		local cursorY = startdata.p2FaceY + (startdata.p2SelY - startdata.p2RowOffset) * (motif.select_info.cell_size[2] + motif.select_info.cell_spacing[2]) + start.f_faceOffset(startdata.p2SelX + 1, startdata.p2SelY + 1, 2)
		if startdata.resetgrid == true then
			start.f_resetGrid()
		end
		main.f_animPosDraw(
				motif.select_info.p2_cursor_active_data,
				cursorX,
				cursorY,
				(motif.select_info['cell_' .. startdata.p2SelX + 1 .. '_' .. startdata.p2SelY + 1 .. '_facing'] or 1)
		)
		--cell selected
		if start.f_slotSelected(startdata.p2Cell + 1, 2, startdata.p2SelX, startdata.p2SelY) and start.f_selGrid(startdata.p2Cell + 1).char ~= nil and start.f_selGrid(startdata.p2Cell + 1).hidden ~= 2 then
			sndPlay(motif.files.snd_data, motif.select_info.p2_cursor_done_snd[1], motif.select_info.p2_cursor_done_snd[2])
			local selected = start.f_selGrid(startdata.p2Cell + 1).char_ref
			if main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
				selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
			end
			start.f_playWave(selected, 'cursor', motif.select_info.p2_select_snd[1], motif.select_info.p2_select_snd[2])
			table.insert(startdata.t_p2Selected, {
				ref = selected,
				pal = start.f_selectPal(selected, main.f_btnPalNo(main.t_cmd[2])),
				cursor = { cursorX, cursorY, startdata.p2RowOffset, (motif.select_info['cell_' .. startdata.p2SelX + 1 .. '_' .. startdata.p2SelY + 1 .. '_facing'] or 1)},
				ratio = start.f_setRatio(2)
			})
			startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected + 1] = { startdata.p2SelX, startdata.p2SelY, startdata.p2FaceOffset, startdata.p2RowOffset}
			if #startdata.t_p2Selected == startdata.p2NumChars then
				startdata.p2SelEnd = true
			end
			main.f_cmdInput()
			--select screen timer reached 0
		elseif motif.select_info.timer_enabled == 1 and startdata.timerSelect == -1 then
			sndPlay(motif.files.snd_data, motif.select_info.p2_cursor_done_snd[1], motif.select_info.p2_cursor_done_snd[2])
			local selected = start.f_selGrid(startdata.p2Cell + 1).char_ref
			local rand = false
			for i = #startdata.t_p2Selected + 1, startdata.p2NumChars do
				if rand or main.t_selChars[selected + 1].char == 'randomselect' or main.t_selChars[selected + 1].hidden == 3 then
					selected = main.t_randomChars[math.random(1, #main.t_randomChars)]
				end
				if not rand then --play it just for the first character
					start.f_playWave(selected, 'cursor', motif.select_info.p2_select_snd[1], motif.select_info.p2_select_snd[2])
				end
				rand = true
				table.insert(startdata.t_p2Selected, {
					ref = selected,
					pal = start.f_selectPal(selected),
					cursor = { cursorX, cursorY, startdata.p2RowOffset, (motif.select_info['cell_' .. startdata.p2SelX + 1 .. '_' .. startdata.p2SelY + 1 .. '_facing'] or 1)},
					ratio = start.f_setRatio(2)
				})
				startdata.t_p2Cursor[startdata.p2NumChars - #startdata.t_p2Selected + 1] = { startdata.p2SelX, startdata.p2SelY, startdata.p2FaceOffset, startdata.p2RowOffset}
			end
			startdata.p2SelEnd = true
		end
	end
end

--;===========================================================
--; STAGE MENU
--;===========================================================
function start.f_stageMenu()
	if main.f_input(main.t_players, {'$B'}) then
		sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
		startdata.stageList = startdata.stageList - 1
		if startdata.stageList < 0 then startdata.stageList = #main.t_includeStage[2] end
	elseif main.f_input(main.t_players, {'$F'}) then
		sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
		startdata.stageList = startdata.stageList + 1
		if startdata.stageList > #main.t_includeStage[2] then startdata.stageList = 0 end
	elseif main.f_input(main.t_players, {'$U'}) then
		sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
		for i = 1, 10 do
			startdata.stageList = startdata.stageList - 1
			if startdata.stageList < 0 then startdata.stageList = #main.t_includeStage[2] end
		end
	elseif main.f_input(main.t_players, {'$D'}) then
		sndPlay(motif.files.snd_data, motif.select_info.stage_move_snd[1], motif.select_info.stage_move_snd[2])
		for i = 1, 10 do
			startdata.stageList = startdata.stageList + 1
			if startdata.stageList > #main.t_includeStage[2] then startdata.stageList = 0 end
		end
	end
	if startdata.stageList == 0 then --draw random stage portrait loaded from screenpack SFF
		main.t_animUpdate[motif.select_info.stage_portrait_random_data] = 1
		animDraw(motif.select_info.stage_portrait_random_data)
	else --draw stage portrait loaded from stage SFF
		drawPortraitStage(
				startdata.stageList,
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
		if startdata.stageList == 0 then
			startdata.stageNo = main.t_includeStage[2][math.random(1, #main.t_includeStage[2])]
		else
			startdata.stageNo = main.t_includeStage[2][startdata.stageList]
		end
		startdata.stageActiveType = 'stage_done'
		startdata.stageEnd = true
		--main.f_cmdInput()
	else
		if startdata.stageActiveCount < 2 then --delay change
			startdata.stageActiveCount = startdata.stageActiveCount + 1
		elseif startdata.stageActiveType == 'stage_active' then
			startdata.stageActiveType = 'stage_active2'
			startdata.stageActiveCount = 0
		else
			startdata.stageActiveType = 'stage_active'
			startdata.stageActiveCount = 0
		end
	end
	local t_txt = {}
	if startdata.stageList == 0 then
		t_txt[1] = motif.select_info.stage_random_text
	else
		t_txt = main.f_extractText(motif.select_info.stage_text, startdata.stageList, getStageName(main.t_includeStage[2][startdata.stageList]))
	end
	for i = 1, #t_txt do
		startdata.txt_selStage:update({
			font =   motif.select_info[startdata.stageActiveType .. '_font'][1],
			bank =   motif.select_info[startdata.stageActiveType .. '_font'][2],
			align =  motif.select_info[startdata.stageActiveType .. '_font'][3],
			text =   t_txt[i],
			x =      motif.select_info.stage_pos[1] + motif.select_info[startdata.stageActiveType .. '_offset'][1],
			y =      motif.select_info.stage_pos[2] + motif.select_info[startdata.stageActiveType .. '_offset'][2] + main.f_ySpacing(motif.select_info, startdata.stageActiveType .. '_font') * (i - 1),
			scaleX = motif.select_info[startdata.stageActiveType .. '_font_scale'][1],
			scaleY = motif.select_info[startdata.stageActiveType .. '_font_scale'][2],
			r =      motif.select_info[startdata.stageActiveType .. '_font'][4],
			g =      motif.select_info[startdata.stageActiveType .. '_font'][5],
			b =      motif.select_info[startdata.stageActiveType .. '_font'][6],
			src =    motif.select_info[startdata.stageActiveType .. '_font'][7],
			dst =    motif.select_info[startdata.stageActiveType .. '_font'][8],
			height = motif.select_info[startdata.stageActiveType .. '_font_height'],
		})
		startdata.txt_selStage:draw()
	end
end

--;===========================================================
--; VERSUS SCREEN
--;===========================================================
function start.f_selectChar(player, t)
	for i = 1, #t do
		selectChar(player, t[i].ref, t[i].pal)
	end
end

function start.f_selectVersus()
	if not main.versusScreen or not main.t_charparam.vsscreen or (main.t_charparam.rivals and start.f_rivalsMatch('vsscreen', 0)) or main.t_selChars[startdata.t_p1Selected[1].ref + 1].vsscreen == 0 then
		start.f_selectChar(1, startdata.t_p1Selected)
		start.f_selectChar(2, startdata.t_p2Selected)
		return true
	else
		local text = main.f_extractText(motif.vs_screen.match_text, startdata.matchNo)
		startdata.txt_matchNo:update({ text = text[1]})
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
		--main.f_cmdInput()
		main.fadeStart = getFrameCount()
		local counter = 0 - motif.vs_screen.fadein_time
		startdata.fadeType = 'fadein'
		while true do
			if counter == motif.vs_screen.stage_time then
				start.f_playWave(startdata.stageNo, 'stage', motif.vs_screen.stage_snd[1], motif.vs_screen.stage_snd[2])
			end
			if esc() or main.f_input(main.t_players, {'m'}) then
				--main.f_cmdInput()
				return nil
			elseif p1Confirmed and p2Confirmed then
				if startdata.fadeType == 'fadein' and (counter >= motif.vs_screen.time or main.f_input({ 1}, { 'pal', 's'})) then
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
					if main.f_input({1}, {'pal', 's'}) then
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
					elseif main.f_input({1}, {'$U'}) then
						if #startdata.t_p1Selected > 1 then
							sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
							p1Row = p1Row - 1
							if p1Row == 0 then p1Row = #startdata.t_p1Selected end
						end
					elseif main.f_input({1}, {'$D'}) then
						if #startdata.t_p1Selected > 1 then
							sndPlay(motif.files.snd_data, motif.vs_screen.p1_cursor_move_snd[1], motif.vs_screen.p1_cursor_move_snd[2])
							p1Row = p1Row + 1
							if p1Row > #startdata.t_p1Selected then p1Row = 1 end
						end
					elseif main.f_input({1}, {'$B'}) then
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
					elseif main.f_input({1}, {'$F'}) then
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
					if main.f_input({2}, {'pal', 's'}) then
						if not p2Confirmed then
							sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_done_snd[1], motif.vs_screen.p2_cursor_done_snd[2])
							start.f_selectChar(2, startdata.t_p2Selected)
							p2Confirmed = true
						end
					elseif main.f_input({2}, {'$U'}) then
						if #startdata.t_p2Selected > 1 then
							sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
							p2Row = p2Row - 1
							if p2Row == 0 then p2Row = #startdata.t_p2Selected end
						end
					elseif main.f_input({2}, {'$D'}) then
						if #startdata.t_p2Selected > 1 then
							sndPlay(motif.files.snd_data, motif.vs_screen.p2_cursor_move_snd[1], motif.vs_screen.p2_cursor_move_snd[2])
							p2Row = p2Row + 1
							if p2Row > #startdata.t_p2Selected then p2Row = 1 end
						end
					elseif main.f_input({2}, {'$B'}) then
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
					elseif main.f_input({2}, {'$F'}) then
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
			for i = 1, #startdata.t_p2Selected do
				if #t_portrait < motif.vs_screen.p2_num then
					table.insert(t_portrait, startdata.t_p2Selected[i].ref)
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
				main.f_cmdInput()
			end
			main.f_refresh()
		end
		return true
	end
end

--;===========================================================
--; RESULT SCREEN
--;===========================================================
local function f_drawTextAtLayerNo(t, prefix, t_text, txt, layerNo)
	if t[prefix .. '_layerno'] ~= layerNo then
		return
	end
	for i = 1, #t_text do
		txt:update({
			text = t_text[i],
			y =    t[prefix .. '_offset'][2] + main.f_ySpacing(t, prefix .. '_font') * (i - 1)
		})
		txt:draw()
	end
end

local function f_lowestRankingData(data)
	if stats.modes == nil or stats.modes[gamemode()] == nil or stats.modes[gamemode()].ranking == nil or #stats.modes[gamemode()].ranking < motif.rankings.max_entries then
		if data == 'score' then
			return 0
		else --time
			return 99
		end
	end
	local ret = 0
	for k, v in ipairs(stats.modes[gamemode()].ranking) do
		if k == 1 or (data == 'score' and ret > v[data]) or (data == 'time' and ret < v[data]) then
			ret = v[data]
		end
	end
	return ret
end

start.resultInit = false
function start.f_resultInit()
	if startdata.resultInit then
		return startdata.t_result.active
	end
	startdata.resultInit = true
	startdata.t_result = {
		active = false,
		prefix = 'winstext',
		resultText = {},
		txt = nil,
		displayTime = 0,
		fadeType = 'fadein'
	}
	if main.resultsTable == nil then
		return false
	end
	startdata.t_result.displayTime = 0 - main.resultsTable.fadein_time
	if winnerteam() == 1 then
		startdata.winCnt = startdata.winCnt + 1
	else
		startdata.loseCnt = startdata.loseCnt + 1
	end
	local t = main.resultsTable
	local stateType = ''
	local winBgm = true
	if gamemode('arcade') or gamemode('teamcoop') or gamemode('netplayteamcoop') then
		if winnerteam() ~= 1 or startdata.matchNo < startdata.lastMatch then
			return false
		end
		if main.t_selChars[startdata.t_p1Selected[1].ref + 1].ending ~= nil and main.f_fileExists(main.t_selChars[startdata.t_p1Selected[1].ref + 1].ending) then --not displayed if the team leader has an ending
			return false
		end
		startdata.t_result.prefix = 'wintext'
		startdata.t_result.resultText = main.f_extractText(t[startdata.t_result.prefix .. '_text'])
		startdata.t_result.txt = startdata.txt_winscreen
	elseif gamemode('bossrush') then
		if winnerteam() ~= 1 or startdata.matchNo < startdata.lastMatch then
			return false
		end
		startdata.t_result.resultText = main.f_extractText(t[startdata.t_result.prefix .. '_text'])
		startdata.t_result.txt = startdata.txt_resultBossRush
	elseif gamemode('survival') or gamemode('survivalcoop') or gamemode('netplaysurvivalcoop') then
		if winnerteam() == 1 and (startdata.matchNo < startdata.lastMatch or (startdata.t_roster[startdata.matchNo + 1] ~= nil and startdata.t_roster[startdata.matchNo + 1][1] == -1)) then
			return false
		end
		startdata.t_result.resultText = main.f_extractText(t[startdata.t_result.prefix .. '_text'], startdata.winCnt)
		startdata.t_result.txt = startdata.txt_resultSurvival
		if startdata.winCnt < t.roundstowin and startdata.matchNo < startdata.lastMatch then
			stateType = '_lose'
			winBgm = false
		else
			stateType = '_win'
		end
	elseif gamemode('vs100kumite') then
		if startdata.matchNo < startdata.lastMatch then
			return false
		end
		startdata.t_result.resultText = main.f_extractText(t[startdata.t_result.prefix .. '_text'], startdata.winCnt, startdata.loseCnt)
		startdata.t_result.txt = startdata.txt_resultVS100
		if startdata.winCnt < t.roundstowin then
			stateType = '_lose'
			winBgm = false
		else
			stateType = '_win'
		end
	elseif gamemode('timeattack') then
		if winnerteam() ~= 1 or startdata.matchNo < startdata.lastMatch then
			return false
		end
		startdata.t_result.resultText = main.f_extractText(start.f_clearTimeText(t[startdata.t_result.prefix .. '_text'], timetotal() / 60))
		startdata.t_result.txt = startdata.txt_resultTimeAttack
		if matchtime() / 60 >= f_lowestRankingData('time') then
			stateType = '_lose'
			winBgm = false
		else
			stateType = '_win'
		end
	elseif gamemode('timechallenge') then
		if winnerteam() ~= 1 then
			return false
		end
		startdata.t_result.resultText = main.f_extractText(start.f_clearTimeText(t[startdata.t_result.prefix .. '_text'], timetotal() / 60))
		startdata.t_result.txt = startdata.txt_resultTimeChallenge
		if matchtime() / 60 >= f_lowestRankingData('time') then
			stateType = '_lose'
			winBgm = false
		else
			stateType = '_win'
		end
	elseif gamemode('scorechallenge') then
		if winnerteam() ~= 1 then
			return false
		end
		player(1) --assign sys.debugWC to player 1
		startdata.t_result.resultText = main.f_extractText(t[startdata.t_result.prefix .. '_text'], scoretotal())
		startdata.t_result.txt = startdata.txt_resultScoreChallenge
		if scoretotal() <= f_lowestRankingData('score') then
			stateType = '_lose'
			winBgm = false
		else
			stateType = '_win'
		end
	else
		return false
	end
	for i = 1, 2 do
		for k, v in ipairs(t['p' .. i .. '_statedef' .. stateType]) do
			if charChangeState(i, v) then
				break
			end
		end
	end
	main.f_bgReset(motif.resultsbgdef.bg)
	if winBgm then
		main.f_playBGM(false, motif.music.results_bgm, motif.music.results_bgm_loop, motif.music.results_bgm_volume, motif.music.results_bgm_loopstart, motif.music.results_bgm_loopend)
	else
		main.f_playBGM(false, motif.music.results_lose_bgm, motif.music.results_lose_bgm_loop, motif.music.results_lose_bgm_volume, motif.music.results_lose_bgm_loopstart, motif.music.results_lose_bgm_loopend)
	end
	main.fadeStart = getFrameCount()
	startdata.t_result.active = true
	return true
end

function start.f_result()
	if not start.f_resultInit() then
		return false
	end
	local t = main.resultsTable
	startdata.t_result.displayTime = startdata.t_result.displayTime + 1
	--draw overlay
	fillRect(
			t.boxbg_coords[1],
			t.boxbg_coords[2],
			t.boxbg_coords[3] - t.boxbg_coords[1] + 1,
			t.boxbg_coords[4] - t.boxbg_coords[2] + 1,
			t.boxbg_col[1],
			t.boxbg_col[2],
			t.boxbg_col[3],
			t.boxbg_alpha[1],
			t.boxbg_alpha[2],
			false,
			false
	)
	--draw text at layerno = 0
	f_drawTextAtLayerNo(t, startdata.t_result.prefix, startdata.t_result.resultText, startdata.t_result.txt, 0)
	--draw layerno = 0 backgrounds
	bgDraw(motif.resultsbgdef.bg, false)
	--draw text at layerno = 1
	f_drawTextAtLayerNo(t, startdata.t_result.prefix, startdata.t_result.resultText, startdata.t_result.txt, 1)
	--draw layerno = 1 backgrounds
	bgDraw(motif.resultsbgdef.bg, true)
	--draw text at layerno = 1
	f_drawTextAtLayerNo(t, startdata.t_result.prefix, startdata.t_result.resultText, startdata.t_result.txt, 2)
	--draw fadein / fadeout
	if startdata.t_result.fadeType == 'fadein' and (start.t_result.displayTime >= t.time or main.f_input({ 1}, { 'pal', 's'})) then
		main.fadeStart = getFrameCount()
		startdata.t_result.fadeType = 'fadeout'
	end
	main.fadeActive = fadeColor(
			startdata.t_result.fadeType,
			main.fadeStart,
			t[startdata.t_result.fadeType .. '_time'],
			t[startdata.t_result.fadeType .. '_col'][1],
			t[startdata.t_result.fadeType .. '_col'][2],
			t[startdata.t_result.fadeType .. '_col'][3]
	)
	--frame transition
	main.f_cmdInput()
	if esc() or main.f_input(main.t_players, {'m'}) then
		esc(false)
		startdata.t_result.active = false
		return false
	end
	if not main.fadeActive and startdata.t_result.fadeType == 'fadeout' then
		startdata.t_result.active = false
		return false
	end
	return true
end

--;===========================================================
--; VICTORY SCREEN
--;===========================================================
function start.f_teamOrder(teamNo, allow_ko, num)
	local allow_ko = allow_ko or 0
	local t = {}
	local playerNo = -1
	local selectNo = -1
	local ok = false
	for i = 1, #startdata.t_p1Selected + #startdata.t_p2Selected do
		if i % 2 ~= teamNo then --only if character belongs to selected team
			if player(i) then --assign sys.debugWC if player i exists
				if win() then --win team
					if alive() and not ok then --first not KOed win team member
						playerNo = i
						selectNo = selectno()
						if #t >= num then break end
						table.insert(t, {['pn'] = i, ['ref'] = selectno()})
						ok = true
					elseif alive() or allow_ko == 1 then --other win team members
						if #t >= num then break end
						table.insert(t, {['pn'] = i, ['ref'] = selectno()})
					end
				else --lose team
					if not ok then
						playerNo = i
						selectNo = selectno()
						ok = true
					end
					if #t >= num then break end
					table.insert(t, {['pn'] = i, ['ref'] = selectno()})
				end
			end
		end
	end
	return playerNo, selectNo, t
end

start.victoryInit = false
function start.f_victoryInit()
	if startdata.victoryInit then
		return startdata.t_victory.active
	end
	startdata.victoryInit = true
	startdata.t_victory = {
		active = false,
		winquote = '',
		textcnt = 0,
		textend = false,
		winnerNo = -1,
		winnerRef = -1,
		loserNo = -1,
		loserRef = -1,
		team1 = {},
		team2 = {},
		p1_slide_dist = {0, 0},
		p2_slide_dist = {0, 0},
		displayTime = 0 - motif.victory_screen.fadein_time,
		fadeType = 'fadein'
	}
	if winnerteam() < 1 or not main.victoryScreen or motif.victory_screen.enabled == 0 then
		return false
	elseif gamemode('versus') or gamemode('netplayversus') then
		if motif.victory_screen.vs_enabled == 0 then
			return false
		end
	elseif winnerteam() == 2 and motif.victory_screen.cpu_enabled == 0 then
		return false
	end
	for i = 1, 2 do
		if winnerteam() == i then
			startdata.t_victory.winnerNo, startdata.t_victory.winnerRef, startdata.t_victory.team1 = start.f_teamOrder(i - 1, motif.victory_screen.winner_teamko_enabled, motif.victory_screen.p1_num)
		else
			startdata.t_victory.loserNo, startdata.t_victory.loserRef, startdata.t_victory.team2 = start.f_teamOrder(i - 1, true, motif.victory_screen.p2_num)
		end
	end
	if startdata.t_victory.winnerNo == -1 or startdata.t_victory.winnerRef == -1 then
		return false
	elseif not main.t_charparam.winscreen then
		return false
	elseif main.t_charparam.rivals and start.f_rivalsMatch('winscreen', 0) then --winscreen assigned as rivals param
		return false
	elseif main.t_selChars[startdata.t_victory.winnerRef + 1].winscreen == 0 then --winscreen assigned as character param
		return false
	end
	main.f_bgReset(motif.victorybgdef.bg)
	if not startdata.t_victoryBGM[winnerteam()] then
		main.f_playBGM(false, motif.music.victory_bgm, motif.music.victory_bgm_loop, motif.music.victory_bgm_volume, motif.music.victory_bgm_loopstart, motif.music.victory_bgm_loopend)
	end
	startdata.t_victory.winquote = getCharVictoryQuote(startdata.t_victory.winnerNo)
	if startdata.t_victory.winquote == '' then
		startdata.t_victory.winquote = motif.victory_screen.winquote_text
	end
	startdata.txt_p1_winquoteName:update({ text = start.f_getName(startdata.t_victory.winnerRef)})
	startdata.txt_p2_winquoteName:update({ text = start.f_getName(startdata.t_victory.loserRef)})
	main.fadeStart = getFrameCount()
	start.t_victory.active = true
	return true
end

function start.f_victory()
	if not start.f_victoryInit() then
		return false
	end
	if startdata.t_victory.textend then
		startdata.t_victory.displayTime = startdata.t_victory.displayTime + 1
	end
	--draw overlay
	fillRect(
			motif.victory_screen.boxbg_coords[1],
			motif.victory_screen.boxbg_coords[2],
			motif.victory_screen.boxbg_coords[3] - motif.victory_screen.boxbg_coords[1] + 1,
			motif.victory_screen.boxbg_coords[4] - motif.victory_screen.boxbg_coords[2] + 1,
			motif.victory_screen.boxbg_col[1],
			motif.victory_screen.boxbg_col[2],
			motif.victory_screen.boxbg_col[3],
			motif.victory_screen.boxbg_alpha[1],
			motif.victory_screen.boxbg_alpha[2],
			false,
			false
	)
	--draw layerno = 0 backgrounds
	bgDraw(motif.victorybgdef.bg, false)
	--draw loser team portraits
	for i = #startdata.t_victory.team2, 1, -1 do
		for j = 1, 2 do
			if startdata.t_victory.p2_slide_dist[j] < motif.victory_screen['p2_c' .. i .. '_slide_dist'][j] then
				startdata.t_victory.p2_slide_dist[j] = math.min(startdata.t_victory.p2_slide_dist[j] + motif.victory_screen['p2_c' .. i .. '_slide_speed'][j], motif.victory_screen['p2_c' .. i .. '_slide_dist'][j])
			end
		end
		charSpriteDraw(
				startdata.t_victory.team2[i].pn,
				{
					motif.victory_screen['p2_c' .. i .. '_spr'][1], motif.victory_screen['p2_c' .. i .. '_spr'][2],
					motif.victory_screen.p2_spr[1], motif.victory_screen.p2_spr[2],
					9000, 1
				},
				motif.victory_screen.p2_pos[1] + motif.victory_screen.p2_offset[1] + motif.victory_screen['p2_c' .. i .. '_offset'][1] + math.floor(startdata.t_victory.p2_slide_dist[1] + 0.5),
				motif.victory_screen.p2_pos[2] + motif.victory_screen.p2_offset[2] + motif.victory_screen['p2_c' .. i .. '_offset'][2] + math.floor(startdata.t_victory.p2_slide_dist[2] + 0.5),
				motif.victory_screen.p2_scale[1] * motif.victory_screen['p2_c' .. i .. '_scale'][1],
				motif.victory_screen.p2_scale[2] * motif.victory_screen['p2_c' .. i .. '_scale'][2],
				motif.victory_screen.p2_facing,
				motif.victory_screen.p2_window[1],
				motif.victory_screen.p2_window[2],
				motif.victory_screen.p2_window[3] * config.GameWidth / main.SP_Localcoord[1],
				motif.victory_screen.p2_window[4] * config.GameHeight / main.SP_Localcoord[2]
		)
	end
	--draw winner team portraits
	for i = #startdata.t_victory.team1, 1, -1 do
		for j = 1, 2 do
			if startdata.t_victory.p1_slide_dist[j] < motif.victory_screen['p1_c' .. i .. '_slide_dist'][j] then
				startdata.t_victory.p1_slide_dist[j] = math.min(startdata.t_victory.p1_slide_dist[j] + motif.victory_screen['p1_c' .. i .. '_slide_speed'][j], motif.victory_screen['p1_c' .. i .. '_slide_dist'][j])
			end
		end
		charSpriteDraw(
				startdata.t_victory.team1[i].pn,
				{
					motif.victory_screen['p1_c' .. i .. '_spr'][1], motif.victory_screen['p1_c' .. i .. '_spr'][2],
					motif.victory_screen.p1_spr[1], motif.victory_screen.p1_spr[2],
					9000, 1
				},
				motif.victory_screen.p1_pos[1] + motif.victory_screen.p1_offset[1] + motif.victory_screen['p1_c' .. i .. '_offset'][1] + math.floor(start.t_victory.p1_slide_dist[1] + 0.5),
				motif.victory_screen.p1_pos[2] + motif.victory_screen.p1_offset[2] + motif.victory_screen['p1_c' .. i .. '_offset'][2] + math.floor(start.t_victory.p1_slide_dist[2] + 0.5),
				motif.victory_screen.p1_scale[1] * motif.victory_screen['p1_c' .. i .. '_scale'][1],
				motif.victory_screen.p1_scale[2] * motif.victory_screen['p1_c' .. i .. '_scale'][2],
				motif.victory_screen.p1_facing,
				motif.victory_screen.p1_window[1],
				motif.victory_screen.p1_window[2],
				motif.victory_screen.p1_window[3] * config.GameWidth / main.SP_Localcoord[1],
				motif.victory_screen.p1_window[4] * config.GameHeight / main.SP_Localcoord[2]
		)
	end
	--draw winner name
	startdata.txt_p1_winquoteName:draw()
	--draw loser name
	if motif.victory_screen.loser_name_enabled == 1 then
		startdata.txt_p2_winquoteName:draw()
	end
	--draw winquote
	startdata.t_victory.textcnt = startdata.t_victory.textcnt + 1
	startdata.t_victory.textend = main.f_textRender(
			startdata.txt_winquote,
			startdata.t_victory.winquote,
			startdata.t_victory.textcnt,
			motif.victory_screen.winquote_offset[1],
			motif.victory_screen.winquote_offset[2],
			main.font_def[motif.victory_screen.winquote_font[1] .. motif.victory_screen.winquote_font_height],
			motif.victory_screen.winquote_delay,
			main.f_lineLength(motif.victory_screen.winquote_offset[1], motif.info.localcoord[1], motif.victory_screen.winquote_font[3], motif.victory_screen.winquote_window, motif.victory_screen.winquote_textwrap:match('[wl]'))
	)
	--draw layerno = 1 backgrounds
	bgDraw(motif.victorybgdef.bg, true)
	--draw fadein / fadeout
	if startdata.t_victory.fadeType == 'fadein' and (startdata.t_victory.displayTime >= motif.victory_screen.time or main.f_input({ 1}, { 'pal', 's'})) then
		main.fadeStart = getFrameCount()
		startdata.t_victory.fadeType = 'fadeout'
	end
	main.fadeActive = fadeColor(
			startdata.t_victory.fadeType,
			main.fadeStart,
			motif.victory_screen[startdata.t_victory.fadeType .. '_time'],
			motif.victory_screen[startdata.t_victory.fadeType .. '_col'][1],
			motif.victory_screen[startdata.t_victory.fadeType .. '_col'][2],
			motif.victory_screen[startdata.t_victory.fadeType .. '_col'][3]
	)
	--frame transition
	main.f_cmdInput()
	if esc() or main.f_input(main.t_players, {'m'}) then
		esc(false)
		startdata.t_victory.active = false
		return false
	end
	if not main.fadeActive and startdata.t_victory.fadeType == 'fadeout' then
		startdata.t_victory.active = false
		return false
	end
	return true
end

--;===========================================================
--; CONTINUE SCREEN
--;===========================================================
start.continueInit = false
function start.f_continueInit()
	if startdata.continueInit then
		return startdata.t_continue.active
	end
	startdata.continueInit = true
	startdata.t_continue = {
		active = false,
		continue = false,
		yesActive = true,
		selected = false,
		counter = 0,-- - motif.victory_screen.fadein_time
		text = main.f_extractText(motif.continue_screen.credits_text, main.credits),
		fadeType = 'fadein'
	}
	startdata.continueFlag = false
	if motif.continue_screen.enabled == 0 or not main.continueScreen or winnerteam() == 1 then
		return false
	end
	startdata.txt_credits:update({ text = startdata.t_continue.text[1]})
	main.f_bgReset(motif.continuebgdef.bg)
	main.f_playBGM(false, motif.music.continue_bgm, motif.music.continue_bgm_loop, motif.music.continue_bgm_volume, motif.music.continue_bgm_loopstart, motif.music.continue_bgm_loopend)
	--animReset(motif.continue_screen.continue_anim_data)
	--animUpdate(motif.continue_screen.continue_anim_data)
	for i = 1, 2 do
		for k, v in ipairs(motif.continue_screen['p' .. i .. '_statedef_continue']) do
			if charChangeState(i, v) then
				break
			end
		end
	end
	main.fadeStart = getFrameCount()
	startdata.t_continue.active = true
	return true
end

function start.f_continue()
	if not start.f_continueInit() then
		return false
	end
	--draw overlay
	fillRect(
			motif.continue_screen.boxbg_coords[1],
			motif.continue_screen.boxbg_coords[2],
			motif.continue_screen.boxbg_coords[3] - motif.continue_screen.boxbg_coords[1] + 1,
			motif.continue_screen.boxbg_coords[4] - motif.continue_screen.boxbg_coords[2] + 1,
			motif.continue_screen.boxbg_col[1],
			motif.continue_screen.boxbg_col[2],
			motif.continue_screen.boxbg_col[3],
			motif.continue_screen.boxbg_alpha[1],
			motif.continue_screen.boxbg_alpha[2],
			false,
			false
	)
	--draw layerno = 0 backgrounds
	bgDraw(motif.continuebgdef.bg, false)
	if motif.continue_screen.animated_continue == 1 then --advanced continue screen parameters
		if startdata.t_continue.counter < motif.continue_screen.continue_end_skiptime then
			if not startdata.t_continue.selected and main.f_input({ 1}, { 's'}) then
				startdata.t_continue.continue = true
				for i = 1, 2 do
					for k, v in ipairs(motif.continue_screen['p' .. i .. '_statedef_yes']) do
						if charChangeState(i, v) then
							break
						end
					end
				end
				startdata.t_continue.selected = true
				main.credits = main.credits - 1
				startdata.t_continue.text = main.f_extractText(motif.continue_screen.credits_text, main.credits)
				startdata.txt_credits:update({ text = startdata.t_continue.text[1]})
			elseif not startdata.t_continue.selected and main.f_input({ 1}, { 'pal', 's'}) and start.t_continue.counter >= motif.continue_screen.continue_starttime + motif.continue_screen.continue_skipstart then
				local cnt = 0
				if startdata.t_continue.counter < motif.continue_screen.continue_9_skiptime then
					cnt = motif.continue_screen.continue_9_skiptime
				elseif startdata.t_continue.counter <= motif.continue_screen.continue_8_skiptime then
					cnt = motif.continue_screen.continue_8_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_7_skiptime then
					cnt = motif.continue_screen.continue_7_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_6_skiptime then
					cnt = motif.continue_screen.continue_6_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_5_skiptime then
					cnt = motif.continue_screen.continue_5_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_4_skiptime then
					cnt = motif.continue_screen.continue_4_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_3_skiptime then
					cnt = motif.continue_screen.continue_3_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_2_skiptime then
					cnt = motif.continue_screen.continue_2_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_1_skiptime then
					cnt = motif.continue_screen.continue_1_skiptime
				elseif startdata.t_continue.counter < motif.continue_screen.continue_0_skiptime then
					cnt = motif.continue_screen.continue_0_skiptime
				end
				while startdata.t_continue.counter < cnt do
					startdata.t_continue.counter = startdata.t_continue.counter + 1
					animUpdate(motif.continue_screen.continue_anim_data)
				end
			end
			if startdata.t_continue.counter == motif.continue_screen.continue_9_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_9_snd[1], motif.continue_screen.continue_9_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_8_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_8_snd[1], motif.continue_screen.continue_8_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_7_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_7_snd[1], motif.continue_screen.continue_7_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_6_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_6_snd[1], motif.continue_screen.continue_6_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_5_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_5_snd[1], motif.continue_screen.continue_5_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_4_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_4_snd[1], motif.continue_screen.continue_4_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_3_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_3_snd[1], motif.continue_screen.continue_3_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_2_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_2_snd[1], motif.continue_screen.continue_2_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_1_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_1_snd[1], motif.continue_screen.continue_1_snd[2])
			elseif startdata.t_continue.counter == motif.continue_screen.continue_0_skiptime then
				sndPlay(motif.files.snd_data, motif.continue_screen.continue_0_snd[1], motif.continue_screen.continue_0_snd[2])
			end
		elseif startdata.t_continue.counter == motif.continue_screen.continue_end_skiptime then
			playBGM(motif.music.continue_end_bgm, true, motif.music.continue_end_bgm_loop, motif.music.continue_end_bgm_volume, motif.music.continue_end_bgm_loopstart, motif.music.continue_end_bgm_loopend)
			sndPlay(motif.files.snd_data, motif.continue_screen.continue_end_snd[1], motif.continue_screen.continue_end_snd[2])
			for i = 1, 2 do
				for k, v in ipairs(motif.continue_screen['p' .. i .. '_statedef_no']) do
					if charChangeState(i, v) then
						break
					end
				end
			end
		end
		--draw credits text
		if startdata.t_continue.counter >= motif.continue_screen.continue_skipstart then --show when counter starts counting down
			startdata.txt_credits:draw()
		end
		startdata.t_continue.counter = startdata.t_continue.counter + 1
		--draw counter
		animUpdate(motif.continue_screen.continue_anim_data)
		animDraw(motif.continue_screen.continue_anim_data)
	else --vanilla mugen continue screen parameters
		if not startdata.t_continue.selected and main.f_input({ 1}, { '$F', '$B'}) then
			sndPlay(motif.files.snd_data, motif.continue_screen.move_snd[1], motif.continue_screen.move_snd[2])
			if startdata.t_continue.yesActive then
				startdata.t_continue.yesActive = false
			else
				startdata.t_continue.yesActive = true
			end
		elseif not startdata.t_continue.selected and main.f_input({ 1}, { 'pal', 's'}) then
			startdata.t_continue.continue = startdata.t_continue.yesActive
			if startdata.t_continue.continue then
				sndPlay(motif.files.snd_data, motif.continue_screen.done_snd[1], motif.continue_screen.done_snd[2])
				for i = 1, 2 do
					for k, v in ipairs(motif.continue_screen['p' .. i .. '_statedef_yes']) do
						if charChangeState(i, v) then
							break
						end
					end
				end
				startdata.t_continue.selected = true
				main.credits = main.credits - 1
				--startconfig.t_continue.text = main.f_extractText(motif.continue_screen.credits_text, main.credits)
				--txt_credits:update({text = startconfig.t_continue.text[1]})
			else
				sndPlay(motif.files.snd_data, motif.continue_screen.cancel_snd[1], motif.continue_screen.cancel_snd[2])
				for i = 1, 2 do
					for k, v in ipairs(motif.continue_screen['p' .. i .. '_statedef_no']) do
						if charChangeState(i, v) then
							break
						end
					end
				end
			end
			startdata.t_continue.counter = motif.continue_screen.endtime + 1
		end
		startdata.txt_continue:draw()
		for i = 1, 2 do
			local txt = ''
			local var = ''
			if i == 1 then
				txt = startdata.txt_yes
				if startdata.t_continue.yesActive then
					var = 'yes_active'
				else
					var = 'yes'
				end
			else
				txt = startdata.txt_no
				if startdata.t_continue.yesActive then
					var = 'no'
				else
					var = 'no_active'
				end
			end
			txt:update({
				font =   motif.continue_screen[var .. '_font'][1],
				bank =   motif.continue_screen[var .. '_font'][2],
				align =  motif.continue_screen[var .. '_font'][3],
				text =   motif.continue_screen[var .. '_text'],
				x =      motif.continue_screen.pos[1] + motif.continue_screen[var .. '_offset'][1],
				y =      motif.continue_screen.pos[2] + motif.continue_screen[var .. '_offset'][2],
				scaleX = motif.continue_screen[var .. '_font_scale'][1],
				scaleY = motif.continue_screen[var .. '_font_scale'][2],
				r =      motif.continue_screen[var .. '_font'][4],
				g =      motif.continue_screen[var .. '_font'][5],
				b =      motif.continue_screen[var .. '_font'][6],
				src =    motif.continue_screen[var .. '_font'][7],
				dst =    motif.continue_screen[var .. '_font'][8],
				height = motif.continue_screen[var .. '_font_height'],
			})
			txt:draw()
		end
	end
	--draw layerno = 1 backgrounds
	bgDraw(motif.continuebgdef.bg, true)
	--draw fadein / fadeout
	main.fadeActive = fadeColor(
			startdata.t_continue.fadeType,
			main.fadeStart,
			motif.continue_screen[startdata.t_continue.fadeType .. '_time'],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][1],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][2],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][3]
	)
	--draw fadein / fadeout
	if startdata.t_continue.fadeType == 'fadein' and (startdata.t_continue.counter > motif.continue_screen.endtime or startdata.t_continue.continue or main.f_input({ 1}, { 'pal', 's'})) then
		main.fadeStart = getFrameCount()
		startdata.t_continue.fadeType = 'fadeout'
	end
	main.fadeActive = fadeColor(
			startdata.t_continue.fadeType,
			main.fadeStart,
			motif.continue_screen[startdata.t_continue.fadeType .. '_time'],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][1],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][2],
			motif.continue_screen[startdata.t_continue.fadeType .. '_col'][3]
	)
	--frame transition
	main.f_cmdInput()
	if esc() or main.f_input(main.t_players, {'m'}) then
		esc(false)
		startdata.t_continue.active = false
		startdata.continueFlag = false
		return false
	end
	if not main.fadeActive and startdata.t_continue.fadeType == 'fadeout' then
		startdata.t_continue.active = false
		startdata.continueFlag = startdata.t_continue.continue
		return false
	end
	return true
end

--;===========================================================
--; STAGE MUSIC
--;===========================================================
function start.f_stageMusic()
	if main.flags['-nomusic'] ~= nil then
		return
	end
	if gamemode('demo') and (motif.demo_mode.fight_playbgm == 0 or motif.demo_mode.fight_stopbgm == 0) then
		return
	end
	if roundstart() then
		if roundno() == 1 then
			main.f_playBGM(true, startdata.t_music.music.bgmusic, 1, startdata.t_music.music.volume, startdata.t_music.music.bgmloopstart, startdata.t_music.music.bgmloopend)
			startdata.bgmstate = 0
		elseif startdata.bgmstate ~= 1 then
			if startdata.t_music.musicalt.bgmusic ~= nil and (startdata.t_music.bgmtrigger_alt == 0 or roundtype() == 3) then
				main.f_playBGM(true, startdata.t_music.musicalt.bgmusic, 1, startdata.t_music.musicalt.volume, startdata.t_music.musicalt.bgmloopstart, startdata.t_music.musicalt.bgmloopend)
				startdata.bgmstate = 1
			elseif startdata.bgmstate == 2 then
				main.f_playBGM(true, startdata.t_music.music.bgmusic, 1, startdata.t_music.music.volume, startdata.t_music.music.bgmloopstart, startdata.t_music.music.bgmloopend)
				startdata.bgmstate = 0
			end
		end
	elseif startdata.t_music.musiclife.bgmusic ~= nil and startdata.bgmstate ~= 2 and roundstate() == 2 then
		local p1cnt, p2cnt = 1, 1
		if startdata.p1TeamMode == 1 or startdata.p1TeamMode == 3 then --p1 simul or tag
			p1cnt = #startdata.t_p1Selected
		end
		if startdata.p2TeamMode == 1 or startdata.p2TeamMode == 3 then --p2 simul or tag
			p2cnt = #startdata.t_p2Selected
		end
		for i = 1, #startdata.t_p1Selected + #startdata.t_p2Selected do
			player(i) --assign sys.debugWC to player i
			if life() / lifemax() * 100 <= startdata.t_music.bgmratio_life then
				if teamside() == 1 then
					if p1cnt > 1 or alive() then
						p1cnt = p1cnt - 1
					end
				elseif p2cnt > 1 or alive() then
					p2cnt = p2cnt - 1
				end
			end
		end
		local bglife = false
		if startdata.t_music.bgmtrigger_life == 1 then
			bglife = p1cnt <= 0 or p2cnt <= 0
		else
			bglife = (p1cnt <= 0 and player(1) and roundtype() >= 2) or (p2cnt <= 0 and player(2) and roundtype() >= 2)
		end
		if bglife then
			main.f_playBGM(true, startdata.t_music.musiclife.bgmusic, 1, startdata.t_music.musiclife.volume, startdata.t_music.musiclife.bgmloopstart, startdata.t_music.musiclife.bgmloopend)
			startdata.bgmstate = 2
		end
		--elseif #startconfig.t_music.musicvictory > 0 and start.bgmstate ~= -1 and matchover() then
	elseif #startdata.t_music.musicvictory > 0 and startdata.bgmstate ~= -1 and roundstate() == 3 then
		if startdata.t_music.musicvictory[1] ~= nil and player(1) and win() and (roundtype() == 1 or roundtype() == 3) then --assign sys.debugWC to player 1
			main.f_playBGM(true, startdata.t_music.musicvictory[1].bgmusic, 1, startdata.t_music.musicvictory[1].volume, startdata.t_music.musicvictory[1].bgmloopstart, startdata.t_music.musicvictory[1].bgmloopend)
			startdata.bgmstate = -1
		elseif startdata.t_music.musicvictory[2] ~= nil and player(2) and win() and (roundtype() == 1 or roundtype() == 3) then --assign sys.debugWC to player 2
			main.f_playBGM(true, startdata.t_music.musicvictory[2].bgmusic, 1, startdata.t_music.musicvictory[2].volume, startdata.t_music.musicvictory[2].bgmloopstart, startdata.t_music.musicvictory[2].bgmloopend)
			startdata.bgmstate = -1
		end
	end
end

function start.getStartData()
	return startdata
end

return start