local wezterm = require("wezterm")
local helpers = require("utils/helpers")
local ssh = require("utils/ssh")
local multiplexing = require("utils/multiplexing")

local config = {}

ssh.apply_to_config(config)
local helper_keys = helpers.apply_to_config(config)
local multiplexing_keys = multiplexing.apply_to_config(config)

config.keys = helper_keys
for _, key in ipairs(multiplexing_keys) do
	table.insert(config.keys, key)
end

return config
