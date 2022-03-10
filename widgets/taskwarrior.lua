local awful = require("awful")
local beautiful = require("beautiful")

local TextboxWithIcon = require("widgets.templates.textbox-with-icon")

local task_signal = require("external-signal.task")

local function new(options)
	options = options or {}
	local self = TextboxWithIcon{
		icon = beautiful.taskwarrior_icon,
		text = "?",
		keep_icon_color = true
	}

	-- Connect signal to get ram info
	self:set_text("?")
	awesome.connect_signal(task_signal, function(pending, overdue)
		if overdue > 0 then
			self:set_text(("!%s/%s"):format(overdue, pending))
		else
			self:set_text(("%s"):format(pending))
		end
	end)

	if options.open_command then
		self:add_button(awful.button({}, 1, function()
			awful.spawn.with_shell(options.open_command)
		end))
	end

	return self
end

return new
