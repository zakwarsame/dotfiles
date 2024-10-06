local set = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

set('n', '<Esc>', '<cmd>nohlsearch<CR>')

set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
set('n', '<leader>di', function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end, { desc = 'Toggle [D]iagnostics for current buffer' })
set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
set('n', '<Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
set('n', '<C-w>', '<C-w><C-w>', { desc = 'Switch windows' })
set('n', '<leader>vs', '<C-w>v', { desc = 'Split window vertically' }) -- split window vertically
set('n', '<leader>hs', '<C-w>s', { desc = 'Split window horizontally' }) -- split window horizontally
set('n', '<leader>es', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' }) -- close current split window
-- experimenting with stuff
set('n', '<leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })

-- rust keympas
set('n', '<leader>a', function()
  vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr })
-- Swap capslock and esc key
set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- moving windows
set('n', '<leader>ml', '<C-w>5<', { silent = true })
set('n', '<leader>mr', '<C-w>5>', { silent = true })
set('n', '<leader>mu', '<C-w>5-', { silent = true })
set('n', '<leader>md', '<C-w>5+', { silent = true })

set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

set('v', '<leader>cr', '"hy:%s/<C-r>h//g<Left><Left>', { noremap = true, silent = true })

-- not a keymap, but idk where to put this
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Dismiss Noice Message
vim.keymap.set('n', '<leader>dn', '<cmd>NoiceDismiss<CR>', { desc = 'Dismiss Noice Message' })
