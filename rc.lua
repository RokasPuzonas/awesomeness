local beautiful = require("beautiful")
local awful = require("awful")

local preferences = {
	terminal_cmd = "kitty",
	editor = "nvim",
	editor_cmd = "kitty -e nvim",
	program_launcher_cmd = "rofi -show run",
	web_browser_cmd = "brave",
	file_manager_cmd = "pcmanfm",

	dirs = {
		downloads = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
		documents = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
		music = os.getenv("XDG_MUSIC_DIR") or "~/Music",
		pictures = os.getenv("XDG_PICTURES_DIR") or "~/Pictures",
		videos = os.getenv("XDG_VIDEOS_DIR") or "~/Videos",
		-- Make sure the directory exists so that your screenshots
		-- are not lost
		screenshots = os.getenv("XDG_SCREENSHOTS_DIR") or "~/Pictures/Screenshots",
	},

	tags = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},

	layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
	}
}

local xrdb = beautiful.xresources.get_current_theme()
local color_palette = {
	background = xrdb.background,
	foreground = xrdb.foreground,
	color0     = xrdb.color0,
	color1     = xrdb.color1,
	color2     = xrdb.color2,
	color3     = xrdb.color3,
	color4     = xrdb.color4,
	color5     = xrdb.color5,
	color6     = xrdb.color6,
	color7     = xrdb.color7,
	color8     = xrdb.color8,
	color9     = xrdb.color9,
	color10    = xrdb.color10,
	color11    = xrdb.color11,
	color12    = xrdb.color12,
	color13    = xrdb.color13,
	color14    = xrdb.color14,
	color15    = xrdb.color15,
}

local bindings = {
	show_help                    = { "super+s"               , "show help"                            , "awesome"},
	show_mainmenu                = { "super+w"               , "show main menu"                       , "awesome"},
	quit_awesome                 = { "super+shift+q"         , "quit awesome"                         , "awesome"},
	reload_awesome               = { "super+shift+r"         , "reload awesome"                       , "awesome"},

	launch_terminal              = { "super+return"          , "launch terminal"                      , "system" },
	program_launcher             = { "super+x"               , "program launcher"                     , "system" },
	show_menubar                 = { "super+p"               , "show the menubar"                     , "system" },

	kill_client                  = { "super+shift+c"         , "kill client"                          , "client" },
	maximize_client              = { "super+m"               , "(un)maximize client"                  , "client" },
	fullscreen_client            = { "super+f"               , "toggle fullscreen"                    , "client" },
	minimize_client              = { "super+n"               , "minimize"                             , "client" },
	maximize_vertically_client   = { "super+control+m"       , "(un)maximize vertically"              , "client" },
	float_client                 = { "super+control+space"   , "toggle floating"                      , "client" },
	move_client_to_master        = { "super+control+return"  , "move to master"                       , "client" },
	move_client_to_screen        = { "super+o"               , "move to screen"                       , "client" },
	keep_client_on_top           = { "super+t"               , "keep client on top"                   , "client" },
	maximize_horizontally_client = { "super+shift+m"         , "(un)maximize horizontally"            , "client" },
	focus_next_client            = { "super+j"               , "focus next by index"                  , "client" },
	focus_prev_client            = { "super+k"               , "focus previous by index"              , "client" },
	swap_with_next_client        = { "super+shift+j"         , "swap with next client by index"       , "client" },
	swap_with_prev_client        = { "super+shift+k"         , "swap with previous client by index"   , "client" },
	restore_minimized            = { "super+control+n"       , "restore minimized"                    , "client" },
	jump_to_urgent_client        = { "super+u"               , "jump to urgent client"                , "client" },
	go_back_client               = { "super+tab"             , "go back"                              , "client" },

	focus_the_next_screen        = { "super+control+j"       , "focus the next screen"                , "screen" },
	focus_the_previous_screen    = { "super+control+k"       , "focus the previous screen"            , "screen" },

	increase_master_width        = { "super+l"               , "increase master width factor"         , "layout" },
	decrease_master_width        = { "super+h"               , "decrease master width factor"         , "layout" },
	increase_master_client_count = { "super+shift+h"         , "increase the number of master clients", "layout" },
	decrease_master_client_count = { "super+shift+l"         , "decrease the number of master clients", "layout" },
	increase_column_count        = { "super+control+h"       , "increase the number of columns"       , "layout" },
	decrease_column_count        = { "super+control+l"       , "decrease the number of columns"       , "layout" },
	select_next_layout           = { "super+space"           , "select next"                          , "layout" },
	select_prev_layout           = { "super+shift+space"     , "select previous"                      , "layout" },

	next_tag                     = { "super+right"           , "next tag"                             , "tag"    },
	prev_tag                     = { "super+left"            , "previous tag"                         , "tag"    },
	go_back_tag                  = { "super+escape"          , "go back a tag"                        , "tag"    },
	view_tag                     = { "super+#?"              , "view tag #?"                          , "tag"    },
	toggle_tag                   = { "super+control+#?"      , "toggle tag #?"                        , "tag"    },
	move_client_to_tag           = { "super+shift+#?"        , "move client to tag #?"                , "tag"    },
	toggle_client_on_tag         = { "super+control+shift+#?", "toggle client on tag #?"              , "tag"    },
}


-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

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
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local superkey = "Mod4"
local altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = preferences.layouts
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "edit config", preferences.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", preferences.terminal_cmd }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = preferences.terminal_cmd -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

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
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

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

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(preferences.tags, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
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
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
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
local globalkeys = {}
local function parse_binding(binding, func)
	local mod = {}
	local key = nil
	for k in binding[1]:gmatch("[^%s%+]+") do
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
	return awful.key(mod, key, func, {description = binding[2], group = binding[3]})
end

do
	local available_bindings = {}
	local function try_appending_bindings(bindings_with_funcs)
		for binding, func in pairs(bindings_with_funcs) do
			table.insert(available_bindings, parse_binding(binding, func))
		end
	end

	try_appending_bindings{
		[bindings.show_help                    ] = hotkeys_popup.show_help,
		[bindings.show_mainmenu                ] = function() mymainmenu:show() end,
		[bindings.quit_awesome                 ] = awesome.quit,
		[bindings.reload_awesome               ] = awesome.restart,
		[bindings.launch_terminal              ] = function() awful.spawn(preferences.terminal_cmd) end,
		[bindings.program_launcher             ] = function() awful.spawn(preferences.program_launcher_cmd) end,
		[bindings.show_menubar                 ] = function() menubar.show() end,
		[bindings.focus_next_client            ] = function () awful.client.focus.byidx( 1) end,
		[bindings.focus_prev_client            ] = function () awful.client.focus.byidx(-1) end,
		[bindings.swap_with_next_client        ] = function () awful.client.swap.byidx(  1) end,
		[bindings.swap_with_prev_client        ] = function () awful.client.swap.byidx( -1) end,
		[bindings.focus_the_next_screen        ] = function () awful.screen.focus_relative( 1) end,
		[bindings.focus_the_previous_screen    ] = function () awful.screen.focus_relative(-1) end,
		[bindings.jump_to_urgent_client        ] = awful.client.urgent.jumpto,
		[bindings.go_back_client               ] = function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end,
		[bindings.increase_master_width        ] = function () awful.tag.incmwfact( 0.05) end,
		[bindings.decrease_master_width        ] = function () awful.tag.incmwfact(-0.05) end,
		[bindings.increase_master_client_count ] = function () awful.tag.incnmaster( 1, nil, true) end,
		[bindings.decrease_master_client_count ] = function () awful.tag.incnmaster(-1, nil, true) end,
		[bindings.increase_column_count        ] = function () awful.tag.incncol( 1, nil, true) end,
		[bindings.decrease_column_count        ] = function () awful.tag.incncol(-1, nil, true) end,
		[bindings.select_next_layout           ] = function () awful.layout.inc( 1) end,
		[bindings.select_prev_layout           ] = function () awful.layout.inc(-1) end,
		[bindings.next_tag                     ] = awful.tag.viewnext,
		[bindings.prev_tag                     ] = awful.tag.viewprev,
		[bindings.go_back_tag                  ] = awful.tag.history.restore,
    [bindings.restore_minimized            ] = function ()
				local c = awful.client.restore()
				-- Focus restored client
				if c then
					c:emit_signal("request::activate", "key.unminimize", {raise = true})
				end
		end,
	}

	globalkeys = gears.table.join(table.unpack(available_bindings))
end

local clientkeys
do
	local available_bindings = {}
	local function try_appending_bindings(bindings_with_funcs)
		for binding, func in pairs(bindings_with_funcs) do
			table.insert(available_bindings, parse_binding(binding, func))
		end
	end

	try_appending_bindings{
		[bindings.kill_client                  ] = function(c) c:kill() end,
		[bindings.maximize_client              ] = function(c) c.maximized = not c.maximized end,
		[bindings.fullscreen_client            ] = function(c) c.fullscreen = not c.fullscreen end,
		[bindings.minimize_client              ] = function(c) c.minimized = true end,
		[bindings.maximize_vertically_client   ] = function(c) c.maximized_vertical = not c.maximized_vertical; c:raise() end,
		[bindings.float_client                 ] = awful.client.floating.toggle,
		[bindings.move_client_to_master        ] = function(c) c:swap(awful.client.getmaster()) end,
		[bindings.move_client_to_screen        ] = function(c) c.move_to_screeno() end,
		[bindings.keep_client_on_top           ] = function (c) c.ontop = not c.ontop end,
		[bindings.maximize_horizontally_client ] = function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end,
	}

	clientkeys = gears.table.join(table.unpack(available_bindings))

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it work on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 9 do
			globalkeys = gears.table.join(globalkeys, -- View tag only.
			awful.key({superkey}, '#' .. i + 9, function()
					local screen = awful.screen.focused()
					local tag = screen.tags[i]
					if tag then tag:view_only() end
			end, {description = 'view tag #' .. i, group = 'tag'}),
			 -- Toggle tag display.
										awful.key({superkey, 'Control'}, '#' .. i + 9, function()
					 local screen = awful.screen.focused()
					 local tag = screen.tags[i]
					 if tag then awful.tag.viewtoggle(tag) end
			 end, {description = 'toggle tag #' .. i, group = 'tag'}),
			 -- Move client to tag.
										awful.key({superkey, 'Shift'}, '#' .. i + 9, function()
					 if client.focus then
							 local tag = client.focus.screen.tags[i]
							 if tag then client.focus:move_to_tag(tag) end
					 end
			 end, {description = 'move focused client to tag #' .. i, group = 'tag'}),
			 -- Toggle tag on focused client.
										awful.key({superkey, 'Control', 'Shift'}, '#' .. i + 9,
										 function()
						if client.focus then
								local tag = client.focus.screen.tags[i]
								if tag then client.focus:toggle_tag(tag) end
						end
				end, {description = 'toggle focused client on tag #' .. i, group = 'tag'}))
	end
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
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
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
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
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
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

