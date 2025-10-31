local wezterm = require("wezterm")
local session_manager = require("wezterm-session-manager/session-manager")

local config = {}

local color_schemes = {
	"tokyonight_night",
	"GruvboxDark",
	"GruvboxDarkHard",
	"rose-pine",
}

config.color_scheme = color_schemes[3]

config.window_decorations = "RESIZE"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 15

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.scrollback_lines = 5000

local opacity = true
if opacity then
	config.window_background_opacity = 0.98
	config.window_background_image = ""
	config.window_background_image_hsb = {
		brightness = 0.015,
		hue = 1.0,
		saturation = 1.0,
	}
end

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.status_update_interval = 2000
config.window_close_confirmation = "NeverPrompt"

local mux = wezterm.mux

local function session_info(window)
	local ws = window:mux_window():get_workspace()

	local domain = mux.get_domain("unix")
	local state = "Detached"
	if domain then
		state = domain:state()
	end

	return ws, state
end

wezterm.on("gui-startup", function(cmd)
	session_manager.initialize_workspaces()
end)

wezterm.on("update-status", function(window, pane)
	local ws, state = session_info(window)
	-- local label = string.format("[%s]  |  [%s]", ws, state)
	local label = string.format("[%s]", ws)

	-- Escreve na lateral esquerda da barra de abas
	window:set_right_status(wezterm.format({
		{ Text = " " .. label .. " " },
	}))
end)

-- https://mwop.net/blog/2024-07-04-how-i-use-wezterm.html
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)

local act = wezterm.action

config.keys = {

	-- rename current tab
	{
		key = "t",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "rename tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

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

	-- sessions
	-- Rename current session
	{
		key = "r",
		mods = "ALT|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},

	-- Show list of workspaces
	{
		key = "c",
		mods = "ALT",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},

	-- Session manager bindings
	{
		key = "s",
		mods = "ALT|SHIFT",
		action = act({ EmitEvent = "save_session" }),
	},
	{
		key = "c",
		mods = "ALT|SHIFT",
		action = act({ EmitEvent = "load_session" }),
	},
	{
		key = "r",
		mods = "ALT",
		action = act({ EmitEvent = "restore_session" }),
	},
}

return config
