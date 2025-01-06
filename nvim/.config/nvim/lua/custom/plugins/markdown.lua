return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('obsidian').setup {
        -- notes_subdir = 'ghost',
        -- new_notes_location = 'notes_subdir',
        --
        -- using [[]] mostly, so this creates files using the title if there is one
        note_id_func = function(title)
          local timestamp = os.date '%Y%m%d%H%M'
          local suffix = ''
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            return timestamp .. '-' .. suffix
          else
            -- If title is nil, just add 4 random uppercase letters
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
            return timestamp .. '-' .. suffix
          end
        end,
        templates = {
          subdir = 'templates',
          date_format = '%Y-%m-%d',
          time_format = '%H:%M:%S',
        },
        daily_notes = {
          folder = 'notes/dailies',
          date_format = '%Y-%m-%d',
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = '%B %-d, %Y',
          -- Optional, default tags to add to each new daily note created.
          default_tags = { 'daily-notes' },
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = nil,
        },
        ui = {
          enable = false,
        },
        workspaces = {
          {
            name = 'personal',
            path = '~/Documents/obsidian-vault',
          },
        },
        mappings = {
          -- toggle check-boxes
          ['<leader>ti'] = {
            action = function()
              return require('obsidian').util.toggle_checkbox()
            end,
            opts = { buffer = true },
          },
        },
      }
    end,
  },
}
