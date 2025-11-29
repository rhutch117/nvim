return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nevim-tree/nvim-web-devicons',
        },
        config = function()
            local nvimtree = require('nvim-tree')

            -- recommended settings from nvim-tree docs
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true

            nvimtree.setup({
                hijack_cursor = true,
                disable_netrw = true,
                hijack_unnamed_buffer_when_opening = true,

                diagnostics = {
                    enable = true,
                },
                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
                renderer = {
                    highlight_git = true,
                    group_empty = true,
                    icons = {
                        glyphs = {
                            git = {
                                unstaged = '',
                                staged = 'S',
                                unmerged = '',
                                renamed = '➜',
                                deleted = '',
                                untracked = 'U',
                                ignored = '◌',
                            },
                        },
                    },
                },
                filters = {
                    git_ignored = false,
                    dotfiles = false,
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                    change_dir = {
                        enable = false,
                    },
                },
            })

            -- set keymaps
            local keymap = vim.keymap
            keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' }) -- toggle file explorer
            keymap.set(
                'n',
                '<leader>ef',
                '<cmd>NvimTreeFindFileToggle<CR>',
                { desc = 'Toggle file explorer on current file' }
            ) -- toggle file explorer on current file
            keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' }) -- collapse file explorer
            keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' }) -- refresh file explorer
        end,
    },
}
