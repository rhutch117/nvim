local function merge(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

local function mappings(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    local buf_def = '<Cmd>lua vim.lsp.buf.definition()<CR>'
    local buf_def_split = '<Cmd>sp | lua vim.lsp.buf.definition()<CR>'
    local buf_def_vsplit = '<Cmd>vsp | lua vim.lsp.buf.definition()<CR>'
    local buf_incoming_calls = '<Cmd>lua vim.lsp.buf.incoming_calls()<CR>'
    local buf_incoming_calls_opts = merge({ desc = 'List all callers' }, opts)
    local diag_next = '<Cmd>lua vim.diagnostic.goto_next({ float = false })<CR>'
    local diag_next_opts = merge({ desc = 'Go to next diagnostic' }, opts)
    local diag_open_float = '<Cmd>lua vim.diagnostic.open_float()<CR>'
    local diag_open_float_opts = merge({ desc = 'Float current diag' }, opts)
    local diag_prev = '<Cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>'
    local diag_prev_opts = merge({ desc = 'Go to prev diagnostic' }, opts)
    local diag_show = '<Cmd>lua vim.diagnostic.show()<CR>'
    local diag_show_opts = merge({ desc = 'Show project diagnostics' }, opts)

    -- IMPORTANT: Since adding "rachartier/tiny-inline-diagnostic.nvim"
    -- we need to configure `float = false` above in `diag_next` and `diag_prev`.
    vim.keymap.set('n', '[x', diag_prev, diag_prev_opts)
    vim.keymap.set('n', ']x', diag_next, diag_next_opts)

    vim.keymap.set('n', '<c-s>', buf_def_split, opts)
    vim.keymap.set('n', '<c-\\>', buf_def_vsplit, opts)
    vim.keymap.set('n', '<c-]>', buf_def, opts)
    vim.keymap.set('n', ']r', diag_open_float, diag_open_float_opts)
    vim.keymap.set('n', ']s', diag_show, diag_show_opts)
    vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover({ border = 'single', max_height = 25, max_width = 100 })
    end, opts)

    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, 'LSP: [R]e[n]ame')
    vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, 'LSP: [G]oto Code [A]ction')
    vim.keymap.set('n', 'grr', require('telescope.builtin').lsp_references, 'LSP: [G]oto [R]eferences')
    vim.keymap.set('n', 'gri', require('telescope.builtin').lsp_implementations, 'LSP: [G]oto [I]mplementations')
    vim.keymap.set('n', 'grd', require('telescope.builtin').lsp_definitions, 'LSP: [G]oto [D]efinition')
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, 'LSP: [G]oto [D]eclaration')
    vim.keymap.set('n', 'gO', require('telescope.builtin').lsp_document_symbols, 'LSP: Open Document Symbols')
    vim.keymap.set('n', 'gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'LSP: Open Workspace Symbols')
    vim.keymap.set('n', 'grt', require('telescope.builtin').lsp_type_definitions, 'LSP: [G]oto [T]ype [D]efinition')

    vim.keymap.set('n', 'gi', buf_incoming_calls, buf_incoming_calls_opts)
end

return {
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        -- TERRAFORM DOCS
        'Afourcat/treesitter-terraform-doc.nvim',
        dependencies = { 'nvim-treesitter' },
    },
    {
        -- LSP
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', opts = {} },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            { 'j-hui/fidget.nvim', opts = {} },

            -- Allows extra capabilities provided by blink.cmp
            'saghen/blink.cmp',
        },
        config = function()
            require('mason').setup()

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                    -- Find references for the word under your cursor.
                    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                    ---@param client vim.lsp.Client
                    ---@param method vim.lsp.protocol.Method
                    ---@param bufnr? integer some lsp support methods only in specific files
                    ---@return boolean
                    local function client_supports_method(client, method, bufnr)
                        if vim.fn.has('nvim-0.11') == 1 then
                            return client:supports_method(method, bufnr)
                        else
                            return client.supports_method(method, { bufnr = bufnr })
                        end
                    end

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if
                        client
                        and client_supports_method(
                            client,
                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
                            event.buf
                        )
                    then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if
                        client
                        and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
                    then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                clangd = {
                    '--fallback-style={BasedOnStyle: Google, IndentWidth: 2, TabWidth: 2, UseTab: Never}',
                },
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                                unusedwrite = true,
                                fieldalignment = true,
                                nilness = true,
                                shadow = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                        },
                    },
                },
                pylsp = {
                    settings = {
                        pylsp = {
                            plugins = {
                                pyflakes = { enabled = false },
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = 'basic', -- choose between "off", "basic", or "strict"
                            },
                        },
                    },
                },
                -- rust_analyzer = {},
                -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
                --
                -- Some languages (like typescript) have entire language plugins that can be useful:
                --    https://github.com/pmizio/typescript-tools.nvim
                --
                -- But for many setups, the LSP (`ts_ls`) will work just fine
                ts_ls = {},
                --
                prettier = {},

                lua_ls = {
                    -- cmd = { ... },
                    -- filetypes = { ... },
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            -- Ensure the servers and tools above are installed
            --
            -- To check the current status of installed tools and/or manually install
            -- other tools, you can run
            --    :Mason
            --
            -- You can press `g?` for help in this menu.
            --
            -- `mason` had to be setup earlier: to configure its options see the
            -- `dependencies` table for `nvim-lspconfig` above.
            --
            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })
            require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

            require('mason-lspconfig').setup({
                ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        -- RUST LSP
        'mrcjkb/rustaceanvim',
        version = '^4',
        ft = { 'rust' },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            vim.g.rustaceanvim = {
                capabilities = capabilities,
                -- Plugin configuration
                tools = {
                    autoSetHints = true,
                    inlay_hints = {
                        show_parameter_hints = true,
                        parameter_hints_prefix = 'in: ', -- "<- "
                        other_hints_prefix = 'out: ', -- "=> "
                    },
                },
                -- LSP configuration
                --
                -- REFERENCE:
                -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                -- https://rust-analyzer.github.io/manual.html#configuration
                -- https://rust-analyzer.github.io/manual.html#features
                --
                -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
                --       <section> should be an object.
                --       <property> should be a primitive.
                server = {
                    on_attach = function(client, bufnr)
                        mappings(client, bufnr)
                        require('illuminate').on_attach(client)

                        local bufopts = {
                            noremap = true,
                            silent = true,
                            buffer = bufnr,
                        }
                        vim.keymap.set('n', '<leader><leader>rr', '<Cmd>RustLsp runnables<CR>', bufopts)
                        vim.keymap.set('n', 'K', '<Cmd>RustLsp hover actions<CR>', bufopts)
                    end,
                    settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = 'create',
                            },
                            cargo = { allFeatures = true },
                            checkOnSave = {
                                -- default: `cargo check`
                                command = 'clippy',
                                allFeatures = true,
                            },
                            inlayHints = {
                                lifetimeElisionHints = {
                                    enable = true,
                                    useParameterNames = true,
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        -- LSP INLAY HINTS
        --
        -- NOTE: See ../autocommands.lua for LspAttach autocommand.
        'felpafel/inlay-hint.nvim',
        event = 'LspAttach',
        config = function()
            require('inlay-hint').setup({
                virt_text_pos = 'inline', -- eol, inline, right_align
            })
        end,
    },
    {
        -- LSP SERVER CONFIGURATION
        'mason-org/mason-lspconfig.nvim',
        dependencies = { 'mason-org/mason.nvim', 'treesitter-terraform-doc.nvim' },
        config = function()
            local mason_lspconfig = require('mason-lspconfig')

            -- NOTE: taplo -> TOML
            --
            -- Can't auto-install these as there is no mappings in mason-lspconfig.
            -- ◍ goimports
            -- ◍ goimports-reviser
            -- ◍ golangci-lint
            mason_lspconfig.setup({
                ensure_installed = {
                    'bashls',
                    'dagger',
                    'dockerls',
                    'gopls',
                    'helm_ls',
                    'html',
                    'jsonls',
                    'lua_ls',
                    'marksman',
                    'pylsp',
                    'rust_analyzer',
                    'taplo',
                    'terraformls',
                    'tflint',
                    'ts_ls',
                    'vimls',
                    'yamlls',
                    'stylua', -- Used to format Lua code
                    'clang_format', -- Used to format c++ code
                },
                automatic_enable = {
                    exclude = {
                        'gopls', -- if we auto enable (vim.lsp.enable()) then my `gq` operator fails as it's set to `gofmt` and we need to unset it (see: ./lsp/golang.lua)
                    },
                },
            })
        end,
    },
    {
        -- LSP DIAGNOSTICS
        'folke/trouble.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        keys = {
            {
                '<leader><leader>dc',
                '<Cmd>Trouble close<CR>',
                desc = 'Close latest Trouble window',
                mode = 'n',
                noremap = true,
                silent = true,
            },
            {
                '<leader><leader>da',
                '<Cmd>Trouble diagnostics focus=true<CR>',
                desc = 'Open diagnostics for all buffers in Trouble',
                mode = 'n',
                noremap = true,
                silent = true,
            },
            {
                '<leader><leader>db',
                '<Cmd>Trouble diagnostics focus=true filter.buf=0<CR>',
                desc = 'Open diagnostics for current buffer in Trouble',
                mode = 'n',
                noremap = true,
                silent = true,
            },
            {
                '<leader><leader>lr',
                '<Cmd>Trouble lsp_references focus=true<CR>',
                desc = 'Open any references to this symbol in Trouble',
                mode = 'n',
                noremap = true,
                silent = true,
            },
            {
                ']t',
                function()
                    require('trouble').next({ skip_groups = false, jump = true })
                end,
                desc = 'Next item',
                mode = 'n',
                noremap = true,
                silent = true,
            },
            {
                '[t',
                function()
                    require('trouble').prev({ skip_groups = false, jump = true })
                end,
                desc = 'Prev item',
                mode = 'n',
                noremap = true,
                silent = true,
            },
        },
        config = function()
            require('trouble').setup({})
        end,
    },
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        config = function()
            vim.diagnostic.config({ virtual_text = true }) -- don't use neovim's default virtual_text
            require('tiny-inline-diagnostic').setup({
                options = {
                    show_source = true,
                    multiple_diag_under_cursor = true,
                    -- break_line = {
                    -- 	enabled = true,
                    -- 	after = 60,
                    -- }
                },
            })
        end,
    },
    {
        -- CODE ACTIONS POP-UP
        'rachartier/tiny-code-action.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope.nvim' },
        },
        event = 'LspAttach',
        config = function()
            require('tiny-code-action').setup()
            vim.keymap.set('n', '<leader><leader>la', function()
                require('tiny-code-action').code_action()
            end, { noremap = true, silent = true, desc = 'code action menu' })
        end,
    },
    {
        -- ADD MISSING DIAGNOSTICS HIGHLIGHT GROUPS
        'folke/lsp-colors.nvim',
        config = true,
    },
}
