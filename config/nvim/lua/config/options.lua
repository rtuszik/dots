-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- -- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false
vim.opt.conceallevel = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4 -- Number of spaces per tab when editing
vim.opt.smartindent = true
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"
vim.g.lazyvim_python_ruff = "ruff"
