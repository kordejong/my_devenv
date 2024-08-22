-- https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md#default-mappings
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        -- "nvim-treesitter/nvim-treesitter",  -- Use built-in version
        "sharkdp/fd",
    },
    config = function()
        -- defaults = {
        --     layout_strategy = "flex",
        --     layout_config = {
        --         horizontal = {
        --             size = {
        --                 width = "90%",
        --                 height = "90%",
        --             },
        --         },
        --         vertical = {
        --             size = {
        --                 width = "90%",
        --                 height = "90%",
        --             },
        --         },
        --     },
        -- }
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end,
}
