MainData = {
    t_commands = {
        ['$U'] = 0, ['$D'] = 0, ['$B'] = 0, ['$F'] = 0, ['a'] = 0, ['b'] = 0, ['c'] = 0, ['x'] = 0, ['y'] = 0, ['z'] = 0, ['s'] = 0, ['d'] = 0, ['w'] = 0, ['m'] = 0, ['/s'] = 0, ['/d'] = 0, ['/w'] = 0},
    t_players = {},
    t_cmd = {},
    t_pIn = {},
    debugLog = false,
    motifDef = nil,

}

-- Constructor
-- @param o initial table if nil wil be created
function MainData:new(o, configRef)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return MainData