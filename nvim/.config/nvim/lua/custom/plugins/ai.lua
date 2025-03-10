return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/custom',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local system_prompt =
        'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks'
      local helpful_prompt =
        'You are a helpful assistant. You are a code oriented, Principal Software Engineer at a FAANG company. Follow what I have sent are my notes so far. ALWAYS use backticks/codeblocks (```) when generating specific code/quotes. Please keep your answers brief, concise and as accurate as possible (think through them).'
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
          model = 'LLM_MODEL',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = helpful_prompt,
          replace = false,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      local function anthropic_replace()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'LLM_MODEL',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = system_prompt,
          replace = true,
        }, llm.make_spec_curl_args, llm.handle_spec_data)
      end

      local function non_proxy_anthropic_replace()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'LLM_MODEL',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = system_prompt,
          replace = true,
        }, llm.make_anthropic_spec_curl_args, llm.handle_anthropic_spec_data)
      end

      local function non_proxy_anthropic_help()
        llm.invoke_llm_and_stream_into_editor({
          url = 'LLM_PROXY',
          model = 'LLM_MODEL',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = helpful_prompt,
          replace = false,
        }, llm.make_anthropic_spec_curl_args, llm.handle_anthropic_spec_data)
      end

      vim.keymap.set({ 'n', 'v' }, '<leader>k', anthropic_help, { desc = 'llm anthropic_help' })
      vim.keymap.set({ 'n', 'v' }, '<leader>K', anthropic_replace, { desc = 'llm anthropic' })
      vim.keymap.set({ 'n', 'v' }, '<leader>P', openai_help, { desc = 'llm openai' })
      -- vim.keymap.set({ 'n', 'v' }, '<leader>p', openai_replace, { desc = 'llm openai' })

      vim.keymap.set({ 'n', 'v' }, '<leader>;h', non_proxy_anthropic_help, { desc = 'llm anthropic help' })
      vim.keymap.set({ 'n', 'v' }, '<leader>;r', non_proxy_anthropic_replace, { desc = 'llm anthropic replace' })
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },
    opts = {
      provider = 'openai',
      auto_suggestions = true,
    },
    config = function()
      require 'custom.avante'
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
      'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
      { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require 'custom.codecompanion'
    end,
  },
}
