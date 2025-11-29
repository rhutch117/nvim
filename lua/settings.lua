-- OPTIONS
-- To see what an option is set to execute `:lua = vim.o.<name>`

vim.g.have_nerd_font = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.opt.virtualedit = 'block'

vim.opt.expandtab = true -- Neovim will insert spaces when you press the Tab key.
vim.opt.tabstop = 2 -- When expandtab is false (e.g. .editorconfig override), pressing the Tab key will insert a tab character that visually takes up this number of spaces
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- Since expandtab is set to true, << or >> will match tabstop and use spaces for indentation, and so each tab press will insert 2 spaces.
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 999
vim.opt.wrap = false

vim.opt.clipboard = 'unnamedplus'

if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end
