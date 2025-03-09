return {
  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   opts = {
  --     suggestion = {
  --       auto_trigger = true,
  --       keymap = {
  --         accept = '<C-y>',
  --       },
  --     },
  --   },
  --   config = function()
  --     require('copilot').setup {}
  --   end,
  -- },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')

        -- Actions
        -- map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset hunk')

        map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')

        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')

        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')

        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, 'Blame line')
        map('n', '<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame')

        map('n', '<leader>hd', gs.diffthis, 'Diff this')
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, 'Diff this ~')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk')
      end,
    },
  },
  -- lazy.nvim
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    config = function()
      require 'custom.noice'
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed, not both.
      'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
    },
    -- config = true,
    config = function()
      require 'custom.neogit'
    end,
  },
  {
    'polarmutex/git-worktree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'git_worktree'
    end,
    init = function()
      vim.g.git_worktree = {
        change_directory_command = 'cd',
        update_on_change = false,
        update_on_change_command = 'e .',
        clearjumps_on_change = true,
        confirm_telescope_deletions = true,
        autopush = false,
      }

      local Hooks = require 'git-worktree.hooks'
      Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
    end,
    keys = {
      {
        '<leader>gW',
        function()
          local branch = vim.fn.input 'Branch: '
          local path = vim.fn.input 'Path: '
          if path == '' then
            path = '../' .. branch
          end
          require('git-worktree').create_worktree(path, branch, 'origin')
        end,
        desc = 'Create a new worktree',
      },
      {
        '<leader>gw',
        function()
          require('telescope').extensions.git_worktree.git_worktree()
        end,
        desc = '[Telescope] Switch Git Worktree',
      },
      {
        '<leader>gt',
        function()
          require('telescope').extensions.git_worktree.create_git_worktree()
        end,
        desc = '[Telescope] Create Git Worktree',
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      harpoon:setup {}

      vim.keymap.set('n', '<C-m>', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<C-,>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-/>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },

  -- wezterm-nvim movement/navigation
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    keys = {
      -- Movement between splits
      { '<Left>', function() require("smart-splits").move_cursor_left() end, mode = {"i", "n", "v"}, desc = "Move to left split" },
      { '<Right>', function() require("smart-splits").move_cursor_right() end, mode = {"i", "n", "v"}, desc = "Move to right split" },
      { '<C-;>', function() require("smart-splits").move_cursor_up() end, mode = {"i", "n", "v"}, desc = "Move to upper split" },
      { "<C-'>", function() require("smart-splits").move_cursor_down() end, mode = {"i", "n", "v"}, desc = "Move to lower split" },
      -- Resizing splits (special chars from WezTerm)
      { '<Char-0xB1>', function() require("smart-splits").resize_left() end, mode = {"n"}, desc = "Resize split left" },
      { '<Char-0xB2>', function() require("smart-splits").resize_right() end, mode = {"n"}, desc = "Resize split right" },
      { '<Char-0xB3>', function() require("smart-splits").resize_up() end, mode = {"n"}, desc = "Resize split up" },
      { '<Char-0xB4>', function() require("smart-splits").resize_down() end, mode = {"n"}, desc = "Resize split down" },
      -- Keep ALT bindings for non-WezTerm environments
      { '<A-Left>', function() require("smart-splits").resize_left() end, mode = {"n"}, desc = "Resize split left" },
      { '<A-Right>', function() require("smart-splits").resize_right() end, mode = {"n"}, desc = "Resize split right" },
      { '<A-Up>', function() require("smart-splits").resize_up() end, mode = {"n"}, desc = "Resize split up" },
      { '<A-Down>', function() require("smart-splits").resize_down() end, mode = {"n"}, desc = "Resize split down" },
    },
  },
}
