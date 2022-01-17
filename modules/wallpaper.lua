local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local function connect()
	screen.connect_signal('request::wallpaper', function(s)
		awful.wallpaper{
			screen = s,
			bg = beautiful.wallpaper_bg,
			widget = {
				image = beautiful.wallpaper,
				upscale = false,
				downscale = true,
				resize = true,
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox
			}
		}
	end)
end

return { connect = connect }

