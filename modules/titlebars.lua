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

local helper = {}

local shape = require("gears.shape")
helper.rrect = function(radius)
  return function(cr, width, height)
    shape.octogon(cr, width, height, radius)
  end
end

local function connect()
	client.connect_signal("request::titlebars", function(c)
		local titlebar = awful.titlebar(c, {
			size = beautiful.get_font_height() * 1.2
		})
		titlebar.widget = create_titlebar_widget(c)
		-- if not c.floating then
		-- 	awful.titlebar.hide(c)
		-- end
	end)

	client.connect_signal("property::floating", function(c)
		-- print("float")
		-- if c.floating then
		-- 	awful.titlebar.show(c)
		-- else
		-- 	awful.titlebar.hide(c)
		-- end
	end)

	screen.connect_signal("arrange", function()
		-- print("arrange")
		-- print("maximize")
		-- -- c.screen:emit_signal("arrange")
		-- print(screen)
		-- screen.emit_signal("arrange")
	end)

	client.connect_signal("property::maximized", function(c)
		-- print("maximize")
		-- c.screen:emit_signal("arrange")
	end)

	-- Apply rounded corners to clients if needed
	--[[
	if beautiful.border_radius and beautiful.border_radius > 0 then
		client.connect_signal("manage", function (c, startup)
			if not c.fullscreen and not c.maximized then
				c.shape = helper.rrect(beautiful.border_radius)
			end
		end)

		-- Fullscreen and maximized clients should not have rounded corners
		local function no_round_corners (c)
			if c.fullscreen or c.maximized then
				c.shape = shape.rectangle
			else
				c.shape = helper.rrect(beautiful.border_radius)
			end
		end

		client.connect_signal("property::fullscreen", no_round_corners)
		client.connect_signal("property::maximized", no_round_corners)

		beautiful.snap_shape = helper.rrect(beautiful.border_radius * 2)
	else
		beautiful.snap_shape = shape.rectangle
	end
	]]--
end

return { connect = connect }
