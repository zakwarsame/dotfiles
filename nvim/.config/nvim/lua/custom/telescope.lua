-- local actions = require 'telescope.actions'
-- local lga_actions = require 'telescope-live-grep-args.actions'
--
-- local success, shopify_config = pcall(require, 'custom.shopify_config')
--
-- -- [[ Configure Telescope ]]
-- require('telescope').setup {
--   -- You can put your default mappings / updates / etc. in here
--   --  All the info you're looking for is in `:help telescope.setup()`
--   --
--   -- defaults = {
--   --   mappings = {
--   --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
--   --   },
--   -- },
--   pickers = {
--     find_files = {
--       hidden = true, -- will still show the inside of `.git/` as it's not `.gitignore`d.
--       find_command = {
--         'rg',
--         '--files',
--         -- search files that are in ignored by git
--         '--unrestricted',
--         -- follow symlinks
--         '--follow',
--         -- don't search logs
--         '--glob',
--         '!log',
--         -- don't search node modules
--         '--glob',
--         '!node_modules',
--         -- don't search tmp directory
--         '--glob',
--         '!tmp',
--         -- don't search .git directory
--         '--glob',
--         '!.git',
--       },
--     },
--     git_branches = {
--       mappings = {
--         i = { ['<cr>'] = actions.git_switch_branch },
--       },
--     },
--   },
--   extensions = {
--     ['ui-select'] = {
--       require('telescope.themes').get_dropdown(),
--     },
--     live_grep_args = {
--       auto_quoting = true,
--       mappings = { -- extend mappings
--         i = {
--           ['<C-t>'] = lga_actions.quote_prompt(),
--           ['<C-i>'] = lga_actions.quote_prompt {
--             postfix = " --iglob '**/*{}*/**' --iglob '**/*{}*' ",
--           },
--           -- freeze the current list and start a fuzzy search in the frozen list
--           ['<C-f>'] = actions.to_fuzzy_refine,
--           -- exact word
--           ['<C-w>'] = lga_actions.quote_prompt { postfix = ' -w ' },
--         },
--       },
--       -- layout_config = { mirror=true }, -- mirror preview pane
--       hidden = true,
--       additional_args = function(_)
--         return {
--           -- search files that are in ignored by git
--           '--unrestricted',
--           -- follow symlinks
--           '--follow',
--           -- don't search logs
--           '--glob',
--           '!log',
--           -- don't search node modules
--           '--glob',
--           '!node_modules',
--           -- don't search tmp directory
--           '--glob',
--           '!tmp',
--           -- don't search .git directory
--           '--glob',
--           '!.git',
--         }
--       end,
--     },
--   },
--   defaults = {
--     vimgrep_arguments = {
--       'rg',
--       '--color=never',
--       '--no-heading',
--       '--with-filename',
--       '--line-number',
--       '--column',
--       '--smart-case',
--       '--hidden',
--       '--glob',
--       '!**/.git/*',
--     },
--     mappings = {
--       i = {
--         ['<esc>'] = actions.close,
--       },
--     },
--   },
-- }
--
-- -- Enable Telescope extensions if they are installed
-- pcall(require('telescope').load_extension, 'fzf')
-- pcall(require('telescope').load_extension, 'ui-select')
-- pcall(require('telescope').load_extension, 'live_grep_args')
-- pcall(require('telescope').load_extension, 'git_worktree')
--
-- local live_grep_args_shortcuts = require 'telescope-live-grep-args.shortcuts'
-- -- See `:help telescope.builtin`
-- local builtin = require 'telescope.builtin'
-- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
-- vim.keymap.set('n', '<leader>sf', function()
--   require('telescope.builtin').find_files {
--     hidden = true,
--     no_ignore = true,
--   }
-- end, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
-- -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>s]', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[F]ind [G]rep Args' })
-- vim.keymap.set('n', '<leader>sc', live_grep_args_shortcuts.grep_word_under_cursor, { desc = '[G]rep [C]urrent Word' })
--
-- -- git pickers
-- vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
-- vim.keymap.set('n', '<leader>gb', function()
--   builtin.git_branches { show_remote_tracking_branches = false }
-- end, { desc = '[G]it [B]ranches (Local)' })
-- vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
--
-- -- git worktrees
-- -- vim.keymap.set('n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktree, { desc = '[G]it [W]orktrees' })
-- -- vim.keymap.set('n', '<leader>gW', require('telescope').extensions.git_worktree.create_git_worktree, { desc = '[G]it Create [W]orktree' })
--
-- -- Slightly advanced example of overriding default behavior and theme
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = '[/] Fuzzily search in current buffer' })
--
-- -- It's also possible to pass additional configuration options.
-- --  See `:help telescope.builtin.live_grep()` for information about particular keys
-- vim.keymap.set('n', '<leader>s/', function()
--   builtin.live_grep {
--     grep_open_files = true,
--     prompt_title = 'Live Grep in Open Files',
--   }
-- end, { desc = '[S]earch [/] in Open Files' })
--
-- -- Shortcut for searching Neovim configuration files
-- vim.keymap.set('n', '<leader>sn', function()
--   builtin.find_files { cwd = vim.fn.stdpath 'config' }
-- end, { desc = '[S]earch [N]eovim files' })
--
-- vim.keymap.set('n', '<leader>sd', function()
--   local home = os.getenv 'HOME'
--   local dotfiles_path = success and shopify_config.dotfiles_path or (home .. '/dotfiles')
--
--   print(dotfiles_path)
--   require('telescope.builtin').find_files {
--     cwd = dotfiles_path,
--     hidden = true,
--     no_ignore = true,
--   }
-- end, { desc = '[S]earch [D]otfiles' })
--
-- vim.keymap.set(
--   'n',
--   '<leader>sD',
--   [[:lua require('telescope').extensions.live_grep_args.live_grep_args({ cwd = ]]
--     .. (success and 'shopify_config.dotfiles_path' or "(os.getenv('HOME') .. '/dotfiles')")
--     .. [[ })<CR>]],
--   { desc = '[S]earch [D]otfiles' }
-- )
--
-- vim.keymap.set('n', '<leader>so', function()
--   require('telescope.builtin').find_files {
--     cwd = os.getenv 'HOME' .. '/Documents/obsidian-vault',
--     find_command = { 'rg', '--files', '--type', 'md' },
--   }
-- end, { desc = '[S]earch [O]bsidian' })
--
-- vim.keymap.set('n', '<leader>sO', function()
--   require('telescope').extensions.live_grep_args.live_grep_args {
--     cwd = os.getenv 'HOME' .. '/Documents/obsidian-vault',
--     additional_args = function()
--       return { '--type', 'md' }
--     end,
--   }
-- end, { desc = '[S]earch [O]bsidian Content' })
--
-- vim.keymap.set('n', '<leader>st', ':ObsidianTags<CR>', { desc = '[S]earch [T]ags' })
-- vim.keymap.set('n', '<leader>od', ':ObsidianDailies<CR>', { desc = '[O]bsidian [D]ailies'
