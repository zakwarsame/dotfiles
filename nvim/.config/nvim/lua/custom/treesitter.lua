local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true })

  require('nvim-treesitter').setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'tsx', 'python', 'rust', 'toml', 'nix' },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  }

  -- indent = { enable = true }
  -- sync_install = false
  -- highlight = { enable = true, custom_captures = {} }
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      local parsers = require 'nvim-treesitter.parsers'

      parsers.lua = {
        tier = 0,

        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          path = '~/plugins/tree-sitter-lua',
          files = { 'src/parser.c', 'src/scanner.c' },
        },
      }
    end,
  })
end

M.setup()

return M
