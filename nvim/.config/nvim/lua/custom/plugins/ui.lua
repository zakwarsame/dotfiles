local success, shopify_config = pcall(require, 'custom.shopify_config')

local function show_spin_fqdn()
  if success then
    return shopify_config.show_spin_fqdn()
  end
  return ''
end

return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
    end,

    config = function()
      local transparent = true
      require('tokyonight').setup {
        transparent = transparent,
        styles = {
          sidebars = transparent and 'transparent' or 'dark',
          floats = transparent and 'transparent' or 'dark',
        },
        on_colors = function(colors)
          colors.bg_highlight = '#143652'
          colors.bg_visual = '#275378'
        end,
      }
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'numToStr/comment.nvim',
    opts = {
      toggler = {
        line = 'gc',
      },
      opleader = {
        line = 'gc',
      },
      mappings = {
        basic = true,
        extra = false,
      },
    },
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'b0o/nvim-tree-preview.lua',
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      auto_reload_on_write = false,
      actions = {
        open_file = { resize_window = true, window_picker = { enable = false } },
      },
      git = { enable = false, ignore = false },
      view = {
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local columns = vim.opt.columns:get()
            local lines = vim.opt.lines:get()
            local cmdheight = vim.opt.cmdheight:get()
            local screen_w = columns
            local screen_h = lines - cmdheight
            local window_w = math.floor(screen_w * 0.5)
            local window_h = math.floor(screen_h * 0.8)
            local center_x = (screen_w - window_w) / 2
            local center_y = (screen_h - window_h) / 2
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w,
              height = window_h,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * 0.5)
        end,
      },
    },
    config = function(_, opts)
      opts.on_attach = function(bufnr)
        local api = require 'nvim-tree.api'
        api.config.mappings.default_on_attach(bufnr)

        local function keymap_opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local preview = require 'nvim-tree-preview'

        vim.keymap.set('n', 'P', preview.watch, keymap_opts 'Preview (Watch)')
        -- vim.keymap.set('n', '<Esc>', preview.unwatch, keymap_opts 'Close Preview/Unwatch')

        vim.keymap.set('n', '<Tab>', function()
          local node = api.tree.get_node_under_cursor()
          if node then
            if node.type == 'directory' then
              api.node.open.edit()
            else
              preview.node(node, { toggle_focus = true })
            end
          end
        end, keymap_opts 'Preview')
      end

      require('nvim-tree').setup(opts)

      local api = require 'nvim-tree.api'

      vim.keymap.set('n', '<C-n>', function()
        api.tree.toggle { find_file = true, focus = true }
      end, { desc = 'Toggle NvimTree and Find File' })

      vim.keymap.set('n', '<leader>n', function()
        api.tree.find_file { open = true }
      end, { desc = 'NvimTree Find File' })

      vim.keymap.set('n', '<Esc><Esc>', function()
        api.tree.close()
      end, { desc = 'Close NvimTree' })
    end,
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.pairs').setup()
      require('mini.pick').setup()
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'tokyonight',
        icons_enabled = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'hostname' },
        lualine_c = { 'branch', { 'filename', path = 1 }, 'aerial' },
        lualine_x = { 'diff', show_spin_fqdn, 'encoding', 'fileformat' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      extensions = { 'fugitive', 'fzf' },
    },
  },
  {
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        providers = { 'lsp', 'treesitter' },
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { 'lsp' },
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
      },
      scope = {
        enabled = true,
        show_start = false,
        highlight = { 'Function', 'Label' },
        priority = 500,
      },
    },
  },
  -- {
  --   'mvllow/modes.nvim',
  --   config = function()
  --     require('modes').setup()
  --   end,
  -- },
}
