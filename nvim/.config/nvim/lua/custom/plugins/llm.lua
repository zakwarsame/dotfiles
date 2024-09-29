return {
  {
    dir = '../../llm.lua',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local system_prompt =
        'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
      local helpful_prompt =
        'You are a helpful assistant. You are a code oriented, Principal Software Engineer at a FAANG company. Keep your answers brief, precise, accurate and to the point. Follow what I have sent are my notes so far.'
      local llm = require 'custom.llm'

      local function openai_replace()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'gpt-4o',
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = system_prompt,
          replace = true,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      local function openai_help()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'gpt-4o',
          api_key_name = 'OPENAI_API_KEY',
          system_prompt = helpful_prompt,
          replace = false,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      local function anthropic_help()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'anthropic:claude-3-5-sonnet',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = helpful_prompt,
          replace = false,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      local function anthropic_replace()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'anthropic:claude-3-5-sonnet',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = system_prompt,
          replace = true,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>L', anthropic_help, { desc = 'llm anthropic_help' })
      vim.keymap.set({ 'n', 'v' }, '<leader>l', anthropic_replace, { desc = 'llm anthropic' })
      vim.keymap.set({ 'n', 'v' }, '<leader>P', openai_help, { desc = 'llm openai' })
      vim.keymap.set({ 'n', 'v' }, '<leader>p', openai_replace, { desc = 'llm openai' })
    end,
  },
}
