return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'nvim-neotest/neotest-jest',
      -- commit = 'c2118446d770fedb360a91b1d91a7025db86d4f1',
    },
    'marilari88/neotest-vitest',
    'nvim-neotest/nvim-nio',
  },
  lazy = false,
  keys = {
    {
      '<leader>tn',
      function()
        require('neotest').run.run()
      end,
      desc = 'Test Nearest',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Test File',
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Test Last',
    },
    {
      '<leader>tF',
      function()
        require('neotest').run.run { status = 'failed' }
      end,
      desc = 'Test Failed',
    },
    {
      '<leader>tO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle Output Panel',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Show Summary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open { enter = true }
      end,
      desc = 'Show Output',
    },
    {
      '[t',
      function()
        require('neotest').jump.prev { status = 'failed' }
      end,
      desc = 'Goto Prev Failed',
    },
    {
      ']t',
      function()
        require('neotest').jump.next { status = 'failed' }
      end,
      desc = 'Goto Next Failed',
    },
    {
      '<leader>TO',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle Output Panel',
    },
    {
      '<leader>R',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop',
    },
    {
      '<leader>tp',
      function()
        require('neotest').run.run(vim.fn.getcwd())
      end,
      desc = 'Test Project',
    },
  },
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>tw', "<cmd>lua require('neotest').run.run({ jestCommand = 'pnpm run test --watch' })<cr>", {})

    local neotest = require 'neotest'

    neotest.setup {
      discovery = {
        enabled = false,
      },
      adapters = {
        require 'neotest-jest' {
          jestCommand = 'pnpm test --',
          -- jestConfigFile = 'jest.config.js',
          jestConfigFile = function(file)
            if string.find(file, '/packages/') then
              return string.match(file, '(.-/[^/]+/)src') .. 'jest.config.js'
            end

            return vim.fn.getcwd() .. '/jest.config.js'
          end,
          -- jestCommand = 'dev test -- --watch',
        },
        -- require 'neotest-vitest' {},
      },
      quickfix = {
        enabled = false,
        open = false,
      },
      output_panel = {
        open = 'rightbelow vsplit | resize 30',
      },
      status = {
        virtual_text = false,
        signs = true,
      },
    }
  end,
}
