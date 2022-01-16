--   __ ___      _____  ___  ___  _ __ ___   ___
--  / _` \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \
-- | (_| |\ V  V /  __/\__ \ (_) | | | | | |  __/
--  \__,_| \_/\_/ \___||___/\___/|_| |_| |_|\___|

pcall(require, "luarocks.loader")

-- If luarocks is not installed, or a certain package is not installed.
-- Use fallback from libs directory
local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
package.path = ("%s;%s/libs/?.lua"):format(package.path, config_dir)
package.path = ("%s;%s/libs/?/init.lua"):format(package.path, config_dir)

require("modules.error-handling")

local config = require("config")

local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

require("modules.layouts").connect()

require("modules.wallpaper").connect()

require("modules.wibar").connect()

require("modules.bindings").connect()

require("modules.rules").connect()
require("awful.autofocus")

require("modules.titlebars").connect()

require("modules.notifications").connect()

if config.sloppy_focus then
	client.connect_signal("mouse::enter", function(c)
		c:activate { context = "mouse_enter", raise = false }
	end)
end

if config.less_intensive_gc then
	collectgarbage("setpause", 160)
	collectgarbage("setstepmul", 400)
else
	collectgarbage("setpause", 110)
	collectgarbage("setstepmul", 1000)
end

