require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  callback = function()
    print("Lua file saved!")
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lspinfo,help,lspsagahover,*,vim,lua", -- lsp popups or relevant float types
  callback = function()
    -- Map Ctrl-i in insert mode to go to normal mode in the float
    vim.keymap.set("i", "<C-i>", "<Esc>", { buffer = true, silent = true })
  end,
})
