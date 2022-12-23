local awful = require("awful")
local config = require("config")
local hotkeys_popup = require("awful.hotkeys_popup")
local PlayerCTL = require("widgets.playerctl")

local main_menu = require("widgets.main-menu")

local super = config.super
local ctrl = config.ctrl
local shift = config.shift

local function bindings(keybindings_tree)
	local keybindings = {}
	local trees = {keybindings_tree}
	while #trees > 0 do
		local tree = table.remove(trees)
		for _, subtree in ipairs(tree) do
			if type(subtree) == "table" and not subtree.binding then
				table.insert(trees, subtree)
			else
				subtree.binding = nil
				table.insert(keybindings, subtree)
			end
		end
	end
	return keybindings
end

local function group(group_name, keybindings)
	for _, key in ipairs(keybindings) do
		key.group = group_name
	end
	return keybindings
end

local function keybind(modifiers, key, description, on_press)
	local keys = awful.key{
		modifiers = modifiers,
		key = key,
		on_press = on_press,
		description = description
	}
	keys.binding = true
	return keys
end

local function keybind_grp(modifiers, keygroup, description, on_press)
	local keys = awful.key{
		modifiers = modifiers,
		keygroup = keygroup,
		on_press = on_press,
		description = description
	}
	keys.binding = true
	return keys
end

local function buttonbind(modifiers, key, on_press)
	local btns = awful.button(modifiers, key, on_press)
	btns.binding = true
	return btns
end

local function launch_program(program)
	return function() awful.spawn(program) end
end

local function launch_shell_program(program)
	return function() awful.spawn.with_shell(program) end
end

local function screenshot_to_clipboard()
	awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png")
end

local function screenshot_to_file()
		local date = os.date("%Y-%m-%d_%H:%M:%S")
		local path = ("%s/%s.png"):format(config.user_dirs.screenshots, date)
		awful.spawn(("maim -suq %s"):format(path))
		awful.spawn.with_shell(("printf '%s' | xclip -selection clipboard"):format(path))
end

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys").tmux.add_rules_for_terminal{ rule = { name = "tmux" } }

-- General Awesome keys
awful.keyboard.append_global_keybindings(bindings{
	group("awesome", {
		keybind({super           }, "s", "show help",
			hotkeys_popup.show_help),
		keybind({super           }, "w", "show main menu",
			function() main_menu:show() end),
		keybind({super, ctrl     }, "r", "reload awesome",
			awesome.restart),
		keybind({super, shift    }, "q", "quit awesome",
			awesome.quit),
	}),
	group("launcher", {
		keybind({super       }, "Return", "open a terminal",
			launch_program(config.terminal)),
		keybind({super       }, "p"     , "program launcher",
			launch_program(config.program_launcher)),
		keybind({super       }, "q"     , "web browser",
			launch_program(config.web_browser)),
		keybind({super, shift}, "s"     , "take screenshot to clipboard",
			screenshot_to_clipboard),
		keybind({super, ctrl }, "s"     , "take screenshot and save to file",
			screenshot_to_file),
		keybind({super, shift}, "t"     , "taskwarrior",
			launch_shell_program(config.taskwarrior_cmd))
	})
})

-- Mouse bindings
awful.mouse.append_global_mousebindings(bindings{
	buttonbind({}, 3, function() main_menu:toggle() end),
	buttonbind({}, 4, awful.tag.viewprev),
	buttonbind({}, 5, awful.tag.viewnext)
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings(bindings{ group("tag", {
	keybind({super}, "Left"  , "view previous", awful.tag.viewprev),
	keybind({super}, "Right" , "view next", awful.tag.viewnext),
	keybind({super}, "Escape", "go back", awful.tag.history.restore)
}) })

-- Focus related keybindings
awful.keyboard.append_global_keybindings(bindings{
	group("client", {
		keybind({super}, "j", "focus next by index", function()
			awful.client.focus.byidx(1)
		end),
		keybind({super}, "k", "focus previous by index", function()
			awful.client.focus.byidx(-1)
		end),
		keybind({super}, "Tab", "go back", function()
			awful.client.focus.history.previous()
			if client.focus then client.focus:raise() end
		end),
		keybind({super, ctrl}, "n", "restore minimized", function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then c:activate{raise = true, context = "key.unminimize"} end
		end),
	}),

	group("screen", {
		keybind({super, ctrl}, "k", "focus the previous screen", function()
			awful.screen.focus_relative(-1)
		end),
		keybind({super, ctrl}, "j", "focus the next screen", function()
			awful.screen.focus_relative(1)
		end)
	})
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings(bindings{
	group("client", {
		keybind({super, shift}, "j", "swap with next client by index", function()
			awful.client.swap.byidx(1)
		end),
		keybind({super, "Shift"}, "k", "swap with previous client by index", function()
			awful.client.swap.byidx(-1)
		end),
		keybind({super}, "u", "jump to urgent client", awful.client.urgent.jumpto),
	}),

	group("layout", {
		keybind({super}, "l", "increase master width factor", function()
			awful.tag.incmwfact(0.05)
		end),
		keybind({super}, "h", "decrease master width factor", function()
			awful.tag.incmwfact(-0.05)
		end),
		keybind({super, shift}, "h", "increase the number of master clients", function()
			awful.tag.incnmaster(1, nil, true)
		end),
		keybind({super, shift}, "l", "decrease the number of master clients", function()
			awful.tag.incnmaster(-1, nil, true)
		end),
		keybind({super, ctrl}, "h", "increase the number of columns", function()
			awful.tag.incncol(1, nil, true)
		end),
		keybind({super, ctrl}, "l", "decrease the number of columns", function()
			awful.tag.incncol(-1, nil, true)
		end),
		-- keybind({super}, "space", "select next", function()
		-- 	awful.layout.inc(1)
		-- end),
		-- keybind({super, shift}, "space", "select previous", function()
		-- 	awful.layout.inc(-1)
		-- end)
	})
})

awful.keyboard.append_global_keybindings(bindings{ group("tag", {
	keybind_grp({super}, 'numrow', 'only view tag', function(idx)
		local screen = awful.screen.focused()
		local tag = screen.tags[idx]
		if tag then tag:view_only() end
	end),
	keybind_grp({super, ctrl}, 'numrow', 'toggle tag', function(idx)
		local screen = awful.screen.focused()
		local tag = screen.tags[idx]
		if tag then awful.tag.viewtoggle(tag) end
	end),
	keybind_grp({super, shift}, 'numrow', 'move focused client to tag', function(idx)
		if client.focus then
			local tag = client.focus.screen.tags[idx]
			if tag then client.focus:move_to_tag(tag) end
		end
	end),
	keybind_grp({super, ctrl, shift}, 'numrow', 'toggle focused client on tag', function(idx)
		if client.focus then
			local tag = client.focus.screen.tags[idx]
			if tag then client.focus:toggle_tag(tag) end
		end
	end),
}) })

-- Playerctl
awful.keyboard.append_global_keybindings(bindings{ group("playerctl", {
	keybind({ctrl, super}, "Down", "play/pause track", function()
		local playerctl = PlayerCTL.getController()
		playerctl:play_pause()
	end),
	keybind({ctrl, super}, "Right", "next track", function()
		local playerctl = PlayerCTL.getController()
		playerctl:next()
	end),
	keybind({ctrl, super}, "Left", "previous track", function()
		local playerctl = PlayerCTL.getController()
		playerctl:previous()
	end)
}) })

awful.keyboard.append_global_keybindings(bindings{
	keybind({super}, "space", "switch keyboard layout", function()
		awful.screen.kbd_layout:next_layout()
	end)
})

client.connect_signal('request::default_mousebindings', function()
	awful.mouse.append_client_mousebindings(bindings{
		buttonbind({}, 1, function(c)
			c:activate{context = 'mouse_click'}
		end),
		buttonbind({super}, 1, function(c)
			c:activate{context = 'mouse_click', action = 'mouse_move'}
		end),
		buttonbind({super}, 3, function(c)
			c:activate{context = 'mouse_click', action = 'mouse_resize'}
		end)
	})
end)

client.connect_signal('request::default_keybindings', function()
	awful.keyboard.append_client_keybindings(bindings{ group("client", {
		keybind({super}, 'f', 'toggle fullscreen', function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),
		keybind({super, 'Shift'}, 'c', 'close', function(c) c:kill() end),
		keybind({super, 'Control'}, 'space', 'toggle floating', awful.client.floating.toggle),
		keybind({super, 'Control'}, 'Return', 'move to master', function(c)
			c:swap(awful.client.getmaster())
		end),
		keybind({super}, 'o', 'move to screen', function(c) c:move_to_screen() end),
		keybind({super}, 't', 'toggle keep on top', function(c) c.ontop = not c.ontop end),
		keybind({super}, 'n', 'minimize', function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
		keybind({super}, 'm', '(un)maximize', function(c)
			c.maximized = not c.maximized
			c:raise()
		end),
		keybind({super, 'Control'}, 'm', '(un)maximize vertically', function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end),
		keybind({super, 'Shift'}, 'm', '(un)maximize horizontally', function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end)
	}) })
end)
