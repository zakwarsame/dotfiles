return {
  config = function()
    -- Which-key keymaps
    local wk = require 'which-key'
    wk.add {
      -- [LEADER] mappings
      { '<leader>c', icon = '󰆩 ', group = '[C]ode' },
      { '<leader>d', icon = '󰈙 ', group = '[D]ocument' },
      { '<leader>r', icon = '󰑕 ', group = '[R]ename' },
      { '<leader>s', icon = '󰍉 ', group = '[S]earch' },
      { '<leader>w', icon = '󱂬 ', group = '[W]orkspace' },
      { '<leader>t', icon = '󰔡 ', group = '[T]oggle' },
      {
        mode = { 'n', 'v' }, -- NORMAL and VISUAL mode
        { '<leader>h', icon = '󰊢 ', desc = 'Git [H]unk' },
      },
    }
  end,
}
