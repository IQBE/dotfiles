--------------------
-- MY NVIM CONFIG --
-- By IQBE        --
--------------------

-- Disable mouse controls
vim.o.mouse = ""

-- Display numbers
vim.wo.relativenumber = true
vim.wo.number = true

-- Display cross
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- Tab width
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Setup colors
vim.opt.termguicolors = true

-- Plugins (lazy.nvim)
require("config.lazy")
vim.cmd.colorscheme "catppuccin-mocha"
