local wezterm = require("wezterm")

local module = {
	apply_to_config = function()
		local act = wezterm.action
		local multiplexing_keys = {
			-- scrollback
			{
				key = "[",
				mods = "LEADER",
				action = act.ActivateCopyMode,
			},
			-- fullscreen
			{
				key = "f",
				mods = "LEADER",
				action = act.TogglePaneZoomState,
			},

      {
        -- swap
        key = "{",
        mods = "LEADER|SHIFT",
        action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
      },

      --open wezterm config
      {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
          description = "Enter new name for tab",
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              window:active_tab():set_title(line)
            end
          end),
        }),
      },
      {
        key = "w",
        mods = "LEADER",
        action = act.ShowTabNavigator,
      },

      -- sessions stuff

      -- Attach to muxer
      {
        key = "a",
        mods = "LEADER",
        action = act.AttachDomain("unix"),
      },

      -- Detach from muxer
      {
        key = "d",
        mods = "LEADER",
        action = act.DetachDomain({ DomainName = "unix" }),
      },
      -- Rename current session; analagous to command in tmux
      {
        key = "$",
        mods = "LEADER|SHIFT",
        action = act.PromptInputLine({
          description = "Enter new name for session",
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              mux.rename_workspace(window:mux_window():get_workspace(), line)
            end
          end),
        }),
      },
      -- Show list of workspaces
      {
        key = "s",
        mods = "LEADER",
        action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
      },
    }

    return multiplexing_keys
  end,
}

return module
