MainData = {}

-- Constructor
-- @param o initial table if nil wil be created
function MainData:new(o, configRef, mainRef)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return MainData