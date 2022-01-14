-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- If luarocks is not installed, or a certain package is not installed.
-- Use fallback from libs directory
local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
package.path = ("%s;%s/libs/?.lua"):format(package.path, config_dir)
package.path = ("%s;%s/libs/?/init.lua"):format(package.path, config_dir)

-- Standard awesome library
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
-- Notification library
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local config = require("config")

-- {{{ Error handling
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
					preset = naughty.config.presets.critical,
					title = "Oops, an error happened!",
					text = tostring(err)
				})
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- Themes define colours, icons, font and wallpapers.
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. config.theme .. "/"
beautiful.init(theme_dir .. "theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local superkey = "Mod4"
local altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = config.layouts
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local	myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "edit config", config.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({
    items = {
        {'awesome', myawesomemenu, beautiful.awesome_icon},
        {'open terminal', config.terminal_cmd}
    }
})

local mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- }}}

-- {{{ Wibar
-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
		awful.button({ }, 1, function(t) t:view_only() end),
		awful.button({ superkey }, 1, function(t)
															if client.focus then
																	client.focus:move_to_tag(t)
															end
													end),
		awful.button({ }, 3, awful.tag.viewtoggle),
		awful.button({ superkey }, 3, function(t)
															if client.focus then
																	client.focus:toggle_tag(t)
															end
													end),
		awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
		awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	 awful.button({ }, 1, function (c)
														if c == client.focus then
																c.minimized = true
														else
																c:emit_signal(
																		"request::activate",
																		"tasklist",
																		{raise = true}
																)
														end
												end),
	 awful.button({ }, 3, function()
														awful.menu.client_list({ theme = { width = 250 } })
												end),
	 awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
	 awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	awful.tag(config.tags, s, awful.layout.layouts[1])
end)

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
			 awful.button({ }, 1, function () awful.layout.inc( 1) end),
			 awful.button({ }, 3, function () awful.layout.inc(-1) end),
			 awful.button({ }, 4, function () awful.layout.inc( 1) end),
			 awful.button({ }, 5, function () awful.layout.inc(-1) end))
		 )
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

		-- Net
		local lain  = require("lain")
		local markup = lain.util.markup
		local neticon = wibox.widget.imagebox(config_dir.."assets/icons/net.png")
		local net = lain.widget.net({
			settings = function(self, net_now)
				local received = string.format("%06.1f", net_now.received)
				local sent = string.format("%06.1f", net_now.sent)
				self.markup = markup.font(beautiful.font,
					markup("#7AC82E", " ⤓ " .. received) .. " " ..
					markup("#46A8C3", " ⤒ " .. sent .. " ")
				)
			end
		})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
						spacing = 3,
            mykeyboardlayout,
            wibox.widget.systray(),
						{
							layout = wibox.layout.fixed.horizontal,
							neticon,
							net,
						},
            mytextclock,
            s.mylayoutbox,
        }
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
-- Replaces patterns like "%{foobar}" from strings with the same name using values
-- from data table
local function replace_groups(str, data)
	return str:gsub("%%%b{}", function(group)
		local key = group:sub(3, -2)
		local value = data[key]
		if value == nil then return "" end
		return tostring(value)
	end)
end

local function replace_binding_groups(binding, binding_data)
	local new_binding = {}
	for k, v in pairs(binding) do
		if type(v) == "string" then
			new_binding[k] = replace_groups(v, binding_data)
		else
			new_binding[k] = v
		end
	end
	return new_binding
end

local function parse_binding_key(key_string)
	local key
	local mod = {}
	for k in key_string:gmatch("[^%s%+]+") do
		k = k:lower()
		if k == "super" then
			table.insert(mod, superkey)
		elseif k == "shift" then
			table.insert(mod, "Shift")
		elseif k == "alt" then
			table.insert(mod, altkey)
		elseif k == "control" or k == "ctrl" then
			table.insert(mod, "Control")
		elseif #k == 1 or k == "space" then
			key = k
		else
			key = k:gsub("^%l", string.upper)
		end
	end

	return key, mod
end

local globalkeys = {}
local function create_key_from_binding(binding, func)
	local key, mod = parse_binding_key(binding[1])
	return awful.key(mod, key, func, {description = binding[2], group = binding[3]})
end

local function create_keys_from_bindings(bindings_with_funcs)
	local all_keys = {}
	for binding, func in pairs(bindings_with_funcs) do
		table.insert(all_keys, create_key_from_binding(binding, func))
	end
	return gears.table.join(table.unpack(all_keys))
end

do
	local b = config.bindings
	globalkeys = create_keys_from_bindings{
		[b.show_help                   ]= hotkeys_popup.show_help,
		[b.show_mainmenu               ]= function() mymainmenu:show() end,
		[b.quit_awesome                ]= awesome.quit,
		[b.screenshot                  ]= function() awful.spawn.with_shell("maim -suq | xclip -selection clipboard -t image/png") end,
		[b.save_screenshot             ]= function()
			local date = os.date("%Y-%m-%d_%H:%M:%S")
			local path = ("%s/%s.png"):format(config.user_dirs.screenshots, date:sub(1, -2))
			awful.spawn.with_shell(("maim -suq %s && echo %s | xclip -selection clipboard"):format(path, path))
		end,
		[b.reload_awesome              ]= awesome.restart,
		[b.launch_terminal             ]= function() awful.spawn(config.terminal_cmd) end,
		[b.program_launcher            ]= function() awful.spawn(config.program_launcher_cmd) end,
		[b.focus_next_client           ]= function () awful.client.focus.byidx( 1) end,
		[b.focus_prev_client           ]= function () awful.client.focus.byidx(-1) end,
		[b.swap_with_next_client       ]= function () awful.client.swap.byidx(  1) end,
		[b.swap_with_prev_client       ]= function () awful.client.swap.byidx( -1) end,
		[b.focus_the_next_screen       ]= function () awful.screen.focus_relative( 1) end,
		[b.focus_the_previous_screen   ]= function () awful.screen.focus_relative(-1) end,
		[b.jump_to_urgent_client       ]= awful.client.urgent.jumpto,
		[b.go_back_client              ]= function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end,
		[b.increase_master_width       ]= function () awful.tag.incmwfact( 0.05) end,
		[b.decrease_master_width       ]= function () awful.tag.incmwfact(-0.05) end,
		[b.increase_master_client_count]= function () awful.tag.incnmaster( 1, nil, true) end,
		[b.decrease_master_client_count]= function () awful.tag.incnmaster(-1, nil, true) end,
		[b.increase_column_count       ]= function () awful.tag.incncol( 1, nil, true) end,
		[b.decrease_column_count       ]= function () awful.tag.incncol(-1, nil, true) end,
		[b.select_next_layout          ]= function () awful.layout.inc( 1) end,
		[b.select_prev_layout          ]= function () awful.layout.inc(-1) end,
		[b.next_tag                    ]= awful.tag.viewnext,
		[b.prev_tag                    ]= awful.tag.viewprev,
		[b.go_back_tag                 ]= awful.tag.history.restore,
    [b.restore_minimized           ]= function ()
				local c = awful.client.restore()
				-- Focus restored client
				if c then
					c:emit_signal("request::activate", "key.unminimize", {raise = true})
				end
		end,
	}

	for i, tagname in ipairs(config.tags) do
		local tag_data = { i = i, name = tagname }
		local view_tag             = replace_binding_groups(b.view_tag, tag_data)
		local toggle_tag           = replace_binding_groups(b.toggle_tag, tag_data)
		local move_client_to_tag   = replace_binding_groups(b.move_client_to_tag, tag_data)
		local toggle_client_on_tag = replace_binding_groups(b.toggle_client_on_tag, tag_data)

		local tagkeys = create_keys_from_bindings{
			[view_tag] = function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then tag:view_only() end
			end,
			[toggle_tag] = function()
				 local screen = awful.screen.focused()
				 local tag = screen.tags[i]
				 if tag then awful.tag.viewtoggle(tag) end
			 end,
			[move_client_to_tag] = function()
				 if client.focus then
					 local tag = client.focus.screen.tags[i]
					 if tag then client.focus:move_to_tag(tag) end
				 end
			 end,
			[toggle_client_on_tag] = function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then client.focus:toggle_tag(tag) end
				end
			end
		}

		globalkeys = gears.table.join(globalkeys, tagkeys)
	end
end

local clientkeys
do
	local b = config.bindings
	clientkeys = create_keys_from_bindings{
		[b.kill_client                 ]= function(c) c:kill() end,
		[b.maximize_client             ]= function(c) c.maximized = not c.maximized end,
		[b.fullscreen_client           ]= function(c) c.fullscreen = not c.fullscreen end,
		[b.minimize_client             ]= function(c) c.minimized = true end,
		[b.maximize_vertically_client  ]= function(c) c.maximized_vertical = not c.maximized_vertical; c:raise() end,
		[b.float_client                ]= awful.client.floating.toggle,
		[b.move_client_to_master       ]= function(c) c:swap(awful.client.getmaster()) end,
		[b.move_client_to_screen       ]= function(c) c.move_to_screeno() end,
		[b.keep_client_on_top          ]= function (c) c.ontop = not c.ontop end,
		[b.maximize_horizontally_client]= function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end,
	}
end

local clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
	awful.button({ superkey }, 1, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),
	awful.button({ superkey }, 3, function (c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen
		}
	},
	table.unpack(config.rules)
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
if not config.no_titlebars then
	client.connect_signal('request::titlebars', function(c)
			-- buttons for the titlebar
			local buttons = gears.table.join(awful.button({}, 1, function()
					c:emit_signal('request::activate', 'titlebar', {raise = true})
					awful.mouse.client.move(c)
			end), awful.button({}, 3, function()
					c:emit_signal('request::activate', 'titlebar', {raise = true})
					awful.mouse.client.resize(c)
			end))

			awful.titlebar(c):setup{
					{ -- Left
							awful.titlebar.widget.iconwidget(c),
							buttons = buttons,
							layout = wibox.layout.fixed.horizontal
					},
					{ -- Middle
							{ -- Title
									align = 'center',
									widget = awful.titlebar.widget.titlewidget(c)
							},
							buttons = buttons,
							layout = wibox.layout.flex.horizontal
					},
					{ -- Right
							awful.titlebar.widget.floatingbutton(c),
							awful.titlebar.widget.maximizedbutton(c),
							awful.titlebar.widget.stickybutton(c),
							awful.titlebar.widget.ontopbutton(c),
							awful.titlebar.widget.closebutton(c),
							layout = wibox.layout.fixed.horizontal()
					},
					layout = wibox.layout.align.horizontal
			}
	end)

	client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
	client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

-- Enable sloppy focus, so that focus follows mouse.
if config.sloppy_focus then
	client.connect_signal("mouse::enter", function(c)
		c:emit_signal("request::activate", "mouse_enter", {raise = false})
	end)
end

-- }}}

