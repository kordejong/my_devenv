-- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file

return {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")

        -- vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
        -- vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
        -- vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

        -- vim.keymap.set({"i", "s"}, "<C-E>", function()
        --     if ls.choice_active() then
        --         ls.change_choice(1)
        --     end
        -- end, {silent = true})

        -- Expand current item or jump to the next item within the snippet
        vim.keymap.set({"i", "s"}, "<C-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, {silent = true})

        -- Move to the previous item within the snippet
        vim.keymap.set({"i", "s"}, "<C-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, {silent = true})

        -- Useful for choice nodes
        vim.keymap.set({"i"}, "<C-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, {silent = true})

        vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/plugins/luasnip.lua<CR>")

        require("luasnip.loaders.from_lua").lazy_load({paths = { vim.fn.stdpath("config") .. "/snippets"}})

        -- s: new snippet
        -- t: format
        -- i: insert node
        -- rep: repeat node
    end,
}
