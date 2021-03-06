local common = require('external.script.common.common')
local configservice = require('external.script.service.configservice')
local statsservice = require('external.script.service.statsservice')
local MainData = require('external.script.objects.maindata')

main = {}

--nClock = os.clock()
--print("Elapsed time: " .. os.clock() - nClock)
--;===========================================================
--; INITIALIZE DATA
--;===========================================================
math.randomseed(os.time())

main.flags = getCommandLineFlags()
if main.flags['-config'] == nil then main.flags['-config'] = 'save/config.json' end
if main.flags['-stats'] == nil then main.flags['-stats'] = 'save/stats.json' end

--One-time load of the json routines
json = common:getJSONparser()

--Data loading from config.json
config = configservice:getConfig()

if config.SafeLoading then
	setGCPercent(-1)
end

--Data loading from stats.json
stats = statsservice:getStats()

local maindata = MainData:new(nil, config)

--;===========================================================
--; COMMON FUNCTIONS
--;===========================================================
--add default commands
function main:f_initCommandsTable()
	self.t_commands = {
	['$U'] = 0, ['$D'] = 0, ['$B'] = 0, ['$F'] = 0, ['a'] = 0, ['b'] = 0, ['c'] = 0, ['x'] = 0, ['y'] = 0, ['z'] = 0, ['s'] = 0, ['d'] = 0, ['w'] = 0, ['m'] = 0, ['/s'] = 0, ['/d'] = 0, ['/w'] = 0}
end
main:f_initCommandsTable()

function main:f_commandNew()
	local c = commandNew()
	for k, v in pairs(self.t_commands) do
		commandAdd(c, k, k)
	end
	return c
end

function main:f_initPlayers()
	self.t_players = {}
	self.t_cmd = {}
	self.t_pIn = {}
	for i = 1, #config.KeyConfig do
		table.insert(self.t_players, i)
		table.insert(self.t_cmd, self:f_commandNew())
		table.insert(self.t_pIn, i)
	end
end
main:f_initPlayers()

--add new commands
function main:f_commandAdd(cmd)
	if self.t_commands[cmd] ~= nil then
		return
	end
	for i = 1, #self.t_cmd do
		commandAdd(self.t_cmd[i], cmd, cmd)
	end
	self.t_commands[cmd] = 0
end

--makes the input detectable in the current frame
function main:f_cmdInput()
	for i = 1, #config.KeyConfig do
		commandInput(self.t_cmd[i], self.t_pIn[i])
	end
end

--returns value depending on button pressed (a = 1; a + start = 7 etc.)
function main:f_btnPalNo(cmd)
	local s = 0
	if commandGetState(cmd, '/s') then s = 6 end
	for i, k in pairs({'a', 'b', 'c', 'x', 'y', 'z'}) do
		if commandGetState(cmd, k) then return i + s end
	end
	return 0
end

--return bool based on command input
function main:f_input(p, b)
	for i = 1, #p do
		for j = 1, #b do
			if b[j] == 'pal' then
				if self:f_btnPalNo(self.t_cmd[p[i]]) > 0 then
					return true
				end
			elseif commandGetState(self.t_cmd[p[i]], b[j]) then
				return true
			end
		end
	end
	return false
end

--return table with key names
function main:f_extractKeys(str)
	local t = {}
	for i, c in ipairs(self:f_strsplit('%s*&%s*', str)) do --split string using "%s*&%s*" delimiter
		t[i] = c
	end
	return t
end

--check if a file or directory exists in this path
function main:f_exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			--permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--check if a directory exists in this path
function main:f_isdir(path)
	-- "/" works on both Unix and Windows
	return self:f_exists(path .. '/')
end

function main:f_checkDebugDir()
	self.debugLog = false
	if self:f_isdir('debug') then
		self.debugLog = true
	end
end
main:f_checkDebugDir()

--check if file exists
function main:f_fileExists(file)
	if file == '' then
		return false
	end
	local f = io.open(file,'r')
	if f ~= nil then
		io.close(f)
		return true
	end
	return false
end

--prints "t" table content into "toFile" file
function main:f_printTable(t, toFile)
	local toFile = toFile or 'debug/table_print.txt'
	local txt = ''
	local print_t_cache = {}
	local function sub_print_t(t, indent)
		if print_t_cache[tostring(t)] then
			txt = txt .. indent .. '*' .. tostring(t) .. '\n'
		else
			print_t_cache[tostring(t)] = true
			if type(t) == 'table' then
				for pos, val in pairs(t) do
					if type(val) == 'table' then
						txt = txt .. indent .. '[' .. pos .. '] => ' .. tostring(t) .. ' {' .. '\n'
						sub_print_t(val, indent .. string.rep(' ', string.len(tostring(pos)) + 8))
						txt = txt .. indent .. string.rep(' ', string.len(tostring(pos)) + 6) .. '}' .. '\n'
					elseif type(val) == 'string' then
						txt = txt .. indent .. '[' .. pos .. '] => "' .. val .. '"' .. '\n'
					else
						txt = txt .. indent .. '[' .. pos .. '] => ' .. tostring(val) ..'\n'
					end
				end
			else
				txt = txt .. indent .. tostring(t) .. '\n'
			end
		end
	end
	if type(t) == 'table' then
		txt = txt .. tostring(t) .. ' {' .. '\n'
		sub_print_t(t, '  ')
		txt = txt .. '}' .. '\n'
	else
		sub_print_t(t, '  ')
	end
	local file = io.open(toFile,"w+")
	if file == nil then return end
	file:write(txt)
	file:close()
end

--prints "v" variable into "toFile" file
function main:f_printVar(v, toFile)
	local toFile = toFile or 'debug/var_print.txt'
	local file = io.open(toFile,"w+")
	file:write(v)
	file:close()
end

--split strings
function main:f_strsplit(delimiter, text)
	local list = {}
	local pos = 1
	if string.find('', delimiter, 1) then
		if string.len(text) == 0 then
			table.insert(list, text)
		else
			for i = 1, string.len(text) do
				table.insert(list, string.sub(text, i, i))
			end
		end
	else
		while true do
			local first, last = string.find(text, delimiter, pos)
			if first then
				table.insert(list, string.sub(text, pos, first - 1))
				pos = last + 1
			else
				table.insert(list, string.sub(text, pos))
				break
			end
		end
	end
	return list
end

--escape ().%+-*?[^$ characters
function main:f_escapePattern(str)
	return str:gsub('([^%w])', '%%%1')
end

--
function main:f_initCommandLineFlags()
	--command line global flags
	if self.flags['-ailevel'] ~= nil then
		config.Difficulty = math.max(1, math.min(tonumber(self.flags['-ailevel']), 8))
	end
	if self.flags['-speed'] ~= nil then
		config.GameSpeed = math.max(10, math.min(tonumber(self.flags['-speed']), 200))
	end
	if self.flags['-speedtest'] ~= nil then
		setGameSpeed(100)
	end
	if self.flags['-nosound'] ~= nil then
		setVolumeMaster(0)
	end
	if self.flags['-togglelifebars'] ~= nil then
		toggleStatusDraw()
	end
	if self.flags['-maxpowermode'] ~= nil then
		toggleMaxPowerMode()
	end
end
main:f_initCommandLineFlags()

--motif
function main:f_loadSystemDef()
	self.motifDef = config.Motif
	if self.flags['-r'] ~= nil or self.flags['-rubric'] ~= nil then
		local case = self.flags['-r']:lower() or self.flags['-rubric']:lower()
		if case:match('^data[/\\]') and self:f_fileExists(self.flags['-r']) then
			self.motifDef = self.flags['-r'] or self.flags['-rubric']
		elseif case:match('%.def$') and self:f_fileExists('data/' .. self.flags['-r']) then
			self.motifDef = 'data/' .. (self.flags['-r'] or self.flags['-rubric'])
		elseif self:f_fileExists('data/' .. self.flags['-r'] .. '/system.def') then
			self.motifDef = 'data/' .. (self.flags['-r'] or self.flags['-rubric']) .. '/system.def'
		end
	end
	self.motifData = common:getFile(self.motifDef, 'r')
end
main:f_loadSystemDef()

--lifebar
--local file = io.open(main.motifDef, 'r')
--main.motifData = file:read("*all")
--file:close()

function main:f_loadLifeBarDef()
	local fileDir = self.motifDef:match('^(.-)[^/\\]+$')
	if self.flags['-lifebar'] ~= nil then
		self.lifebarDef = self.flags['-lifebar']
	else
		self.lifebarDef = self.motifData:match('\n%s*fight%s*=%s*(.-%.def)%s*')
	end
	if self:f_fileExists(self.lifebarDef) then
		self.lifebarDef = self.lifebarDef
	elseif self:f_fileExists(fileDir .. self.lifebarDef) then
		self.lifebarDef = fileDir .. self.lifebarDef
	elseif self:f_fileExists('data/' .. self.lifebarDef) then
		self.lifebarDef = 'data/' .. self.lifebarDef
	else
		self.lifebarDef = 'data/fight.def'
	end
	self.lifebarData = common:getFile(self.lifebarDef, 'r')
end
main:f_loadLifeBarDef()
refresh()

--localcoord
require('external.script.screenpack')

--fix for wrong x coordinate after flipping text/sprite (this should be fixed on source code level at some point)
function main:f_alignOffset(align)
	if align == -1 then
		return 1
	end
	return 0
end

main.font = {}
main.font_def = {}

local ColorUtils = require('external.script.util.colorutils')
color = ColorUtils:getColor()
local RectangleUtils = require('external.script.util.rectangleutils')
rect = RectangleUtils:getRectangle(color)

--refreshing screen after delayed animation progression to next frame
main.t_animUpdate = {}
function main:f_refresh()
	for k, v in pairs(self.t_animUpdate) do
		for i = 1, v do
			animUpdate(k)
		end
	end
	self.t_animUpdate = {}
	refresh()
end

--animDraw at specified coordinates
function main:f_animPosDraw(a, x, y, f)
	self.t_animUpdate[a] = 1
	animSetPos(a, x, y)
	if f ~= nil then animSetFacing(a, f) end
	animDraw(a)
end

--dynamically adjusts alpha blending each time called based on specified values
local alpha1cur = 0
local alpha2cur = 0
local alpha1add = true
local alpha2add = true
function main:f_boxcursorAlpha(r1min, r1max, r1step, r2min, r2max, r2step)
	if r1step == 0 then alpha1cur = r1max end
	if alpha1cur < r1max and alpha1add then
		alpha1cur = alpha1cur + r1step
		if alpha1cur >= r1max then
			alpha1add = false
		end
	elseif alpha1cur > r1min and not alpha1add then
		alpha1cur = alpha1cur - r1step
		if alpha1cur <= r1min then
			alpha1add = true
		end
	end
	if r2step == 0 then alpha2cur = r2max end
	if alpha2cur < r2max and alpha2add then
		alpha2cur = alpha2cur + r2step
		if alpha2cur >= r2max then
			alpha2add = false
		end
	elseif alpha2cur > r2min and not alpha2add then
		alpha2cur = alpha2cur - r2step
		if alpha2cur <= r2min then
			alpha2add = true
		end
	end
	return alpha1cur, alpha2cur
end

--generate anim from table
function main:f_animFromTable(t, sff, x, y, scaleX, scaleY, facing, infFrame, defsc)
	x = x or 0
	y = y or 0
	scaleX = scaleX or 1.0
	scaleY = scaleY or 1.0
	facing = facing or '0'
	infFrame = infFrame or 1
	local facing_sav = ''
	local anim = ''
	local length = 0
	for i = 1, #t do
		local t_anim = {}
		for j, c in ipairs(self:f_strsplit(',', t[i])) do --split using "," delimiter
			table.insert(t_anim, c)
		end
		if #t_anim > 1 then
			--required parameters
			t_anim[3] = tonumber(t_anim[3]) + x
			t_anim[4] = tonumber(t_anim[4]) + y
			if tonumber(t_anim[5]) == -1 then
				length = length + infFrame
			else
				length = length + tonumber(t_anim[5])
			end
			--optional parameters
			if t_anim[6] ~= nil and not t_anim[6]:match(facing) then --flip parameter not negated by repeated flipping
				if t_anim[6]:match('[Hh]') then t_anim[3] = t_anim[3] + 1 end --fix for wrong offset after flipping sprites
				if t_anim[6]:match('[Vv]') then t_anim[4] = t_anim[4] + 1 end --fix for wrong offset after flipping sprites
				t_anim[6] = facing .. t_anim[6]
			end
		end
		for j = 1, #t_anim do
			if j == 1 then
				anim = anim .. t_anim[j]
			else
				anim = anim .. ', ' .. t_anim[j]
			end
		end
		anim = anim .. '\n'
	end
	if defsc then self:f_disableLuaScale() end
	local data = animNew(sff, anim)
	animSetScale(data, scaleX, scaleY)
	animUpdate(data)
	if defsc then self:f_setLuaScale() end
	return data, length
end

--copy table content into new table
function main:f_tableCopy(t)
	if t == nil then
		return nil
	end
	t = t or {}
	local t2 = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			t2[k] = self:f_tableCopy(v)
		else
			t2[k] = v
		end
	end
	return t2
end

--returns table length
function main:f_tableLength(t)
	local n = 0
	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

--randomizes table content
function main:f_tableShuffle(t)
	local rand = math.random
	assert(t, "main:f_tableShuffle() expected a table, got nil")
	local iterations = #t
	local j
	for i = iterations, 2, -1 do
		j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
end

--return table with reversed keys
function main:f_tableReverse(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

--wrap table
function main:f_tableWrap(t, l)
	for i = 1, l do
		table.insert(t, 1, t[#t])
		table.remove(t, #t)
	end
end

--merge 2 tables into 1 overwriting values
function main:f_tableMerge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				self:f_tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		elseif type(t1[k] or false) == "table" then
			t1[k][1] = v
		else
			t1[k] = v
		end
	end
	return t1
end

--return table with proper order and without rows disabled in screenpack
function main:f_tableClean(t, t_sort)
	local t_clean = {}
	local t_added = {}
	--first we add all entries existing in screenpack file in correct order
	for i = 1, #t_sort do
		for j = 1, #t do
			if t_sort[i] == t[j].itemname and t[j].displayname ~= '' then
				table.insert(t_clean, t[j])
				t_added[t[j].itemname] = 1
				break
			end
		end
	end
	--then we add remaining default entries if not existing yet and not disabled (by default or via screenpack)
	for i = 1, #t do
		if t_added[t[i].itemname] == nil and t[i].displayname ~= '' then
			table.insert(t_clean, t[i])
		end
	end
	return t_clean
end

--iterate over the table in order
-- basic usage, just sort by the keys:
--for k, v in main:f_sortKeys(t) do
--	print(k, v)
--end
-- this uses an custom sorting function ordering by score descending
--for k, v in main:f_sortKeys(t, function(t, a, b) return t[b] < t[a] end) do
--	print(k, v)
--end
function main:f_sortKeys(t, order)
	-- collect the keys
	local keys = {}
	for k in pairs(t) do table.insert(keys, k) end
	-- if order function given, sort it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a, b) return order(t, a, b) end)
	else
		table.sort(keys)
	end
	-- return the iterator function
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

--remove duplicated string pattern
function main:f_uniq(str, pattern, subpattern)
	local out = {}
	for s in str:gmatch(pattern) do
		local s2 = s:match(subpattern)
		if not self:f_contains(out, s2) then table.insert(out, s) end
	end
	return table.concat(out)
end


function main:f_contains(t, val)
	for k, v in pairs(t) do
		--if v == val then
		if v:match(val) then
			return true
		end
	end
	return false
end

--calculates text line length (in pixels) for main:f_textRender
function main:f_lineLength(startX, maxWidth, align, window, windowWrap)
	if #window == 0 then
		return 0
	end
	local w = maxWidth
	if #window > 0 and windowWrap then
		w = window[3]
	end
	if align == 1 then --left
		return w - startX
	elseif align == 0 then --center
		return math.floor(math.min(startX - (window[1] or 0), w - startX) * 2 + 0.5)
	else --right
		return startX - (window[1] or 0)
	end
end

--draw string letter by letter + wrap lines. Returns true after finishing rendering last letter.
function main:f_textRender(data, str, counter, x, y, font_def, delay, length)
	if data.font == -1 then return end
	local delay = delay or 0
	local length = length or 0
	str = tostring(str)
	local text = ''
	if length <= 0 then --auto wrapping disabled
		text = str:gsub('\\n', '\n')
	else --add \n before the word that exceeds amount of free pixels in the line
		local tmp = ''
		local pxLeft = length
		local tmp_px = 0
		local space = (font_def[' '] or fontGetTextWidth(self.font[data.font .. data.height], ' ')) * data.scaleX
		for i = 1, string.len(str) do
			local symbol = string.sub(str, i, i)
			if font_def[symbol] == nil then --store symbol length in global table for faster counting
				font_def[symbol] = fontGetTextWidth(self.font[data.font .. data.height], symbol)
			end
			local px = font_def[symbol] * data.scaleX
			if pxLeft + space - px >= 0 then
				if symbol:match('%s') then
					text = text .. tmp .. symbol
					tmp = ''
					tmp_px = 0
				else
					tmp = tmp .. symbol
					tmp_px = tmp_px + px
				end
				pxLeft = pxLeft - px
			else --character in this word is outside the pixel range
				text = text .. '\n'
				tmp = tmp .. symbol
				tmp_px = tmp_px + px
				pxLeft = length - tmp_px
				tmp_px = 0
			end
		end
		text = text .. tmp
	end
	--store each string ending with \n in new table row
	local subEnd = math.floor(#text - (#text - counter / delay))
	local t = {}
	for line in text:gmatch('([^\r\n]*)[\r\n]?') do
		table.insert(t, line)
	end
	--render
	local ret = false
	local lengthCnt = 0
	for i = 1, #t do
		if subEnd < #str then
			local length = #t[i]
			if i > 1 and i <= #t then
				length = length + 1
			end
			lengthCnt = lengthCnt + length
			if subEnd < lengthCnt then
				t[i] = t[i]:sub(0, subEnd - lengthCnt)
			end
		elseif i == #t then
			ret = true
		end
		data:update({
			text = t[i],
			x =    x,
			y =    y + self.floor((font_def.Size[2] + font_def.Spacing[2]) * data.scaleY + 0.5) * (i - 1),
		})
		data:draw()
	end
	return ret
end

--Convert DEF string to table
function main:f_extractText(txt, var1, var2, var3, var4)
	local t = {var1 or '', var2 or '', var3 or '', var4 or ''}
	local tmp = ''
	--replace %s, %i with variables
	local cnt = 0
	tmp = txt:gsub('(%%[is])', function(m1)
		cnt = cnt + 1
		if t[cnt] ~= nil then
			return t[cnt]
		end
	end)
	--store each line in different row
	t = {}
	tmp = tmp:gsub('\n', '\\n')
	for i, c in ipairs(self:f_strsplit('\\n', tmp)) do --split string using "\n" delimiter
		t[i] = c
	end
	if #t == 0 then
		t[1] = tmp
	end
	return t
end

--ensure that correct data type is set
function main:f_dataType(arg)
	arg = arg:gsub('^%s*(.-)%s*$', '%1')
	if tonumber(arg) then
		arg = tonumber(arg)
	elseif arg == 'true' then
		arg = true
	elseif arg == 'false' then
		arg = false
	else
		arg = tostring(arg)
	end
	return arg
end

--odd value rounding
function main:f_oddRounding(v)
	if v % 2 ~= 0 then
		return 1
	else
		return 0
	end
end

--y spacing calculation
function main:f_ySpacing(t, key)
	local font_def = self.font_def[t[key][1] .. t[key .. '_height']]
	if font_def == nil then return 0 end
	return math.floor(font_def.Size[2] * t[key .. '_scale'][2] + font_def.Spacing[2] * t[key .. '_scale'][2] + 0.5)
end

--count occurrences of a substring
function main:f_countSubstring(s1, s2)
	return select(2, s1:gsub(s2, ""))
end

--warning display
function main:f_warning(t, info, background, font_info, title, coords, col, alpha, defaultscale)
	if defaultscale == nil then defaultscale = motif.defaultWarning end
	font_info = font_info or motif.warning_info
	title = title or self.txt_warningTitle
	coords = coords or motif.warning_info.boxbg_coords
	col = col or motif.warning_info.boxbg_col
	alpha = alpha or motif.warning_info.boxbg_alpha
	resetKey()
	esc(false)
	while true do
		self:f_cmdInput()
		if esc() or self:f_input(self.t_players, {'m'}) then
			sndPlay(motif.files.snd_data, info.cancel_snd[1], info.cancel_snd[2])
			return false
		elseif getKey() ~= '' then
			sndPlay(motif.files.snd_data, info.cursor_move_snd[1], info.cursor_move_snd[2])
			resetKey()
			return true
		end
		--draw clearcolor
		clearColor(background.bgclearcolor[1], background.bgclearcolor[2], background.bgclearcolor[3])
		--draw layerno = 0 backgrounds
		bgDraw(background.bg, false)
		--draw layerno = 1 backgrounds
		bgDraw(background.bg, true)
		--draw menu box
		fillRect(coords[1], coords[2], coords[3] - coords[1] + 1, coords[4] - coords[2] + 1, col[1], col[2], col[3], alpha[1], alpha[2], false, false)
		--draw title
		title:draw()
		--draw text
		for i = 1, #t do
			self.txt_warning:update({
				font =   font_info.text_font[1],
				bank =   font_info.text_font[2],
				align =  font_info.text_font[3],
				text =   t[i],
				x =      font_info.text_pos[1],
				y =      font_info.text_pos[2] + self:f_ySpacing(font_info, 'text_font') * (i - 1),
				scaleX = font_info.text_font_scale[1],
				scaleY = font_info.text_font_scale[2],
				r =      font_info.text_font[4],
				g =      font_info.text_font[5],
				b =      font_info.text_font[6],
				src =    font_info.text_font[7],
				dst =    font_info.text_font[8],
				height = font_info.text_font_height,
				defsc =  defaultscale
			})
			self.txt_warning:draw()
		end
		--end loop
		refresh()
	end
end

--input display
function main:f_drawInput(t, info, background, category, controllerNo, keyBreak)
	--main:f_cmdInput()
	category = category or 'string'
	controllerNo = controllerNo or 0
	keyBreak = keyBreak or ''
	if category == 'string' then
		table.insert(t, '')
	end
	local input = ''
	local btnReleased = 0
	resetKey()
	while true do
		if esc() --[[or main:f_input(main.t_players, {'m'})]] then
			input = ''
			break
		end
		if category == 'keyboard' then
			input = getKey()
			if input ~= '' then
				break
			end
		elseif category == 'gamepad' then
			if getJoystickPresent(controllerNo) == false then
				break
			end
			if getKey() == keyBreak then
				input = keyBreak
				break
			end
			local tmp = getKey()
			if tonumber(tmp) == nil then --button released
				if btnReleased == 0 then
					btnReleased = 1
				elseif btnReleased == 2 then
					break
				end
			elseif btnReleased == 1 then --button pressed after releasing button once
				input = tmp
				btnReleased = 2
			end
		else --string
			if getKey() == 'RETURN' then
				break
			elseif getKey() == 'BACKSPACE' then
				input = input:match('^(.-).?$')
			else
				input = input .. getKeyText()
			end
			t[#t] = input
			resetKey()
		end
		--draw clearcolor
		clearColor(background.bgclearcolor[1], background.bgclearcolor[2], background.bgclearcolor[3])
		--draw layerno = 0 backgrounds
		bgDraw(background.bg, false)
		--draw layerno = 1 backgrounds
		bgDraw(background.bg, true)
		--draw overlay
		fillRect(
				motif.infobox.boxbg_coords[1],
				motif.infobox.boxbg_coords[2],
				motif.infobox.boxbg_coords[3] - motif.infobox.boxbg_coords[1] + 1,
				motif.infobox.boxbg_coords[4] - motif.infobox.boxbg_coords[2] + 1,
				motif.infobox.boxbg_col[1],
				motif.infobox.boxbg_col[2],
				motif.infobox.boxbg_col[3],
				motif.infobox.boxbg_alpha[1],
				motif.infobox.boxbg_alpha[2],
				false,
				false
		)
		--draw text
		for i = 1, #t do
			self.txt_input:update({
				text = t[i],
				y =    motif.infobox.text_pos[2] + self:f_ySpacing(motif.infobox, 'text_font') * (i - 1),
			})
			self.txt_input:draw()
		end
		--end loop
		self:f_cmdInput()
		refresh()
	end
	self:f_cmdInput()
	return input
end

--update rounds to win variables
function main:f_updateRoundsNum()
	if config.RoundsNumSingle == -1 then
		self.roundsNumSingle = getMatchWins()
	else
		self.roundsNumSingle = config.RoundsNumSingle
	end
	if config.RoundsNumTeam == -1 then
		self.roundsNumTeam = getMatchWins()
	else
		self.roundsNumTeam = config.RoundsNumTeam
	end
	if config.MaxDrawGames == -2 then
		self.maxDrawGames = getMatchMaxDrawGames()
	else
		self.maxDrawGames = config.MaxDrawGames
	end
end

--refresh screen every 0.02 during initial loading
main.nextRefresh = os.clock() + 0.02
function main:loadingRefresh(txt)
	if os.clock() >= self.nextRefresh then
		if txt ~= nil then
			txt:draw()
		end
		refresh()
		self.nextRefresh = os.clock() + 0.02
	end
end

main.escMenu = false
require('external.script.global')

--;===========================================================
--; COMMAND LINE QUICK VS
--;===========================================================
function main:f_launchQuickVS()
	if self.flags['-p1'] ~= nil and self.flags['-p2'] ~= nil then
		local chars = {}
		local ref = 0
		local p1TeamMode = 0
		local p2TeamMode = 0
		local p1NumChars = 0
		local p2NumChars = 0
		local roundTime = config.RoundTime
		loadLifebar(self.lifebarDef)
		local frames = getTimeFramesPerCount()
		self:f_updateRoundsNum()
		local matchWins = {self.roundsNumSingle, self.roundsNumTeam, self.maxDrawGames}
		local t = {}
		for k, v in pairs(self.flags) do
			if k:match('^-p[0-9]+$') then
				local num = tonumber(k:match('^-p([0-9]+)'))
				local player = 1
				if num % 2 == 0 then --even value
					player = 2
					p2NumChars = p2NumChars + 1
				else
					p1NumChars = p1NumChars + 1
				end
				local pal = 1
				if self.flags['-p' .. num .. '.pal'] ~= nil then
					pal = tonumber(self.flags['-p' .. num .. '.pal'])
				end
				local ai = 0
				if self.flags['-p' .. num .. '.ai'] ~= nil then
					ai = tonumber(self.flags['-p' .. num .. '.ai'])
				end
				table.insert(t, {character = v, player = player, num = num, pal = pal, ai = ai, override = {}})
				if self.flags['-p' .. num .. '.power'] ~= nil then
					t[#t].override['power'] = tonumber(self.flags['-p' .. num .. '.power'])
				end
				if self.flags['-p' .. num .. '.guardPoints'] ~= nil then
					t[#t].override['guardPoints'] = tonumber(self.flags['-p' .. num .. '.guardPoints'])
				end
				if self.flags['-p' .. num .. '.dizzyPoints'] ~= nil then
					t[#t].override['dizzyPoints'] = tonumber(self.flags['-p' .. num .. '.dizzyPoints'])
				end
				if self.flags['-p' .. num .. '.life'] ~= nil then
					t[#t].override['life'] = tonumber(self.flags['-p' .. num .. '.life'])
				end
				if self.flags['-p' .. num .. '.lifeMax'] ~= nil then
					t[#t].override['lifeMax'] = tonumber(self.flags['-p' .. num .. '.lifeMax'])
				end
				if self.flags['-p' .. num .. '.lifeRatio'] ~= nil then
					t[#t].override['lifeRatio'] = tonumber(self.flags['-p' .. num .. '.lifeRatio'])
				end
				if self.flags['-p' .. num .. '.attackRatio'] ~= nil then
					t[#t].override['attackRatio'] = tonumber(self.flags['-p' .. num .. '.attackRatio'])
				end
				refresh()
			elseif k:match('^-tmode1$') then
				p1TeamMode = tonumber(v)
			elseif k:match('^-tmode2$') then
				p2TeamMode = tonumber(v)
			elseif k:match('^-time$') then
				roundTime = tonumber(v)
			elseif k:match('^-rounds$') then
				matchWins[1] = tonumber(v)
				matchWins[2] = tonumber(v)
			elseif k:match('^-draws$') then
				matchWins[3] = tonumber(v)
			end
		end
		if p1TeamMode == 0 and p1NumChars > 1 then
			p1TeamMode = 1
		end
		if p2TeamMode == 0 and p2NumChars > 1 then
			p2TeamMode = 1
		end
		local p1FramesMul = 1
		local p2FramesMul = 1
		if p1TeamMode == 3 then
			p1FramesMul = p1NumChars
		end
		if p2TeamMode == 3 then
			p2FramesMul = p2NumChars
		end
		frames = frames * math.max(p1FramesMul, p2FramesMul)
		if p2TeamMode == 0 then
			setMatchWins(matchWins[1])
		else
			setMatchWins(matchWins[2])
		end
		setMatchMaxDrawGames(matchWins[3])
		setTimeFramesPerCount(frames)
		setRoundTime(math.max(-1, roundTime * frames))
		setGuardBar(config.BarGuard)
		setStunBar(config.BarStun)
		setRedLifeBar(config.BarRedLife)
		setAutoguard(1, config.AutoGuard)
		setAutoguard(2, config.AutoGuard)
		--add stage
		local stage = 'stages/stage0.def'
		if self.flags['-s'] ~= nil then
			if self:f_fileExists(self.flags['-s']) then
				stage = self.flags['-s']
			elseif self:f_fileExists('stages/' .. self.flags['-s'] .. '.def') then
				stage = 'stages/' .. self.flags['-s'] .. '.def'
			end
		end
		addStage(stage)
		--load data
		loadDebugFont(config.DebugFont)
		selectStart()
		setMatchNo(1)
		setStage(0)
		selectStage(0)
		setTeamMode(1, p1TeamMode, p1NumChars)
		setTeamMode(2, p2TeamMode, p2NumChars)
		if self.debugLog then self:f_printTable(t, 'debug/t_quickvs.txt') end
		--iterate over the table in -p order ascending
		for k, v in self:f_sortKeys(t, function(t, a, b) return t[b].num > t[a].num end) do
			if chars[v.character] == nil then
				addChar(v.character)
				chars[v.character] = ref
				ref = ref + 1
			end
			selectChar(v.player, chars[v.character], v.pal)
			setCom(v.num, v.ai)
			overrideCharData(v.num, v.override)
		end
		loadStart()
		local winner, t_gameStats = game()
		if self.flags['-log'] ~= nil then
			self:f_printTable(t_gameStats, self.flags['-log'])
		end
		--exit ikemen
		return
	end
end
main:f_launchQuickVS()

--;===========================================================
--; LOAD DATA
--;===========================================================
local motiffile = require('external.script.motif')
motif = motiffile.getMotifData()

local TextUtils = require('external.script.util.textutils')
text = TextUtils:getText(motif, main)

setMotifDir(motif.fileDir)

local t_preloading = {
	{typ = 'char', pre = config.PreloadingSmall, spr = {motif.select_info.portrait_spr}},
	{typ = 'char', pre = config.PreloadingBig, spr = {motif.select_info.p1_face_spr, motif.select_info.p2_face_spr}},
	{typ = 'char', pre = config.PreloadingVersus, spr = {motif.vs_screen.p1_spr, motif.vs_screen.p2_spr}},
	{typ = 'stage', pre = config.PreloadingStage, spr = {motif.select_info.stage_portrait_spr}},
}

function main:f_preloadPortrait()
	for _, t in pairs(t_preloading) do
		if t.pre then
			for _, v in ipairs(t.spr) do
				setPortraitPreloading(v[1], v[2], t.typ == 'stage')
			end
		end
	end
end
main:f_preloadPortrait()

-- todo Refactor to data object
main.txt_warning = text:create({})
main.txt_warningTitle = text:create({
	font =   motif.warning_info.title_font[1],
	bank =   motif.warning_info.title_font[2],
	align =  motif.warning_info.title_font[3],
	text =   motif.warning_info.title,
	x =      motif.warning_info.title_pos[1],
	y =      motif.warning_info.title_pos[2],
	scaleX = motif.warning_info.title_font_scale[1],
	scaleY = motif.warning_info.title_font_scale[2],
	r =      motif.warning_info.title_font[4],
	g =      motif.warning_info.title_font[5],
	b =      motif.warning_info.title_font[6],
	src =    motif.warning_info.title_font[7],
	dst =    motif.warning_info.title_font[8],
	height = motif.warning_info.title_font_height,
	defsc =  motif.defaultWarning
})
main.txt_input = text:create({
	font =   motif.infobox.text_font[1],
	bank =   motif.infobox.text_font[2],
	align =  motif.infobox.text_font[3],
	text =   '',
	x =      motif.infobox.text_pos[1],
	y =      0,
	scaleX = motif.infobox.text_font_scale[1],
	scaleY = motif.infobox.text_font_scale[2],
	r =      motif.infobox.text_font[4],
	g =      motif.infobox.text_font[5],
	b =      motif.infobox.text_font[6],
	src =    motif.infobox.text_font[7],
	dst =    motif.infobox.text_font[8],
	height = motif.infobox.text_font_height,
	defsc =  motif.defaultInfobox
})

-- todo Refactor to function
local txt_loading = text:create({
	font =   motif.title_info.loading_font[1],
	bank =   motif.title_info.loading_font[2],
	align =  motif.title_info.loading_font[3],
	text =   motif.title_info.loading_text,
	x =      motif.title_info.loading_offset[1],
	y =      motif.title_info.loading_offset[2],
	scaleX = motif.title_info.loading_font_scale[1],
	scaleY = motif.title_info.loading_font_scale[2],
	r =      motif.title_info.loading_font[4],
	g =      motif.title_info.loading_font[5],
	b =      motif.title_info.loading_font[6],
	src =    motif.title_info.loading_font[7],
	dst =    motif.title_info.loading_font[8],
	height = motif.title_info.loading_font_height,
	defsc =  motif.defaultLoading
})
txt_loading:draw()
refresh()

--add characters and stages using select.def
function main:f_charParam(t, c)
	if c:match('music[alv]?[li]?[tfc]?[et]?o?r?y?%s*=') then --music / musicalt / musiclife / musicvictory
		local bgmvolume, bgmloopstart, bgmloopend = 100, 0, 0
		c = c:gsub('%s+([0-9%s]+)$', function(m1)
			for i, c in ipairs(main:f_strsplit('%s+', m1)) do --split using whitespace delimiter
				if i == 1 then
					bgmvolume = tonumber(c)
				elseif i == 2 then
					bgmloopstart = tonumber(c)
				elseif i == 3 then
					bgmloopend = tonumber(c)
				else
					break
				end
			end
			return ''
		end)
		c = c:gsub('\\', '/')
		local bgtype, bgmusic = c:match('^(music[a-z]*)%s*=%s*(.-)%s*$')
		if t[bgtype] == nil then t[bgtype] = {} end
		table.insert(t[bgtype], {bgmusic = bgmusic, bgmvolume = bgmvolume, bgmloopstart = bgmloopstart, bgmloopend = bgmloopend})
	elseif c:match('lifebar%s*=') then --lifebar
		if t.lifebar == nil then
			t.lifebar = c:match('=%s*(.-)%s*$')
		end
	elseif c:match('[0-9]+%s*=%s*[^%s]') then --num = string (unused)
		local var1, var2 = c:match('([0-9]+)%s*=%s*(.+)%s*$')
		t[tonumber(var1)] = var2
	elseif c:match('%.[Dd][Ee][Ff]') then --stage
		c = c:gsub('\\', '/')
		if t.stage == nil then
			t.stage = {}
		end
		table.insert(t.stage, c)
	else --param = value
		local param, value = c:match('^(.-)%s*=%s*(.-)$')
		if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
			t[param] = tonumber(value)
			if t[param] == nil then
				t[param] = value
			end
		end
	end
end

function main:f_addChar(line, row, playable, slot)
	local slot = slot or false
	local valid = false
	local tmp = ''
	self.t_selChars[row] = {}
	--parse 'rivals' param and get rid of it if exists
	for num, str in line:gmatch('([0-9]+)%s*=%s*{([^%}]-)}') do
		num = tonumber(num)
		if self.t_selChars[row].rivals == nil then
			self.t_selChars[row].rivals = {}
		end
		for i, c in ipairs(self:f_strsplit(',', str)) do --split using "," delimiter
			c = c:match('^%s*(.-)%s*$')
			if i == 1 then
				c = c:gsub('\\', '/')
				c = tostring(c)
				self.t_selChars[row].rivals[num] = {char = c}
			else
				self:f_charParam(self.t_selChars[row].rivals[num], c)
			end
		end
		line = line:gsub(',%s*' .. num .. '%s*=%s*{([^%}]-)}', '')
	end
	--parse rest of the line
	for i, c in ipairs(self:f_strsplit(',', line)) do --split using "," delimiter
		c = c:match('^%s*(.-)%s*$')
		if i == 1 then
			c = c:gsub('\\', '/')
			c = tostring(c)
			addChar(c)
			tmp = getCharName(row - 1)
			if tmp == '' then
				playable = false
				break
			end
			self.t_charDef[c:lower()] = row - 1
			if tmp == 'Random' then
				self.t_selChars[row].char = c:lower()
				playable = false
				break
			end
			self.t_selChars[row].char = c
			valid = true
			self.t_selChars[row].playable = playable
			self.t_selChars[row].displayname = tmp
			self.t_selChars[row].author = getCharAuthor(row - 1)
			self.t_selChars[row].def = getCharFileName(row - 1)
			self.t_selChars[row].dir = self.t_selChars[row].def:gsub('[^/]+%.def$', '')
			self.t_selChars[row].pal, self.t_selChars[row].pal_defaults, self.t_selChars[row].pal_keymap = getCharPalettes(row - 1)
			if playable then
				tmp = getCharIntro(row - 1):gsub('\\', '/')
				if tmp ~= '' then
					if self:f_fileExists(self.t_selChars[row].dir .. tmp) then
						self.t_selChars[row].intro = self.t_selChars[row].dir .. tmp
					elseif self:f_fileExists('data/' .. tmp) then
						self.t_selChars[row].intro = 'data/' .. tmp
					end
				end
				tmp = getCharEnding(row - 1):gsub('\\', '/')
				if tmp ~= '' then
					if self:f_fileExists(self.t_selChars[row].dir .. tmp) then
						self.t_selChars[row].ending = self.t_selChars[row].dir .. tmp
					elseif self:f_fileExists('data/' .. tmp) then
						self.t_selChars[row].ending = 'data/' .. tmp
					end
				end
				self.t_selChars[row].order = 1
			end
		else
			self:f_charParam(self.t_selChars[row], c)
		end
	end
	if self.t_selChars[row].hidden == nil then
		self.t_selChars[row].hidden = 0
	end
	if self.t_selChars[row].char ~= nil then
		self.t_selChars[row].char_ref = self.t_charDef[self.t_selChars[row].char:lower()]
	end
	if playable then
		--order param
		if self.t_orderChars[self.t_selChars[row].order] == nil then
			self.t_orderChars[self.t_selChars[row].order] = {}
		end
		table.insert(self.t_orderChars[self.t_selChars[row].order], row - 1)
		--ordersurvival param
		local num = self.t_selChars[row].ordersurvival or 1
		if self.t_orderSurvival[num] == nil then
			self.t_orderSurvival[num] = {}
		end
		table.insert(self.t_orderSurvival[num], row - 1)
		--boss rush mode
		if self.t_selChars[row].boss ~= nil and self.t_selChars[row].boss == 1 then
			--[[if main.t_bossChars[main.t_selChars[row].order] == nil then
				main.t_bossChars[main.t_selChars[row].order] = {}
			end
			table.insert(main.t_bossChars[main.t_selChars[row].order], row - 1)]]
			table.insert(self.t_bossChars, row - 1)
		end
		--bonus games mode
		if self.t_selChars[row].bonus ~= nil and self.t_selChars[row].bonus == 1 then
			table.insert(self.t_bonusChars, row - 1)
		end
	end
	--slots
	if not slot then
		table.insert(self.t_selGrid, {['chars'] = {row}, ['slot'] = 1})
	else
		table.insert(self.t_selGrid[#self.t_selGrid].chars, row)
	end
	for _, v in ipairs({'next', 'previous', 'select'}) do
		if self.t_selChars[row][v] ~= nil then
			self.t_selChars[row][v] = self.t_selChars[row][v]:gsub('/(.)%s*+', '/%1,') --convert '+' to ',' for button holding
			self:f_commandAdd(self.t_selChars[row][v])
			if self.t_selGrid[#self.t_selGrid][v] == nil then
				self.t_selGrid[#self.t_selGrid][v] = {}
			end
			if self.t_selGrid[#self.t_selGrid][v][self.t_selChars[row][v]] == nil then
				self.t_selGrid[#self.t_selGrid][v][self.t_selChars[row][v]] = {}
			end
			table.insert(self.t_selGrid[#self.t_selGrid][v][self.t_selChars[row][v]], #self.t_selGrid[#self.t_selGrid].chars)
		end
	end
	self:loadingRefresh(txt_loading)
	return valid
end

function main:f_addStage(file)
	file = file:gsub('\\', '/')
	--if not main:f_fileExists(file) or file:match('^stages/$') then
	--	return #main.t_selStages
	--end
	addStage(file)
	local stageNo = #self.t_selStages + 1
	local tmp = getStageName(stageNo)
	--if tmp == '' then
	--	return stageNo
	--end
	self.t_stageDef[file:lower()] = stageNo
	self.t_selStages[stageNo] = {name = tmp, stage = file}
	local t_bgmusic = getStageBgm(stageNo)
	for k, v in pairs(t_bgmusic) do
		if k:match('^bgmusic') or k:match('^bgmvolume') or k:match('^bgmloop') then
			local tmp1, tmp2, tmp3 = k:match('^([^%.]+)(%.?)([A-Za-z]*)$')
			if t_bgmusic['bgmusic' .. tmp2 .. tmp3] ~= nil and t_bgmusic['bgmusic' .. tmp2 .. tmp3] ~= '' then
				if self.t_selStages[stageNo]['music' .. tmp3] == nil then
					self.t_selStages[stageNo]['music' .. tmp3] = {}
					table.insert(self.t_selStages[stageNo]['music' .. tmp3], {bgmusic = '', bgmvolume = 100, bgmloopstart = 0, bgmloopend = 0})
				end
				if k:match('^bgmusic') then
					self.t_selStages[stageNo]['music' .. tmp3][1][tmp1] = tostring(v)
				elseif tonumber(v) then
					self.t_selStages[stageNo]['music' .. tmp3][1][tmp1] = tonumber(v)
				end
			end
		elseif v ~= '' then
			self.t_selStages[stageNo][k:gsub('%.', '_')] = self:f_dataType(v)
		end
	end
	local attachedChar = getStageAttachedChar(stageNo)
	if attachedChar ~= '' then
		self.t_selStages[stageNo].attachedChar = {}
		self.t_selStages[stageNo].attachedChar.def, self.t_selStages[stageNo].attachedChar.displayname, self.t_selStages[stageNo].attachedChar.sprite, self.t_selStages[stageNo].attachedChar.sound = getCharAttachedInfo(attachedChar)
		self.t_selStages[stageNo].attachedChar.dir = self.t_selStages[stageNo].attachedChar.def:gsub('[^/]+%.def$', '')
	end
	return stageNo
end

main.t_includeStage = {{}, {}} --includestage = 1, includestage = -1
main.t_orderChars = {}
main.t_orderStages = {}
main.t_orderSurvival = {}
main.t_bossChars = {}
main.t_bonusChars = {}
main.t_stageDef = {['random'] = 0}
main.t_charDef = {}
local t_addExluded = {}
local chars = 0
local stages = 0
local tmp = ''
local section = 0
local row = 0
local slot = false
local file = io.open(motif.files.select,"r")
local content = file:read("*all")
file:close()
content = content:gsub('([^\r\n;]*)%s*;[^\r\n]*', '%1')
content = content:gsub('\n%s*\n', '\n')
function main:f_parseSelectDef()
	for line in content:gmatch('[^\r\n]+') do
		--for line in io.lines("data/select.def") do
		local lineCase = line:lower()
		if lineCase:match('^%s*%[%s*characters%s*%]') then
			self.t_selChars = {}
			self.t_selGrid = {}
			row = 0
			section = 1
		elseif lineCase:match('^%s*%[%s*extrastages%s*%]') then
			self.t_selStages = {}
			row = 0
			section = 2
		elseif lineCase:match('^%s*%[%s*options%s*%]') then
			self.t_selOptions = {
				arcadestart = {wins = 0, offset = 0},
				arcadeend = {wins = 0, offset = 0},
				teamstart = {wins = 0, offset = 0},
				teamend = {wins = 0, offset = 0},
				survivalstart = {wins = 0, offset = 0},
				survivalend = {wins = 0, offset = 0},
				ratiostart = {wins = 0, offset = 0},
				ratioend = {wins = 0, offset = 0},
			}
			row = 0
			section = 3
		elseif section == 1 then --[Characters]
			if lineCase:match(',%s*exclude%s*=%s*1') then --character should be added after all slots are filled
				table.insert(t_addExluded, line)
			elseif lineCase:match('^%s*slot%s*=%s*{%s*$') then --start of the 'multiple chars in one slot' assignment
				table.insert(self.t_selGrid, {['chars'] = {}, ['slot'] = 1})
				slot = true
			elseif slot and lineCase:match('^%s*}%s*$') then --end of 'multiple chars in one slot' assignment
				slot = false
			else
				chars = chars + 1
				self:f_addChar(line, chars, true, slot)
			end
		elseif section == 2 then --[ExtraStages]
			for i, c in ipairs(self:f_strsplit(',', line)) do --split using "," delimiter
				c = c:gsub('^%s*(.-)%s*$', '%1')
				if i == 1 then
					row = self:f_addStage(c)
					table.insert(self.t_includeStage[1], row)
					table.insert(self.t_includeStage[2], row)
				elseif c:match('music[alv]?[li]?[tfc]?[et]?o?r?y?%s*=') then --music / musicalt / musiclife / musicvictory
					local bgmvolume, bgmloopstart, bgmloopend = 100, 0, 0
					c = c:gsub('%s+([0-9%s]+)$', function(m1)
						for i, c in ipairs(self:f_strsplit('%s+', m1)) do --split using whitespace delimiter
							if i == 1 then
								bgmvolume = tonumber(c)
							elseif i == 2 then
								bgmloopstart = tonumber(c)
							elseif i == 3 then
								bgmloopend = tonumber(c)
							else
								break
							end
						end
						return ''
					end)
					c = c:gsub('\\', '/')
					local bgtype, bgmusic = c:match('^(music[a-z]*)%s*=%s*(.-)%s*$')
					if self.t_selStages[row][bgtype] == nil then self.t_selStages[row][bgtype] = {} end
					table.insert(self.t_selStages[row][bgtype], {bgmusic = bgmusic, bgmvolume = bgmvolume, bgmloopstart = bgmloopstart, bgmloopend = bgmloopend})
				else
					local param, value = c:match('^(.-)%s*=%s*(.-)$')
					if param ~= nil and value ~= nil and param ~= '' and value ~= '' then
						self.t_selStages[row][param] = tonumber(value)
						if param:match('order') then
							if self.t_orderStages[self.t_selStages[row].order] == nil then
								self.t_orderStages[self.t_selStages[row].order] = {}
							end
							table.insert(self.t_orderStages[self.t_selStages[row].order], row)
						end
					end
				end
			end
		elseif section == 3 then --[Options]
			if lineCase:match('%.maxmatches%s*=') then
				local rowName, line = lineCase:match('^%s*(.-)%.maxmatches%s*=%s*(.+)')
				rowName = rowName:gsub('%.', '_')
				self.t_selOptions[rowName .. 'maxmatches'] = {}
				for i, c in ipairs(self:f_strsplit(',', line:gsub('%s*(.-)%s*', '%1'))) do --split using "," delimiter
					self.t_selOptions[rowName .. 'maxmatches'][i] = tonumber(c)
				end
			elseif lineCase:match('%.ratiomatches%s*=') then
				local rowName, line = lineCase:match('^%s*(.-)%.ratiomatches%s*=%s*(.+)')
				rowName = rowName:gsub('%.', '_')
				self.t_selOptions[rowName .. 'ratiomatches'] = {}
				for i, c in ipairs(self:f_strsplit(',', line:gsub('%s*(.-)%s*', '%1'))) do --split using "," delimiter
					local rmin, rmax, order = c:match('^%s*([0-9]+)-?([0-9]*)%s*:%s*([0-9]+)%s*$')
					rmin = tonumber(rmin)
					rmax = tonumber(rmax) or rmin
					order = tonumber(order)
					if rmin == nil or order == nil or rmin < 1 or rmin > 4 or rmax < 1 or rmax > 4 or rmin > rmax then
						self:f_warning(self:f_extractText(motif.warning_info.text_ratio_text), motif.title_info, motif.titlebgdef)
						self.t_selOptions[rowName .. 'ratiomatches'] = nil
						break
					end
					if rmax == '' then
						rmax = rmin
					end
					table.insert(self.t_selOptions[rowName .. 'ratiomatches'], {['rmin'] = rmin, ['rmax'] = rmax, ['order'] = order})
				end
			elseif lineCase:match('%.airamp%.') then
				local rowName, rowName2, wins, offset = lineCase:match('^%s*(.-)%.airamp%.(.-)%s*=%s*([0-9]+)%s*,%s*([0-9-]+)')
				self.t_selOptions[rowName .. rowName2] = {wins = tonumber(wins), offset = tonumber(offset)}
			end
		end
	end
end
main:f_parseSelectDef()

--add default maxmatches / ratiomatches values if config is missing in select.def
if main.t_selOptions.arcademaxmatches == nil then main.t_selOptions.arcademaxmatches = {6, 1, 1, 0, 0, 0, 0, 0, 0, 0} end
if main.t_selOptions.teammaxmatches == nil then main.t_selOptions.teammaxmatches = {4, 1, 1, 0, 0, 0, 0, 0, 0, 0} end
if main.t_selOptions.timeattackmaxmatches == nil then main.t_selOptions.timeattackmaxmatches = {6, 1, 1, 0, 0, 0, 0, 0, 0, 0} end
if main.t_selOptions.survivalmaxmatches == nil then main.t_selOptions.survivalmaxmatches = {-1, 0, 0, 0, 0, 0, 0, 0, 0, 0} end
if main.t_selOptions.arcaderatiomatches == nil then
	main.t_selOptions.arcaderatiomatches = {
		{['rmin'] = 1, ['rmax'] = 3, ['order'] = 1},
		{['rmin'] = 3, ['rmax'] = 3, ['order'] = 1},
		{['rmin'] = 2, ['rmax'] = 2, ['order'] = 1},
		{['rmin'] = 2, ['rmax'] = 2, ['order'] = 1},
		{['rmin'] = 1, ['rmax'] = 1, ['order'] = 2},
		{['rmin'] = 3, ['rmax'] = 3, ['order'] = 1},
		{['rmin'] = 1, ['rmax'] = 2, ['order'] = 3}
	}
end

--add excluded characters once all slots are filled
for i = #main.t_selGrid, (motif.select_info.rows + motif.select_info.rows_scrolling) * motif.select_info.columns - 1 do
	chars = chars + 1
	main.t_selChars[chars] = {}
	table.insert(main.t_selGrid, {['chars'] = {}, ['slot'] = 1})
	addChar('dummyChar')
end
for i = 1, #t_addExluded do
	chars = chars + 1
	main:f_addChar(t_addExluded[i], chars, true)
end

--add Training by stupa if not included in select.def
if main.t_charDef[config.TrainingChar] == nil then
	chars = chars + 1
	main:f_addChar(config.TrainingChar .. ', exclude = 1', chars, false)
end

--add remaining character parameters
main.t_randomChars = {}
function main:f_loadCharacters()
	--for each character loaded
	for i = 1, #self.t_selChars do
		--change character 'rivals' param char and stage string file paths to reference values
		if self.t_selChars[i].rivals ~= nil then
			for _, v in pairs(self.t_selChars[i].rivals) do
				--add 'rivals' param character if needed or reference existing one
				if v.char ~= nil then
					if self.t_charDef[v.char:lower()] == nil then --new char
						chars = chars + 1
						if self:f_addChar(v.char .. ', exclude = 1', chars, false) then
							v.char_ref = chars - 1
						else
							self:f_warning(self:f_extractText(v.char .. motif.warning_info.text_rivals_text), motif.title_info, motif.titlebgdef)
							v.char = nil
						end
					else --already added
						v.char_ref = self.t_charDef[v.char:lower()]
					end
				end
				--add 'rivals' param stages if needed or reference existing ones
				if v.stage ~= nil then
					for k = 1, #v.stage do
						if self.t_stageDef[v.stage[k]:lower()] == nil then
							v.stage[k] = self:f_addStage(v.stage[k])
						else --already added
							v.stage[k] = self.t_stageDef[v.stage[k]:lower()]
						end
					end
				end
			end
		end
		--character stage param
		if self.t_selChars[i].stage ~= nil then
			for j, v in ipairs(self.t_selChars[i].stage) do
				--add 'stage' param stages if needed or reference existing ones
				if self.t_stageDef[v:lower()] == nil then
					self.t_selChars[i].stage[j] = self:f_addStage(v)
					if self.t_selChars[i].includestage == nil or self.t_selChars[i].includestage == 1 then --stage available all the time
						table.insert(self.t_includeStage[1], self.t_selChars[i].stage[j])
						table.insert(self.t_includeStage[2], self.t_selChars[i].stage[j])
					elseif self.t_selChars[i].includestage == -1 then --excluded stage that can be still manually selected
						table.insert(self.t_includeStage[2], self.t_selChars[i].stage[j])
					end
				else --already added
					self.t_selChars[i].stage[j] = self.t_stageDef[v:lower()]
				end
			end
		end
		--if character's name has been stored
		if self.t_selChars[i].displayname ~= nil then
			--generate table with characters allowed to be random selected
			if self.t_selChars[i].playable and (self.t_selChars[i].hidden == nil or self.t_selChars[i].hidden <= 1) and (self.t_selChars[i].exclude == nil or self.t_selChars[i].exclude == 0) then
				table.insert(self.t_randomChars, i - 1)
			end
		end
	end
end
main:f_loadCharacters()

--Save debug tables
if main.debugLog then
	main:f_printTable(main.t_selChars, "debug/t_selChars.txt")
	main:f_printTable(main.t_selStages, "debug/t_selStages.txt")
	main:f_printTable(main.t_selOptions, "debug/t_selOptions.txt")
	main:f_printTable(main.t_orderChars, "debug/t_orderChars.txt")
	main:f_printTable(main.t_orderStages, "debug/t_orderStages.txt")
	main:f_printTable(main.t_orderSurvival, "debug/t_orderSurvival.txt")
	main:f_printTable(main.t_randomChars, "debug/t_randomChars.txt")
	main:f_printTable(main.t_bossChars, "debug/t_bossChars.txt")
	main:f_printTable(main.t_bonusChars, "debug/t_bonusChars.txt")
	main:f_printTable(main.t_stageDef, "debug/t_stageDef.txt")
	main:f_printTable(main.t_charDef, "debug/t_charDef.txt")
	main:f_printTable(main.t_includeStage, "debug/t_includeStage.txt")
	main:f_printTable(main.t_selGrid, "debug/t_selGrid.txt")
	main:f_printTable(config, "debug/config.txt")
end

--Debug stuff
loadDebugFont(config.DebugFont)

--Assign Lifebar
txt_loading:draw()
refresh()
loadLifebar(motif.files.fight)
main.timeFramesPerCount = getTimeFramesPerCount()
main:f_updateRoundsNum()
main:loadingRefresh(txt_loading)

--print warning if training character is missing
if main.t_charDef[config.TrainingChar] == nil then
	main:f_warning(main:f_extractText(motif.warning_info.text_training_text), motif.title_info, motif.titlebgdef)
	os.exit()
end

--print warning if no characters can be randomly chosen
if #main.t_randomChars == 0 then
	main:f_warning(main:f_extractText(motif.warning_info.text_chars_text), motif.title_info, motif.titlebgdef)
	os.exit()
end

--print warning if no stages have been added
if #main.t_includeStage[1] == 0 then
	main:f_warning(main:f_extractText(motif.warning_info.text_stages_text), motif.title_info, motif.titlebgdef)
	os.exit()
end

--print warning if at least 1 match is not possible with the current maxmatches settings
for k, v in pairs(main.t_selOptions) do
	local mode = k:match('^(.+)maxmatches$')
	if mode ~= nil then
		local orderOK = false
		for i = 1, #main.t_selOptions[k] do
			if mode == 'survival' and (main.t_selOptions[k][i] > 0 or main.t_selOptions[k][i] == -1) and main.t_orderSurvival[i] ~= nil and #main.t_orderSurvival[i] > 0 then
				orderOK = true
				break
			elseif main.t_selOptions[k][i] > 0 and main.t_orderChars[i] ~= nil and #main.t_orderChars[i] > 0 then
				orderOK = true
				break
			end
		end
		if not orderOK then
			main:f_warning(main:f_extractText(motif.warning_info.text_order_text), motif.title_info, motif.titlebgdef)
			os.exit()
		end
	end
end

--uppercase title
function main:f_itemnameUpper(title, uppercase)
	if title == nil then
		return ''
	end
	if uppercase then
		return title:upper()
	end
	return title
end

--Load additional scripts
start = require('external.script.start')
randomtest = require('external.script.randomtest')
options = require('external.script.options')
replay = require('external.script.replay')
storyboard = require('external.script.storyboard')
menu = require('external.script.menu')

if main.flags['-storyboard'] ~= nil then
	storyboard.f_storyboard(main.flags['-storyboard'])
	os.exit()
end

--;===========================================================
--; MENUS
--;===========================================================
main.txt_title = text:create({
	font =   motif.title_info.title_font[1],
	bank =   motif.title_info.title_font[2],
	align =  motif.title_info.title_font[3],
	text =   '',
	x =      motif.title_info.title_offset[1],
	y =      motif.title_info.title_offset[2],
	scaleX = motif.title_info.title_font_scale[1],
	scaleY = motif.title_info.title_font_scale[2],
	r =      motif.title_info.title_font[4],
	g =      motif.title_info.title_font[5],
	b =      motif.title_info.title_font[6],
	src =    motif.title_info.title_font[7],
	dst =    motif.title_info.title_font[8],
	height = motif.title_info.title_font_height,
})
local txt_footer1 = text:create({
	font =   motif.title_info.footer1_font[1],
	bank =   motif.title_info.footer1_font[2],
	align =  motif.title_info.footer1_font[3],
	text =   motif.title_info.footer1_text,
	x =      motif.title_info.footer1_offset[1],
	y =      motif.title_info.footer1_offset[2],
	scaleX = motif.title_info.footer1_font_scale[1],
	scaleY = motif.title_info.footer1_font_scale[2],
	r =      motif.title_info.footer1_font[4],
	g =      motif.title_info.footer1_font[5],
	b =      motif.title_info.footer1_font[6],
	src =    motif.title_info.footer1_font[7],
	dst =    motif.title_info.footer1_font[8],
	height = motif.title_info.footer1_font_height,
	defsc =  motif.defaultFooter
})
local txt_footer2 = text:create({
	font =   motif.title_info.footer2_font[1],
	bank =   motif.title_info.footer2_font[2],
	align =  motif.title_info.footer2_font[3],
	text =   motif.title_info.footer2_text,
	x =      motif.title_info.footer2_offset[1],
	y =      motif.title_info.footer2_offset[2],
	scaleX = motif.title_info.footer2_font_scale[1],
	scaleY = motif.title_info.footer2_font_scale[2],
	r =      motif.title_info.footer2_font[4],
	g =      motif.title_info.footer2_font[5],
	b =      motif.title_info.footer2_font[6],
	src =    motif.title_info.footer2_font[7],
	dst =    motif.title_info.footer2_font[8],
	height = motif.title_info.footer2_font_height,
	defsc =  motif.defaultFooter
})
local txt_footer3 = text:create({
	font =   motif.title_info.footer3_font[1],
	bank =   motif.title_info.footer3_font[2],
	align =  motif.title_info.footer3_font[3],
	text =   motif.title_info.footer3_text,
	x =      motif.title_info.footer3_offset[1],
	y =      motif.title_info.footer3_offset[2],
	scaleX = motif.title_info.footer3_font_scale[1],
	scaleY = motif.title_info.footer3_font_scale[2],
	r =      motif.title_info.footer3_font[4],
	g =      motif.title_info.footer3_font[5],
	b =      motif.title_info.footer3_font[6],
	src =    motif.title_info.footer3_font[7],
	dst =    motif.title_info.footer3_font[8],
	height = motif.title_info.footer3_font_height,
	defsc =  motif.defaultFooter
})
local txt_infoboxTitle = text:create({
	font =   motif.infobox.title_font[1],
	bank =   motif.infobox.title_font[2],
	align =  motif.infobox.title_font[3],
	text =   motif.infobox.title,
	x =      motif.infobox.title_pos[1],
	y =      motif.infobox.title_pos[2],
	scaleX = motif.infobox.title_font_scale[1],
	scaleY = motif.infobox.title_font_scale[2],
	r =      motif.infobox.title_font[4],
	g =      motif.infobox.title_font[5],
	b =      motif.infobox.title_font[6],
	src =    motif.infobox.title_font[7],
	dst =    motif.infobox.title_font[8],
	height = motif.infobox.title_font_height,
	defsc =  motif.defaultInfobox
})

main.txt_mainSelect = text:create({
	font =   motif.select_info.title_font[1],
	bank =   motif.select_info.title_font[2],
	align =  motif.select_info.title_font[3],
	text =   '',
	x =      motif.select_info.title_offset[1],
	y =      motif.select_info.title_offset[2],
	scaleX = motif.select_info.title_font_scale[1],
	scaleY = motif.select_info.title_font_scale[2],
	r =      motif.select_info.title_font[4],
	g =      motif.select_info.title_font[5],
	b =      motif.select_info.title_font[6],
	src =    motif.select_info.title_font[7],
	dst =    motif.select_info.title_font[8],
	height = motif.select_info.title_font_height,
})

main.reconnect = false
main.serverhost = false
main.t_itemname = {
	--ARCADE / TEAM ARCADE
	['arcade'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1 --P1 controls P2 side of the select screen
		main.resetScore = true --score is set to lose count after loosing a match
		main.versusScreen = true --versus screen enabled
		main.victoryScreen = true --victory screen enabled
		main.continueScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_charparam.rivals = true
		main.t_lifebar.p1score = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.win_screen
		main.credits = config.Credits - 1 --amount of continues
		if t[item].itemname == 'arcade' then
			main.p1TeamMenu.single = true
			main.p2TeamMenu.single = true
			main.txt_mainSelect:update({text = motif.select_info.title_arcade_text}) --message displayed on top of select screen
		else --teamarcade
			main.p1TeamMenu.single = true
			main.p1TeamMenu.simul = true
			main.p1TeamMenu.turns = true
			main.p1TeamMenu.tag = true
			main.p1TeamMenu.ratio = true
			main.p2TeamMenu.single = true
			main.p2TeamMenu.simul = true
			main.p2TeamMenu.turns = true
			main.p2TeamMenu.tag = true
			main.p2TeamMenu.ratio = true
			main.txt_mainSelect:update({text = motif.select_info.title_teamarcade_text})
		end
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('arcade')
		start.f_selectArcade()
	end,
	--TIME ATTACK
	['timeattack'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		if main.roundTime == -1 then
			main.roundTime = 99
		end
		main.resetScore = true
		main.versusScreen = true
		main.continueScreen = true
		main.quickContinue = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.timer = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.time_attack_results_screen
		main.credits = config.Credits - 1
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_timeattack_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('timeattack')
		start.f_selectArcade()
	end,
	--TIME CHALLENGE
	['timechallenge'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.matchWins = {1, 1, 0}
		if main.roundTime == -1 then
			main.roundTime = 99
		end
		main.stageMenu = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.timer = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.time_challenge_results_screen
		main.p1TeamMenu.single = true
		main.p2TeamMenu.single = true
		main.txt_mainSelect:update({text = motif.select_info.title_timechallenge_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('timechallenge')
		start.f_selectSimple()
	end,
	--SCORE CHALLENGE
	['scorechallenge'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.matchWins = {1, 1, 0}
		main.stageMenu = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.p1score = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.score_challenge_results_screen
		main.p1TeamMenu.single = true
		main.p2TeamMenu.single = true
		main.txt_mainSelect:update({text = motif.select_info.title_scorechallenge_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('scorechallenge')
		start.f_selectSimple()
	end,
	--VS MODE / TEAM VERSUS
	['versus'] = function(cursorPosY, moveTxt, item, t)
		setHomeTeam(1) --P1 side considered the home team
		main.t_pIn[2] = 2 --P2 controls P2 side of the select screen
		main.stageMenu = true --stage selection enabled
		main.p2Faces = true --additional window with P2 select screen small portraits (faces) enabled
		main.p2SelectMenu = true
		main.versusScreen = true
		main.victoryScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.p1score = true
		main.t_lifebar.p2score = true
		if t[item].itemname == 'versus' then
			main.p1TeamMenu.single = true
			main.p2TeamMenu.single = true
			main.txt_mainSelect:update({text = motif.select_info.title_versus_text})
		else --teamversus
			main.p1TeamMenu.single = true
			main.p1TeamMenu.simul = true
			main.p1TeamMenu.turns = true
			main.p1TeamMenu.tag = true
			main.p1TeamMenu.ratio = true
			main.p2TeamMenu.single = true
			main.p2TeamMenu.simul = true
			main.p2TeamMenu.turns = true
			main.p2TeamMenu.tag = true
			main.p2TeamMenu.ratio = true
			main.txt_mainSelect:update({text = motif.select_info.title_teamversus_text})
		end
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('versus')
		start.f_selectSimple()
	end,
	--TEAM CO-OP
	['teamcoop'] = function(cursorPosY, moveTxt, item, t)
		main.t_pIn[2] = 2
		main.coop = true --P2 fighting on P1 side enabled
		main.p2Faces = true
		main.p2SelectMenu = true
		main.resetScore = true
		main.versusScreen = true
		main.victoryScreen = true
		main.continueScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_charparam.rivals = true
		main.t_lifebar.p1score = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.win_screen
		main.credits = config.Credits - 1
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.tag = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_teamcoop_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('teamcoop')
		start.f_selectArcade()
	end,
	--SURVIVAL
	['survival'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.matchWins = {1, 1, 0}
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.match = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.survival_results_screen
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_survival_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('survival')
		start.f_selectArranged()
	end,
	--SURVIVAL CO-OP
	['survivalcoop'] = function(cursorPosY, moveTxt, item, t)
		main.t_pIn[2] = 2
		main.matchWins = {1, 1, 0}
		main.coop = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.match = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.survival_results_screen
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.tag = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_survivalcoop_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('survivalcoop')
		start.f_selectArranged()
	end,
	--TRAINING
	['training'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 2
		main.stageMenu = true
		main.p2SelectMenu = true
		main.roundTime = -1
		--uses default main.t_charparam assignment
		main.t_lifebar.p1score = true
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2Char = {main.t_charDef[config.TrainingChar]} --predefined P2 character as Training by stupa
		main.txt_mainSelect:update({text = motif.select_info.title_training_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('training')
		start.f_selectSimple()
	end,
	--WATCH
	['watch'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.aiFight = true --AI = config.Difficulty for all characters enabled
		main.stageMenu = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.p1ai = true
		main.t_lifebar.p2ai = true
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_watch_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('watch')
		start.f_selectSimple()
	end,
	--OPTIONS
	['options'] = function(cursorPosY, moveTxt, item, t)
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		options.menu.loop()
	end,
	--FREE BATTLE
	['freebattle'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.stageMenu = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.p1score = true
		main.t_lifebar.p2ai = true
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_freebattle_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('freebattle')
		start.f_selectSimple()
	end,
	--VS 100 KUMITE
	['vs100kumite'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.matchWins = {1, 1, 0}
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.match = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.vs100_kumite_results_screen
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_vs100kumite_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('vs100kumite')
		start.f_selectArranged()
	end,
	--BOSS RUSH
	['bossrush'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.match = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.boss_rush_results_screen
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_bossrush_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('bossrush')
		start.f_selectArranged()
	end,
	--REPLAY
	['replay'] = function(cursorPosY, moveTxt, item, t)
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		replay.f_replay()
	end,
	--RANDOMTEST
	['randomtest'] = function(cursorPosY, moveTxt, item, t)
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		clearColor(motif.titlebgdef.bgclearcolor[1], motif.titlebgdef.bgclearcolor[2], motif.titlebgdef.bgclearcolor[3])
		setGameMode('randomtest')
		randomtest.run()
		main:f_bgReset(motif.titlebgdef.bg)
		main:f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
	end,
	--TOURNAMENT ROUND OF 32
	['tournament32'] = function(cursorPosY, moveTxt, item, t)
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.txt_mainSelect:update({text = motif.select_info.title_tournament32_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('tournament')
		start.f_selectTournament(32)
	end,
	--TOURNAMENT ROUND OF 16
	['tournament16'] = function(cursorPosY, moveTxt, item, t)
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.txt_mainSelect:update({text = motif.select_info.title_tournament16_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('tournament')
		start.f_selectTournament(16)
	end,
	--TOURNAMENT QUARTERFINALS
	['tournament8'] = function(cursorPosY, moveTxt, item, t)
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.txt_mainSelect:update({text = motif.select_info.title_tournament8_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('tournament')
		start.f_selectTournament(8)
	end,
	--HOST
	['serverhost'] = function(cursorPosY, moveTxt, item, t)
		main.serverhost = true
		main:f_connect("", main:f_extractText(motif.title_info.connecting_host_text, getListenPort()))
		local f = main:f_checkSubmenu(main.menu.submenu.server, 2)
		if f ~= '' then
			main:f_default()
			main.t_itemname[f](cursorPosY, moveTxt, item, t)
			--resetRemapInput()
		end
		replayStop()
		exitNetPlay()
		exitReplay()
	end,
	--NEW ADDRESS
	['joinadd'] = function(cursorPosY, moveTxt, item, t)
		sndPlay(motif.files.snd_data, motif.title_info.cursor_move_snd[1], motif.title_info.cursor_move_snd[2])
		local name = main:f_drawInput(main:f_extractText(motif.title_info.input_ip_name_text), motif.title_info, motif.titlebgdef, 'string')
		if name ~= '' then
			sndPlay(motif.files.snd_data, motif.title_info.cursor_move_snd[1], motif.title_info.cursor_move_snd[2])
			local address = main:f_drawInput(main:f_extractText(motif.title_info.input_ip_address_text), motif.title_info, motif.titlebgdef, 'string')
			if address:match('^[0-9%.]+$') then
				sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
				config.IP[name] = address
				table.insert(t, #t, {data = text:create({}), itemname = 'ip_' .. name, displayname = name})
				local file = io.open(main.flags['-config'], 'w+')
				file:write(json.encode(config, {indent = true}))
				file:close()
			else
				sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
			end
		else
			sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
		end
	end,
	--ONLINE VERSUS
	['netplayversus'] = function(cursorPosY, moveTxt, item, t)
		setHomeTeam(1)
		main.t_pIn[2] = 2
		main.stageMenu = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		main.victoryScreen = true
		--uses default main.t_charparam assignment
		main.t_lifebar.p1score = true
		main.t_lifebar.p2score = true
		main.p1TeamMenu.single = true
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.turns = true
		main.p1TeamMenu.tag = true
		main.p1TeamMenu.ratio = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_netplayversus_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('netplayversus')
		start.f_selectSimple()
	end,
	--ONLINE CO-OP
	['netplayteamcoop'] = function(cursorPosY, moveTxt, item, t)
		main.t_pIn[2] = 2
		main.coop = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.resetScore = true
		main.versusScreen = true
		main.victoryScreen = true
		main.continueScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_charparam.rivals = true
		main.t_lifebar.p1score = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.win_screen
		main.credits = config.Credits - 1
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.tag = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_netplayteamcoop_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('netplayteamcoop')
		start.f_selectArcade()
	end,
	--ONLINE SURVIVAL
	['netplaysurvivalcoop'] = function(cursorPosY, moveTxt, item, t)
		main.t_pIn[2] = 2
		main.matchWins = {1, 1, 0}
		main.coop = true
		main.p2Faces = true
		main.p2SelectMenu = true
		main.versusScreen = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.t_lifebar.match = true
		main.t_lifebar.p2ai = true
		main.resultsTable = motif.survival_results_screen
		main.p1TeamMenu.simul = true
		main.p1TeamMenu.tag = true
		main.p2TeamMenu.single = true
		main.p2TeamMenu.simul = true
		main.p2TeamMenu.turns = true
		main.p2TeamMenu.tag = true
		main.p2TeamMenu.ratio = true
		main.txt_mainSelect:update({text = motif.select_info.title_netplaysurvivalcoop_text})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('netplaysurvivalcoop')
		start.f_selectArranged()
	end,
	--BONUS CHAR
	['bonus'] = function(cursorPosY, moveTxt, item, t)
		if main.playerInput ~= 1 then
			remapInput(1, main.playerInput)
			remapInput(main.playerInput, 1)
		end
		main.t_pIn[2] = 1
		main.p2SelectMenu = true
		main.t_charparam.stage = true
		main.t_charparam.music = true
		main.t_charparam.ai = true
		main.t_charparam.rounds = true
		main.t_charparam.time = true
		main.t_charparam.single = true
		main.p1TeamMenu.single = true
		main.p2TeamMenu.single = true
		main.p2Char = {main.t_bonusChars[item]}
		main.txt_mainSelect:update({text = getCharName(main.t_bonusChars[item])})
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		main:f_menuFade('title_info', 'fadeout', cursorPosY, moveTxt, item, t)
		setGameMode('bonus')
		start.f_selectSimple()
	end,
	--CONNECT
	['connect'] = function(cursorPosY, moveTxt, item, t)
		main.serverhost = false
		main:f_connect(config.IP[t[item].displayname], main:f_extractText(motif.title_info.connecting_join_text, t[item].displayname, config.IP[t[item].displayname]))
		local f = main:f_checkSubmenu(main.menu.submenu.server, 2)
		if f ~= '' then
			main:f_default()
			main.t_itemname[f](cursorPosY, moveTxt, item, t)
			--resetRemapInput()
		end
		replayStop()
		exitNetPlay()
		exitReplay()
	end,
}
main.t_itemname.teamarcade = main.t_itemname.arcade
main.t_itemname.teamversus = main.t_itemname.versus
if main.debugLog then main:f_printTable(main.t_itemname, 'debug/t_mainItemname.txt') end

function main:f_deleteIP(item, t)
	if t[item].itemname:match('^ip_') then
		sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
		resetKey()
		config.IP[t[item].itemname:gsub('^ip_', '')] = nil
		local file = io.open(self.flags['-config'], 'w+')
		file:write(json.encode(config, {indent = true}))
		file:close()
		for i = 1, #t do
			if t[i].itemname == t[item].itemname then
				table.remove(t, i)
				break
			end
		end
	end
end

--open submenu
function main:f_checkSubmenu(t, minimum, resetPos)
	local minimum = minimum or 0
	if t == nil then return '' end
	local cnt = 0
	local f = ''
	local skip = false
	for k, v in ipairs(t.items) do
		if v.itemname:match('^bonus_') or v.itemname == 'joinadd' then
			skip = true
			break
		elseif v.itemname ~= 'back' then
			f = v.itemname
			cnt = cnt + 1
		end
	end
	if cnt >= minimum or skip then
		sndPlay(motif.files.snd_data, motif.title_info.cursor_done_snd[1], motif.title_info.cursor_done_snd[2])
		if resetPos then
			t.cursorPosY = 1
			t.moveTxt = 0
			t.item = 1
		end
		t.reset = true
		t.loop()
		f = ''
	end
	return f
end

local demoFrameCounter = 0
local introWaitCycles = 0
function main:createMenu(tbl, bool_bgreset, bool_storyboard, bool_demo, bool_escsnd, bool_f1, bool_del)
	return function()
		local cursorPosY = 1
		local moveTxt = 0
		local item = 1
		local t = tbl.items
		if bool_storyboard then
			if motif.files.logo_storyboard ~= '' then
				storyboard.f_storyboard(motif.files.logo_storyboard)
			end
			if motif.files.intro_storyboard ~= '' then
				storyboard.f_storyboard(motif.files.intro_storyboard)
			end
		end
		if bool_bgreset then
			self:f_bgReset(motif.titlebgdef.bg)
			self:f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
		end
		while true do
			if tbl.reset then
				tbl.reset = false
				self:f_cmdInput()
			else
				self:f_menuCommonDraw(cursorPosY, moveTxt, item, t, 'fadein', 'title_info', 'title_info', 'titlebgdef', self.txt_title, false, motif.defaultLocalcoord, true, {txt_footer1, txt_footer2, txt_footer3})
			end
			if bool_demo then
				self:f_demo(cursorPosY, moveTxt, item, t)
			end
			local item_sav = item
			cursorPosY, moveTxt, item = self:f_menuCommonCalc(cursorPosY, moveTxt, item, t, 'title_info', self:f_extractKeys(motif.title_info.menu_key_previous), self:f_extractKeys(motif.title_info.menu_key_next))
			self.txt_title:update({text = tbl.title})
			if item_sav ~= item then
				demoFrameCounter = 0
				introWaitCycles = 0
			end
			if esc() or self:f_input(self.t_players, {'m'}) then
				if bool_escsnd then
					sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
				end
				break
			elseif bool_f1 and getKey() == 'F1' then
				self:f_warning(
						self:f_extractText(motif.infobox.text),
						motif.title_info,
						motif.titlebgdef,
						motif.infobox,
						txt_infoboxTitle,
						motif.infobox.boxbg_coords,
						motif.infobox.boxbg_col,
						motif.infobox.boxbg_alpha,
						motif.defaultInfobox
				)
			elseif bool_del and getKey() == 'DELETE' then
				self:f_deleteIP(item, t)
			else
				self.playerInput = 0
				if self:f_input({1}, self:f_extractKeys(motif.title_info.menu_key_accept)) then
					self.playerInput = 1
				elseif self:f_input({2}, self:f_extractKeys(motif.title_info.menu_key_accept)) then
					self.playerInput = 2
				end
				if self.playerInput > 0 then
					demoFrameCounter = 0
					local f = self:f_checkSubmenu(tbl.submenu[t[item].itemname], 2)
					if f == '' then
						if t[item].itemname:match('^bonus_') then
							f = 'bonus'
						elseif t[item].itemname:match('^ip_') then
							f = 'connect'
						else
							f = t[item].itemname
						end
					end
					if f == 'back' then
						sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
						break
					elseif f == 'exit' then
						break
					elseif self.t_itemname[f] ~= nil then
						t[item].itemname = f
						self:f_default()
						self.t_itemname[f](cursorPosY, moveTxt, item, t)
						self:f_default()
					end
				end
			end
		end
	end
end

local t_menuWindow = {0, 0, main.SP_Localcoord[1], main.SP_Localcoord[2]}
if motif.title_info.menu_window_margins_y[1] ~= 0 or motif.title_info.menu_window_margins_y[2] ~= 0 then
	t_menuWindow = {
		0,
		math.max(0, motif.title_info.menu_pos[2] - motif.title_info.menu_window_margins_y[1]),
		motif.info.localcoord[1],
		motif.title_info.menu_pos[2] + (motif.title_info.menu_window_visibleitems - 1) * motif.title_info.menu_item_spacing[2] + motif.title_info.menu_window_margins_y[2]
	}
end

--dynamically generates all main screen menus and submenus using itemname data stored in main.t_sort table
main.menu = {title = main:f_itemnameUpper(motif.title_info.title_text, motif.title_info.menu_title_uppercase == 1), submenu = {}, items = {}}
main.menu.loop = main:createMenu(main.menu, true, true, true, false, true, false)
local t_pos = {} --for storing current main.menu table position
local t_skipGroup = {}
local lastNum = 0
function main:f_parseMenu()
	for i = 1, #self.t_sort.title_info do
		for j, c in ipairs(self:f_strsplit('_', self.t_sort.title_info[i])) do --split using "_" delimiter
			--exceptions for expanding the menu table
			if motif.title_info['menu_itemname_' .. self.t_sort.title_info[i]] == '' and c ~= 'server' then --items and groups without displayname are skipped
				t_skipGroup[c] = true
				break
			elseif t_skipGroup[c] then --named item but inside a group without displayname
				break
			elseif c == 'bossrush' and self:f_tableLength(self.t_bossChars) == 0 then --skip boss rush mode if there are no characters with boss param set to 1
				break
			elseif c == 'bonusgames' and #self.t_bonusChars == 0 then --skip bonus mode if there are no characters with bonus param set to 1
				t_skipGroup[c] = true
				break
			end
			--appending the menu table
			if j == 1 then --first string after menu.itemname (either reserved one or custom submenu assignment)
				if self.menu.submenu[c] == nil then
					self.menu.submenu[c] = {title = self:f_itemnameUpper(motif.title_info['menu_itemname_' .. self.t_sort.title_info[i]], motif.title_info.menu_title_uppercase == 1), submenu = {}, items = {}}
					self.menu.submenu[c].loop = self:createMenu(self.menu.submenu[c], false, false, false, true, true, c == 'serverjoin')
					if not self.t_sort.title_info[i]:match(c .. '_') then
						table.insert(self.menu.items, {data = text:create({window = t_menuWindow}), itemname = c, displayname = motif.title_info['menu_itemname_' .. self.t_sort.title_info[i]]})
					end
				end
				t_pos = self.menu.submenu[c]
			else --following strings
				if t_pos.submenu[c] == nil then
					t_pos.submenu[c] = {title = self:f_itemnameUpper(motif.title_info['menu_itemname_' .. self.t_sort.title_info[i]], motif.title_info.menu_title_uppercase == 1), submenu = {}, items = {}}
					t_pos.submenu[c].loop = self:createMenu(t_pos.submenu[c], false, false, false, true, true, c == 'serverjoin')
					table.insert(t_pos.items, {data = text:create({window = t_menuWindow}), itemname = c, displayname = motif.title_info['menu_itemname_' .. self.t_sort.title_info[i]]})
				end
				if j > lastNum then
					t_pos = t_pos.submenu[c]
				end
			end
			lastNum = j
			--add bonus character names to bonusgames submenu
			if self.t_sort.title_info[i]:match('_bonusgames_back$') and c == 'bonusgames' then --j == main:f_countSubstring(main.t_sort.title_info[i], '_') then
				for k = 1, #self.t_bonusChars do
					local name = getCharName(self.t_bonusChars[k])
					table.insert(t_pos.items, {data = text:create({window = t_menuWindow}), itemname = 'bonus_' .. name:gsub('%s+', '_'), displayname = name:upper()})
				end
			end
			--add IP addresses for serverjoin submenu
			if self.t_sort.title_info[i]:match('_serverjoin_back$') and c == 'serverjoin' then --j == main:f_countSubstring(main.t_sort.title_info[i], '_') then
				for k, v in pairs(config.IP) do
					table.insert(t_pos.items, {data = text:create({window = t_menuWindow}), itemname = 'ip_' .. k, displayname = k})
				end
			end
		end
	end
end
main:f_parseMenu()

if main.debugLog then main:f_printTable(main.menu, 'debug/t_mainMenu.txt') end

function main:f_default()
	main.matchWins = {main.roundsNumSingle, main.roundsNumTeam, main.maxDrawGames}
	main.roundTime = config.RoundTime --default round time
	main.p1Char = nil --no predefined P1 character (assigned via table: {X, Y, (...)})
	main.p2Char = nil --no predefined P2 character (assigned via table: {X, Y, (...)})
	main.p1TeamMenu = {single = false, simul = false, turns = false, tag = false, ratio = false} --p1 side team mode options
	main.p2TeamMenu = {single = false, simul = false, turns = false, tag = false, ratio = false} --p2 side team mode options
	main.aiFight = false --AI = config.Difficulty for all characters disabled
	main.stageMenu = false --stage selection disabled
	main.p2Faces = false --additional window with P2 select screen small portraits (faces) disabled
	main.coop = false --P2 fighting on P1 side disabled
	main.p2SelectMenu = false --P2 character selection disabled
	main.resetScore = false --score is not set to lose count after loosing a match
	main.versusScreen = false --versus screen disabled
	main.victoryScreen = false --victory screen disabled
	main.continueScreen = false --continue screen disabled
	main.quickContinue = false --continue without char selection enforcement disabled
	main.resultsTable = nil --no results table reference
	main:f_resetCharparam()
	main:f_resetLifebar()
	--main.t_pIn[1] = 1 --P1 controls P1 side of the select screen
	--main.t_pIn[2] = 2 --P2 controls P2 side of the select screen
	for i = 1, #config.KeyConfig do
		main.t_pIn[i] = i
	end
	demoFrameCounter = 0
	setAutoguard(1, config.AutoGuard)
	setAutoguard(2, config.AutoGuard)
	setAutoLevel(false) --generate autolevel.txt in game dir
	setHomeTeam(2) --P2 side considered the home team: http://mugenguild.com/forum/topics/ishometeam-triggers-169132.0.html
	setConsecutiveWins(1, 0)
	setConsecutiveWins(2, 0)
	setGameMode('')
	setGuardBar(config.BarGuard)
	setStunBar(config.BarStun)
	setRedLifeBar(config.BarRedLife)
	setDemoTime(motif.demo_mode.fight_endtime)
	setTimeFramesPerCount(main.timeFramesPerCount)
	setRoundTime(math.max(-1, main.roundTime * main.timeFramesPerCount))
	resetRemapInput()
end

function main:f_resetCharparam()
	main.t_charparam = {
		stage = false,
		music = false,
		ai = false,
		vsscreen = true,
		winscreen = true,
		rounds = false,
		time = false,
		lifebar = true,
		single = false,
		rivals = false,
	}
end

function main:f_resetLifebar()
	main.t_lifebar = {
		timer = false,
		p1score = false,
		p2score = false,
		match = false,
		p1ai = false,
		p2ai = false,
		mode = true,
		bars = true,
		lifebar = true,
	}
	setLifebarElements(main.t_lifebar)
end

function main:f_demo(cursorPosY, moveTxt, item, t, fadeType)
	if motif.demo_mode.enabled == 0 then
		return
	end
	demoFrameCounter = demoFrameCounter + 1
	if demoFrameCounter < motif.demo_mode.title_waittime then
		return
	end
	main:f_default()
	main:f_menuFade('demo_mode', 'fadeout', cursorPosY, moveTxt, item, t)
	clearColor(motif.titlebgdef.bgclearcolor[1], motif.titlebgdef.bgclearcolor[2], motif.titlebgdef.bgclearcolor[3])
	if motif.demo_mode.fight_bars_display == 1 then
		setLifebarElements({['bars'] = true})
	else
		setLifebarElements({['bars'] = false})
	end
	if motif.demo_mode.debuginfo == 0 and config.DebugKeys then
		setAllowDebugKeys(false)
	end
	setGameMode('demo')
	for i = 1, 2 do
		setCom(i, 8)
		setTeamMode(i, 0, 1)
		local ch = main.t_randomChars[math.random(1, #main.t_randomChars)]
		selectChar(i, ch, getCharRandomPalette(ch))
	end
	local stage = start.f_setStage()
	start.f_setMusic(stage)
	loadStart()
	game()
	setAllowDebugKeys(config.DebugKeys)
	refresh()
	--intro
	if introWaitCycles >= motif.demo_mode.intro_waitcycles then
		if motif.files.intro_storyboard ~= '' then
			storyboard.f_storyboard(motif.files.intro_storyboard)
		end
		introWaitCycles = 0
	else
		introWaitCycles = introWaitCycles + 1
	end
	main:f_bgReset(motif.titlebgdef.bg)
	--start title BGM only if it has been interrupted
	if motif.demo_mode.fight_stopbgm == 1 or motif.demo_mode.fight_playbgm == 1 or (introWaitCycles == 0 and motif.files.intro_storyboard ~= '') then
		main:f_playBGM(true, motif.music.title_bgm, motif.music.title_bgm_loop, motif.music.title_bgm_volume, motif.music.title_bgm_loopstart, motif.music.title_bgm_loopend)
	end
	main:f_menuFade('demo_mode', 'fadein', cursorPosY, moveTxt, item, t)
end

function main:f_menuCommonCalc(cursorPosY, moveTxt, item, t, section, keyPrev, keyNext)
	local startItem = 1
	for _, v in ipairs(t) do
		if v.itemname ~= 'empty' then
			break
		end
		startItem = startItem + 1
	end
	if main:f_input(main.t_players, keyNext) then
		sndPlay(motif.files.snd_data, motif[section].cursor_move_snd[1], motif[section].cursor_move_snd[2])
		while true do
			item = item + 1
			if cursorPosY < motif[section].menu_window_visibleitems then
				cursorPosY = cursorPosY + 1
			end
			if t[item] == nil or t[item].itemname ~= 'empty' then
				break
			end
		end
	elseif main:f_input(main.t_players, keyPrev) then
		sndPlay(motif.files.snd_data, motif[section].cursor_move_snd[1], motif[section].cursor_move_snd[2])
		while true do
			item = item - 1
			if cursorPosY > startItem then
				cursorPosY = cursorPosY - 1
			end
			if t[item] == nil or t[item].itemname ~= 'empty' then
				break
			end
		end
	end
	if item > #t or (item == 1 and t[item].itemname == 'empty') then
		item = 1
		while true do
			if t[item].itemname ~= 'empty' or item >= #t then
				break
			else
				item = item + 1
			end
		end
		cursorPosY = item
	elseif item < 1 then
		item = #t
		while true do
			if t[item].itemname ~= 'empty' or item <= 1 then
				break
			else
				item = item - 1
			end
		end
		if item > motif[section].menu_window_visibleitems then
			cursorPosY = motif[section].menu_window_visibleitems
		else
			cursorPosY = item
		end
	end
	if cursorPosY >= motif[section].menu_window_visibleitems then
		moveTxt = (item - motif[section].menu_window_visibleitems) * motif[section].menu_item_spacing[2]
	elseif cursorPosY <= startItem then
		moveTxt = (item - startItem) * motif[section].menu_item_spacing[2]
	end
	return cursorPosY, moveTxt, item
end

function main:f_menuCommonDraw(cursorPosY, moveTxt, item, t, fadeType, fadeData, section, bgdef, title, dataScale, rectScale, rectFix, t_footer, skipClear)
	--draw clearcolor
	if not skipClear then
		clearColor(motif[bgdef].bgclearcolor[1], motif[bgdef].bgclearcolor[2], motif[bgdef].bgclearcolor[3])
	end
	--draw layerno = 0 backgrounds
	bgDraw(motif[bgdef].bg, false)
	--draw menu box
	if motif[section].menu_boxbg_visible == 1 then
		local coord4 = 0
		if #t > motif[section].menu_window_visibleitems then
			coord4 = motif[section].menu_window_visibleitems * (motif[section].menu_boxcursor_coords[4] - motif[section].menu_boxcursor_coords[2] + 1) + main:f_oddRounding(motif[section].menu_boxcursor_coords[2])
		else
			coord4 = #t * (motif[section].menu_boxcursor_coords[4] - motif[section].menu_boxcursor_coords[2] + 1) + main:f_oddRounding(motif[section].menu_boxcursor_coords[2])
		end
		fillRect(
				motif[section].menu_pos[1] + motif[section].menu_boxcursor_coords[1],
				motif[section].menu_pos[2] + motif[section].menu_boxcursor_coords[2],
				motif[section].menu_boxcursor_coords[3] - motif[section].menu_boxcursor_coords[1] + 1,
				coord4,
				motif[section].menu_boxbg_col[1],
				motif[section].menu_boxbg_col[2],
				motif[section].menu_boxbg_col[3],
				motif[section].menu_boxbg_alpha[1],
				motif[section].menu_boxbg_alpha[2],
				rectScale,
				rectFix
		)
	end
	--draw title
	title:draw()
	--draw menu items
	local items_shown = item + motif[section].menu_window_visibleitems - cursorPosY
	if items_shown > #t or (motif[section].menu_window_visibleitems > 1 and items_shown < #t and (motif[section].menu_window_margins_y[1] ~= 0 or motif[section].menu_window_margins_y[2] ~= 0)) then
		items_shown = #t
	end
	for i = 1, items_shown do
		if i > item - cursorPosY then
			if i == item then
				if t[i].selected then
					t[i].data:update({
						font =   motif[section].menu_item_selected_active_font[1],
						bank =   motif[section].menu_item_selected_active_font[2],
						align =  motif[section].menu_item_selected_active_font[3],
						text =   t[i].displayname,
						x =      motif[section].menu_pos[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_selected_active_font_scale[1],
						scaleY = motif[section].menu_item_selected_active_font_scale[2],
						r =      motif[section].menu_item_selected_active_font[4],
						g =      motif[section].menu_item_selected_active_font[5],
						b =      motif[section].menu_item_selected_active_font[6],
						src =    motif[section].menu_item_selected_active_font[7],
						dst =    motif[section].menu_item_selected_active_font[8],
						height = motif[section].menu_item_selected_active_font_height,
						defsc =  dataScale
					})
					t[i].data:draw()
				else
					t[i].data:update({
						font =   motif[section].menu_item_active_font[1],
						bank =   motif[section].menu_item_active_font[2],
						align =  motif[section].menu_item_active_font[3],
						text =   t[i].displayname,
						x =      motif[section].menu_pos[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_active_font_scale[1],
						scaleY = motif[section].menu_item_active_font_scale[2],
						r =      motif[section].menu_item_active_font[4],
						g =      motif[section].menu_item_active_font[5],
						b =      motif[section].menu_item_active_font[6],
						src =    motif[section].menu_item_active_font[7],
						dst =    motif[section].menu_item_active_font[8],
						height = motif[section].menu_item_active_font_height,
						defsc =  dataScale
					})
					t[i].data:draw()
				end
				if t[i].vardata ~= nil then
					t[i].vardata:update({
						font =   motif[section].menu_item_value_active_font[1],
						bank =   motif[section].menu_item_value_active_font[2],
						align =  motif[section].menu_item_value_active_font[3],
						text =   t[i].vardisplay,
						x =      motif[section].menu_pos[1] + motif[section].menu_item_spacing[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_value_active_font_scale[1],
						scaleY = motif[section].menu_item_value_active_font_scale[2],
						r =      motif[section].menu_item_value_active_font[4],
						g =      motif[section].menu_item_value_active_font[5],
						b =      motif[section].menu_item_value_active_font[6],
						src =    motif[section].menu_item_value_active_font[7],
						dst =    motif[section].menu_item_value_active_font[8],
						height = motif[section].menu_item_value_active_font_height,
						defsc =  dataScale
					})
					t[i].vardata:draw()
				end
			else
				if t[i].selected then
					t[i].data:update({
						font =   motif[section].menu_item_selected_font[1],
						bank =   motif[section].menu_item_selected_font[2],
						align =  motif[section].menu_item_selected_font[3],
						text =   t[i].displayname,
						x =      motif[section].menu_pos[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_selected_font_scale[1],
						scaleY = motif[section].menu_item_selected_font_scale[2],
						r =      motif[section].menu_item_selected_font[4],
						g =      motif[section].menu_item_selected_font[5],
						b =      motif[section].menu_item_selected_font[6],
						src =    motif[section].menu_item_selected_font[7],
						dst =    motif[section].menu_item_selected_font[8],
						height = motif[section].menu_item_selected_font_height,
						defsc =  dataScale
					})
					t[i].data:draw()
				else
					t[i].data:update({
						font =   motif[section].menu_item_font[1],
						bank =   motif[section].menu_item_font[2],
						align =  motif[section].menu_item_font[3],
						text =   t[i].displayname,
						x =      motif[section].menu_pos[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_font_scale[1],
						scaleY = motif[section].menu_item_font_scale[2],
						r =      motif[section].menu_item_font[4],
						g =      motif[section].menu_item_font[5],
						b =      motif[section].menu_item_font[6],
						src =    motif[section].menu_item_font[7],
						dst =    motif[section].menu_item_font[8],
						height = motif[section].menu_item_font_height,
						defsc =  dataScale
					})
					t[i].data:draw()
				end
				if t[i].vardata ~= nil then
					t[i].vardata:update({
						font =   motif[section].menu_item_value_font[1],
						bank =   motif[section].menu_item_value_font[2],
						align =  motif[section].menu_item_value_font[3],
						text =   t[i].vardisplay,
						x =      motif[section].menu_pos[1] + motif[section].menu_item_spacing[1],
						y =      motif[section].menu_pos[2] + (i - 1) * motif[section].menu_item_spacing[2] - moveTxt,
						scaleX = motif[section].menu_item_value_font_scale[1],
						scaleY = motif[section].menu_item_value_font_scale[2],
						r =      motif[section].menu_item_value_font[4],
						g =      motif[section].menu_item_value_font[5],
						b =      motif[section].menu_item_value_font[6],
						src =    motif[section].menu_item_value_font[7],
						dst =    motif[section].menu_item_value_font[8],
						height = motif[section].menu_item_value_font_height,
						defsc =  dataScale
					})
					t[i].vardata:draw()
				end
			end
		end
	end
	--draw menu cursor
	if motif[section].menu_boxcursor_visible == 1 and not main.fadeActive then
		local src, dst = main:f_boxcursorAlpha(
				motif[section].menu_boxcursor_alpharange[1],
				motif[section].menu_boxcursor_alpharange[2],
				motif[section].menu_boxcursor_alpharange[3],
				motif[section].menu_boxcursor_alpharange[4],
				motif[section].menu_boxcursor_alpharange[5],
				motif[section].menu_boxcursor_alpharange[6]
		)
		fillRect(
				motif[section].menu_pos[1] + motif[section].menu_boxcursor_coords[1],
				motif[section].menu_pos[2] + motif[section].menu_boxcursor_coords[2] + (cursorPosY - 1) * motif[section].menu_item_spacing[2],
				motif[section].menu_boxcursor_coords[3] - motif[section].menu_boxcursor_coords[1] + 1,
				motif[section].menu_boxcursor_coords[4] - motif[section].menu_boxcursor_coords[2] + 1 + main:f_oddRounding(motif[section].menu_boxcursor_coords[2]),
				motif[section].menu_boxcursor_col[1],
				motif[section].menu_boxcursor_col[2],
				motif[section].menu_boxcursor_col[3],
				src,
				dst,
				rectScale,
				rectFix
		)
	end
	--draw scroll arrows
	if #t > motif[section].menu_window_visibleitems then
		if item > cursorPosY then
			animUpdate(motif[section].menu_arrow_up_data)
			animDraw(motif[section].menu_arrow_up_data)
		end
		if item >= cursorPosY and items_shown < #t then
			animUpdate(motif[section].menu_arrow_down_data)
			animDraw(motif[section].menu_arrow_down_data)
		end
	end
	--draw layerno = 1 backgrounds
	bgDraw(motif[bgdef].bg, true)
	--footer draw
	if motif[section].footer_boxbg_visible == 1 then
		fillRect(
				motif[section].footer_boxbg_coords[1],
				motif[section].footer_boxbg_coords[2],
				motif[section].footer_boxbg_coords[3] - motif[section].footer_boxbg_coords[1] + 1,
				motif[section].footer_boxbg_coords[4] - motif[section].footer_boxbg_coords[2] + 1,
				motif[section].footer_boxbg_col[1],
				motif[section].footer_boxbg_col[2],
				motif[section].footer_boxbg_col[3],
				motif[section].footer_boxbg_alpha[1],
				motif[section].footer_boxbg_alpha[2],
				motif.defaultLocalcoord,
				rectFix
		)
	end
	for i = 1, #t_footer do
		t_footer[i]:draw()
	end
	--draw fadein / fadeout
	main.fadeActive = fadeColor(
			fadeType,
			main.fadeStart,
			motif[fadeData][fadeType .. '_time'],
			motif[fadeData][fadeType .. '_col'][1],
			motif[fadeData][fadeType .. '_col'][2],
			motif[fadeData][fadeType .. '_col'][3]
	)
	--frame transition
	if main.fadeActive then
		commandBufReset(main.t_cmd[1])
		commandBufReset(main.t_cmd[2])
	elseif fadeType == 'fadeout' then
		commandBufReset(main.t_cmd[1])
		commandBufReset(main.t_cmd[2])
		return --skip last frame rendering
	else
		main:f_cmdInput()
	end
	if not skipClear then
		refresh()
	end
end

main.fadeActive = false
function main:f_menuFade(screen, fadeType, cursorPosY, moveTxt, item, t)
	main.fadeStart = getFrameCount()
	while true do
		--cursorPosY, moveTxt, item, t, fadeType, fadeData, section, bgdef, title, dataScale, rectScale, rectFix, t_footer
		if screen == 'title_info' then
			main:f_menuCommonDraw(cursorPosY, moveTxt, item, t, fadeType, 'title_info', 'title_info', 'titlebgdef', main.txt_title, false, motif.defaultLocalcoord, true, {txt_footer1, txt_footer2, txt_footer3})
		elseif screen == 'option_info' then
			main:f_menuCommonDraw(cursorPosY, moveTxt, item, t, fadeType, 'option_info', 'option_info', 'optionbgdef', options.txt_title, motif.defaultOptions, motif.defaultOptions, false, {})
		elseif screen == 'replay_info' then
			main:f_menuCommonDraw(cursorPosY, moveTxt, item, t, fadeType, 'replay_info', 'replay_info', 'replaybgdef', replay.txt_title, motif.defaultReplay, motif.defaultReplay, false, {})
		elseif screen == 'demo_mode' then
			main:f_menuCommonDraw(cursorPosY, moveTxt, item, t, fadeType, 'demo_mode', 'title_info', 'titlebgdef', main.txt_title, false, motif.defaultLocalcoord, true, {txt_footer1, txt_footer2, txt_footer3})
		end
		if not main.fadeActive then
			break
		end
	end
end

function main:f_bgReset(data)
	main.t_animUpdate = {}
	alpha1cur = 0
	alpha2cur = 0
	alpha1add = true
	alpha2add = true
	bgReset(data)
	main.fadeStart = getFrameCount()
end

function main:f_playBGM(interrupt, bgm, bgmLoop, bgmVolume, bgmLoopstart, bgmLoopend)
	if main.flags['-nomusic'] ~= nil then
		return
	end
	local bgm = bgm or ''
	local bgmLoop = bgmLoop or 1
	local bgmVolume = bgmVolume or 100
	local bgmLoopstart = bgmLoopstart or 0
	local bgmLoopend = bgmLoopend or 0
	if interrupt or bgm ~= '' then
		playBGM(bgm, true, bgmLoop, bgmVolume, bgmLoopstart, bgmLoopend)
	end
end

local txt_connecting = text:create({
	font =   motif.title_info.connecting_font[1],
	bank =   motif.title_info.connecting_font[2],
	align =  motif.title_info.connecting_font[3],
	text =   '',
	x =      motif.title_info.connecting_offset[1],
	y =      motif.title_info.connecting_offset[2],
	scaleX = motif.title_info.connecting_font_scale[1],
	scaleY = motif.title_info.connecting_font_scale[2],
	r =      motif.title_info.connecting_font[4],
	g =      motif.title_info.connecting_font[5],
	b =      motif.title_info.connecting_font[6],
	src =    motif.title_info.connecting_font[7],
	dst =    motif.title_info.connecting_font[8],
	height = motif.title_info.connecting_font_height,
	defsc =  motif.defaultConnecting
})

function main:f_connect(server, t)
	local cancel = false
	enterNetPlay(server)
	while not connected() do
		if esc() or main:f_input(main.t_players, {'m'}) then
			sndPlay(motif.files.snd_data, motif.title_info.cancel_snd[1], motif.title_info.cancel_snd[2])
			cancel = true
			break
		end
		--draw clearcolor
		clearColor(motif.titlebgdef.bgclearcolor[1], motif.titlebgdef.bgclearcolor[2], motif.titlebgdef.bgclearcolor[3])
		--draw layerno = 0 backgrounds
		bgDraw(motif.titlebgdef.bg, false)
		--draw layerno = 1 backgrounds
		bgDraw(motif.titlebgdef.bg, true)
		--draw menu box
		fillRect(
				motif.title_info.connecting_boxbg_coords[1],
				motif.title_info.connecting_boxbg_coords[2],
				motif.title_info.connecting_boxbg_coords[3] - motif.title_info.connecting_boxbg_coords[1] + 1,
				motif.title_info.connecting_boxbg_coords[4] - motif.title_info.connecting_boxbg_coords[2] + 1,
				motif.title_info.connecting_boxbg_col[1],
				motif.title_info.connecting_boxbg_col[2],
				motif.title_info.connecting_boxbg_col[3],
				motif.title_info.connecting_boxbg_alpha[1],
				motif.title_info.connecting_boxbg_alpha[2],
				false,
				false
		)
		--draw text
		for i = 1, #t do
			txt_connecting:update({text = t[i]})
			txt_connecting:draw()
		end
		--end loop
		refresh()
	end
	main:f_cmdInput()
	if not cancel then
		replayRecord('save/replays/' .. os.date("%Y-%m-%d %I-%M%p-%Ss") .. '.replay')
		synchronize()
		math.randomseed(sszRandom())
	end
end

--;===========================================================
--; INITIALIZE LOOPS
--;===========================================================
if config.SafeLoading then
	setGCPercent(100)
end


function main.doStressTest()
	if main.flags['-stresstest'] ~= nil then
		main:f_default()
		local frameskip = tonumber(main.flags['-stresstest'])
		if frameskip >= 1 then
			setGameSpeed(frameskip + 1)
		end
		setGameMode('randomtest')
		randomtest.run()
		os.exit()
	end
end
main.doStressTest()

function main.getMainData()
	return maindata
end

-- call this as late as possible to make sure prior objects/functions are loaded
require('external.script.extend')
main.menu.loop()

-- Debug Info
--main.motifData = nil
--if main.debugLog then main:f_printTable(main, "debug/t_main.txt") end