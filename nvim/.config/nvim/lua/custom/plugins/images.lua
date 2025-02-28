return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
  },
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      relative_to_current_file = true,
      use_absolute_path = false,
      file_path = 'assets',
      url_encode_path = false,
      prompt_for_file_name = false,
    },
    keys = {
      -- suggested keymap
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
  -- if the above works on linux, delete the following
  -- {
  --   'HakonHarnes/img-clip.nvim',
  --   ft = { 'markdown', 'md', 'markdown.mdx' },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   opts = {
  --     -- default_dir_path = '/home/alchemy/Documents/obsidian-vault/assets',
  --     -- dir_path = function()
  --     --   return vim.fn.expand '%:p:h' .. '/assets'
  --     -- end,
  --     -- file_name = function()
  --     --   return os.date '%Y%m%d-%H%M%S'
  --     -- end,
  --   },
  --   keys = {
  --     { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
  --   },
  -- },
  {
    '3rd/image.nvim',
    dependencies = { 'luarocks.nvim' },
    config = function()
      require('image').setup {
        backend = 'kitty',
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { 'markdown', 'md', 'markdown.mdx' },
          },
        },
        max_height_window_percentage = 30,
        window_overlap_clear_enabled = false,
        hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp' },
      }
    end,
  },
}
