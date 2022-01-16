local config = {}

config.theme = "default"

config.super = "Mod4"
config.altkey = "Mod1"
config.shift = "Shift"
config.ctrl = "Control"

config.terminal = "kitty"
config.editor = os.getenv("EDITOR") or "nvim"
config.editor_cmd = config.terminal.." -e "..config.editor
config.program_launcher = "rofi -show run"
config.web_browser = "brave"
config.file_manager = "pcmanfm"

config.sloppy_focus = true
config.no_titlebars = false
config.compress_tag_bindings = true
config.less_intensive_gc = false -- gc = garbage collector

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

config.tags = {"1", "2", "3", "4", "5"}

local suit = require("awful.layout.suit")
config.layouts = {
	suit.floating,
	suit.tile,
	suit.tile.left,
	suit.tile.bottom,
	suit.tile.top,
	suit.fair,
	suit.fair.horizontal,
	suit.spiral,
	suit.spiral.dwindle,
	suit.max,
	suit.max.fullscreen,
	suit.magnifier,
	suit.corner.nw,
}

return config

