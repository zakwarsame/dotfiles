require('codecompanion').setup {
  adapters = {

    anthropic = function()
      return require('codecompanion.adapters').extend('openai', {
        url = 'http://127.0.0.1:8787/v1/chat/completions',
        env = {
          api_key = function()
            return os.getenv 'ANTHROPIC_API_KEY'
          end,

          -- model = 'anthropic:claude-3-5-sonnet',
        },
        schema = {
          model = {
            default = 'anthropic:claude-3-5-sonnet-20241022',
          },
        },
      })
    end,
  },
  -- schema = {
  --   model = {
  --     default = 'anthropic:claude-3-5-sonnet',
  --   },
  -- },

  strategies = {
    chat = {
      adapter = 'anthropic',
    },
    inline = {
      adapter = 'anthropic',
    },
    agent = {
      adapter = 'anthropic',
    },
  },
}

vim.api.nvim_set_keymap('n', '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-a>', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>a', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd [[cab cc CodeCompanion]]
