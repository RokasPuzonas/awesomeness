local signal_name = "external::task"

local easy_watch_with_shell = require("helpers").easy_watch_with_shell

local update_interval = 10
local task_script = [[echo $(task +PENDING count) $(task +OVERDUE count)]]

easy_watch_with_shell(task_script, update_interval, function(stdout)
	local pending, overdue = stdout:match("(%d+)%s+(%d+)")
	pending = tonumber(pending)
	overdue = tonumber(overdue)
	awesome.emit_signal(signal_name, pending, overdue)
end)

return signal_name
