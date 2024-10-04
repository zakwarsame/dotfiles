local openai = require 'avante.providers.openai'

require('avante').setup {
  mappings = {
    ask = '<leader>;a',
    edit = '<leader>;e',
    refresh = '<leader>;r',
    toggle = {
      debug = '<leader>;d',
      hint = '<leader>;h',
    },
    submit = {
      insert = '<C-CR>',
    },

    suggestion = {
      accept = '<C-y>',
      next = '<C-n>',
      prev = '<C-p>',
    },
  },
  behaviour = {
    auto_suggestions = true,
  },
  hints = {
    enabled = false,
  },
  provider = 'local_proxy',
  auto_suggestions_provider = 'local_proxy',
  vendors = {
    ['local_proxy'] = {
      endpoint = 'http://127.0.0.1:8787/v3/v1/',
      model = 'anthropic:claude-3-5-sonnet',
      api_key_name = 'ANTHROPIC_API_KEY',
      parse_curl_args = openai.parse_curl_args,
      parse_response_data = openai.parse_response,
    },
  },
}

local avante_group = vim.api.nvim_create_augroup('AvanteSettings', {})

vim.api.nvim_create_autocmd('FileType', {
  group = avante_group,
  pattern = { 'Avante', 'AvanteInput' },
  callback = function()
    vim.opt_local.breakindent = false
    vim.opt_local.wrap = true
  end,
})
