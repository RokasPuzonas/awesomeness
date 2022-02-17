local config = {}

config.theme = "ascii-fox-srcery"
-- config.theme = "arch-gruvbox"

config.super = "Mod4"
config.alt = "Mod1"
config.shift = "Shift"
config.ctrl = "Control"

config.terminal = "kitty"
config.editor = os.getenv("EDITOR") or "nvim"
config.editor_cmd = config.terminal.." -e "..config.editor
config.taskwarrior_cmd = config.terminal.." -e taskwarrior-tui"
config.program_launcher = "rofi -show run"
config.web_browser = "brave"
config.file_manager = "pcmanfm"

function config.edit_file_cmd(filename, dir)
	return ("%s -d='%s' %s %s"):format(config.terminal, dir, config.editor, filename)
end

config.sloppy_focus = true
config.no_titlebars = false
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
	suit.floating,
}

return config
