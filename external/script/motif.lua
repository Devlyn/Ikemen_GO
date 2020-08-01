local MotifData = require('external.script.objects.motifdata')
local configservice = require('external.script.service.configservice')
--;===========================================================
--; DEFAULT VALUES
--;===========================================================
--This pre-made table (3/4 of the whole file) contains all default values used in screenpack. New table from parsed DEF file is merged on top of this one.
--This is important because there are more params available in Ikemen. Whole screenpack code refers to these values.
local motif = {}
local motifdata = MotifData:new(nil, configservice:getConfig(), main)
--;===========================================================
--; PARSE SCREENPACK
--;===========================================================
local function parseScreenPack(mainRef)
	local main = mainRef
	--here starts proper screenpack DEF file parsing
	main.t_fntDefault = {0, 0, 255, 255, 255, 255, 0}
	main.t_sort = {}
	local t = {}
	local pos = t
	local pos_sort = main.t_sort
	local def_pos = motifdata
	t.anim = {}
	local fileDir, fileName = motifdata.def:match('^(.-)([^/\\]+)$')
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
				def_pos = motifdata[group]
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
						pos.font_height[num] = main:f_dataType(value)
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
						for i, c in ipairs(main:f_strsplit(',', value)) do --split value using "," delimiter
							if param:match('_anim$') then --mugen recognizes animations even if there are more values
								pos[param] = main:f_dataType(c)
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
								table.insert(pos[param], main:f_dataType(c))
							end
						end
					else --single value
						pos[param] = main:f_dataType(value)
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
		main:loadingRefresh()
	end
	return t
end
local parsedPack = parseScreenPack(main)
--file:close()
if main.debugLog then main:f_printTable(main.t_sort, 'debug/t_sort.txt') end

--;===========================================================
--; FIX REFERENCES, LOAD DATA
--;===========================================================
local function adaptOldCellSpacing(tableRef)
	local table = tableRef
	--adopt old DEF code to Ikemen features
	if type(table.select_info.cell_spacing) ~= "table" then
		table.select_info.cell_spacing = { table.select_info.cell_spacing, table.select_info.cell_spacing}
	end
end
adaptOldCellSpacing(parsedPack)

local function adaptOldVictoryScreen(tableRef)
	local table = tableRef
	if table.victory_screen ~= nil then
		for i = 1, 4 do
			if table.victory_screen['p1_c' .. i .. '_spr'] == nil and table.victory_screen.p1_spr ~= nil then
				table.victory_screen['p1_c' .. i .. '_spr'] = table.victory_screen.p1_spr
			end
			if table.victory_screen['p2_c' .. i .. '_spr'] == nil and table.victory_screen.p2_spr ~= nil then
				table.victory_screen['p2_c' .. i .. '_spr'] = table.victory_screen.p2_spr
			end
		end
	end
end
adaptOldVictoryScreen(parsedPack)

local function updateTrainingInfo(motifRef, tableRef)
	--training_info section reuses menu_info values (excluding itemnames)
	local motif = motifRef
	local t = tableRef
	motif.training_info = main:f_tableMerge(motif.training_info, motif.menu_info)
	if t.menu_info == nil then t.menu_info = {} end
	if t.training_info == nil then t.training_info = {} end
	for k, v in pairs(t.menu_info) do
		if not k:match('_itemname_') then
			t.training_info[k] = v
		end
	end
end
updateTrainingInfo(motifdata, parsedPack)

local function mergeMotifTables(motifRef, tableRef)
	local motif = motifRef
	local t = tableRef
	--merge tables
	motif = main:f_tableMerge(motif, t)
end
mergeMotifTables(motifdata, parsedPack)

local function fixMissingValues(motifRef)
	local motif = motifRef
	--fix missing params/sections
	if motif.victory_screen.enabled == 0 then
		motif.victory_screen.cpu_enabled = 0
		motif.victory_screen.vs_enabled = 0
	end
end
fixMissingValues(motifdata)


local function updateDefaults(motifRef)
	local motif = motifRef
	--disable scaling if element should use default values (non-existing in mugen)
	motif.defaultWarning = true --t.warning_info == nil or t.warning_info.text_font == nil
	motif.defaultOptions = true --t.option_info == nil or t.option_info.menu_item_font == nil
	motif.defaultReplay = true --t.replay_info == nil or t.replay_info.menu_item_font == nil
	motif.defaultMenu = true --t.menu_info == nil or t.menu_info.menu_item_font == nil
	motif.defaultConnecting = true --t.title_info == nil or t.title_info.connecting_font == nil
	motif.defaultInfobox = false --t.infobox == nil or t.infobox.text_font == nil
	motif.defaultLoading = false --t.title_info == nil or t.title_info.loading_font == nil
	motif.defaultFooter = false --t.title_info == nil or t.title_info.footer1_font == nil
	motif.defaultLocalcoord = main.SP_Localcoord[1] ~= config.GameWidth or main.SP_Localcoord[2] ~= config.GameHeight
end
updateDefaults(motifdata)

--general paths
local t_dir = {
	{t = {'files',            'spr'},              skip = {'^data/'},        dirs = {motifdata.fileDir .. motifdata.files.spr,                   'data/' .. motifdata.files.spr}},
	{t = {'files',            'snd'},              skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.files.snd,                   'data/' .. motifdata.files.snd}},
	{t = {'files',            'logo_storyboard'},  skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.files.logo_storyboard,       'data/' .. motifdata.files.logo_storyboard}},
	{t = {'files',            'intro_storyboard'}, skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.files.intro_storyboard,      'data/' .. motifdata.files.intro_storyboard}},
	{t = {'files',            'select'},           skip = {'^data/'},        dirs = {motifdata.fileDir .. motifdata.files.select,                'data/' .. motifdata.files.select}},
	{t = {'files',            'fight'},            skip = {'^data/'},        dirs = {motifdata.fileDir .. motifdata.files.fight,                 'data/' .. motifdata.files.fight}},
	{t = {'files',            'glyphs'},           skip = {'^data/'},        dirs = {motifdata.fileDir .. motifdata.files.glyphs,                'data/' .. motifdata.files.glyphs}},
	{t = {'music',            'title_bgm'},        skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.title_bgm,             'music/' .. motifdata.music.title_bgm}},
	{t = {'music',            'select_bgm'},       skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.select_bgm,            'music/' .. motifdata.music.select_bgm}},
	{t = {'music',            'vs_bgm'},           skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.vs_bgm,                'music/' .. motifdata.music.vs_bgm}},
	{t = {'music',            'victory_bgm'},      skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.victory_bgm,           'music/' .. motifdata.music.victory_bgm}},
	{t = {'music',            'option_bgm'},       skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.option_bgm,            'music/' .. motifdata.music.option_bgm}},
	{t = {'music',            'replay_bgm'},       skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.replay_bgm,            'music/' .. motifdata.music.replay_bgm}},
	{t = {'music',            'continue_bgm'},     skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.continue_bgm,          'music/' .. motifdata.music.continue_bgm}},
	{t = {'music',            'continue_end_bgm'}, skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.continue_end_bgm,      'music/' .. motifdata.music.continue_end_bgm}},
	{t = {'music',            'results_bgm'},      skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.results_bgm,           'music/' .. motifdata.music.results_bgm}},
	{t = {'music',            'tournament_bgm'},   skip = {'^music/', '^$'}, dirs = {motifdata.fileDir .. motifdata.music.tournament_bgm,        'music/' .. motifdata.music.tournament_bgm}},
	{t = {'default_ending',   'storyboard'},       skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.default_ending.storyboard,   'data/' .. motifdata.default_ending.storyboard}},
	{t = {'end_credits',      'storyboard'},       skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.end_credits.storyboard,      'data/' .. motifdata.end_credits.storyboard}},
	{t = {'game_over_screen', 'storyboard'},       skip = {'^data/',  '^$'}, dirs = {motifdata.fileDir .. motifdata.game_over_screen.storyboard, 'data/' .. motifdata.game_over_screen.storyboard}},
}
for k, v in ipairs(t_dir) do
	local skip = false
	for j = 1, #v.skip do
		if motifdata[v.t[1]][v.t[2]]:match(v.skip[j]) then
			skip = true
			break
		end
	end
	if not skip then
		for j = 1, #v.dirs do
			if main:f_fileExists(v.dirs[j]) then
				motifdata[v.t[1]][v.t[2]] = v.dirs[j]
				break
			end
		end
	end
end

motifdata.files.spr_data = sffNew(motifdata.files.spr)
main:loadingRefresh()
motifdata.files.snd_data = sndNew(motifdata.files.snd)
main:loadingRefresh()
motifdata.files.glyphs_data = sffNew(motifdata.files.glyphs)
main:loadingRefresh()

--data
local anim = ''
local facing = ''
t_dir = {'titlebgdef', 'selectbgdef', 'versusbgdef', 'continuebgdef', 'victorybgdef', 'resultsbgdef', 'optionbgdef', 'replaybgdef', 'menubgdef', 'trainingbgdef', 'tournamentbgdef'}
for k, v in ipairs(t_dir) do
	if v == 'trainingbgdef' and parsedPack.trainingbgdef == nil then
		motifdata[v] = motifdata.menubgdef
	else
		--optional sff paths and data
		if motifdata[v].spr ~= '' then
			if not motifdata[v].spr:match('^data/') then
				if main:f_fileExists(motifdata.fileDir .. motifdata[v].spr) then
					motifdata[v].spr = motifdata.fileDir .. motifdata[v].spr
				elseif main:f_fileExists('data/' .. motifdata[v].spr) then
					motifdata[v].spr = 'data/' .. motifdata[v].spr
				end
			end
			motifdata[v].spr_data = sffNew(motifdata[v].spr)
			main:loadingRefresh()
		else
			motifdata[v].spr = motifdata.files.spr
			motifdata[v].spr_data = motifdata.files.spr_data
		end
		--backgrounds
		motifdata[v].bg = bgNew(motifdata[v].spr_data, motifdata.def, v:match('^(.+)def$'))
		main:loadingRefresh()
	end
end

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
			t[v.s .. 'data'] = animNew(motifdata.files.spr_data, anim)
			animSetScale(t[v.s .. 'data'], t[v.s .. 'scale'][1], t[v.s .. 'scale'][2])
			animUpdate(t[v.s .. 'data'])
		elseif t[v.s .. 'anim'] ~= nil and motifdata.anim[t[v.s .. 'anim']] ~= nil then --create animation data
			t[v.s .. 'data'] = main:f_animFromTable(
					motifdata.anim[t[v.s .. 'anim']],
					motifdata.files.spr_data,
					t[v.s .. 'offset'][1] + v.x,
					t[v.s .. 'offset'][2] + v.y,
					t[v.s .. 'scale'][1],
					t[v.s .. 'scale'][2],
					f_facing(t[v.s .. 'facing'])
			)
		else --create dummy data
			t[v.s .. 'data'] = animNew(motifdata.files.spr_data, '-1, -1, 0, 0, -1')
			animUpdate(t[v.s .. 'data'])
		end
		animSetWindow(t[v.s .. 'data'], 0, 0, motifdata.info.localcoord[1], motifdata.info.localcoord[2])
		main:loadingRefresh()
	end
end

parsedPack = motifdata.select_info
t_dir = {
	{s = 'cell_bg_',                      x = 0,                                                   y = 0},
	{s = 'cell_random_',                  x = 0,                                                   y = 0},
	{s = 'p1_cursor_active_',             x = 0,                                                   y = 0},
	{s = 'p1_cursor_done_',               x = 0,                                                   y = 0},
	{s = 'p2_cursor_active_',             x = 0,                                                   y = 0},
	{s = 'p2_cursor_done_',               x = 0,                                                   y = 0},
	{ s = 'p1_teammenu_bg_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_bg_single_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_bg_simul_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_bg_turns_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_bg_tag_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_bg_ratio_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_selftitle_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_enemytitle_', x = parsedPack.p1_teammenu_pos[1], y = parsedPack.p1_teammenu_pos[2]},
	{ s = 'p1_teammenu_item_cursor_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_value_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_value_empty_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio1_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio2_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio3_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio4_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio5_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio6_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p1_teammenu_ratio7_icon_', x = parsedPack.p1_teammenu_pos[1] + parsedPack.p1_teammenu_item_offset[1], y = parsedPack.p1_teammenu_pos[2] + parsedPack.p1_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_bg_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_bg_single_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_bg_simul_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_bg_turns_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_bg_tag_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_bg_ratio_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_selftitle_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_enemytitle_', x = parsedPack.p2_teammenu_pos[1], y = parsedPack.p2_teammenu_pos[2]},
	{ s = 'p2_teammenu_item_cursor_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_value_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_value_empty_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio1_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio2_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio3_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio4_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio5_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio6_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'p2_teammenu_ratio7_icon_', x = parsedPack.p2_teammenu_pos[1] + parsedPack.p2_teammenu_item_offset[1], y = parsedPack.p2_teammenu_pos[2] + parsedPack.p2_teammenu_item_offset[2]},
	{ s = 'stage_portrait_random_', x = parsedPack.stage_pos[1] + parsedPack.stage_portrait_offset[1], y = parsedPack.stage_pos[2] + parsedPack.stage_portrait_offset[2]},
}
f_loadSprData(motifdata.select_info, t_dir)

for k, v in ipairs({motifdata.title_info, motifdata.option_info, motifdata.replay_info, motifdata.menu_info, motifdata.training_info}) do
	f_loadSprData(v, {
		{s = 'menu_arrow_up_',   x = v.menu_pos[1], y = v.menu_pos[2]},
		{s = 'menu_arrow_down_', x = v.menu_pos[1], y = v.menu_pos[2]},
	})
end
for k, v in ipairs({motifdata.menu_info, motifdata.training_info}) do
	f_loadSprData(v, {
		{s = 'movelist_arrow_up_',   x = v.movelist_pos[1], y = v.movelist_pos[2]},
		{s = 'movelist_arrow_down_', x = v.movelist_pos[1], y = v.movelist_pos[2]},
	})
end

motifdata.glyphs_data = {}
for k, v in pairs(motifdata.glyphs) do
	--https://www.ssec.wisc.edu/~tomw/java/unicode.html#xE000
	k = numberToRune(v[1] + 0xe000) --Private Use 0xe000 (57344) - 0xf8ff (63743)
	local anim = animNew(motifdata.files.glyphs_data, v[1] .. ', ' .. v[2] .. ', 0, 0, -1')
	--animSetScale(anim, 1, 1)
	animUpdate(anim)
	motifdata.glyphs_data[k] = {
		anim = anim,
		--info = animGetSpriteInfo(anim, v[1], v[2]),
		info = animGetSpriteInfo(anim),
	}
end

if motifdata.vs_screen.p1_name_active_font == nil then
	motifdata.vs_screen.p1_name_active_font = {
		motifdata.vs_screen.p1_name_font[1],
		motifdata.vs_screen.p1_name_font[2],
		motifdata.vs_screen.p1_name_font[3],
		motifdata.vs_screen.p1_name_font[4],
		motifdata.vs_screen.p1_name_font[5],
		motifdata.vs_screen.p1_name_font[6],
		motifdata.vs_screen.p1_name_font[7],
		motifdata.vs_screen.p1_name_font[8]
	}
	motifdata.vs_screen.p1_name_active_font_scale = {motifdata.vs_screen.p1_name_font_scale[1], motifdata.vs_screen.p1_name_font_scale[2]}
end
if motifdata.vs_screen.p2_name_active_font == nil then
	motifdata.vs_screen.p2_name_active_font = {
		motifdata.vs_screen.p2_name_font[1],
		motifdata.vs_screen.p2_name_font[2],
		motifdata.vs_screen.p2_name_font[3],
		motifdata.vs_screen.p2_name_font[4],
		motifdata.vs_screen.p2_name_font[5],
		motifdata.vs_screen.p2_name_font[6],
		motifdata.vs_screen.p2_name_font[7],
		motifdata.vs_screen.p2_name_font[8]
	}
	motifdata.vs_screen.p2_name_active_font_scale = {motifdata.vs_screen.p2_name_font_scale[1], motifdata.vs_screen.p2_name_font_scale[2]}
end

--commands
local t_cmdItems = {
	motifdata.title_info.menu_key_next,
	motifdata.title_info.menu_key_previous,
	motifdata.title_info.menu_key_accept,
	motifdata.select_info.teammenu_key_next,
	motifdata.select_info.teammenu_key_previous,
	motifdata.select_info.teammenu_key_add,
	motifdata.select_info.teammenu_key_subtract,
	motifdata.select_info.teammenu_key_accept,
}
for k, v in ipairs(t_cmdItems) do
	for i, cmd in ipairs (main:f_extractKeys(v)) do
		main:f_commandAdd(cmd)
	end
end

-- If we don't find menu in system.def we use the default one.
if main.t_sort.option_info == nil or #main.t_sort.option_info == 0 then
	motifdata:setBaseOptionInfo()
end
if main.t_sort.menu_info == nil or #main.t_sort.menu_info == 0 then
	motifdata:setBaseMenuInfo()
end
if main.t_sort.training_info == nil or #main.t_sort.training_info == 0 then
	motifdata:setBaseTrainingInfo()
end

if main.debugLog then main:f_printTable(motifdata, "debug/t_motif.txt") end

function motif.getMotifData()
	return motifdata
end

return motif