local signal_name = "external::network"

local easy_timer = require("helpers").easy_timer

local function isIgnored(name, ignored_devices)
	if not ignored_devices then return false end

	for _, pattern in ipairs(ignored_devices) do
		if name:find(pattern) then
			return true
		end
	end

	return false
end

local function getDeviceStatistics(ignored_devices)
	local statistics = {
		total_received = 0,
		total_sent = 0,
		devices = {}
	}

	local file = io.open("/proc/net/dev", "r")
	if not file then return statistics end

	-- Skip first 2 line that describe the format
	local _ = file:read("*l")
	local _ = file:read("*l")
	-- Read every devices. 1 device per line
	for line in file:lines() do
		-- Parse line, only extract total sent and received
		local name, total_received, total_sent = line:match("^%s*([^%s]+):%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")

		if not isIgnored(name, ignored_devices) then
			total_sent = tonumber(total_sent)
			total_received = tonumber(total_received)

			-- Save parsed data
			statistics.devices[name] = {
				total_sent = total_sent,
				total_received = total_received
			}
			statistics.total_received = statistics.total_received + total_received
			statistics.total_sent = statistics.total_sent + total_sent
		end
	end

	file:close()
	return statistics
end

local update_interval = 5
local units = "KiB"
local units_scalar = 1024
local ignored_devices = {"lo", "docker"}

local last_stats
easy_timer(update_interval, function()
	local current_stats = getDeviceStatistics(ignored_devices)

	current_stats.total_received = current_stats.total_received / units_scalar
	current_stats.total_sent = current_stats.total_sent / units_scalar

	if last_stats then
		current_stats.received = current_stats.total_received - last_stats.total_received
		current_stats.sent = current_stats.total_sent - last_stats.total_sent
	else
		current_stats.received = 0
		current_stats.sent = 0
	end

	for name, device in pairs(current_stats.devices) do
		device.total_received = device.total_received / units_scalar
		device.total_sent = device.total_sent / units_scalar

		if last_stats then
			device.received = device.total_received - last_stats.devices[name].total_received
			device.sent = device.total_sent - last_stats.devices[name].total_sent
		else
			current_stats.received = 0
			current_stats.sent = 0
		end
	end

	awesome.emit_signal(signal_name, current_stats, units)
	last_stats = current_stats
end)

return signal_name
