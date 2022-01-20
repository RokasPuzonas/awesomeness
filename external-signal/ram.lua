local signal_name = "external::ram"

local easy_watch = require("helpers").easy_watch

local update_interval = 10
local units = "MiB"

-- Returns the used amount of ram in percentage
local ram_script = [[
sh -c "
	free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
"]]

-- Periodically get ram info
easy_watch(ram_script, update_interval, function(stdout)
    local available = stdout:match('(.*)@@')
    local total = stdout:match('@@(.*)@')
    local used = tonumber(total) - tonumber(available)
    awesome.emit_signal(signal_name, used, total, units)
end)

return signal_name

