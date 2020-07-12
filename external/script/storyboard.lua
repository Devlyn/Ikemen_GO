require('external.script.util.dump')
require('external.script.common.common')

local storyboard = {}

--http://www.elecbyte.com/mugendocs/storyboard.html

storyboard.t_storyboard = {} --stores all parsed storyboards (we parse each of them only once)

local function f_reset(t)
	for k, v in pairs(t.scene) do
		if t.scene[k].bg_name ~= '' then
			bgReset(t.scene[k].bg)
		end
		for k2, v2 in pairs(t.scene[k].layer) do
			if t.scene[k].layer[k2].anim_data ~= nil then
				animReset(t.scene[k].layer[k2].anim_data)
				animUpdate(t.scene[k].layer[k2].anim_data)
			end
			t.scene[k].layer[k2].text_timer = 0
		end
	end
end

local function f_play(t)
	playBGM('')
	if main.debugLog then main.f_printTable(t, 'debug/t_storyboard.txt') end
	--loop through scenes in order
	for k, v in main.f_sortKeys(t.scene) do
		--scene >= startscene
		if k >= t.scenedef.startscene then
			local fadeType = 'fadein'
			local fadeStart = getFrameCount()
			for i = 0, t.scene[k].end_time do
				--end storyboard
				if (esc() or main.input({1, 2}, {'pal', 's'})) and t.scenedef.skipbutton > 0 then
					main.f_cmdInput()
					return
				end
				--play bgm
				if i == 0 and t.scene[k].bgm ~= nil then
					playBGM(t.scene[k].bgm, true, t.scene[k].bgm_loop, t.scene[k].bgm_volume, t.scene[k].bgm_loopstart, t.scene[k].bgm_loopend)
				end
				--play snd
				if t.scenedef.snd_data ~= nil then
					for k2, v2 in main.f_sortKeys(t.scene[k].sound) do
						if i == v2.starttime then
							sndPlay(t.scenedef.snd_data, v2.value[1], v2.value[2])
						end
					end
				end
				--draw clearcolor
				clearColor(t.scene[k].clearcolor[1], t.scene[k].clearcolor[2], t.scene[k].clearcolor[3])
				--draw layerno = 0 backgrounds
				if t.scene[k].bg_name ~= '' then
					bgDraw(t.scene[k].bg, false)
				end
				--loop through layers in order
				for k2, v2 in main.f_sortKeys(t.scene[k].layer) do
					if i >= t.scene[k].layer[k2].starttime and i <= t.scene[k].layer[k2].endtime then
						--layer anim
						if t.scene[k].layer[k2].anim_data ~= nil then
							animDraw(t.scene[k].layer[k2].anim_data)
							animUpdate(t.scene[k].layer[k2].anim_data)
						end
						--layer text
						if t.scene[k].layer[k2].text_data ~= nil then
							t.scene[k].layer[k2].text_timer = t.scene[k].layer[k2].text_timer + 1
							main.f_textRender(
								t.scene[k].layer[k2].text_data,
								t.scene[k].layer[k2].text,
								t.scene[k].layer[k2].text_timer,
								t.scene[k].layerall_pos[1] + t.scene[k].layer[k2].offset[1],
								t.scene[k].layerall_pos[2] + t.scene[k].layer[k2].offset[2],
								main.font_def[t.scene[k].layer[k2].font[1] .. t.scene[k].layer[k2].font_height],
								t.scene[k].layer[k2].text_delay,
								main.f_lineLength(t.scene[k].layerall_pos[1] + t.scene[k].layer[k2].offset[1], t.info.localcoord[1], t.scene[k].layer[k2].font[3], t.scene[k].layer[k2].text_window, true)
							)
							end
					end
				end
				--draw layerno = 1 backgrounds
				if t.scene[k].bg_name ~= '' then
					bgDraw(t.scene[k].bg, true)
				end
				--draw fadein / fadeout
				if i == t.scene[k].end_time - t.scene[k].fadeout_time then
					fadeType = 'fadeout'
					fadeStart = getFrameCount()
				end
				main.fadeActive = fadeScreen(
					fadeType,
					fadeStart,
					t.scene[k][fadeType .. '_time'],
					t.scene[k][fadeType .. '_col'][1],
					t.scene[k][fadeType .. '_col'][2],
					t.scene[k][fadeType .. '_col'][3]
				)
				--if main.input({1}, {'pal', 's'}) and t.scenedef.skipbutton <= 0 then
				--	main.f_cmdInput()
				--	refresh()
				--	do
				--		break
				--	end
				--end
				main.f_cmdInput()
				callGoRefresh()
			end
		end
	end
end

local function f_parse(path)
	--storyboards use their own localcoord function, so we disable it
	main.SetDefaultScale()
	local file = io.open(path, 'r')
	local fileDir, fileName = path:match('^(.-)([^/\\]+)$')
	local t = {}
	local pos = t
	local pos_default = {}
	local pos_val = {}
	t.anim = {}
	t.scene = {}
	t.def = fileDir .. fileName
	t.fileDir = fileDir
	t.fileName = fileName
	local tmp = ''
	local t_default =
	{
		info = {localcoord = {320, 240}},
		scenedef = {
			spr = '',
			snd = '',
			font = {},
			font_height = {},
			startscene = 0,
			skipbutton = 1, --Ikemen feature
		},
		scene = {},
	}
	for line in file:lines() do
		line = line:gsub('%s*;.*$', '')
		if line:match('^%s*%[.-%s*%]%s*$') then --matched [] group
			line = line:match('^%s*%[(.-)%s*%]%s*$') --match text between []
			line = line:gsub('[%. ]', '_') --change . and space to _
			local row = tostring(line:lower())
			if row:match('^scene_[0-9]+$') then --matched scene
				row = tonumber(row:match('^scene_([0-9]+)$'))
				t.scene[row] = {}
				pos = t.scene[row]
				pos.layer = {}
				pos.sound = {}
				t_default.scene[row] =
				{
					end_time = 0,
					fadein_time = 0,
					fadein_col = {0, 0, 0},
					fadeout_time = 0,
					fadeout_col = {0, 0, 0},
					clearcolor = {},
					layerall_pos = {},
					layer = {},
					sound = {},
					--bgm = '',
					bgm_loop = 0,
					bgm_volume = 100,  --Ikemen feature
					bgm_loopstart = 0, --Ikemen feature
					bgm_loopend = 0, --Ikemen feature
					--window = {0, 0, 0, 0},
					bg_name = ''
				}
				pos_default = t_default.scene[row]
			elseif row:match('^begin_action_[0-9]+$') then --matched anim
				row = tonumber(row:match('^begin_action_([0-9]+)$'))
				t.anim[row] = {}
				pos = t.anim[row]
			else --matched other []
				t[row] = {}
				pos = t[row]
			end
		else --matched non [] line
			local param, value = line:match('^%s*([^=]-)%s*=%s*(.-)%s*$')
			if param ~= nil and value ~= nil and not value:match('^%s*$') then --param = value pattern matched
				param = param:gsub('[%. ]', '_') --change param . and space to _
				param = param:lower() --lowercase param
				value = value:gsub('"', '') --remove brackets from value
				value = value:gsub('^(%.[0-9])', '0%1') --add 0 before dot if missing at the beginning of matched string
				value = value:gsub('([^0-9])(%.[0-9])', '%10%2') --add 0 before dot if missing anywhere else
				if param:match('^font[0-9]+') then --font param matched
					local num = tonumber(param:match('font([0-9]+)'))
					if param:match('_height$') then
						if pos.font_height == nil then
							pos.font_height = {}
						end
						pos.font_height[num] = main.f_dataType(value)
					else
						value = value:gsub('\\', '/')
						if pos.font == nil then
							pos.font = {}
						end
						pos.font[num] = tostring(value)
					end
				else
					if param:match('^layer[0-9]+_') then --scene layer param matched
						local num = tonumber(param:match('^layer([0-9]+)_'))
						param = param:gsub('layer[0-9]+_', '')
						if pos.layer[num] == nil then
							pos.layer[num] = {}
							pos_default.layer[num] =
							{
								anim = -1,
								text = '',
								font = {'f-6x9.def', 0, 0, 255, 255, 255, 255, 0},
								font_scale = {1.0, 1.0}, --Ikemen feature
								font_height = -1, --Ikemen feature
								text_delay = 2, --Ikemen feature
								text_window = {}, --Ikemen feature
								text_timer = 0, --Ikemen feature
								offset = {0, 0},
								starttime = 0,
								--endtime = 0
							}
						end
						pos_val = pos.layer[num]
					elseif param:match('^sound[0-9]+_') then --sound param matched
						local num = tonumber(param:match('^sound([0-9]+)_'))
						param = param:gsub('sound[0-9]+_', '')
						if pos.sound[num] == nil then
							pos.sound[num] = {}
							pos_default.sound[num] =
							{
								value = {-1, -1},
								starttime = 0,
								volumescale = 100, --not supported yet
								pan = 0 --not supported yet
							}
						end
						pos_val = pos.sound[num]
					else
						pos_val = pos
					end
					if pos_val[param] == nil or param:match('_font_height$') then --mugen takes into account only first occurrence
						if param:match('_font$') then --assign default font values if needed (also ensure that there are multiple values in the first place)
							local _, n = value:gsub(',%s*[0-9]*', '')
							for i = n + 1, #main.t_fntDefault do
								value = value:gsub(',?%s*$', ',' .. main.t_fntDefault[i])
							end
						end
						if value:match('.+,.+') then --multiple values
							for i, c in ipairs(main.f_strsplit(',', value)) do --split value using "," delimiter
								if i == 1 then
									--t_layer[k2].font
									pos_val[param] = {}
									if param:match('_font$') and tonumber(c) ~= -1 then
										if t.scenedef ~= nil and t.scenedef.font ~= nil and t.scenedef.font[tonumber(c)] ~= nil then
											if pos_val[param .. '_height'] == nil and t.scenedef.font_height[tonumber(c)] ~= nil then
												pos_val[param .. '_height'] = t.scenedef.font_height[tonumber(c)]
											end
											c = t.scenedef.font[tonumber(c)]
										else
											break --use default font values
										end
									end
								end
								if c == nil or c == '' then
									table.insert(pos_val[param], 0)
								else
									table.insert(pos_val[param], main.f_dataType(c))
								end
							end
						else --single value
							pos_val[param] = main.f_dataType(value)
						end
					end
				end
			else --only valid lines left are animations
				line = line:lower()
				local value = line:match('^%s*([0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+%s*,%s*[0-9%-]+.-)[,%s]*$') or line:match('^%s*loopstart') or line:match('^%s*interpolate [oasb][fncl][fgae][sln][ed]t?')
				if value ~= nil then
					value = value:gsub(',%s*,', ',0,') --add missing values
					value = value:gsub(',%s*$', '')
					table.insert(pos, value)
				end
			end
		end
	end
	file:close()
	--;===========================================================
	--; FIX REFERENCES, LOAD DATA
	--;===========================================================
	--merge tables
	t = main.f_tableMerge(t_default, t)
	--scenedef spr
	if not t.scenedef.spr:match('^data/') then
		if f_fileExists(t.fileDir .. t.scenedef.spr) then
			t.scenedef.spr = t.fileDir .. t.scenedef.spr
		elseif f_fileExists('data/' .. t.scenedef.spr) then
			t.scenedef.spr = 'data/' .. t.scenedef.spr
		end
	end
	t.scenedef.spr_data = sffNew(t.scenedef.spr)
	--scenedef snd
	if t.scenedef.snd ~= '' then
		if not t.scenedef.snd:match('^data/') then
			if f_fileExists(t.fileDir .. t.scenedef.snd) then
				t.scenedef.snd = t.fileDir .. t.scenedef.snd
			elseif f_fileExists('data/' .. t.scenedef.snd) then
				t.scenedef.snd = 'data/' .. t.scenedef.snd
			end
		end
		t.scenedef.snd_data = sndNew(t.scenedef.snd)
	end
	--loop through scenes
	local prev_k = ''
	for k, v in main.f_sortKeys(t.scene) do
		--bgm
		if t.scene[k].bgm ~= nil then
			if t.scene[k].bgm:match('^data/') then
			elseif f_fileExists(t.fileDir .. t.scene[k].bgm) then
				t.scene[k].bgm = t.fileDir .. t.scene[k].bgm
			elseif f_fileExists('music/' .. t.scene[k].bgm) then
				t.scene[k].bgm = 'music/' .. t.scene[k].bgm
			end
		end
		--default values
		if #t.scene[k].clearcolor == 0 then
			if prev_k ~= '' and #t.scene[prev_k].clearcolor > 0 then
				t.scene[k].clearcolor[1], t.scene[k].clearcolor[2], t.scene[k].clearcolor[3] = t.scene[prev_k].clearcolor[1], t.scene[prev_k].clearcolor[2], t.scene[prev_k].clearcolor[3]
			else
				t.scene[k].clearcolor[1], t.scene[k].clearcolor[2], t.scene[k].clearcolor[3] = 0, 0, 0
			end
		end
		if #t.scene[k].layerall_pos == 0 then
			if prev_k ~= '' and #t.scene[prev_k].layerall_pos > 0 then
				t.scene[k].layerall_pos[1], t.scene[k].layerall_pos[2] = t.scene[prev_k].layerall_pos[1], t.scene[prev_k].layerall_pos[2]
			else
				t.scene[k].layerall_pos[1], t.scene[k].layerall_pos[2] = 0, 0
			end
		end
		prev_k = k
		--backgrounds
		if t.scene[k].bg_name ~= '' then
			t.scene[k].bg = bgNew(t.scenedef.spr_data, t.def, t.scene[k].bg_name:lower())
			bgReset(t.scene[k].bg)
		end
		--loop through scene layers
		local t_layer = t.scene[k].layer
		for k2, v2 in pairs(t_layer) do
			--anim
			if t_layer[k2].anim ~= -1 and t.anim[t_layer[k2].anim] ~= nil then
				t.scene[k].layer[k2].anim_data = main.f_animFromTable(
					t.anim[t_layer[k2].anim],
					t.scenedef.spr_data,
					t.scene[k].layerall_pos[1] + t_layer[k2].offset[1],
					t.scene[k].layerall_pos[2] + t_layer[k2].offset[2]
				)
				animSetScale(t.scene[k].layer[k2].anim_data, 320/t.info.localcoord[1], 240/t.info.localcoord[2])
			end
			--text
			if t_layer[k2].text ~= '' then
				t.scene[k].layer[k2].text_data = text:create({
					font =   t_layer[k2].font[1],
					bank =   t_layer[k2].font[2],
					align =  t_layer[k2].font[3],
					text =   t_layer[k2].text,
					x =      t.scene[k].layerall_pos[1] + t_layer[k2].offset[1],
					y =      t.scene[k].layerall_pos[2] + t_layer[k2].offset[2],
					scaleX = t_layer[k2].font_scale[1] * 320 / t.info.localcoord[1],
					scaleY = t_layer[k2].font_scale[2] * 240 / t.info.localcoord[2],
					r =      t_layer[k2].font[4],
					g =      t_layer[k2].font[5],
					b =      t_layer[k2].font[6],
					src =    t_layer[k2].font[7],
					dst =    t_layer[k2].font[8],
					height = t_layer[k2].font_height,
					window = t_layer[k2].text_window
				})
			end
			--endtime
			if t_layer[k2].endtime == nil then
				t_layer[k2].endtime = t.scene[k].end_time
			end
		end
	end
	--finished loading storyboard, re-enable custom scaling
	main.SetScaleValues()
	return t
end

function storyboard.f_storyboard(path)
	path = path:gsub('\\', '/')
	if storyboard.t_storyboard[path] == nil then
		storyboard.t_storyboard[path] = f_parse(path)
	else
		f_reset(storyboard.t_storyboard[path])
	end
	f_play(storyboard.t_storyboard[path])
end

return storyboard
