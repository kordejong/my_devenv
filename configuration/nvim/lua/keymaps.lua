-- :help vim.keymap.set()

-- Only relevant in case file type is cpp
vim.keymap.set("n", "<F4>", "<cmd>ClangdShowSymbolInfo<CR>")
vim.keymap.set("n", "<F5>", "<cmd>ClangdSwitchSourceHeader<CR>")

-- Format paragraph
vim.keymap.set("n", "<F6>", "vipgw<CR>")

local function quickfix()
    vim.lsp.buf.code_action({ filter = function(a) return a.isPreferred end, apply = true })
end

vim.keymap.set('n', "<F8>", quickfix, {noremap = true, silent = true})

-- vim.keymap.set("n", '<leader>qf', function() vim.lsp.buf.code_action({ filter = function(a) return a.isPreferred end, apply = true }) end)

vim.keymap.set("n", "<F11>", "<cmd>r $MY_DEVENV/template/source/header.dox<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<F12>", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })
