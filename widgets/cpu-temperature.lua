local beautiful = require("beautiful")

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local cpu_temperature_signal = require("external-signal.cpu-temperature")

local function new()
	local self = TextboxWithIcon{
		icon = beautiful.cpu_temperature_icon,
		text = "??°C"
	}

	awesome.connect_signal(cpu_temperature_signal, function(current)
		self:set_text(("%.1f°C"):format(current))
	end)

	return self
end


return new
