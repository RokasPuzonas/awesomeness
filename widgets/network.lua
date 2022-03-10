local wibox = require("wibox")
local beautiful = require("beautiful")

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local network_signal = require("external-signal.network")

local function new()
	local self = wibox.layout.fixed.horizontal()
	self.sent_widget = TextboxWithIcon{
		icon = beautiful.network_sent_icon,
		text = ("%06.1f"):format(0),
		color = beautiful.network_sent_fg or beautiful.network_fg
	}

	self.received_widget = TextboxWithIcon{
		icon = beautiful.network_received_icon,
		text = ("%06.1f"):format(0),
		color = beautiful.network_received_fg or beautiful.network_fg
	}

	self:add(self.sent_widget)
	self:add(self.received_widget)

	awesome.connect_signal(network_signal, function(stats, units)
		self.sent_widget:set_text(("%06.1f %s"):format(stats.sent, units))
		self.received_widget:set_text(("%06.1f %s"):format(stats.received, units))
	end)

	return self
end

return new
