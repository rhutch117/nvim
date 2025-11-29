-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })

vim.keymap.set('', '<leader><leader>ps', '<Cmd>Lazy sync<CR>', { desc = 'update vim plugins' })

vim.keymap.set('n', '<leader><leader>dd', function()
    vim.diagnostic.enable(false)
end, { desc = 'Disable diagnostics' })

vim.keymap.set('n', '<leader><leader>de', function()
    vim.diagnostic.enable()
end, { desc = 'Enable diagnostics' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Surround a word with quotes, backticks, and others
vim.keymap.set('n', '<leader>"', 'viw<esc>a"<esc>bi"<esc>lel', { desc = 'Surround with single-quotes' })
vim.keymap.set('n', "<leader>'", "viw<esc>a'<esc>bi'<esc>lel", { desc = 'Surround with double-quotes' })
vim.keymap.set('n', '<leader>`', 'viw<esc>a`<esc>bi`<esc>lel', { desc = 'Surround with backticks' })
vim.keymap.set('n', '<leader>*', 'viw<esc>a*<esc>bi*<esc>lel', { desc = 'Surround with asterisks' })

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- Visual --
-- Stay in visual mode while indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent selection left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent selection right' })
-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', { desc = 'Move text up' })
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', { desc = 'Move text down' })
vim.keymap.set('v', 'p', '"_dP', { desc = '' })

-- Visual Block --
-- Move text up and down
vim.keymap.set('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move text up' })
vim.keymap.set('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move text down' })
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv", { desc = '' })
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv", { desc = '' })

-- Escape with jk
vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })
