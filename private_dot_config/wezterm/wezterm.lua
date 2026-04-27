-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Colors (Matching Alacritty import)
config.color_scheme = "Catppuccin Macchiato"

-- Font Configuration
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 14.0
-- config.font_shaper = "Harfbuzz" -- Rendu plus précis et souvent plus fin

-- Rendering (Proche d'Alacritty)
config.front_end = "WebGpu" -- Meilleur rendu sur macOS
-- config.cell_width = 1.0   -- Valeur par défaut d'Alacritty
-- config.line_height = 1.0  -- Valeur par défaut d'Alacritty

-- Window/UI
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Custom tab titles: better names and more space
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title

	-- Use directory name if title is just the shell
	if title == "zsh" or title == "bash" or title == "sh" then
		local uri = tab.active_pane.current_working_dir
		if uri then
			local path = uri.file_path
			if path == os.getenv("HOME") then
				title = "~"
			else
				title = path:gsub("(.*[/\\])(.*)", "%2")
			end
		end
	end

	if tab.tab_title and #tab.tab_title > 0 then
		title = tab.tab_title
	end

	local index = tab.tab_index + 1
	-- Padding: 3 spaces on each side for "more space"
	return {
		{ Text = string.format("   %d: %s   ", index, title) },
	}
end)
config.adjust_window_size_when_changing_font_size = false -- Évite les sauts de taille et les espaces vides

-- Indexing base
config.tab_and_split_indices_are_zero_based = false

-- Smart pane navigation (vim-tmux-navigator style)
local function is_vim(pane)
	-- This checks if the foreground process is vim or nvim
	local process_name = pane:get_foreground_process_name()
	return process_name:find("n?vim") ~= nil or process_name:find("fzf") ~= nil or process_name:find("tmux") ~= nil
end

local function direction_keys(key, direction)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				window:perform_action({
					SendKey = { key = key, mods = "CTRL" }
				}, pane)
			else
				window:perform_action({ ActivatePaneDirection = direction }, pane)
			end
		end),
	}
end

-- Keyboard / macOS specific (Alacritty: option_as_alt = "OnlyLeft")
-- Left Option key acts as Alt, Right Option key acts as Option (for special characters)
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Keybindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "N",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnWindow,
	},
	-- Smart navigation for panes
	direction_keys("h", "Left"),
	direction_keys("j", "Down"),
	direction_keys("k", "Up"),
	direction_keys("l", "Right"),

	-- tmux-like multiplexing
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "H",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	-- Window navigation (tabs in WezTerm)
	{
		key = "h",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- Session/Workspace navigation
	{
		key = "c",
		mods = "LEADER|CTRL",
		action = wezterm.action.SwitchToWorkspace,
	},
	{
		key = "f",
		mods = "LEADER|CTRL",
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	-- Send Ctrl-a to the application when pressing Ctrl-a twice
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	-- Paste from clipboard
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	-- Rename Tab (Window)
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename Tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Rename Workspace (Session)
	{
		key = "$",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename Workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(window:active_workspace(), line)
				end
			end),
		}),
	},
}

-- Add number keys for tab navigation (Prefix + 1..9)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- and finally, return the configuration to wezterm
return config
