vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "IQBE's Custom Theme"

-- Test man
local highlight = function(group, styles)
  local cmd = "hi " .. group
  if styles.gui then cmd = cmd .. " gui=" .. styles.gui end
  if styles.guifg then cmd = cmd .. " guifg=" .. styles.guifg end
  if styles.guibg then cmd = cmd .. " guibg=" .. styles.guibg end
  vim.cmd(cmd)
end

local colors = {
  dim = "#2c2e33",
  background = "#1D1F21",
  foreground = "#CCFFFF",
  cursor_text = "#C5C8C6",
  cursor = "#969896",
  normal = {
    black = "#696969",
    red = "#E74C3C",
    green = "#2ECC71",
    yellow = "#F1C40F",
    blue = "#3498DB",
    magenta = "#9b59b6",
    cyan = "#1ABC9C",
    white = "#bbbbbb",
  },
  bright = {
    black = "#949494",
    red = "#EF8B80",
    green = "#69DD9A",
    yellow = "#F5D451",
    blue = "#74B9E7",
    magenta = "#BB8ECD",
    cyan = "#3AE4C2",
    white = "#ffffff",
  },
}

highlight("Normal", { guifg = colors.foreground, guibg = colors.background })
highlight("Comment", { guifg = colors.normal.black, gui = "italic" })
highlight("Keyword", { guifg = colors.normal.magenta, gui = "bold" })
highlight("String", { guifg = colors.normal.green })
highlight("Function", { guifg = colors.normal.blue, gui = "bold" })
highlight("Operator", { guifg = colors.normal.magenta })
highlight("Type", { guifg = colors.normal.yellow })
highlight("Constant", { guifg = colors.bright.yellow })
highlight("Variable", { guifg = colors.normal.white })
highlight("CursorLine", { guibg = colors.dim })
highlight("Cursor", { guifg = colors.cursor, guibg = colors.cursor_text })
highlight("LineNr", { guifg = colors.bright.black })
highlight("Visual", { guibg = colors.normal.blue })
highlight("Error", { guifg = colors.normal.red, gui = "bold" })
highlight("Warning", { guifg = colors.bright.yellow, gui = "bold" })
