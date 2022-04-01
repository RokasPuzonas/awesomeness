local awful = require("awful")
local beautiful = require("beautiful")
local playerctl_instance

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local PlayerCTL = {}

function PlayerCTL.getController()
	if not playerctl_instance then
		local bling = require("bling")
		playerctl_instance = bling.signal.playerctl.lib()
	end
	return playerctl_instance
end

local function new(options)
	options = options or {}
	local self = TextboxWithIcon{
		icon = beautiful.playerctl_icon
	}

	self.controller = PlayerCTL.getController()

	-- Copy over all methods

	self:set_color(beautiful.playerctl_fg)

	self.controller:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
		self:set_markup(("%s - %s"):format(title, artist))
	end)

	self.controller:connect_signal("playback_status", function(_, playing, player_name)
		if beautiful.playerctl_paused_fg then
			if playing then
				self:set_color(beautiful.playerctl_fg)
			else
				self:set_color(beautiful.playerctl_paused_fg)
			end
		end
	end)

	self.controller:connect_signal("exit", function()
		self:set_text("")
		self:set_color(beautiful.playerctl_fg)
	end)

	if not options.no_buttons then
		self:add_button(awful.button({}, 1, function()
			self.controller:play_pause()
		end))

		self:add_button(awful.button({"Control"}, 1, function()
			self.controller:next()
		end))

		self:add_button(awful.button({"Control"}, 3, function()
			self.controller:previous()
		end))
	end

	return self
end

return setmetatable(PlayerCTL, { __call = new })
