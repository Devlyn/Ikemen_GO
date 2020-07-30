require('external.script.util.dump')
TextUtils = {}

local text = {
    motif = {},
    main = {}
}

--create text
function text:create(t)
    --default values
    if t.window == nil then t.window = {} end
    local o = {
        font = t.font or -1,
        bank = t.bank or 0,
        align = t.align or 0,
        text = t.text or '',
        x = t.x or 0,
        y = t.y or 0,
        scaleX = t.scaleX or 1,
        scaleY = t.scaleY or 1,
        r = t.r or 255,
        g = t.g or 255,
        b = t.b or 255,
        src = t.src or 255,
        dst = t.dst or 0,
        height = t.height or -1,
        window = {
            t.window[1] or 0,
            t.window[2] or 0,
            t.window[3] or self.motif.info.localcoord[1],
            t.window[4] or self.motif.info.localcoord[2]
        },
        defsc = t.defsc or false
    }
    o.ti = textImgNew()
    setmetatable(o, self)
    self.__index = self
    if o.font ~= -1 then
        if self.main.font[o.font .. o.height] == nil then
            self.main.font[o.font .. o.height] = fontNew(o.font, o.height)
        end
        if self.main.font_def[o.font .. o.height] == nil then
            self.main.font_def[o.font .. o.height] = fontGetDef(self.main.font[o.font .. o.height])
        end
        textImgSetFont(o.ti, self.main.font[o.font .. o.height])
    end
    textImgSetBank(o.ti, o.bank)
    textImgSetAlign(o.ti, o.align)
    textImgSetText(o.ti, o.text)
    textImgSetColor(o.ti, o.r, o.g, o.b, o.src, o.dst)
    if o.defsc then self.main.f_disableLuaScale() end
    textImgSetPos(o.ti, o.x + self.main.f_alignOffset(o.align), o.y)
    textImgSetScale(o.ti, o.scaleX, o.scaleY)
    textImgSetWindow(o.ti, o.window[1], o.window[2], o.window[3] - o.window[1], o.window[4] - o.window[2])
    if o.defsc then self.main.f_setLuaScale() end
    return o
end

--update text
function text:update(t)
    local ok = false
    local fontChange = false
    for k, v in pairs(t) do
        if self[k] ~= v then
            if k == 'font' or k == 'height' then
                fontChange = true
            end
            self[k] = v
            ok = true
        end
    end
    if not ok then return end
    if fontChange and self.font ~= -1 then
        if self.main.font[self.font .. self.height] == nil then
            self.main.font[self.font .. self.height] = fontNew(self.font, self.height)
        end
        if self.main.font_def[self.font .. self.height] == nil then
            self.main.font_def[self.font .. self.height] = fontGetDef(self.main.font[self.font .. self.height])
        end
        textImgSetFont(self.ti, self.main.font[self.font .. self.height])
    end
    textImgSetBank(self.ti, self.bank)
    textImgSetAlign(self.ti, self.align)
    textImgSetText(self.ti, self.text)
    textImgSetColor(self.ti, self.r, self.g, self.b, self.src, self.dst)
    if self.defsc then self.main.f_disableLuaScale() end
    textImgSetPos(self.ti, self.x + self.main.f_alignOffset(self.align), self.y)
    textImgSetScale(self.ti, self.scaleX, self.scaleY)
    textImgSetWindow(self.ti, self.window[1], self.window[2], self.window[3] - self.window[1], self.window[4] - self.window[2])
    if self.defsc then self.main.f_setLuaScale() end
end

--draw text
function text:draw()
    if self.font == -1 then return end
    textImgDraw(self.ti)
end

function TextUtils:getText(motifRef, mainRef)
    text.motif = motifRef
    text.main = mainRef
    return text
end

return TextUtils