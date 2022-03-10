local beautiful = require("beautiful")

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local ram_signal = require("external-signal.ram")

local function new(options)
	options = options or {}
	local self = TextboxWithIcon{
		icon = beautiful.ram_icon,
		text = "???"
	}

	self.high_threshold     = options.high_threshold or 0.5
	self.critical_threshold = options.critical_threshold or 0.8

	awesome.connect_signal(ram_signal, function(used, total, units)
		self:set_text(("%s/%s %s"):format(used, total, units))

		local percent = used/total
		if percent >= self.critical_threshold and beautiful.ram_critical_fg then
			self:set_color(beautiful.ram_critical_fg)
		elseif percent >= self.high_threshold and beautiful.ram_high_fg then
			self:set_color(beautiful.ram_high_fg)
		elseif beautiful.ram_fg then
			self:set_color(beautiful.ram_fg)
		end
	end)

	return self
end

return new
