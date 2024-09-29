return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },

  config = function()
    require 'custom.formatter'
  end,
}
