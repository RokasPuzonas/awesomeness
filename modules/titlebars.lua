local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local function create_titlebar_widget(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button({ }, 1, function()
			c:activate { context = "titlebar", action = "mouse_move"  }
		end),
		awful.button({ }, 3, function()
			c:activate { context = "titlebar", action = "mouse_resize"}
		end),
	}

	return {
		{ -- Left
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton   (c),
			awful.titlebar.widget.ontopbutton    (c),
			awful.titlebar.widget.closebutton    (c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end

local function connect()
	client.connect_signal("request::titlebars", function(c)
		local titlebar = awful.titlebar(c, {
			size = beautiful.get_font_height() * 1.2
		})
		titlebar.widget = create_titlebar_widget(c)
		if not c.floating then
			awful.titlebar.hide(c)
		end
	end)

	client.connect_signal("property::floating", function(c)
		if c.floating then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end)
end

return { connect = connect }
