local awful = require("awful")
local wibox = require("wibox")

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
		awful.titlebar(c).widget = create_titlebar_widget(c)
	end)
end

return { connect = connect }

