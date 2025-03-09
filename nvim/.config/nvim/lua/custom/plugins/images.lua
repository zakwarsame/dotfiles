return {
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
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
}
