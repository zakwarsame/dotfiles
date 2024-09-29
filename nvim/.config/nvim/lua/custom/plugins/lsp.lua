local success, shopify_config = pcall(require, 'custom.shopify_config')

return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' }, -- Required
    { -- Optional
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' }, -- Optional
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' }, -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'L3MON4D3/LuaSnip' }, -- Required
    { 'rafamadriz/friendly-snippets' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'saadparwaiz1/cmp_luasnip' },
    {
      'pmizio/typescript-tools.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local nvim_lsp = require 'lspconfig'
        require('typescript-tools').setup {
          single_file_support = success and shopify_config.lsp_settings.single_file_support,
          settings = {
            separate_diagnostic_server = success and shopify_config.lsp_settings.settings.separate_diagnostic_server,
            tsserver_max_memory = 10240,
            root_dir = nvim_lsp.util.root_pattern 'package.json',
          },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentFormattingRangeProvider = false
          end,
        }
      end,
    },
  },
  config = function()
    local lsp = require 'lsp-zero'

    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr, remap = false }

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      map('K', vim.lsp.buf.hover, 'Hover Documentation')

      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      vim.keymap.set('n', '<leader>vrr', function()
        vim.lsp.buf.references()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP References' }))
      vim.keymap.set('n', '<leader>vrn', function()
        vim.lsp.buf.rename()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP Rename' }))
      vim.keymap.set('i', '<C-h>', function()
        vim.lsp.buf.signature_help()
      end, vim.tbl_deep_extend('force', opts, { desc = 'LSP Signature Help' }))

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[T]oggle Inlay [H]ints')
      end
    end)

    require('mason').setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    require('mason-lspconfig').setup {
      ensure_installed = {
        'tsserver',
        'eslint',
        'jdtls',
        'lua_ls',
        'html',
        'tailwindcss',
        'pylsp',
        'dockerls',
        'bashls',
        'marksman',
        'cucumber_language_server',
        'cssls',
      },
      handlers = {
        lsp.default_setup,
        rust_analyzer = function() end,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
      },
    }

    require('mason-tool-installer').setup {
      ensure_installed = {
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
        'isort', -- python formatter
        'black', -- python formatter
        'pylint',
        'eslint_d',
      },
    }

    local cmp_action = require('lsp-zero').cmp_action()
    local cmp = require 'cmp'
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    require('luasnip.loaders.from_vscode').lazy_load()

    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
          },
        },
      }),
    })

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
      },
    }
  end,
}
