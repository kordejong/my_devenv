-- :help vim.opt
-- :help option-list


-- vim.opt.autoindent = true
-- vim.opt.autoread = true
-- vim.opt.autowrite = true
-- vim.opt.autowriteall = true

-- " Default length of a line, used by text formatting using gw
-- set textwidth=110
-- set wrapmargin=0


vim.opt.colorcolumn="+1"
vim.opt.digraph = true
vim.opt.expandtab = true
vim.opt.formatoptions = "cq"

-- Preѵiew substitutions live
vim.opt.inccommand = "split"

-- vim.opt.nofoldenable
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 5

vim.opt.shiftwidth = 4

-- Mode is already in the status line
vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.termguicolors = true
