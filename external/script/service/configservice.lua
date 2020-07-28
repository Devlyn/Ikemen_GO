-- Retrieves and Contains the config JSON file
local common = require('external.script.common.common')
ConfigService = {
    json = common:getJSONparser(),
    config = nil
}

function ConfigService:getConfig()
    if self.config == nil then
        local file = io.open("save/config.json","r")
        self.config = self.json.decode(file:read("*all"))
        file:close()
    end
    return self.config
end

--save configuration
function ConfigService:saveConfig()
    --Data saving to config.json
    file = io.open("save/config.json","w+")
    file:write(self.json.encode(self.getConfig(), {indent = true}))
    file:close()
end

-- Constructor
-- @param o initial table if nil wil be created
function ConfigService:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

return ConfigService