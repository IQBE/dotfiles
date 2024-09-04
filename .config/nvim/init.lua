vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.statuscolumn = "%{v:lnum} %=%{v:virtnum == 0 ? v:relnum : ''} "
