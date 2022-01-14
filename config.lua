local config = {}

config.theme = "default"

config.terminal_cmd = "kitty"
config.editor = "nvim"
config.editor_cmd = "kitty -e nvim"
config.program_launcher_cmd = "rofi -show run"
config.web_browser_cmd = "brave"
config.file_manager_cmd = "pcmanfm"

config.sloppy_focus = true
config.no_titlebars = false

config.user_dirs = {
	downloads   = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
	documents   = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
	music       = os.getenv("XDG_MUSIC_DIR") or "~/Music",
	pictures    = os.getenv("XDG_PICTURES_DIR") or "~/Pictures",
	videos      = os.getenv("XDG_VIDEOS_DIR") or "~/Videos",
	-- Make sure the directory exists so that your screenshots
	-- are not lost
	screenshots = os.getenv("XDG_SCREENSHOTS_DIR") or "~/Pictures/Screenshots",
}

config.tags = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}

local awful = require("awful")
config.layouts = {
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

local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()
config.color_palette = {
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

config.bindings = {
	show_help                    = { "super+s"                 , "show help"                            , "awesome"},
	show_mainmenu                = { "super+w"                 , "show main menu"                       , "awesome"},
	quit_awesome                 = { "super+shift+q"           , "quit awesome"                         , "awesome"},
	reload_awesome               = { "super+shift+r"           , "reload awesome"                       , "awesome"},
	launch_terminal              = { "super+return"            , "launch terminal"                      , "system" },
	program_launcher             = { "super+x"                 , "program launcher"                     , "system" },
	show_menubar                 = { "super+p"                 , "show the menubar"                     , "system" },
	screenshot                   = { "super+shift+s"           , "take a screenshot"                    , "system" },
	save_screenshot              = { "super+control+s"         , "take a screenshot and save"           , "system" },
	kill_client                  = { "super+shift+c"           , "kill client"                          , "client" },
	maximize_client              = { "super+m"                 , "(un)maximize client"                  , "client" },
	fullscreen_client            = { "super+f"                 , "toggle fullscreen"                    , "client" },
	minimize_client              = { "super+n"                 , "minimize"                             , "client" },
	maximize_vertically_client   = { "super+control+m"         , "(un)maximize vertically"              , "client" },
	float_client                 = { "super+control+space"     , "toggle floating"                      , "client" },
	move_client_to_master        = { "super+control+return"    , "move to master"                       , "client" },
	move_client_to_screen        = { "super+o"                 , "move to screen"                       , "client" },
	keep_client_on_top           = { "super+t"                 , "keep client on top"                   , "client" },
	maximize_horizontally_client = { "super+shift+m"           , "(un)maximize horizontally"            , "client" },
	focus_next_client            = { "super+j"                 , "focus next by index"                  , "client" },
	focus_prev_client            = { "super+k"                 , "focus previous by index"              , "client" },
	swap_with_next_client        = { "super+shift+j"           , "swap with next client by index"       , "client" },
	swap_with_prev_client        = { "super+shift+k"           , "swap with previous client by index"   , "client" },
	restore_minimized            = { "super+control+n"         , "restore minimized"                    , "client" },
	jump_to_urgent_client        = { "super+u"                 , "jump to urgent client"                , "client" },
	go_back_client               = { "super+tab"               , "go back"                              , "client" },
	focus_the_next_screen        = { "super+control+j"         , "focus the next screen"                , "screen" },
	focus_the_previous_screen    = { "super+control+k"         , "focus the previous screen"            , "screen" },
	increase_master_width        = { "super+l"                 , "increase master width factor"         , "layout" },
	decrease_master_width        = { "super+h"                 , "decrease master width factor"         , "layout" },
	increase_master_client_count = { "super+shift+h"           , "increase the number of master clients", "layout" },
	decrease_master_client_count = { "super+shift+l"           , "decrease the number of master clients", "layout" },
	increase_column_count        = { "super+control+h"         , "increase the number of columns"       , "layout" },
	decrease_column_count        = { "super+control+l"         , "decrease the number of columns"       , "layout" },
	select_next_layout           = { "super+space"             , "select next"                          , "layout" },
	select_prev_layout           = { "super+shift+space"       , "select previous"                      , "layout" },
	next_tag                     = { "super+right"             , "next tag"                             , "tag"    },
	prev_tag                     = { "super+left"              , "previous tag"                         , "tag"    },
	go_back_tag                  = { "super+escape"            , "go back a tag"                        , "tag"    },
	view_tag                     = { "super+%{i}"              , "view tag #%{name}"                     , "tag"    },
	toggle_tag                   = { "super+control+%{i}"      , "toggle tag #%{name}"                   , "tag"    },
	move_client_to_tag           = { "super+shift+%{i}"        , "move client to tag #%{name}"           , "tag"    },
	toggle_client_on_tag         = { "super+control+shift+%{i}", "toggle client on tag #%{name}"         , "tag"    },
}

config.rules = {
	-- Floating clients.
	{
		rule_any = {
			instance = {
				'DTA', -- Firefox addon DownThemAll.
				'copyq', -- Includes session name in class.
				'pinentry'
			},
			class = {
				'Arandr',
				'Blueman-manager',
				'Gpick',
				'Kruler',
				'MessageWin', -- kalarm.
				'Sxiv',
				'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
				'Wpa_gui',
				'veromix',
				'xtightvncviewer'
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				'Event Tester' -- xev.
			},
			role = {
				'AlarmWindow', -- Thunderbird's calendar.
				'ConfigManager', -- Thunderbird's about:config.
				'pop-up' -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = {floating = true}
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {type = {'normal', 'dialog'}},
		properties = {titlebars_enabled = true}
	}

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}

return config

