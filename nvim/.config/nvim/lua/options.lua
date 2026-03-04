require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = 'both' -- to enable cursorline!
o.relativenumber = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

-- Show a fold column (this shows the arrow space)
o.foldcolumn = "1"

-- Arrow icons + nicer fold UI
vim.opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  foldsep = "│",
  fold = " ",
}

-- Optional: cleaner fold text
vim.opt.foldtext = ""
