ColorUtils = {}

local color = {}

--create color
function color:new(r, g, b, src, dst)
    local n = {r = r or 255, g = g or 255, b = b or 255, src = src or 255, dst = dst or 0}
    setmetatable(n, self)
    self.__index = self
    return n
end

--adds rgb (color + color)
function color.__add(a, b)
    local r = math.max(0, math.min(a.r + b.r, 255))
    local g = math.max(0, math.min(a.g + b.g, 255))
    local b = math.max(0, math.min(a.b + b.b, 255))
    return color:new(r, g, b, a.src, a.dst)
end

--substracts rgb (color - color)
function color.__sub(a, b)
    local r = math.max(0, math.min(a.r - b.r, 255))
    local g = math.max(0, math.min(a.g - b.g, 255))
    local b = math.max(0, math.min(a.b - b.b, 255))
    return color:new(r, g, b, a.src, a.dst)
end

--multiply blend (color * color)
function color.__mul(a, b)
    local r = (a.r / 255) * (b.r / 255) * 255
    local g = (a.g / 255) * (b.g / 255) * 255
    local b = (a.b / 255) * (b.b / 255) * 255
    return color:new(r, g, b, a.src, a.dst)
end

--compares r, g, b, src, and dst (color == color)
function color.__eq(a, b)
    if a.r == b.r and a.g == b.g and a.b == b.b and a.src == b.src and a.dst == b.dst then
        return true
    else
        return false
    end
end

--create color from hex value
function color:fromHex(h)
    h = tostring(h)
    if h:sub(0, 1) =="#" then h = h:sub(2, -1) end
    if h:sub(0, 2) =="0x" then h = h:sub(3, -1) end
    local r = tonumber(h:sub(1, 2), 16)
    local g = tonumber(h:sub(3, 4), 16)
    local b = tonumber(h:sub(5, 6), 16)
    local src = tonumber(h:sub(7, 8), 16) or 255
    local dst = tonumber(h:sub(9, 10), 16) or 0
    return color:new(r, g, b, src, dst)
end

--create string of color converted to hex
function color:toHex(lua)
    local r = string.format("%x", self.r)
    local g = string.format("%x", self.g)
    local b = string.format("%x", self.b)
    local src = string.format("%x", self.src)
    local dst = string.format("%x", self.dst)
    local hex = tostring((r:len() < 2 and "0") .. r .. (g:len() < 2 and "0") .. g .. (b:len() < 2 and "0") .. b ..(src:len() < 2 and "0") .. src .. (dst:len() < 2 and "0") .. dst)
    return hex
end

--returns r, g, b, src, dst
function color:unpack()
    return tonumber(self.r), tonumber(self.g), tonumber(self.b), tonumber(self.src), tonumber(self.dst)
end

function ColorUtils:getColor()
    return color
end

return ColorUtils