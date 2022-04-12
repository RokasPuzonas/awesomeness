local signal_name = "external::cpu-temperature"

local easy_watch = require("helpers").easy_watch

local update_interval = 5

local device = "nouveau-pci-1100"

local script = 'sh -c "sensors ' .. device .. '"'

easy_watch(script, update_interval, function(stdout)
	local temp = stdout:match("(%d+%.%d)")
	awesome.emit_signal(signal_name, tonumber(temp))
end)

return signal_name
