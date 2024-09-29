local opt = vim.opt

-- opens preview at the bottom
opt.inccommand = 'split'

opt.number = true
-- perhaps someday
opt.relativenumber = true

opt.smartcase = true
opt.ignorecase = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = 'yes'
opt.clipboard = 'unnamedplus'

opt.mouse = 'a'
opt.undofile = true

opt.updatetime = 250

-- display which-key sooner
opt.timeoutlen = 700
opt.scrolloff = 10
opt.list = true
opt.listchars = { tab = '┊ ', trail = '·', nbsp = '␣' }
opt.cursorline = true

opt.swapfile = false

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

opt.autoindent = true
opt.cindent = true

opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
