local keymap = vim.keymap
local Snacks = require 'snacks'
local success, shopify_config = pcall(require, 'custom.shopify_config')

require('snacks').setup {
  picker = {
    layout = {
      reverse = true,
      layout = {
        box = 'horizontal',
        backdrop = false,
        width = 0.8,
        height = 0.9,
        border = 'none',
        {
          box = 'vertical',
          { win = 'list', title = ' Results ', title_pos = 'center', border = 'rounded' },
          { win = 'input', height = 1, border = 'rounded', title = '{title} {live} {flags}', title_pos = 'center' },
        },
        {
          win = 'preview',
          title = '{preview:Preview}',
          width = 0.45,
          border = 'rounded',
          title_pos = 'center',
        },
      },
    },
    sources = {
      files = {
        hidden = true,
        ignored = false,
        follow = true,
      },
      grep = {
        hidden = true,
        ignored = false,
        follow = true,
      },
      explorer = {
        hidden = true,
        ignored = false,
        follow = true,
      },
    },
    matcher = {
      frecency = true,
      history_bonus = true,
      cwd_bonus = true,
    },
  },
  image = {
    enabled = true,
    doc = {
      inline = vim.g.neovim_mode == 'skitty' and true or false,
      float = true,
      max_width = vim.g.neovim_mode == 'skitty' and 20 or 60,
      max_height = vim.g.neovim_mode == 'skitty' and 10 or 30,
      -- max_height = 30,
    },
  },
}

keymap.set('n', '<leader>lg', function()
  Snacks.lazygit.open()
end, { desc = 'Open lazygit' })

-- Top Pickers & Explorer
keymap.set('n', '<leader>,', function()
  Snacks.picker.smart()
end, { desc = 'Smart Find Files' })
keymap.set('n', '<leader><space>', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
keymap.set('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
keymap.set('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
keymap.set('n', '<leader>n', function()
  Snacks.picker.notifications()
end, { desc = 'Notification History' })
keymap.set('n', '<leader>e', function()
  Snacks.explorer()
end, { desc = 'File Explorer' })

keymap.set('n', '<leader>E', function()
  Snacks.explorer.reveal()
end, { desc = 'File Explorer' })

-- find
keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Buffers' })
keymap.set('n', '<leader>sd', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Find Config File' })
keymap.set('n', '<leader>sf', function()
  Snacks.picker.files()
end, { desc = 'Find Files' })
keymap.set('n', '<leader>sF', function()
  Snacks.picker.git_files()
end, { desc = 'Find Git Files' })
keymap.set('n', '<leader>fp', function()
  Snacks.picker.projects()
end, { desc = 'Projects' })
keymap.set('n', '<leader>s.', function()
  Snacks.picker.recent()
end, { desc = 'Recent' })

-- git
keymap.set('n', '<leader>gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Git Branches' })
keymap.set('n', '<leader>gl', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log' })
keymap.set('n', '<leader>gL', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
keymap.set('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })
keymap.set('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
keymap.set('n', '<leader>gD', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
keymap.set('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Log File' })

-- Grep
keymap.set('n', '<leader>sb', function()
  Snacks.picker.lines()
end, { desc = 'Buffer Lines' })
keymap.set('n', '<leader>sB', function()
  Snacks.picker.grep_buffers()
end, { desc = 'Grep Open Buffers' })
keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = 'Grep' })
keymap.set({ 'n', 'x' }, '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = 'Visual selection or word' })

-- search
keymap.set('n', '<leader>s"', function()
  Snacks.picker.registers()
end, { desc = 'Registers' })
keymap.set('n', '<leader>s/', function()
  Snacks.picker.search_history()
end, { desc = 'Search History' })
keymap.set('n', '<leader>sa', function()
  Snacks.picker.autocmds()
end, { desc = 'Autocmds' })
keymap.set('n', '<leader>sc', function()
  Snacks.picker.command_history()
end, { desc = 'Command History' })
keymap.set('n', '<leader>sC', function()
  Snacks.picker.commands()
end, { desc = 'Commands' })
keymap.set('n', '<leader>s]', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics' })
keymap.set('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = 'Help Pages' })
keymap.set('n', '<leader>sH', function()
  Snacks.picker.highlights()
end, { desc = 'Highlights' })
keymap.set('n', '<leader>si', function()
  Snacks.picker.icons()
end, { desc = 'Icons' })
keymap.set('n', '<leader>sj', function()
  Snacks.picker.grep { ft = 'javascript,typescript,jsx,tsx' }
end, { desc = 'Grep [J]S/TS Files' })
keymap.set('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
keymap.set('n', '<leader>sl', function()
  Snacks.picker.loclist()
end, { desc = 'Location List' })
keymap.set('n', '<leader>sm', function()
  Snacks.picker.marks()
end, { desc = 'Marks' })
keymap.set('n', '<leader>sM', function()
  Snacks.picker.man()
end, { desc = 'Man Pages' })
keymap.set('n', '<leader>sp', function()
  Snacks.picker.lazy()
end, { desc = 'Search for Plugin Spec' })
keymap.set('n', '<leader>sq', function()
  Snacks.picker.qflist()
end, { desc = 'Quickfix List' })
keymap.set('n', '<leader>sr', function()
  Snacks.picker.resume()
end, { desc = 'Resume' })
keymap.set('n', '<leader>su', function()
  Snacks.picker.undo()
end, { desc = 'Undo History' })
keymap.set('n', '<leader>uC', function()
  Snacks.picker.colorschemes()
end, { desc = 'Colorschemes' })

-- LSP
keymap.set('n', 'gd', function()
  Snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
keymap.set('n', 'gD', function()
  Snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
keymap.set('n', 'gr', function()
  Snacks.picker.lsp_references()
end, { desc = 'References', nowait = true })
keymap.set('n', 'gI', function()
  Snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
keymap.set('n', 'gy', function()
  Snacks.picker.lsp_type_definitions()
end, { desc = 'Goto T[y]pe Definition' })
keymap.set('n', '<leader>ss', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
keymap.set('n', '<leader>sS', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })

-- You can also use glob patterns
-- keymap.set('n', '<leader>sjt', function()
--   Snacks.picker.grep({ glob = '*.test.*' })
-- end, { desc = 'Grep [T]est Files' })

keymap.set('n', '<leader>sJ', function()
  Snacks.picker.jumps()
end, { desc = '[S]earch [J]umps' })

-- Obsidian shortcuts
keymap.set('n', '<leader>so', function()
  Snacks.picker.files {
    cwd = os.getenv 'HOME' .. '/Documents/obsidian-vault',
    glob = '**/*.md',
  }
end, { desc = '[S]earch [O]bsidian Files' })

keymap.set('n', '<leader>sO', function()
  Snacks.picker.grep {
    cwd = os.getenv 'HOME' .. '/Documents/obsidian-vault',
    glob = '**/*.md',
  }
end, { desc = '[S]earch [O]bsidian Content' })

keymap.set('n', '<leader>st', function()
  vim.cmd 'ObsidianTags'
end, { desc = '[S]earch Obsidian [T]ags' })

keymap.set('n', '<leader>od', function()
  vim.cmd 'ObsidianDailies'
end, { desc = '[O]bsidian [D]ailies' })

keymap.set('n', '<leader>sd', function()
  local home = os.getenv 'HOME'
  local dotfiles_path = success and shopify_config.dotfiles_path or (home .. '/dotfiles')

  print(dotfiles_path)
  Snacks.picker.files {
    cwd = dotfiles_path,
    hidden = true,
    no_ignore = true,
  }
end, { desc = '[S]earch [D]otfiles (Files)' })

keymap.set('n', '<leader>sD', function()
  local home = os.getenv 'HOME'
  local dotfiles_path = success and shopify_config.dotfiles_path or (home .. '/dotfiles')

  print(dotfiles_path)
  Snacks.picker.grep {
    cwd = dotfiles_path,
    hidden = true,
    no_ignore = true,
  }
end, { desc = '[S]earch [D]otfiles (Grep)' })
