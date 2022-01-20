local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local cairo = require("lgi").cairo

local network_signal = require("external-signal.network")

local Network = { mt = {} }

local function loadImage(path, color)
	local image = gears.surface.load_silently(path)
	local cr = cairo.Context(image)
	cr:set_source(gears.color(color))
	cr:set_operator(5) -- CAIRO_OPERATOR_ATOP = 5
	cr:paint()
	return image
end

local function new(options)
	options = options or {}

	local sent_textbox = wibox.widget.textbox()
	local received_textbox = wibox.widget.textbox()
	local sent_color = beautiful.network_sent_fg or beautiful.network_fg
	local received_color = beautiful.network_received_fg or beautiful.network_fg

	local received_icon = loadImage(beautiful.network_received_icon, received_color)
	local sent_icon = loadImage(beautiful.network_sent_icon, sent_color)

	local self = wibox.layout.fixed.horizontal(
		wibox.widget.imagebox(received_icon),
		{
			widget = wibox.container.background,
			fg = received_color,
			received_textbox
		},
		wibox.widget.imagebox(sent_icon),
		{
			widget = wibox.container.background,
			fg = sent_color,
			sent_textbox,
		}
	)

	sent_textbox:set_text(("%06.1f"):format(0))
	received_textbox:set_text(("%06.1f"):format(0))
	awesome.connect_signal(network_signal, function(stats, units)
		sent_textbox:set_text(("%06.1f %s"):format(stats.sent, units))
		received_textbox:set_text(("%06.1f %s"):format(stats.received, units))
	end)

	return self
end

function Network.mt.__call(_, ...)
	return new(...)
end

return setmetatable(Network, Network.mt)
