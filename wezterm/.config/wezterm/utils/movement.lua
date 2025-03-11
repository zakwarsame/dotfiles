local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

local direction_keys = {
	h = "Left",
	l = "Right",
	k = "Up",
	j = "Down",
}

local arrow_direction_keys = {
	LeftArrow = "Left",
	RightArrow = "Right",
	UpArrow = "Up",
	DownArrow = "Down",
}

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

-- Special chars we'll send to Neovim for resize operations
local resize_chars = {
	LeftArrow = utf8.char(0xB1), -- resize left
	RightArrow = utf8.char(0xB2), -- resize right
	UpArrow = utf8.char(0xB3), -- resize up
	DownArrow = utf8.char(0xB4), -- resize down
}

-- Special chars we'll send to Neovim for movement operations
local movement_chars = {
	h = utf8.char(0xC1), -- move left
	l = utf8.char(0xC2), -- move right
	k = utf8.char(0xC3), -- move up
	j = utf8.char(0xC4), -- move down
}

local function get_platform_mods()
	if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
		return "CMD"
	else
		return "ALT"
	end
end

local function split_nav(resize_or_move, key)
	local mod = get_platform_mods()
	if resize_or_move == "resize" then
		-- Keep the original arrow key based resize logic
		return {
			key = key,
			mods = mod,
			action = wezterm.action_callback(function(win, pane)
				if is_vim(pane) then
					-- Send special char for Neovim to interpret
					win:perform_action({
						SendKey = { key = resize_chars[key], mods = "" },
					}, pane)
				else
					win:perform_action({ AdjustPaneSize = { arrow_direction_keys[key], 3 } }, pane)
				end
			end),
		}
	else
		-- Movement logic using hjkl
		return {
			key = key,
			mods = mod,
			action = wezterm.action_callback(function(win, pane)
				if is_vim(pane) then
					-- For movement in Neovim, send special character
					win:perform_action({
						SendKey = { key = movement_chars[key], mods = "" },
					}, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end),
		}
	end
end

function module.apply_to_config(config)
	local keys = {
		-- move between split panes using hjkl
		split_nav("move", "h"),
		split_nav("move", "l"),
		split_nav("move", "k"),
		split_nav("move", "j"),
		-- resize panes (keeping arrow keys)
		split_nav("resize", "LeftArrow"),
		split_nav("resize", "RightArrow"),
		split_nav("resize", "UpArrow"),
		split_nav("resize", "DownArrow"),
		-- tab navigation with Alt+Shift+[ and Alt+Shift+]
		{
			key = "{",
			mods = "ALT|SHIFT",
			action = act.ActivateTabRelative(-1),
		},
		{
			key = "}",
			mods = "ALT|SHIFT",
			action = act.ActivateTabRelative(1),
		},
	}

	-- Add Alt+1,2,3... for direct tab selection
	for i = 1, 9 do
		table.insert(keys, {
			key = tostring(i),
			mods = "ALT",
			action = act.ActivateTab(i - 1),
		})
	end

	if not config.keys then
		config.keys = {}
	end
	for _, k in ipairs(keys) do
		table.insert(config.keys, k)
	end
end

return module
