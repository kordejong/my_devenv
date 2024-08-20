return {
    {
        "shaunsingh/nord.nvim",
        lazy = false,  -- Load this during startup, it is the main colorscheme
        priority = 1000,  -- Load this before all the other start plugins
        config = function()
            vim.cmd.colorscheme("nord")
        end,
    },
}
