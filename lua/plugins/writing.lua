return {
    {
        -- MARKDOWN VIEWER/RENDERER
        'OXY2DEV/markview.nvim',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
            'saghen/blink.cmp',
        },
        opts = {
            preview = {
                enable = false,
            },
        },
        keys = {
            {
                '<leader><leader>v',
                '<Cmd>Markview toggle<CR>',
                desc = 'toggle markdown preview',
                mode = 'n',
                noremap = true,
                silent = true,
            },
        },
    },
    {
        -- NESTED CODEBLOCK INDENTATION FORMATTER
        'wurli/contextindent.nvim',
        opts = { pattern = '*.md' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
    {
        'lervag/wiki.vim',
        config = function()
            -- set keymaps
            local keymap = vim.keymap
            keymap.set('n', '<leader>wj', ':WikiJournal<cr>', { desc = 'Create daily journal entry' }) -- toggle file explorer
            vim.g.wiki_root = '~/wiki'
        end,
    },
}
