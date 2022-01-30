local awful = require("awful")
local config = require("config")
local hotkeys_popup = require("awful.hotkeys_popup")
local PlayerCTL = require("widgets.playerctl")

local main_menu = require("widgets.main-menu")

local super = config.super
local ctrl = config.ctrl
local shift = config.shift

local function connect_global()
	-- Enable hotkeys help widget for VIM and other apps
	-- when client with a matching name is opened:
	require("awful.hotkeys_popup.keys").tmux.add_rules_for_terminal{ rule = { name = "tmux" } }

	-- Mouse bindings
	awful.mouse.append_global_mousebindings({
		awful.button({}, 3, function()
			main_menu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewprev),
		awful.button({}, 5, awful.tag.viewnext)
	})

	-- General Awesome keys
	awful.keyboard.append_global_keybindings({
		awful.key({super}, 's', hotkeys_popup.show_help,
			{description = 'show help', group = 'awesome'}),
		awful.key({super}, 'w', function()
			main_menu:show()
		end, {description = 'show main menu', group = 'awesome'}),
		awful.key({super, 'Control'}, 'r', awesome.restart,
			{description = 'reload awesome', group = 'awesome'}),
		awful.key({super, 'Shift'}, 'q', awesome.quit,
			{description = 'quit awesome', group = 'awesome'}),
		awful.key({super}, 'Return', function()
			awful.spawn(config.terminal)
		end, {description = 'open a terminal', group = 'launcher'}),
		awful.key({super}, 'p', function()
			awful.spawn(config.program_launcher)
		end, {description = 'program launcher', group = 'launcher'}),
		awful.key({super}, 'q', function()
			awful.spawn(config.web_browser)
		end, {
			description = ('web browser \'%s\''):format(config.web_browser),
			group = 'launcher'
		}),
		awful.key({super, ctrl}, "s", function()
			awful.spawn.with_shell("maim -s | xclip -selection clipboard -t image/png")
		end, { description = "take screenshot to clipboard", group = "launcher"}),
		awful.key({super, shift}, "s", function()
			local date = os.date("%Y-%m-%d_%H:%M:%S")
			local path = ("%s/%s.png"):format(config.user_dirs.screenshots, date)
			awful.spawn.with_shell(("maim -suq %s && printf '%s' | xclip -selection clipboard"):format(path, path))
		end, { description = "take screenshot and save to file", group = "launcher"}),
	})

	-- Tags related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({super}, 'Left', awful.tag.viewprev,
			{description = 'view previous', group = 'tag'}),
		awful.key({super}, 'Right', awful.tag.viewnext,
			{description = 'view next', group = 'tag'}),
		awful.key({super}, 'Escape', awful.tag.history.restore,
			{description = 'go back', group = 'tag'})
	})

	-- Focus related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({super}, 'j', function()
			awful.client.focus.byidx(1)
		end, {description = 'focus next by index', group = 'client'}),
		awful.key({super}, 'k', function()
			awful.client.focus.byidx(-1)
		end, {description = 'focus previous by index', group = 'client'}),
		awful.key({super}, 'Tab', function()
			awful.client.focus.history.previous()
			if client.focus then client.focus:raise() end
		end, {description = 'go back', group = 'client'}),
		awful.key({super, 'Control'}, 'j', function()
			awful.screen.focus_relative(1)
		end, {description = 'focus the next screen', group = 'screen'}),
		awful.key({super, 'Control'}, 'k', function()
			awful.screen.focus_relative(-1)
		end, {description = 'focus the previous screen', group = 'screen'}),
		awful.key({super, 'Control'}, 'n', function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then c:activate{raise = true, context = 'key.unminimize'} end
		end, {description = 'restore minimized', group = 'client'})
	})

	-- Layout related keybindings
	awful.keyboard.append_global_keybindings({
		awful.key({super, 'Shift'}, 'j', function()
			awful.client.swap.byidx(1)
		end, {description = 'swap with next client by index', group = 'client'}),
		awful.key({super, 'Shift'}, 'k', function()
			awful.client.swap.byidx(-1)
		end, {description = 'swap with previous client by index', group = 'client'}),
		awful.key({super}, 'u', awful.client.urgent.jumpto,
			{description = 'jump to urgent client', group = 'client'}),
		awful.key({super}, 'l', function()
			awful.tag.incmwfact(0.05)
		end, {description = 'increase master width factor', group = 'layout'}),
		awful.key({super}, 'h', function()
			awful.tag.incmwfact(-0.05)
		end, {description = 'decrease master width factor', group = 'layout'}),
		awful.key({super, 'Shift'}, 'h', function()
			awful.tag.incnmaster(1, nil, true)
		end, {description = 'increase the number of master clients', group = 'layout'}),
		awful.key({super, 'Shift'}, 'l', function()
			awful.tag.incnmaster(-1, nil, true)
		end, {description = 'decrease the number of master clients', group = 'layout'}),
		awful.key({super, 'Control'}, 'h', function()
			awful.tag.incncol(1, nil, true)
		end, {description = 'increase the number of columns', group = 'layout'}),
		awful.key({super, 'Control'}, 'l', function()
			awful.tag.incncol(-1, nil, true)
		end, {description = 'decrease the number of columns', group = 'layout'}),
		awful.key({super}, 'space', function()
			awful.layout.inc(1)
		end, {description = 'select next', group = 'layout'}),
		awful.key({super, 'Shift'}, 'space', function()
			awful.layout.inc(-1)
		end, {description = 'select previous', group = 'layout'})
	})

	awful.keyboard.append_global_keybindings({
		awful.key{
			modifiers = {super},
			keygroup = 'numrow',
			description = 'only view tag',
			group = 'tag',
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then tag:view_only() end
			end
		},
		awful.key{
			modifiers = {super, 'Control'},
			keygroup = 'numrow',
			description = 'toggle tag',
			group = 'tag',
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then awful.tag.viewtoggle(tag) end
			end
		},
		awful.key{
			modifiers = {super, 'Shift'},
			keygroup = 'numrow',
			description = 'move focused client to tag',
			group = 'tag',
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then client.focus:move_to_tag(tag) end
				end
			end
		},
		awful.key{
			modifiers = {super, 'Control', 'Shift'},
			keygroup = 'numrow',
			description = 'toggle focused client on tag',
			group = 'tag',
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then client.focus:toggle_tag(tag) end
				end
			end
		},
		awful.key{
			modifiers = {super},
			keygroup = 'numpad',
			description = 'select layout directly',
			group = 'layout',
			on_press = function(index)
				local t = awful.screen.focused().selected_tag
				if t then t.layout = t.layouts[index] or t.layout end
			end
		}
	})

	-- Playerctl
	awful.keyboard.append_global_keybindings({
		awful.key{
			modifiers = {ctrl, super},
			key = "Down",
			description = "play/pause track",
			group = "playerctl",
			on_press = function()
				local playerctl = PlayerCTL.getController()
				playerctl:play_pause()
			end
		},
		awful.key{
			modifiers = {ctrl, super},
			key = "Right",
			description = "next track",
			group = "playerctl",
			on_press = function()
				local playerctl = PlayerCTL.getController()
				playerctl:next()
			end
		},
		awful.key{
			modifiers = {ctrl, super},
			key = "Left",
			description = "previous track",
			group = "playerctl",
			on_press = function()
				local playerctl = PlayerCTL.getController()
				playerctl:previous()
			end
		}
	})
end

local function connect_client()
	client.connect_signal('request::default_mousebindings', function()
		awful.mouse.append_client_mousebindings({
			awful.button({}, 1, function(c)
				c:activate{context = 'mouse_click'}
			end),
			awful.button({super}, 1, function(c)
				c:activate{context = 'mouse_click', action = 'mouse_move'}
			end),
			awful.button({super}, 3, function(c)
				c:activate{context = 'mouse_click', action = 'mouse_resize'}
			end)
		})
	end)

	client.connect_signal('request::default_keybindings', function()
		awful.keyboard.append_client_keybindings({
			awful.key({super}, 'f', function(c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end, {description = 'toggle fullscreen', group = 'client'}),
			awful.key({super, 'Shift'}, 'c', function(c)
				c:kill()
			end, {description = 'close', group = 'client'}),
			awful.key({super, 'Control'}, 'space', awful.client.floating.toggle,
				{description = 'toggle floating', group = 'client'}),
			awful.key({super, 'Control'}, 'Return', function(c)
				c:swap(awful.client.getmaster())
			end, {description = 'move to master', group = 'client'}),
			awful.key({super}, 'o', function(c)
				c:move_to_screen()
			end, {description = 'move to screen', group = 'client'}),
			awful.key({super}, 't', function(c)
				c.ontop = not c.ontop
			end, {description = 'toggle keep on top', group = 'client'}),
			awful.key({super}, 'n', function(c)
				-- The client currently has the input focus, so it cannot be
				-- minimized, since minimized clients can't have the focus.
				c.minimized = true
			end, {description = 'minimize', group = 'client'}),
			awful.key({super}, 'm', function(c)
				c.maximized = not c.maximized
				c:raise()
			end, {description = '(un)maximize', group = 'client'}),
			awful.key({super, 'Control'}, 'm', function(c)
				c.maximized_vertical = not c.maximized_vertical
				c:raise()
			end, {description = '(un)maximize vertically', group = 'client'}),
			awful.key({super, 'Shift'}, 'm', function(c)
				c.maximized_horizontal = not c.maximized_horizontal
				c:raise()
			end, {description = '(un)maximize horizontally', group = 'client'})
		})
	end)
end

local function connect()
	connect_global()
	connect_client()
end

return { connect = connect }
