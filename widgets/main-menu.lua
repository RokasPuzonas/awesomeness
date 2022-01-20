local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local config = require("config")

local config_dir = require("gears.filesystem").get_configuration_dir()

local awesome_menu = {
	 { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	 { "manual", config.web_browser .. " /usr/share/doc/awesome/doc/index.html" },
	 { "edit config", config.edit_file_cmd(awesome.conffile, config_dir) },
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

