-- https://github.com/neovim/nvim-lspconfig/blob/master/README.md
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

return {
    "neovim/nvim-lspconfig",
    config = function()
        -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require("lspconfig").pyright.setup({
        })
        -- require("lspconfig").pyright.setup({
        --     capabilities = capabilities
        -- })
        require("lspconfig").clangd.setup({
        })
        -- require("lspconfig").clangd.setup({
        --     capabilities = capabilities
        -- })
    end,
    keys = {
        {
            "<F12>",
            function()
                vim.diagnostic.enable(not vim.diagnostic.is_enabled())
            end,
            desc = "Toggle diagnostics",
        },
    },
}
