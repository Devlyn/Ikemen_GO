-- Retrieves and contains the stats JSON file
local common = require('external.script.common.common')
StatsService = {
    json = common:getJSONparser(),
    stats = nil
}

function StatsService:getStats()
    if self.stats == nil then
        local file = io.open("save/stats.json","r")
        self.stats = self.json.decode(file:read("*all"))
        file:close()
    end
    return self.stats
end

--data saving to stats.json
function StatsService:saveStats()
    file = io.open("save/stats.json","w+")
    file:write(self.json.encode(self.getStats(), {indent = true}))
    file:close()
end

-- Constructor
-- @param o initial table if nil wil be created
function StatsService:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

return StatsService