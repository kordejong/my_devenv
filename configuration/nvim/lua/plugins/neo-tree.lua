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
            filesystem = {
                filtered_items = {
                    hide_by_name = {
                        ".git",
                        "__pycache__",
                    },
                    hide_dotfiles = false,
                    show_hidden_files = true,
                    visible = true,  -- Hidden files will be shown, but dimmed
                },
                follow_current_file = {
                    enabled = true,
                },
            },
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
                -- position = "left",
            },
        })
    end
}
