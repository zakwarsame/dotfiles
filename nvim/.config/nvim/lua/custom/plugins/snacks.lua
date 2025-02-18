return {
  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
      explorer = { enabled = true },
      lazygit = { enabled = true },
    },
    config = function()
      require 'custom.snacks'
    end,
  },
}
