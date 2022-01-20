local timer = require("gears.timer")
local spawn = require("awful.spawn")
local gears = require("gears")

local lgi = require("lgi")
local cairo = lgi.cairo

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

function helpers.easy_timer(timeout, callback)
	return timer{
		timeout = timeout,
		callback = callback,
		autostart = true,
		call_now = true
	}
end

return helpers

