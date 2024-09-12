-- Display numbers
vim.wo.relativenumber = true
vim.wo.number = true
vim.opt.statuscolumn = "%{v:lnum} %=%{v:virtnum == 0 ? v:relnum : ''} "

-- Plugins (vim-plug)
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("m4xshen/autoclose.nvim")
Plug("neoclide/coc.nvim", {['branch'] = 'release'})
Plug("nvim-treesitter/nvim-treesitter", {['do'] = ':TSUpdate'})
Plug("ap/vim-css-color")
vim.call("plug#end")

-- Setup Plugins
require("autoclose").setup()
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true, noremap = true})
