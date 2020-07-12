-- Retrieves and Contains the config JSON file
require('external.script.common.common')

local json = getJSONparser()
local file = io.open("save/config.json","r")
local config = json.decode(file:read("*all"))
file:close()

function getConfig()
    return config
end

--save configuration
function saveConfig()
    --Data saving to config.json
    file = io.open("save/config.json","w+")
    file:write(json.encode(config, {indent = true}))
    file:close()
end