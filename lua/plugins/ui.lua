return {
    { -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then
        -- change the command in the config to whatever the name of that colorscheme is.
        --
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
        'folke/tokyonight.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('tokyonight').setup({
                styles = {
                    comments = { italic = false }, -- Disable italics in comments
                },
            })

            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme('tokyonight-night')

            -- Change the color of visual mode highlights
            vim.cmd('highlight Visual guifg=None guibg=#4c00a4')
        end,
    },
    {
        -- quality of life improvements
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
    },

    {
        -- HELP PAGES RENDERING
        'OXY2DEV/helpview.nvim',
        lazy = false,
    },
}
