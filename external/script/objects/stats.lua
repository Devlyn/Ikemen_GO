-- Retrieves and contains the stats JSON file
require('external.script.common.common')

local json = getJSONparser()
local file = io.open("save/stats.json","r")
local stats = json.decode(file:read("*all"))
file:close()

function getStats()
    return stats
end

--data saving to stats.json
function saveStats()
    file = io.open("save/stats.json","w+")
    file:write(json.encode(stats, {indent = true}))
    file:close()
end