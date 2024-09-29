local actions = require 'telescope.actions'
local lga_actions = require 'telescope-live-grep-args.actions'

local success, shopify_config = pcall(require, 'custom.shopify_config')

-- [[ Configure Telescope ]]
require('telescope').setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  -- defaults = {
  --   mappings = {
  --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --   },
  -- },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = { -- extend mappings
        i = {
          ['<C-t>'] = lga_actions.quote_prompt(),
          ['<C-i>'] = lga_actions.quote_prompt {
            postfix = " --iglob '**/*{}*/**' --iglob '**/*{}*' ",
          },
          -- freeze the current list and start a fuzzy search in the frozen list
          ['<C-f>'] = actions.to_fuzzy_refine,
          -- exact word
          ['<C-w>'] = lga_actions.quote_prompt { postfix = ' -w ' },
        },
      },
    },
  },
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob',
      '!**/.git/*',
    },
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension 'live_grep_args')

local live_grep_args_shortcuts = require 'telescope-live-grep-args.shortcuts'
-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').find_files {
    hidden = true,
    no_ignore = true,
  }
end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[F]ind [G]rep Args' })
vim.keymap.set('n', '<leader>sc', live_grep_args_shortcuts.grep_word_under_cursor, { desc = '[G]rep [C]urrent Word' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

vim.keymap.set('n', '<leader>sd', function()
  local home = os.getenv 'HOME'
  local dotfiles_path = success and shopify_config.dotfiles_path or (home .. '/dotfiles')
  require('telescope.builtin').find_files {
    cwd = dotfiles_path .. '/dotfiles',
    hidden = true,
    no_ignore = true,
  }
end, { desc = '[S]earch [D]otfiles' })

vim.keymap.set('n', '<leader>sD', function()
  local home = os.getenv 'HOME'
  require('telescope.builtin').live_grep { cwd = success and shopify_config.dotfiles_path or (home .. '/dotfiles') }
end, { desc = '[S]earch [D]otfiles' })
