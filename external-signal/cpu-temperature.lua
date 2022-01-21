local signal_name = "external::cpu-temperature"

local easy_watch = require("helpers").easy_watch

local update_interval = 5

local script = [[sh -c "sensors | grep 'Package'"]]

easy_watch(script, update_interval, function(stdout)
	local temp, high_temp, crit_temp = stdout:match("(%d+%.%d)[^%d]+(%d+%.%d)[^%d]+(%d+%.%d)")
	awesome.emit_signal(signal_name,
		tonumber(temp),
		tonumber(high_temp),
		tonumber(crit_temp)
	)
end)

return signal_name
