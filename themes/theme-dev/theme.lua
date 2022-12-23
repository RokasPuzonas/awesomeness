local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

-- Please refer to: http://chriskempson.com/projects/base16/
-- for more information on what a "base16" palette/theme is

local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir().."/assets/"
local icons_path =  assets_path.."icons/"

assert(type(palette), "Expected to be given a table palette")
local theme = {}

theme.font = "sans 10"

-- Colors by base16 specification
theme.black1 = "#1C1B19"
theme.black2 = "#383431"
theme.black3 = "#5b534d"
theme.black4 = "#918175"

theme.white1 = "#9e8f76"
theme.white2 = "#D0BFA1"
theme.white3 = "#eadbc2"
theme.white4 = "#fff2db"

theme.red    = "#EF2F27"
theme.orange = "#FF5F00"
theme.yellow = "#FBB829"
theme.green  = "#519F50"
theme.cyan   = "#0AAEB3"
theme.blue   = "#2C78BF"
theme.purple = "#E02C6D"
theme.brown  = "#e0630f"

theme.bright_black  = "#918175"
theme.bright_white  = "#fff2db"
theme.bright_red    = "#F75341"
theme.bright_orange = "#FF8700"
theme.bright_yellow = "#FED06E"
theme.bright_green  = "#98BC37"
theme.bright_cyan   = "#53FDE9"
theme.bright_blue   = "#68A8E4"
theme.bright_purple = "#FF5C8F"
theme.bright_brown  = "#e07f3e"

-- Ensure that all colors are defined
assert(theme.black1, "Missing color '1' (black1)")
assert(theme.black2, "Missing color '2' (black2)")
assert(theme.black3, "Missing color '3' (black3)")
assert(theme.black4, "Missing color '4' (black4)")
assert(theme.white1, "Missing color '5' (white1)")
assert(theme.white2, "Missing color '6' (white2)")
assert(theme.white3, "Missing color '7' (white3)")
assert(theme.white4, "Missing color '8' (white4)")
assert(theme.red   , "Missing color '9' (red)")
assert(theme.orange, "Missing color '10' (orange)")
assert(theme.yellow, "Missing color '11' (yellow)")
assert(theme.green , "Missing color '12' (green)")
assert(theme.cyan  , "Missing color '13' (cyan)")
assert(theme.blue  , "Missing color '14' (blue)")
assert(theme.purple, "Missing color '15' (purple)")
assert(theme.brown , "Missing color '16' (brown)")

theme.black = theme.black1
theme.white = theme.white2

-- Default configuration from here on out
theme.bg_normal     = theme.black1
theme.bg_focus      = theme.black4
theme.bg_urgent     = theme.red
theme.bg_minimize   = theme.black1
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.white2
theme.fg_focus      = theme.white3
theme.fg_urgent     = theme.white3
theme.fg_minimize   = theme.white3

theme.useless_gap         = dpi(3)
theme.gap_single_client   = false
theme.border_width        = dpi(2)
theme.border_radius       = dpi(20)
theme.border_color_normal = theme.black1
theme.border_color_active = theme.bright_orange
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
theme.hotkeys_modifiers_fg = theme.black3
theme.taglist_fg_focus = theme.white3

-- Generate taglist squares:
-- local taglist_square_size = dpi(10)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
-- 	taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
-- 	taglist_square_size, theme.fg_normal
-- )

theme.taglist_icon_sel   = assets_path.."taglist/tag-sel.png"
theme.taglist_icon_unsel = assets_path.."taglist/tag-unsel.png"
theme.taglist_icon_sel_empty   = assets_path.."taglist/tag-sel-empty.png"
theme.taglist_icon_unsel_empty = assets_path.."taglist/tag-unsel-empty.png"

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

theme.playerctl_icon = icons_path.."widgets/note.png"
theme.playerctl_default_art = icons_path.."default-playerctl-art.png"
theme.playerctl_ignore = "chromium"
theme.playerctl_fg = theme.white2
theme.playerctl_paused_fg = theme.yellow

theme.taskwarrior_icon = icons_path.."widgets/taskwarrior.png"

theme.parent_filter_list = {"brave", "Gimp", "MultiMC", "jetbrains-idea-ce"}
theme.child_filter_list = { "Dragon" }
theme.swallowing_filter = true

-- Generate Awesome icon:
theme.logo_icon = "/home/rokas/.config/awesome/assets/logo-light.png"
-- theme.logo_icon = theme_assets.awesome_icon(
-- 	theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule {
		rule       = { urgency = "critical" },
		properties = { bg = theme.red, fg = theme.white2 }
	}
end)

theme.font = "Bauhaus2015 12"

theme.wallpaper = "/home/rokas/.config/awesome/themes/ascii-fox-srcery/wallpaper.png"
theme.wallpaper_stretch = true

theme.kitty_theme = "Srcery"
theme.neovim_theme = "srcery"

return theme
