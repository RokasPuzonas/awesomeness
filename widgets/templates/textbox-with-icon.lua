local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local gtable = require("gears.table")
local beautiful = require("beautiful")

local TextboxWithIcon = {}

local function new(options)
	options = options or {}

	local self = wibox.layout.fixed.horizontal()

	self.textbox = wibox.widget.textbox()
	self.textbox_wrapper = wibox.container.background(self.textbox)
	self.icon_imagebox = wibox.widget.imagebox()

	self:add(self.icon_imagebox)
	self:add(self.textbox_wrapper)

	gtable.crush(self, TextboxWithIcon, true)

	self.keep_icon_color = options.keep_icon_color

	self:set_color(options.color or beautiful.fg_normal)
	self:set_icon(options.icon)

	if options.text then
		self:set_text(options.text)
	elseif options.markup then
		self:set_markup(options.markup)
	end

	return self
end

function TextboxWithIcon:set_text(text)
	self.textbox:set_text(text)
end

function TextboxWithIcon:set_markup(markup)
	self.textbox:set_markup_silently(markup)
end

function TextboxWithIcon:set_icon(new_icon)
	if type(new_icon) == "string" then
		self.icon_image = gears.surface.load_silently(new_icon)
	else
		self.icon_image = new_icon
	end

	self.icon_imagebox:set_image(self.icon_image)

	if not self.keep_icon_color and self.current_color then
		if not self.colored_icon_image then
			self.colored_icon_image = helpers.clone_image(self.icon_image)
		end

		self.icon_imagebox:set_image(self.colored_icon_image)
		helpers.overwrite_colored_image(self.colored_icon_image, self.icon_image, self.current_color)
		self.icon_imagebox:emit_signal("widget::redraw_needed")
	end
end

function TextboxWithIcon:set_color(color)
	-- If the color is the same as the current one, do nothing
	if not color or self.current_color == color then return end
	self.current_color = color

	self.textbox_wrapper.fg = color

	-- Apply color to icon image
	if not self.keep_icon_color and self.colored_icon_image then
		helpers.overwrite_colored_image(self.colored_icon_image, self.icon_image, color)
		self.icon_imagebox:emit_signal("widget::redraw_needed")
	end
end

return new
