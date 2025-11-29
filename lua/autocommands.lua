vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.tf' },
    command = 'set filetype=terraform',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.mdx' },
    command = 'set filetype=markdown',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.mod' },
    command = 'set filetype=gomod',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.jq' },
    command = 'set filetype=jq',
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('WrapLineInMarkdown', { clear = true }),
    pattern = { 'markdown' },
    command = 'setlocal wrap',
})
