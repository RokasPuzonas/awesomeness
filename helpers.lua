-- Helpful reference when working with cairo:
-- * https://github.com/pavouk/lgi/blob/master/samples/cairo.lua
-- * https://www.cairographics.org/manual/cairo-cairo-t.html
-- * https://www.cairographics.org/operators/
-- * https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-operator-t

local timer = require("gears.timer")
local spawn = require("awful.spawn")
local gears = require("gears")

local lgi = require("lgi")
local cairo = lgi.cairo

local helpers = {}

function helpers.easy_watch(command, timeout, callback)
	local t = timer{ timeout = timeout }
	t:connect_signal("timeout", function()
			t:stop()
			spawn.easy_async(command, function(stdout, stderr, exitreason, exitcode)
				callback(stdout, stderr, exitreason, exitcode)
				t:again()
			end)
	end)
	t:start()
	t:emit_signal("timeout")
	return t
end

function helpers.easy_watch_with_shell(command, timeout, callback)
	local t = timer{ timeout = timeout }
	t:connect_signal("timeout", function()
			t:stop()
			spawn.easy_async_with_shell(command, function(stdout, stderr, exitreason, exitcode)
				callback(stdout, stderr, exitreason, exitcode)
				t:again()
			end)
	end)
	t:start()
	t:emit_signal("timeout")
	return t
end

function helpers.easy_timer(timeout, callback)
	return timer{
		timeout = timeout,
		callback = callback,
		autostart = true,
		call_now = true
	}
end

function helpers.clone_image(img)
	local cloned = cairo.ImageSurface.create(cairo.Format.ARGB32, img.width, img.height)
	local cr = cairo.Context(cloned)
	cr:set_source_surface(img, 0, 0)
	cr:paint()
	return cloned
end

function helpers.overwrite_colored_image(img, on_top_image, color)
	local cr = cairo.Context(img)
	cr:set_operator(2) -- CAIRO_OPERATOR_OVER = 2
	cr:set_source_surface(on_top_image, 0, 0)
	cr:paint()
	cr:set_source(gears.color(color))
	cr:set_operator(5) -- CAIRO_OPERATOR_ATOP = 5
	cr:paint()
end

return helpers
