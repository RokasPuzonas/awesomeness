local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local config = require("config")
local main_menu = require("widgets.main-menu")
local Ram = require("widgets.ram")

local super = config.super

local function create_layoutbox(s)
	return awful.widget.layoutbox{
		screen = s,
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(1)
			end)
		}
	}
end

local function create_taglist(s)
	return awful.widget.taglist{
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({super}, 1, function(t)
				if client.focus then client.focus:move_to_tag(t) end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({super}, 3, function(t)
				if client.focus then client.focus:toggle_tag(t) end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end)
		}
	}
end

local function create_tasklist(s)
	return awful.widget.tasklist{
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate{context = 'tasklist', action = 'toggle_minimization'}
			end),
			awful.button({}, 3, function()
				awful.menu.client_list{theme = {width = 250}}
			end),
			awful.button({}, 4, function()
				awful.client.focus.byidx(-1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(1)
			end)
		}
	}
end

local function connect()
	local my_launcher = awful.widget.launcher{
		image = beautiful.awesome_icon,
		menu = main_menu
	}

	-- Keyboard map indicator and switcher
	local my_keyboard_layout = awful.widget.keyboardlayout()

	-- Create a textclock widget
	local my_text_clock = wibox.widget.textclock()

	local ram_widget = Ram()

	screen.connect_signal('request::desktop_decoration', function(s)
		-- Each screen has its own tag table.
		awful.tag(config.tags, s, awful.layout.layouts[1])

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()

		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = create_layoutbox(s)

		-- Create a taglist widget
		s.mytaglist = create_taglist(s)

		-- Create a tasklist widget
		s.mytasklist = create_tasklist(s)

		-- Create the wibox
		s.mywibox = awful.wibar{
			position = 'top',
			screen = s,
			widget = {
				layout = wibox.layout.align.horizontal,
				{ -- Left widgets
					layout = wibox.layout.fixed.horizontal,
					my_launcher,
					s.mytaglist,
					s.mypromptbox
				},
				s.mytasklist, -- Middle widget
				{ -- Right widgets
					layout = wibox.layout.fixed.horizontal,
					my_keyboard_layout,
					wibox.widget.systray(),
					ram_widget,
					my_text_clock,
					s.mylayoutbox
				}
			}
		}
	end)
end

return { connect = connect }
