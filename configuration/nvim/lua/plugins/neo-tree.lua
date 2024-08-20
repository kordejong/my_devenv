-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/README.md
-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
-- https://www.lunarvim.org/docs/configuration/plugins/example-configurations#neo-tree

return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,  -- Load this during startup, otherwise Neotree command is not available
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",  -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",  -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        {
            "<F1>",
            function()
                require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
            end,
            desc = "NeoTree (cwd)",
        },
    },
    config = function()
        require("neo-tree").setup({
            window = {
                mapping_options = {
                },
                mappings = {
                    ["l"] = {
                        "open",
                    },
                    ["h"] = {
                        "navigate_up",
                    },
                },
            },
        })
    end
}
