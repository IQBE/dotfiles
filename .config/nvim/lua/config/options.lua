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
vim.opt.listchars = {
  space = "·",
  tab = "→ ",
  trail = "~",
  extends = ">",
  precedes = "<"
}
vim.opt.list = true
