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
				horizontal_fit_policy = beautiful.wallpaper_stretch and "fit",
				vertical_fit_policy   = beautiful.wallpaper_stretch and "fit",
				widget = wibox.widget.imagebox
			}
		}
	end)
end

return { connect = connect }
