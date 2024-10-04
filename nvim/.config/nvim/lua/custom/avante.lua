local openai = require("avante.providers.openai")

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
      -- insert = '<C-c>',
      -- use ctrl + enter to submit
      insert = '<C-CR>',
    },
  },
  hints = {
    enabled = false,
  },
  provider = 'my_proxy', -- Name of your custom provider
  vendors = {
    ['my_proxy'] = {
      endpoint = 'http://127.0.0.1:8787/v3/v1/', -- Full endpoint URL
      model = 'anthropic:claude-3-5-sonnet',
      api_key_name = 'ANTHROPIC_API_KEY', -- Env variable with your API key
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
