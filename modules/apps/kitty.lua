local spawn = require("awful.spawn")

local kitty = {}

function kitty.set_theme(theme_name, callback)
	local cmd = ("kitty +kitten themes --reload-in=all '%s'"):format(theme_name)
	spawn.easy_async(cmd, function(...)
		if callback then
			callback(...)
		end
	end)
end

return kitty
