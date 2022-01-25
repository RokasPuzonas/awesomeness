local spawn = require("awful.spawn")

local kitty = {}

-- TODO: This is not safe, code CAN BE INJECTED
-- Sanitize the input

function kitty.set_theme(theme_name, callback)
	assert(type(theme_name) == "string", "Expected theme_name to be string")

	local cmd = ("kitty +kitten themes --reload-in=all '%s'"):format(theme_name)
	spawn.easy_async(cmd, function(...)
		if callback then
			callback(...)
		end
	end)
end

return kitty
