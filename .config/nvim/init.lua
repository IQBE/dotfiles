--------------------
-- MY NVIM CONFIG --
-- By IQBE        --
--------------------

-- Disable mouse controls
vim.o.mouse = ""

-- Windows options
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- Options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.incsearch = true

-- Custom keybindings
-- Move (selected) line(s) up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", ":m .+1<CR>==")
vim.keymap.set("n", "K", ":m .-2<CR>==")

-- Indenting using > and < in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Plugins (lazy.nvim)
require("config.lazy")
vim.cmd.colorscheme "catppuccin-mocha"

-- Keymappings
require("config.keymaps")
