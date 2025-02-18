---@module "snacks"
return {

  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
      explorer = {},
      lazygit = { enabled = true },
    },
    config = function()
      require 'custom.snacks'
    end,
  },
  -- lazy.nvim
}
