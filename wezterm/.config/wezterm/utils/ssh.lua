local wezterm = require("wezterm")

local leader = { key = ".", mods = "ALT", timeout_milliseconds = 2000 }

local module = {
	leader = leader,

	apply_to_config = function(config)
		config.leader = leader
		local act = wezterm.action

		-- ocean icon when leader key is active
		wezterm.on("update-right-status", function(window, _)
			local SOLID_LEFT_ARROW = ""
			local ARROW_FOREGROUND = { Foreground = { Color = "#565f89" } }
			local prefix = ""

			if window:leader_is_active() then
				prefix = " " .. utf8.char(0x1f30a) -- ocean wave
				SOLID_LEFT_ARROW = utf8.char(0xe0b2)
			end

			if window:active_tab():tab_id() ~= 0 then
				ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
			end -- arrow color based on if tab is first pane

			window:set_left_status(wezterm.format({
				{ Background = { Color = "#c3e88d" } },
				{ Text = prefix },
				ARROW_FOREGROUND,
				{ Text = SOLID_LEFT_ARROW },
			}))
		end)

		-- config.ssh_domains = {
		-- {
		-- 	-- This name identifies the domain
		-- 	name = "my.server",
		-- 	-- The hostname or address to connect to. Will be used to match settings
		-- 	-- from your ssh config file
		-- 	remote_address = "192.168.1.1",
		-- 	-- The username to use on the remote host
		-- 	username = "wez",
		-- },

		-- }

		config.unix_domains = {
			{
				name = "unix",
			},
		}
		return {}
	end,
}

return module
