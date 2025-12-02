local wezterm = require("wezterm")
local session_manager = require("wezterm-session-manager/session-manager")
local split = require("splits")

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
	-- not using bg image
	-- config.window_background_image = ""
	-- config.window_background_image_hsb = {
	-- 	brightness = 0.015,
	-- 	hue = 1.0,
	-- 	saturation = 1.0,
	-- }
end

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.status_update_interval = 2000
config.window_close_confirmation = "NeverPrompt"

config.unix_domains = {
	{
		name = "unix",
	},
}

local mux = wezterm.mux

local function session_info(window)
	if not window then
		return "Unknown", "Detached"
	end

	-- local ws = window:mux_window():get_workspace()

	local mux_window = window:mux_window()
	local success, ws = pcall(function()
		return mux_window:get_workspace()
	end)

	if not success then
		return "Unknown", "Detached"
	end

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
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)
wezterm.on("show-workspace-selector", function(window, pane)
	session_manager.load_state(window)
end)
wezterm.on("rename_session", function(window)
	session_manager.rename_state(window)
end)
wezterm.on("delete_session", function(window)
	session_manager.delete_state(window)
end)

local act = wezterm.action

config.keys = {

	-- move between split panes
	split.split_nav("move", "h", wezterm),
	split.split_nav("move", "j", wezterm),
	split.split_nav("move", "k", wezterm),
	split.split_nav("move", "l", wezterm),
	-- resize panes
	split.split_nav("resize", "h", wezterm),
	split.split_nav("resize", "j", wezterm),
	split.split_nav("resize", "k", wezterm),
	split.split_nav("resize", "l", wezterm),

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

	-- maximize one window
	{
		key = "m",
		mods = "ALT",
		action = act.TogglePaneZoomState,
	},

	-- activate copy mode or vim mode
	{
		key = "v",
		mods = "ALT|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local function is_vim()
				return pane:get_user_vars().IS_NVIM == "true"
			end

			if is_vim() then
				-- pass the keys through to vim/nvim
				window:perform_action(wezterm.action.SendKey({ key = "v", mods = "ALT|SHIFT" }), pane)
			else
				-- activate copy/vim mode on terminal
				window:perform_action(wezterm.action.ActivateCopyMode, pane)
			end
		end),
	},

	-- sessions

	-- Attach to unix domain
	{
		key = "a",
		mods = "ALT",
		action = act.AttachDomain("unix"),
	},

	{
		key = "d",
		mods = "ALT",
		action = act.DetachDomain({ DomainName = "unix" }),
	},

	{
		key = "r",
		mods = "ALT|SHIFT",
		action = act({ EmitEvent = "rename_session" }),
	},

	-- Session manager bindings
	{
		key = "s",
		mods = "ALT|SHIFT",
		action = act({ EmitEvent = "save_session" }),
	},
	-- Show list of workspaces
	{
		key = "c",
		mods = "ALT",
		action = act({ EmitEvent = "show-workspace-selector" }),
	},
	-- restore previous session manually
	{
		key = "r",
		mods = "ALT",
		action = act({ EmitEvent = "restore_session" }),
	},
	-- delete saved workspace
	{
		key = "d",
		mods = "ALT|SHIFT",
		action = act({ EmitEvent = "delete_session" }),
	},
}

return config
