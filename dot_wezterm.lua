-- import deps
local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
-- end of import deps

-- padding issues
local center_content = function(window, pane)
	local overrides = window:get_config_overrides() or {}

	if pane:is_alt_screen_active() then
		overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
		window:set_config_overrides(overrides)
		return
	end

	local win_dim = window:get_dimensions()
	local tab_dim = pane:tab():get_size()
	local padding_left = (win_dim.pixel_width - tab_dim.pixel_width) / 2
	local padding_top = (win_dim.pixel_height - tab_dim.pixel_height) / 2
	local new_padding = {
		left = padding_left,
		right = 0,
		top = padding_top,
		bottom = 0,
	}
	if overrides.window_padding and new_padding.left == overrides.window_padding.left then
		return
	end
	overrides.window_padding = new_padding
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", center_content)
wezterm.on("window-config-reloaded", center_content)

config.use_resize_increments = true

-- color schemes
config.color_scheme = "catppuccin-macchiato"

-- tabs stuff
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- decoration
config.window_decorations = "RESIZE"

-- background stuff
--[[ config.background = {
	{
		source = {
			File = "./wp.jpg",
		},
		hsb = { brightness = 0.1 },
	},
} ]]

-- keybindings
config.keys = {
	{
		key = "R",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = ",",
		mods = "CMD",
		action = act.SpawnCommandInNewTab({
			cwd = os.getenv("WEZTERM_CONFIG_DIR"),
			set_environment_variables = {
				TERM = "screen-256color",
			},
			args = {
				"/usr/bin/nvim",
				os.getenv("WEZTERM_CONFIG_FILE"),
			},
		}),
	},
}

config.font = wezterm.font("CommitMono")

return config
