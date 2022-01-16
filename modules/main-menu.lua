local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local config = require("config")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys").tmux.add_rules_for_terminal{ rule = { name = "tmux" } }

local awesome_menu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", config.terminal .. " -e man awesome" },
   { "edit config", config.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local main_menu = awful.menu{
	items = {
		{ "awesome", awesome_menu, beautiful.awesome_icon },
		{ "open terminal", config.terminal }
	}
}

return main_menu
