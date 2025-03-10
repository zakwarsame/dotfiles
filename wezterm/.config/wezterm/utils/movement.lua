local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

local direction_keys = {
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
	LeftArrow = utf8.char(0xB1),  -- resize left
	RightArrow = utf8.char(0xB2), -- resize right
	UpArrow = utf8.char(0xB3),    -- resize up
	DownArrow = utf8.char(0xB4),  -- resize down
}

local function get_platform_mods()
	if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
		return "CMD"
	else
		return "ALT"
	end
end

local function get_mods(resize_or_move, key)
	if resize_or_move == "resize" then
		return "SHIFT"
	elseif key == ";" or key == "'" then
		return "CTRL"
	else
		return ""
	end
end

local function split_nav(resize_or_move, key)
	local mod = resize_or_move == "resize" and get_platform_mods() or ""
	return {
		key = key,
		mods = mod,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				if resize_or_move == "resize" then
					-- Send special char for Neovim to interpret
					win:perform_action({
						SendKey = { key = resize_chars[key], mods = "" },
					}, pane)
				else
					-- For movement, just pass the arrow key
					win:perform_action({
						SendKey = { key = key, mods = "" },
					}, pane)
				end
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

function module.apply_to_config(config)
	local keys = {
		-- move between split panes
		split_nav("move", "LeftArrow"),
		split_nav("move", "RightArrow"),
		split_nav("move", "UpArrow"),
		split_nav("move", "DownArrow"),
		-- resize panes
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
