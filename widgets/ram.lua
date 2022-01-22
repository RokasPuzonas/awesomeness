local wibox = require("wibox")
local gears = require("gears")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local helpers = require("helpers")

local ram_signal = require("external-signal.ram")

local Ram = { mt = {} }

local function new(options)
	options = options or {}

	-- Create needed widgets
	local self
	do
		local original_icon = gears.surface.load_silently(beautiful.ram_icon)
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


	self.high_threshold     = options.high_threshold or 0.8
	self.critical_threshold = options.critical_threshold or 0.5

	-- Copy over all methods
	gtable.crush(self, Ram, true)

	-- Connect signal to get ram info
	self.textbox:set_text("???")
	awesome.connect_signal(ram_signal, function(used, total, units)
		self.textbox:set_text(("%s/%s %s"):format(used, total, units))

		local percent = used/total
		if percent >= self.critical_threshold and beautiful.ram_critical_fg then
			self:update_color(beautiful.ram_critical_fg)
		elseif percent >= self.high_threshold and beautiful.ram_high_fg then
			self:update_color(beautiful.ram_high_fg)
		elseif beautiful.ram_fg then
			self:update_color(beautiful.ram_fg)
		end
	end)

	return self
end

function Ram:update_color(color)
	-- If the color is the same as the current one, do nothing
	if self.color == color then return end

	self.textbox_wrapper.fg = color

	-- Apply color to icon image
	do
		helpers.overwrite_colored_image(self.icon, self.original_icon, color)
		self.icon_imagebox:emit_signal("widget::redraw_needed")
	end
end

function Ram.mt.__call(_, ...)
	return new(...)
end

return setmetatable(Ram, Ram.mt)
