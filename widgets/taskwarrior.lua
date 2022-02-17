local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local task_signal = require("external-signal.task")

local TaskWarrior = { mt = {} }

local function new(options)
	options = options or {}

	local self
	do
		local textbox = wibox.widget.textbox()
		local textbox_wrapper = wibox.container.background(textbox)
		local icon_imagebox = wibox.widget.imagebox(beautiful.taskwarrior_icon)

		textbox_wrapper.fg = beautiful.fg_normal
		-- Create main widget that will be returned
		self = wibox.layout.fixed.horizontal(
			icon_imagebox, textbox_wrapper
		)

		-- Save references to some of the child widgets
		self.textbox = textbox
	end

	-- Connect signal to get ram info
	self.textbox:set_text("?")
	awesome.connect_signal(task_signal, function(pending, overdue)
		if overdue > 0 then
			self.textbox:set_text(("!%s/%s"):format(overdue, pending))
		else
			self.textbox:set_text(("%s"):format(pending))
		end
	end)

	if options.open_command then
		self:add_button(awful.button({}, 1, function()
			awful.spawn.with_shell(options.open_command)
		end))
	end

	return self
end

function TaskWarrior.mt.__call(_, ...)
	return new(...)
end

return setmetatable(TaskWarrior, TaskWarrior.mt)
