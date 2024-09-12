-- Display numbers
vim.wo.relativenumber = true
vim.wo.number = true
vim.opt.statuscolumn = "%{v:lnum} %=%{v:virtnum == 0 ? v:relnum : ''} "

-- Plugins (vim-plug)
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("m4xshen/autoclose.nvim")
vim.call("plug#end")

-- Setup Plugins
require("autoclose").setup()
