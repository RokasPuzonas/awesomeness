local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir().."/assets/"
local theme_path = gfs.get_configuration_dir().."/themes/arch-gruvbox/"
local icons_path =  assets_path.."/icons/"

local theme = {}

theme.font = "Fantasque Sans Mono 10"

-- http://www.chriskempson.com/projects/base16/
-- Color scheme: "Gruvbox dark, medium"
-- Color scheme author: "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)"
theme.black1 = "#282828" -- Default background
theme.black2 = "#3c3836"
theme.black3 = "#504945"
theme.black4 = "#665c54"
theme.white1 = "#bdae93"
theme.white2 = "#d5c4a1" -- Default foreground
theme.white3 = "#ebdbb2"
theme.white4 = "#fbf1c7"
theme.red    = "#fb4934"
theme.orange = "#fe8019"
theme.yellow = "#fabd2f"
theme.green  = "#b8bb26"
theme.cyan   = "#8ec07c"
theme.blue   = "#83a598"
theme.purple = "#d3869b"
theme.brown  = "#d65d0e"

theme.bg_normal     = theme.black1
theme.bg_focus      = theme.black4
theme.bg_urgent     = theme.red
theme.bg_minimize   = theme.black1
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.white2
theme.fg_focus      = theme.white3
theme.fg_urgent     = theme.white3
theme.fg_minimize   = theme.white3

theme.useless_gap         = dpi(0)
theme.border_width        = dpi(1)
theme.border_color_normal = theme.black1
theme.border_color_active = theme.white1
theme.border_color_marked = theme.red

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
	taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
	taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = icons_path.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(110)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = icons_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = icons_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = icons_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = icons_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = icons_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = icons_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = icons_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = icons_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = icons_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = icons_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = icons_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = icons_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = icons_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = icons_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = icons_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = icons_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = icons_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = icons_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = icons_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = icons_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = theme_path.."wallpaper.png"
theme.wallpaper_bg = "#272827"

-- You can use your own layout icons like this:
theme.layout_fairh = icons_path.."layouts/fairhw.png"
theme.layout_fairv = icons_path.."layouts/fairvw.png"
theme.layout_floating  = icons_path.."layouts/floatingw.png"
theme.layout_magnifier = icons_path.."layouts/magnifierw.png"
theme.layout_max = icons_path.."layouts/maxw.png"
theme.layout_fullscreen = icons_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = icons_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = icons_path.."layouts/tileleftw.png"
theme.layout_tile = icons_path.."layouts/tilew.png"
theme.layout_tiletop = icons_path.."layouts/tiletopw.png"
theme.layout_spiral  = icons_path.."layouts/spiralw.png"
theme.layout_dwindle = icons_path.."layouts/dwindlew.png"
theme.layout_cornernw = icons_path.."layouts/cornernww.png"
theme.layout_cornerne = icons_path.."layouts/cornernew.png"
theme.layout_cornersw = icons_path.."layouts/cornersww.png"
theme.layout_cornerse = icons_path.."layouts/cornersew.png"

theme.ram_icon = icons_path.."widgets/ram.png"
theme.ram_fg = theme.white2
theme.ram_high_fg = theme.yellow
theme.ram_critical_fg = theme.red

theme.network_sent_icon = icons_path.."widgets/network-sent.png"
theme.network_received_icon = icons_path.."widgets/network-received.png"
theme.network_fg = theme.white2
theme.network_sent_fg = theme.blue
theme.network_received_fg = theme.green

theme.cpu_temperature_icon = icons_path.."widgets/cpu-temperature.png"
theme.cpu_temperature_fg = theme.white2
theme.cpu_temperature_high_fg = theme.yellow
theme.cpu_temperature_critical_fg = theme.red

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
	theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
	rnotification.append_rule {
		rule       = { urgency = 'critical' },
		properties = { bg = theme.red, fg = theme.white2 }
	}
end)

return theme

-- vim: filetype=lua:noexpandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
