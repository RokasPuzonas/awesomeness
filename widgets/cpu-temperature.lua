local beautiful = require("beautiful")

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local cpu_temperature_signal = require("external-signal.cpu-temperature")

local function new()
	local self = TextboxWithIcon{
		icon = beautiful.cpu_temperature_icon,
		text = "??°C"
	}

	awesome.connect_signal(cpu_temperature_signal, function(current, high, critical)
		self:set_text(("%.1f°C"):format(current));

		if current >= critical and beautiful.cpu_temperature_critical_fg then
			self:set_color(beautiful.cpu_temperature_critical_fg)
		elseif current >= high and beautiful.cpu_temperature_high_fg then
			self:set_color(beautiful.cpu_temperature_high_fg)
		else
			self:set_color(beautiful.cpu_temperature_fg)
		end
	end)

	return self
end


return new
