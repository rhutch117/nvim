local M = {}

function M.setup(mappings)
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    vim.lsp.config.pylsp = vim.tbl_extend('force', vim.lsp.config.pylsp or {}, {
        diagnostics = {
            -- keep parity with your Go/Lua setup (tiny-inline-diagnostic handles inline)
            virtual_text = false,
        },
        capabilities = capabilities,
        filetypes = { 'python' },
        root_dir = function(fname)
            return vim.fs.root(fname, {
                'pyproject.toml',
                'setup.cfg',
                'setup.py',
                'requirements.txt',
                '.git',
            }) or vim.fn.getcwd()
        end,

        on_attach = function(client, bufnr)
            mappings(client, bufnr)
            pcall(function()
                require('illuminate').on_attach(client)
            end)

            -- Soft workaround if semantic tokens aren’t advertised
            if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                if semantic then
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = {
                            tokenTypes = semantic.tokenTypes,
                            tokenModifiers = semantic.tokenModifiers,
                        },
                        range = true,
                    }
                end
            end
        end,

        settings = {
            pylsp = {
                plugins = {
                    -- --- Linting / style
                    pyflakes = { enabled = true },
                    mccabe = { enabled = true, threshold = 15 },
                    pycodestyle = {
                        enabled = true,
                        maxLineLength = 88, -- align with Black
                        ignore = { 'E203', 'W503' }, -- Black-compatible
                    },
                    ruff = { enabled = true }, -- set to true if using ruff plugin

                    -- --- Type checking (requires pylsp-mypy)
                    pylsp_mypy = {
                        enabled = false, -- set true if you have pylsp-mypy installed
                        live_mode = true,
                        dmypy = false,
                    },

                    black = { enabled = false },
                    isort = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                },
            },
        },

        init_options = {
            usePlaceholders = true,
        },
    })

    vim.lsp.enable('pylsp')
end

return M
