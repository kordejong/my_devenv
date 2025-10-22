local wezterm = require("wezterm")
-- local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- local project = require("project")

local config = wezterm.config_builder()

config.font_size = 15
config.color_scheme = "nord"
config.enable_tab_bar = false

-- https://wezterm.org/config/lua/wezterm/index.html
-- e.g.: wezterm.home_dir
wezterm.log_info("hostname: " .. wezterm.hostname())

-- -- Switch to the last active tab when I close a tab
-- config.switch_to_last_active_tab_when_closing_tab = true

-- config.window_background_opacity = 0.9

-- config.window_decorations = "RESIZE"
config.window_padding = {
	top = 10,
	bottom = 10,
	left = 10,
	right = 10,
}

-- If a character requires hitting the shift key normally, such as any of the
-- symbols above the numeric keys, or even keys like ?, <, >, the | and {/}
-- symbols, the SHIFT mod MUST be included! (really?)

-- Turn all defaults off
-- config.disable_default_key_bindings = true

-- CTRL|SHIFT - p: command palette

local function move_pane(key, direction)
	return { mods = "LEADER", key = key, action = wezterm.action.ActivatePaneDirection(direction) }
end

local function resize_pane(key, direction)
	return { key = key, action = wezterm.action.AdjustPaneSize({ direction, 1 }) }
end

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Tab management
	{ mods = "LEADER", key = "c", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ mods = "LEADER", key = "p", action = wezterm.action.ActivateTabRelative(-1) },
	{ mods = "LEADER", key = "n", action = wezterm.action.ActivateTabRelative(1) },

	-- Pane / split mangement
	{ mods = "LEADER", key = "-", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "=", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "z", action = wezterm.action.TogglePaneZoomState },

	move_pane("h", "Left"),
	move_pane("j", "Down"),
	move_pane("k", "Up"),
	move_pane("l", "Right"),

	-- When we push LEADER + r...
	-- Activate the `resize_panes` keytable
	{
		mods = "LEADER",
		key = "r",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_panes",
			-- Ensures the keytable stays active after it handles its
			-- first keypress.
			one_shot = false,
			-- Deactivate the keytable after a timeout.
			timeout_milliseconds = 1000,
		}),
	},

	-- Activate VI mode (CTRL-C to exit)
	{ mods = "LEADER", key = "[", action = wezterm.action.ActivateCopyMode },

	-- -- Show list of workspaces
	-- { mods = "LEADER", key = "s", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },

	-- TODO: key already mapped
	-- -- Present our project picker
	-- { mods = "LEADER", key = "p", action = project.choose_project() },

	-- -- Present a list of existing workspaces
	-- { mods = "LEADER", key = "f", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	-- CTRL-SHIFT-d activates the debug overlay
	{ mods = "CTRL", key = "D", action = wezterm.action.ShowDebugOverlay },

	-- ...
}

-- Select tab by number
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_panes = {
		resize_pane("j", "Down"),
		resize_pane("k", "Up"),
		resize_pane("h", "Left"),
		resize_pane("l", "Right"),
	},
}

config.ssh_domains = wezterm.default_ssh_domains()

for _, domain in ipairs(config.ssh_domains) do
	domain.remote_wezterm_path = "/home/kor/opt/bin/wezterm"
end

-- smart_splits.apply_to_config(config)
-- smart_splits.apply_to_config(config, {
-- the default config is here, if you'd like to use the default keys,
-- you can omit this configuration table parameter and just use
-- smart_splits.apply_to_config(config)

-- -- directional keys to use in order of: left, down, up, right
-- direction_keys = { 'h', 'j', 'k', 'l' },
-- -- if you want to use separate direction keys for move vs. resize, you
-- -- can also do this:
-- direction_keys = {
--   move = { 'h', 'j', 'k', 'l' },
--   resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
-- },
-- -- modifier keys to combine with direction_keys
-- modifiers = {
--   move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
--   resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
-- },
-- log level to use: info, warn, error
-- log_level = "info",
-- })

return config
