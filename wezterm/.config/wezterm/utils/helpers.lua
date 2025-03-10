local wezterm = require("wezterm")
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "tokyonight"
	else
		return "tokyonight-day"
	end
end

local function get_theme_config(appearance)
	local scheme = scheme_for_appearance(appearance)
	local overlay_color = appearance:find("Dark")
		and "rgba(28, 33, 39, 0.81)" -- Dark overlay
		or "rgba(255, 255, 255, 0.91)" -- Light overlay

	return {
		color_scheme = scheme,
		background = {
			{
				source = {
					File = wezterm.home_dir .. "/dotfiles/wezterm/wallpapers/landscape.png",
				},
			},
			{
				source = {
					Color = overlay_color,
				},
				height = "100%",
				width = "100%",
			},
		}
	}
end

local module = {
	apply_to_config = function(config)
		config.set_environment_variables = {
			PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
		}
		-- appearance
		local appearance = get_appearance()
		local theme_config = get_theme_config(appearance)
		config.color_scheme = theme_config.color_scheme
		config.background = theme_config.background

		config.font_size = 18.0
		config.font = wezterm.font("JetBrains Mono", { weight = "Regular", italic = false })

		config.window_close_confirmation = "AlwaysPrompt"
		config.window_decorations = "RESIZE"
		config.default_cursor_style = "BlinkingBar"
		config.macos_window_background_blur = 40
		config.window_background_opacity = 0.8

		-- top bar
		config.hide_tab_bar_if_only_one_tab = false
		config.tab_bar_at_bottom = true
		config.use_fancy_tab_bar = false
		config.tab_and_split_indices_are_zero_based = true
		config.tab_max_width = 32

		-- Listen for theme changes
		wezterm.on("window-config-reloaded", function(window, pane)
			local overrides = window:get_config_overrides() or {}
			local new_appearance = window:get_appearance()
			local new_theme_config = get_theme_config(new_appearance)

			overrides.color_scheme = new_theme_config.color_scheme
			overrides.background = new_theme_config.background
			window:set_config_overrides(overrides)
		end)

		-- keybindings
		local act = wezterm.action
		local mods
		if wezterm.target_triple == "aarch64-apple-darwin" then
			mods = "CMD"
		elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
			mods = "ALT"
		elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
			mods = "ALT"
		end

		-- fzf with scrollback - copies selected text to clipboard without printing
		wezterm.on("trigger-fzf-with-scrollback", function(window, pane)
			local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

			local name = os.tmpname()
			local f = io.open(name, "w+")
			f:write(text)
			f:flush()
			f:close()

			local shell_command = 'selected=$(tac "' .. name .. "\" | sed 's/^[ \\t]*//;s/[ \\t]*$//' | fzf); "
			shell_command = shell_command .. 'echo "$selected" | ( '
			shell_command = shell_command .. "if command -v wl-copy >/dev/null 2>&1; then wl-copy; "
			shell_command = shell_command .. "elif command -v pbcopy >/dev/null 2>&1; then pbcopy; "
			shell_command = shell_command .. "elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard; "
			shell_command = shell_command .. 'else echo "No clipboard command found" >&2; fi )\n'

			-- Send the command to the pane
			pane:send_text(shell_command)

			wezterm.sleep_ms(1000)
			os.remove(name)
		end)

		-- not working on wayland
		config.enable_wayland = false
		local keys = {
			{
				key = "w",
				mods = mods,
				action = act.CloseCurrentPane({ confirm = false }),
			},
			{
				key = "r",
				mods = mods,
				action = wezterm.action.ReloadConfiguration,
			},

			{
				key = "/",
				mods = mods,
				action = wezterm.action.EmitEvent("trigger-fzf-with-scrollback"),
			},

			-- CTRL-SHIFT-l activates the debug overlay
			{ key = "L", mods = mods, action = wezterm.action.ShowDebugOverlay },

			{
				key = "t",
				mods = mods,
				action = act.SpawnTab("CurrentPaneDomain"),
			},
			{
				key = "n",
				mods = mods,
				action = act.SpawnWindow,
			},
			{
				key = "Enter",
				mods = mods,
				action = act.SplitPane({
					direction = "Right",
				}),
			},
			{
				key = "Enter",
				mods = mods .. "|SHIFT",
				action = act.SplitPane({
					direction = "Down",
				}),
			},
			{
				key = "[",
				mods = mods,
				action = act.ActivatePaneDirection("Prev"),
			},
			{
				key = "]",
				mods = mods,
				action = act.ActivatePaneDirection("Next"),
			},

			-- Commenting out conflicting movement bindings
			-- {
			-- 	key = "h",
			-- 	mods = mods,
			-- 	action = act.ActivatePaneDirection("Left"),
			-- },
			-- {
			-- 	key = "j",
			-- 	mods = mods,
			-- 	action = act.ActivatePaneDirection("Down"),
			-- },
			-- {
			-- 	key = "k",
			-- 	mods = mods,
			-- 	action = act.ActivatePaneDirection("Up"),
			-- },
			-- {
			-- 	key = "l",
			-- 	mods = mods,
			-- 	action = act.ActivatePaneDirection("Right"),
			-- },

			{
				key = "c",
				mods = mods,
				action = wezterm.action_callback(function(window, pane)
					local sel = window:get_selection_text_for_pane(pane)
					if not sel or sel == "" then
						window:perform_action(wezterm.action.SendKey({ key = "c", mods = mods }), pane)
					else
						window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
					end
				end),
			},
			{
				key = ",",
				mods = "SUPER",
				action = wezterm.action.SpawnCommandInNewTab({
					cwd = wezterm.home_dir,
					args = { "nvim", wezterm.config_file },
				}),
			},
			-- {
			--   key = 'v',
			--   mods = mods,
			--   action = wezterm.action_callback(function(window, pane)
			--     window:perform_action(wezterm.action.SendKey { key = 'v', mods = mods }, pane)
			--   end),
			-- },
			-- {
			--   key = 'V',
			--   mods = mods,
			--   action = wezterm.action_callback(function(window, pane)
			--     window:perform_action(wezterm.action.SendKey { key = 'v', mods = mods }, pane)
			--   end),
			-- },
			-- { key = 'c', mods = 'ALT', action = wezterm.action.Copy },
			{ key = "v", mods = mods, action = wezterm.action.PasteFrom("Clipboard") },

			-- { key = 'v', mods = mods, action = wezterm.action.PasteFrom },
		}

		return keys
	end,
}

return module
