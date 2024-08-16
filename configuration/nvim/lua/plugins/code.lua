-- https://github.com/hrsh7th/nvim-cmp/blob/main/README.md

return {
    {
        -- "nvim-treesitter/nvim-treesitter",

        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- 'hrsh7th/cmp-cmdline'
        },
    },
}
