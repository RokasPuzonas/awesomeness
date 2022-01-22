local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local gtable = require("gears.table")

local cpu_temperature_signal = require("external-signal.cpu-temperature")

local CpuTemperature = { mt = {} }

local function new(options)
	options = options or {}

	local self
	do
		local original_icon = gears.surface.load_silently(beautiful.cpu_temperature_icon)
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

	-- Copy over all methods
	gtable.crush(self, CpuTemperature, true)

	self.textbox:set_text("??°C");
	awesome.connect_signal(cpu_temperature_signal, function(current, high, critical)
		self.textbox:set_text(("%.1f°C"):format(current));

		if current >= critical and beautiful.cpu_temperature_critical_fg then
			self:update_color(beautiful.cpu_temperature_critical_fg)
		elseif current >= high and beautiful.cpu_temperature_high_fg then
			self:update_color(beautiful.cpu_temperature_high_fg)
		else
			self:update_color(beautiful.cpu_temperature_fg)
		end
	end)

	return self
end

function CpuTemperature:update_color(color)
	-- If the color is the same as the current one, do nothing
	if not color or self.color == color then return end

	self.textbox_wrapper.fg = color

	-- Apply color to icon image
	do
		helpers.overwrite_colored_image(self.icon, self.original_icon, color)
		self.icon_imagebox:emit_signal("widget::redraw_needed")
	end
end

function CpuTemperature.mt.__call(_, ...)
	return new(...)
end

return setmetatable(CpuTemperature, CpuTemperature.mt)
