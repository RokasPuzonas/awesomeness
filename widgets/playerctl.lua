local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local gears = require("gears")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local playerctl_instance

local PlayerCTL = { mt = {} }

local function new(options)
	options = options or {}

	local self
	do
		local original_icon = gears.surface.load_silently(beautiful.playerctl_icon)
		local textbox = wibox.widget.textbox()
		local textbox_wrapper = wibox.container.background(textbox)
		local icon = helpers.clone_image(original_icon)
		local icon_imagebox = wibox.widget.imagebox(icon)

		-- Create main widget that will be returned
		self = wibox.layout.fixed.horizontal(
			icon_imagebox, textbox_wrapper
		)

		-- Save references to some of the child widgets
		self.textbox_wrapper = textbox_wrapper
		self.textbox = textbox
		self.icon = icon
		self.icon_imagebox = icon_imagebox
		self.original_icon = original_icon
	end

	self.controller = PlayerCTL.getController()

	-- Copy over all methods
	gtable.crush(self, PlayerCTL, true)

	self:update_color(beautiful.playerctl_fg)

	self.controller:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
		self.textbox:set_markup_silently(("%s - %s"):format(title, artist))
	end)

	self.controller:connect_signal("playback_status", function(_, playing, player_name)
		if beautiful.playerctl_paused_fg then
			if playing then
				self:update_color(beautiful.playerctl_fg)
			else
				self:update_color(beautiful.playerctl_paused_fg)
			end
		end
	end)

	self.controller:connect_signal("exit", function()
		self.textbox:set_text("")
		self:update_color(beautiful.playerctl_fg)
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

function PlayerCTL:update_color(color)
	-- If the color is the same as the current one, do nothing
	if not color or self.color == color then return end

	self.textbox_wrapper.fg = color

	-- Apply color to icon image
	do
		helpers.overwrite_colored_image(self.icon, self.original_icon, color)
		self.icon_imagebox:emit_signal("widget::redraw_needed")
	end
end

function PlayerCTL.getController()
	if not playerctl_instance then
		local bling = require("bling")
		playerctl_instance = bling.signal.playerctl.lib()
	end
	return playerctl_instance
end

function PlayerCTL.mt.__call(_, ...)
	return new(...)
end

return setmetatable(PlayerCTL, PlayerCTL.mt)
