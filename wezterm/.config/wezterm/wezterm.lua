local wezterm = require("wezterm")
local helpers = require("utils/helpers")
local ssh = require("utils/ssh")
local multiplexing = require("utils/multiplexing")
local movement = require("utils/movement")

local config = {}

ssh.apply_to_config(config)
local helper_keys = helpers.apply_to_config(config)
local multiplexing_keys = multiplexing.apply_to_config(config)

-- Include movement_keys in config.keys aggregation
config.keys = {}
local key_sources = { helper_keys, multiplexing_keys }
for _, key_list in ipairs(key_sources) do
	for _, key in ipairs(key_list) do
		table.insert(config.keys, key)
	end
end

-- Remove conflicting keybindings in WezTerm
-- For example, avoid using CTRL+h/j/k/l in WezTerm
-- ... existing code ...

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "IS_NVIM" then
		wezterm.log_info("IS_NVIM changed: " .. tostring(value))
	end
end)

movement.apply_to_config(config)

return config
