local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir().."/themes/arch-gruvbox/"

local base16_template = require("themes.base16-template.theme")

-- http://www.chriskempson.com/projects/base16/
-- Color scheme: "Gruvbox dark, medium"
-- Color scheme author: "Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)"
local theme = base16_template{
	"#282828",
	"#3c3836",
	"#504945",
	"#665c54",
	"#bdae93",
	"#d5c4a1",
	"#ebdbb2",
	"#fbf1c7",
	"#fb4934",
	"#fe8019",
	"#fabd2f",
	"#b8bb26",
	"#8ec07c",
	"#83a598",
	"#d3869b",
	"#d65d0e"
}

theme.font = "Fantasque Sans Mono 10"

theme.wallpaper = theme_path.."wallpaper.png"
theme.wallpaper_bg = "#272827"

theme.kitty_theme = "Gruvbox Dark"

return theme

-- vim: filetype=lua:noexpandtab:shiftwidth=2:tabstop=2:softtabstop=2:textwidth=80
