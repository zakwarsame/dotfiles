local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

local direction_keys = {
	LeftArrow = "Left",
	RightArrow = "Right",
	UpArrow = "Up",
	DownArrow = "Down",
	[";"] = "Up",
	["'"] = "Down",
}

local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local function get_platform_mods()
	if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
		return "CMD", "ALT"
	else
		return "ALT", "ALT|SHIFT"
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
	return {
		key = key,
		mods = get_mods(resize_or_move, key),
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				if key == ";" or key == "'" then
					win:perform_action({
						SendKey = { key = key, mods = "CTRL" },
					}, pane)
				else
					-- For arrow keys, send with SHIFT if resizing
					win:perform_action({
						SendKey = { key = key, mods = resize_or_move == "resize" and "SHIFT" or "" },
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
		split_nav("move", ";"),
		split_nav("move", "'"),
		-- resize panes
		split_nav("resize", "LeftArrow"),
		split_nav("resize", "RightArrow"),
		split_nav("resize", "UpArrow"),
		split_nav("resize", "DownArrow"),
	}

	if not config.keys then
		config.keys = {}
	end
	for _, k in ipairs(keys) do
		table.insert(config.keys, k)
	end
end

return module
