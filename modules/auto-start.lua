local spawn = require("awful").spawn
local gears = require("gears")

local function connect(options)
	local dir = gears.filesystem.get_xdg_config_home() .. "autostart"

	if options then
		assert(type(options) == "table", "Expected optiosn to be a table")
		dir = options.dir or dir
	end

	assert(type(dir) == "string", "Expected dir to be a string")

	-- Remove god damn teams from the autostart folder, because it always get created
	-- when you launch it.
	if gears.filesystem.file_readable(dir .. "/teams.desktop") then
		os.remove(dir .. "/teams.desktop")
	end

	spawn.with_shell(
		"if (xrdb -query | grep -q \"^awesome\\.started:\\s*true$\"); then exit; fi;" ..
		"xrdb -merge <<< \"awesome.started:true\";" .. -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
		([[dex --environment Awesome --autostart --search-paths "%s"]]):format(dir) -- https://github.com/jceb/dex
	)
end

return { connect = connect }

