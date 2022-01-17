local timer = require("gears.timer")
local spawn = require("awful.spawn")

local helpers = {}

function helpers.easy_watch(command, timeout, callback)
	local t = timer{ timeout = timeout }
	t:connect_signal("timeout", function()
			t:stop()
			spawn.easy_async(command, function(stdout, stderr, exitreason, exitcode)
				callback(stdout, stderr, exitreason, exitcode)
				t:again()
			end)
	end)
	t:start()
	t:emit_signal("timeout")
	return t
end

return helpers

