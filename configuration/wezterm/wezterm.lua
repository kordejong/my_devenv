-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html

-- -- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28
--
-- -- or, changing the font size and color scheme.
-- config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 15
config.color_scheme = "nord"

config.enable_tab_bar = false

-- -- Switch to the last active tab when I close a tab
-- config.switch_to_last_active_tab_when_closing_tab = true

-- config.window_decorations = "RESIZE"
config.window_padding = {
	top = 10,
	bottom = 10,
	left = 10,
	right = 10,
}

-- If a character requires hitting the shift key normally, such as any of the
-- symbols above the numeric keys, or even keys like ?, <, >, the | and {/}
-- symbols, the SHIFT mod MUST be included!

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

	{ mods = "LEADER", key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
	{ mods = "LEADER", key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
	{ mods = "LEADER", key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
	{ mods = "LEADER", key = "l", action = wezterm.action.ActivatePaneDirection("Right") },

	{ mods = "CTRL|SHIFT", key = "H", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
	{ mods = "CTRL|SHIFT", key = "J", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },
	{ mods = "CTRL|SHIFT", key = "K", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
	{ mods = "CTRL|SHIFT", key = "L", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },

	-- Activate VI mode (CTRL-C to exit)
	{ mods = "LEADER", key = "[", action = wezterm.action.ActivateCopyMode },

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

config.ssh_domains = wezterm.default_ssh_domains()

for _, domain in ipairs(config.ssh_domains) do
	domain.remote_wezterm_path = "/home/kor/opt/bin/wezterm"
end

-- Finally, return the configuration to wezterm:
return config
