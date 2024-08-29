local wezterm = require("wezterm")
local config = {}

local color_schemes = {
	"tokyonight_night",
	"GruvboxDark",
	"GruvboxDarkHard",
    "rose-pine"
}

config.color_scheme = color_schemes[3]

config.window_frame = {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 14,
}

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- config.window_background_opacity = 0.85

-- config.window_background_image = ""
-- config.window_background_image_hsb = {
-- 	brightness = 0.015,
-- 	hue = 1.0,
-- 	saturation = 1.0,
-- }

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_close_confirmation = "NeverPrompt"

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	---@diagnostic disable-next-line: unused-local
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local act = wezterm.action

config.keys = {

	-- split term
	{
		key = "n",
		mods = "ALT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "N",
		mods = "ALT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- move between splits
	{
		key = "h",
		mods = "ALT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "ALT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "ALT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "ALT",
		action = act.ActivatePaneDirection("Down"),
	},

	-- resize splits
	{
		key = "h",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "l",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "k",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "j",
		mods = "ALT|SHIFT",
		action = act.AdjustPaneSize({ "Down", 1 }),
	},
}

return config
