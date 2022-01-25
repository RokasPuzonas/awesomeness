local spawn = require("awful.spawn")

local neovim = {}

-- TODO: This is not safe, code CAN BE INJECTED
-- Sanitize the input

local function readFile(path)
	local f = io.open(path, "r")
	if not f then return nil end
	local contents = f:read("*a")
	f:close()
	return contents
end

local function writeFile(path, contents)
	local f = io.open(path, "w")
	if not f then return false end
	f:write(contents)
	f:close()
	return true
end

function neovim.get_config_path()
	return os.getenv("HOME").."/.config/nvim/init.lua"
end

function neovim.set_theme(theme_name, background)
	assert(type(theme_name) == "string", "Expected theme_name to be string")
	assert(not background or type(background) == "string", "Expected background to be string or nil")

	local config_path = neovim.get_config_path()
	local nvim_config = readFile(config_path)
	if not nvim_config then
		return false, ("Failed to read neovim config: "):format(config_path)
	end

	local addition
	if background then
		addition = ('-- THEME_BEGIN\nopt("background", "%s")\ncmd("colorscheme %s")\n-- THEME_END'):format(background, theme_name)
	else
		addition = ('-- THEME_BEGIN\ncmd("colorscheme %s")\n-- THEME_END'):format(theme_name)
	end

	local pattern = "-- THEME_BEGIN.+-- THEME_END"
	local new_nvim_config = nvim_config:gsub(pattern, addition, 1)
	if new_nvim_config == nvim_config then
		new_nvim_config = new_nvim_config .. "\n\n" .. addition
	end

	local success = writeFile(config_path, new_nvim_config)
	if not success then
		return false, ("Failed to write to neovim config: "):format(config_path)
	end

	return true
end

function neovim.reload_instances()
	local config_path = neovim.get_config_path()

	local cmd = ([[nvr --nostart --serverlist | xargs -I '{}' nvr --nostart --servername '{}' -cc "so %s"]]):format(config_path)
	spawn.with_shell(cmd)
end

return neovim
