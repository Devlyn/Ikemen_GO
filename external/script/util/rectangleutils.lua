RectangleUtils = {}

local rect = {}

--create a rect
function rect:create(...)
    local args = ...
    args.x1 = args.x or args.x1
    args.y1 = args.y or args.y1
    if args.dim or args.dimensions then
        --create dimensions if arguments have a dim or dimensions argument instead of x1, y1, x2, y2
        local dim = args.dim or args.dimensions
        args.x1 = dim.x1 or dim[1] or args.x1
        args.y1 = dim.y1 or dim[2] or args.y1
        args.x2 = dim.x2 or dim[3] or args.x2
        args.y2 = dim.y2 or dim[4] or args.y2
    elseif args.scale or args.size then
        --create x2,y2 if arguments have a scale or size argument
        local sc = args.scale or args.size
        args.x2 = sc.x or sc[1]
        args.y2 = sc.y or sc[2]
    end
    args.color = args.color or self.color:new(args.r, args.g, args.b, args.src, args.dst)
    args.r, args.g, args.b, args.src, args.dst = args.color:unpack()
    setmetatable(args, self)
    self.__index = self
    return args
end

--modify the rect
function rect:update(...)
    local args = ...
    local env = setfenv(1, args)
    self.x1 = x or x1 or self.x1
    self.y1 = y or y1 or self.y1
    for i, k in pairs(args) do
        self[i] = k
    end
    if dim or dimensions then
        --create dimensions if arguments have a dim or dimensions argument instead of x1, y1, x2, y2
        local dim = args.dim or args.dimensions
        self.x1 = dim.x1 or dim[1] or x1 or self.x1
        self.y1 = dim.y1 or dim[2] or y1 or self.y1
        self.x2 = dim.x2 or dim[3] or x2 or self.x2
        self.y2 = dim.y2 or dim[4] or y2 or self.y2
    elseif scale or size then
        --create x2,y2 if arguments have a scale or size argument
        local sc = args.scale or args.size
        self.x2 = sc.x or sc[1] or self.x2
        self.y2 = sc.y or sc[2] or self.y2
    end
    if r or g or b or src or dst then
        self.color = color:new(r or self.r, g or self.g, b or self.b, src or self.src, dst or self.dst)
    end
    return self
end

--draw the rect using fillRect
function rect:draw()
    local r, g, b, s, d = self.color:unpack()
    fillRect(self.x1, self.y1, self.x2, self.y2, r, g, b, s, d, self.defsc or false, self.fixcoord or false)
end

function RectangleUtils:getRectangle(color)
    rect.color = color
    return rect
end

return RectangleUtils