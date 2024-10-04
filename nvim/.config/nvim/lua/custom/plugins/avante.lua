return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  build = ':AvanteBuild source=false',
  dependencies = {
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    'MeanderingProgrammer/render-markdown.nvim',
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
    provider = 'openai', -- Set to 'openai' since the proxy mimics OpenAI API
    auto_suggestions = true,
  },
  config = function()
    require 'custom.avante'
  end,
}
