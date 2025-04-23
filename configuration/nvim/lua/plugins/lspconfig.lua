-- https://github.com/neovim/nvim-lspconfig/blob/master/README.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- https://github.com/python-lsp/python-lsp-server
            require("lspconfig").pylsp.setup({
                capabilities = capabilities,

                -- on_attach = custom_attach,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        -- group = "LspAutoformat",
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                async = false,
                            })
                        end
                    })
                end,

                settings = {
                    pylsp = {
                        plugins = {
                            -- black = {
                            --     enabled = true,
                            -- },
                            -- flake8 = {
                            --     enabled = false,
                            -- },
                            pyls_isort = {
                                enabled = true,
                            },
                            pycodestyle = {
                                maxLineLength = 110,
                            },
                        },
                    },
                },
            })
            require("lspconfig").pyright.setup({
                -- capabilities = capabilities,
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { '*' },
                        },
                    },
                },
            })
            require("lspconfig").clangd.setup({
                capabilities = capabilities,
            })
            require("lspconfig").ruff.setup({
                init_options = {
                    settings = {
                        -- Ruff language server settings go here
                    }
                },
            })

            -- vim.lsp.set_log_level("debug")  -- :LspInfo / :LspLog
        end,
    },
}
