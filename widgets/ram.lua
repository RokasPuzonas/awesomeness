-- Helpful reference when working with cairo:
-- * https://github.com/pavouk/lgi/blob/master/samples/cairo.lua
-- * https://www.cairographics.org/manual/cairo-cairo-t.html
-- * https://www.cairographics.org/operators/
-- * https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-operator-t

local wibox = require("wibox")
local gears = require("gears")
local gtable = require("gears.table")
local beautiful = require("beautiful")

local lgi = require("lgi")
local cairo = lgi.cairo

local ram_signal = require("external-signal.ram")
local ram_units = "MiB"

local Ram = { mt = {} }

local function clone_image(img)
	local cloned = cairo.ImageSurface.create(cairo.Format.ARGB32, img.width, img.height)
	local cr = cairo.Context(img)
	cr:set_operator(2) -- CAIRO_OPERATOR_OVER = 2
	cr:set_source_surface(img, 0, 0)
	cr:paint()
	return cloned
end

local function new(options)
	options = options or {}

	-- Create needed widgets
	local original_icon = gears.surface.load_silently(beautiful.ram_icon)
	local textbox = wibox.widget.textbox()
	local textbox_wrapper = wibox.container.background(textbox)
	local ram_icon = clone_image(original_icon)

	-- Create main widget that will be returned
	local self = wibox.layout.fixed.horizontal(
		wibox.widget.imagebox(ram_icon), textbox_wrapper
	)

	-- Save references to some of the child widgets
	self.textbox_wrapper = textbox_wrapper
	self.icon = ram_icon
	self.original_icon = original_icon

	self.high_threshold     = options.high_threshold or 0.8
	self.moderate_threshold = options.moderate_threshold or 0.5

	-- Copy over all methods
	gtable.crush(self, Ram, true)

	-- Connect signal to get ram info
	textbox:set_text(("??? %s"):format(ram_units))
	awesome.connect_signal(ram_signal, function(used, total)
		textbox:set_text(("%s/%s %s"):format(used, total, ram_units))

		local percent = used/total
		if percent >= self.high_threshold and beautiful.ram_high_fg then
			self:update_color(beautiful.ram_high_fg)
		elseif percent >= self.moderate_threshold and beautiful.ram_moderate_fg then
			self:update_color(beautiful.ram_moderate_fg)
		elseif beautiful.ram_normal_fg then
			self:update_color(beautiful.ram_normal_fg)
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
		-- TODO: Is it fine to create a cairo context and then throw it out?
		-- Should it be reused when you can?
		local cr = cairo.Context(self.icon)
		cr:set_operator(2) -- CAIRO_OPERATOR_OVER = 2
		cr:set_source_surface(self.original_icon, 0, 0)
		cr:paint()
		cr:set_source(gears.color(color))
		cr:set_operator(5) -- CAIRO_OPERATOR_ATOP = 5
		cr:paint()
	end
end

function Ram.mt.__call(_, ...)
    return new(...)
end

return setmetatable(Ram, Ram.mt)

