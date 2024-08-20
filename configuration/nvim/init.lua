-- Set leaders before plugins are loaded
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.g.editorconfig = true
vim.g.have_nerd_font = true

require "options"
require "keymaps"
require("config.lazy")

-- require("clangd_extensions.inlay_hints").setup_autocmd()
-- require("clangd_extensions.inlay_hints").set_inlay_hints()

vim.api.nvim_create_user_command("KDJReloadConfig", "source $MYVIMRC", {})
