-- https://github.com/neovim/nvim-lspconfig/blob/master/README.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            require("lspconfig").pyright.setup({
                capabilities = capabilities
            })
            require("lspconfig").clangd.setup({
                capabilities = capabilities
            })
            -- vim.lsp.set_log_level("debug")  -- :LspInfo / :LspLog
        end,
    },
}
