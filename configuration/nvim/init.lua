-- set runtimepath^=~/.vim runtimepath+=~/.vim/after
-- let &packpath = &runtimepath
-- source ~/.vim/vimrc


require("config.lazy")



-- vim.opt.autoindent = true
-- vim.opt.autoread = true
-- vim.opt.autowrite = true
-- vim.opt.autowriteall = true

vim.opt.digraph = true
vim.opt.expandtab = true
vim.opt.formatoptions = "cq"
-- vim.opt.nofoldenable
vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.cmd [[colorscheme nord]]

vim.g["airline_theme"] = "minimalist"
vim.g["airline#theme"] = "minimalist"

vim.api.nvim_set_var("airline_theme", "minimalist")





-- " Default length of a line, used by text formatting using gw
-- set textwidth=110
-- set colorcolumn=+1
-- set wrapmargin=0

-- Disable creation of temporary wikis. This is needed to set the filetype of Markdown files to markdown
-- instead of vimwiki.
vim.g["vimwiki_global_ext"] = 0

-- map <F5> :ClangdSwitchSourceHeader<CR>
-- map <F6> vipgw
-- map <F11> :r $MY_DEVENV/template/source/header.dox<CR>



-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.clangd.setup{
    capabilities = capabilities
}
require'lspconfig'.pyright.setup{
    capabilities = capabilities
}

-- require("clangd_extensions.inlay_hints").setup_autocmd()
-- require("clangd_extensions.inlay_hints").set_inlay_hints()

function _G.toggle_diagnostics()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

-- vim.api.nvim_buf_set_keymap(0, 'n', '<F12>', ':call v:lua.toggle_diagnostics()<CR>', {silent=true, noremap=true})

vim.keymap.set('n', '<F12>', ':call v:lua.toggle_diagnostics()<CR>', {silent=true, noremap=true})

