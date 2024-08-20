-- :help vim.keymap.set()


-- Diagnostic keymaps
vim.keymap.set("n", "<F12>", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })


-- Only relevant in case file type is cpp
vim.keymap.set("n", "<F5>", "<cmd>ClangdSwitchSourceHeader<CR>")

-- Format paragraph
vim.keymap.set("n", "<F6>", "vipgw<CR>")

vim.keymap.set("n", "<F11>", "<cmd>r $MY_DEVENV/template/source/header.dox<CR>")
