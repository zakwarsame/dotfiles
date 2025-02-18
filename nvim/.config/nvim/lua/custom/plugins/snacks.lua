---@module "snacks"
return {

  {
    'folke/snacks.nvim',
    opts = {
      lazygit = {
        -- your lazygit configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
      explorer = {},
    },
    config = function()
      require 'custom.snacks'
    end,
  },
  -- lazy.nvim
}
