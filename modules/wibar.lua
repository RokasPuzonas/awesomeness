local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local config = require("config")
local main_menu = require("widgets.main-menu")
local gears = require("gears")

local Ram = require("widgets.ram")
local Network = require("widgets.network")
local CpuTemperature = require("widgets.cpu-temperature")
local PlayerCTL = require("widgets.playerctl")
local TaskWarrior = require("widgets.taskwarrior")

local super = config.super
local shift = config.shift

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

local function create_taglist(s, size)
	local common = require("awful.widget.common")

	local function create_tag_button(buttons, tag)
		local img = awful.widget.button{
			image = beautiful.taglist_icon_unsel_empty,
		}

		local w, h = img._private.default.width, img._private.default.height
		local tag_btn = wibox.container.margin(img, 0, 0, (size-w)/2, (size-h)/2)
		tag_btn.img = img
		tag_btn.buttons = {common.create_buttons(buttons, tag)}
		tag_btn.img.resize = false
		tag_btn.img.valign = "center"
		tag_btn.img.scaling_quality = "nearest"

		return tag_btn
	end

	local function update_function(w, buttons, _, data, tags)
		local list_layout = w:get_children_by_id("list_layout")[1]

		for _, tag in ipairs(tags) do
			local tag_btn = data[tag]

			if not tag_btn then
				tag_btn = create_tag_button(buttons, tag)
				data[tag] = tag_btn
				list_layout:add(tag_btn)
			end

			local image = beautiful.taglist_icon_unsel_empty
			local clients = tag:clients()
			if tag.selected then
				if #clients > 0 then
					image = beautiful.taglist_icon_sel
				else
					image = beautiful.taglist_icon_sel_empty
				end
			else
				if #clients > 0 then
					image = beautiful.taglist_icon_unsel
				else
					image = beautiful.taglist_icon_unsel_empty
				end
			-- elseif tag:getproperty("urgent") then
				-- TODO: Check taglist.taglist_label for reference
			-- elseif t.volatile then
				-- TODO: Check taglist.taglist_label for reference
			end
			tag_btn.img:set_image(image)
		end
	end

	local button = awful.button
	return awful.widget.taglist{
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			{
				id = "list_layout",
				spacing = 6,
				layout = wibox.layout.fixed.horizontal
			},
			left = 10,
			right = 10,
			layout = wibox.container.margin
		},
		buttons = {
			button({}, 1, function(t)
				t:view_only()
			end),
			button({super}, 1, function(t)
				if client.focus then client.focus:move_to_tag(t) end
			end),
			button({}, 3, awful.tag.viewtoggle),
			button({shift}, 1, awful.tag.viewtoggle),
			button({super}, 3, function(t)
				if client.focus then client.focus:toggle_tag(t) end
			end),
			button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end)
		},
		update_function = update_function,
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
		},
		-- widget_template = {
		--         {
		-- 				id     = "icon_role",
		-- 				widget = wibox.widget.imagebox,
		--         },
		--         id     = "background_role",
		--         widget = wibox.container.background,
		--     },
		widget_template = {
        {
            {
                {
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget  = wibox.container.margin,
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 10,
            right = 10,
            widget = wibox.container.margin
        },
        id     = "background_role",
        widget = wibox.container.background,
    },
	}
end

local function connect()
	local size = 32

	local my_launcher = awful.widget.launcher{
		image = beautiful.logo_icon,
		menu = main_menu
	}
	my_launcher.scaling_quality = "nearest"

	-- Keyboard map indicator and switcher
	local my_keyboard_layout = awful.widget.keyboardlayout()

	-- Create a textclock widget
	local my_text_clock = wibox.widget.textclock("%Y-%m-%d %H:%M")

	local ram_widget = Ram()

	local network_widget = Network()

	local cpu_temperature = CpuTemperature()

	local playerctl_widget = PlayerCTL()

	local taskwarrior = TaskWarrior{
		open_command = config.taskwarrior_cmd
	}

	awful.screen.kbd_layout = my_keyboard_layout
	local tags = {}
	for i=1, config.tag_amount do
		table.insert(tags, tostring(i))
	end
	screen.connect_signal('request::desktop_decoration', function(s)
		-- Each screen has its own tag table.
		awful.tag(tags, s, awful.layout.layouts[1])

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()

		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = create_layoutbox(s)

		-- Create a taglist widget
		s.mytaglist = create_taglist(s, size)

		-- Create a tasklist widget
		s.mytasklist = create_tasklist(s)

		-- Create the wibox
		local shape = require("gears.shape")
		s.mywibox = awful.wibar{
			-- shape = function(cr, width, height)
			-- 	return shape.hexagon(cr, width, height)
			-- end,
			-- restrict_workarea = false,
			-- opacity = 0.5,
			-- ontop = true,
			position = 'top',
			margins = {top = 8, left = 16, right = 16, bottom=8},
			height = size,
			bg = "#00000000",
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
					spacing = 5,
					my_keyboard_layout,
					-- wibox.widget.systray(),
					playerctl_widget,
					-- taskwarrior,
					-- cpu_temperature,
					-- ram_widget,
					-- network_widget,
					my_text_clock,
					s.mylayoutbox
				}
			}
		}
	end)
end

return { connect = connect }
