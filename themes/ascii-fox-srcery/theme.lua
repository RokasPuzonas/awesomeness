local gfs = require("gears.filesystem")
local theme_path = gfs.get_configuration_dir().."/themes/ascii-fox-srcery/"

local base16_template = require("themes.base16-template.theme")

-- From: https://srcery-colors.github.io/
local theme = base16_template{
	black1 = "#1C1B19",
	black2 = "#383431",
	black3 = "#5b534d",
	black4 = "#918175",

	white1 = "#9e8f76",
	white2 = "#D0BFA1",
	white3 = "#eadbc2",
	white4 = "#fff2db",

	red    = "#EF2F27",
	orange = "#FF5F00",
	yellow = "#FBB829",
	green  = "#519F50",
	cyan   = "#0AAEB3",
	blue   = "#2C78BF",
	purple = "#E02C6D",
	brown  = "#e0630f",

	bright_black  = "#918175",
	bright_white  = "#fff2db",
	bright_red    = "#F75341",
	bright_orange = "#FF8700",
	bright_yellow = "#FED06E",
	bright_green  = "#98BC37",
	bright_cyan   = "#53FDE9",
	bright_blue   = "#68A8E4",
	bright_purple = "#FF5C8F",
	bright_brown  = "#e07f3e"
}

theme.font = "Fantasque Sans Mono 10"

theme.wallpaper = theme_path.."wallpaper.png"
theme.wallpaper_stretch = true

theme.kitty_theme = "Srcery"

return theme
