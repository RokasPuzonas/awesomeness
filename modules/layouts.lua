local awful = require("awful")

local config = require("config")

local function connect()
	tag.connect_signal("request::default_layouts", function()
		awful.layout.append_default_layouts(config.layouts)
	end)
end

return { connect = connect }

