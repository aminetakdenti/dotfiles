return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { "biome", 'markdownlint' },
        javascript = { "biome", 'eslint' },
        typescript = { "biome", 'eslint' },
        javascriptreact = { "biome", 'eslint' },
        typescriptreact = { "biome", 'eslint' },
        json = { "biome", 'eslint' },
        lua = { 'luacheck' },
      }
    end,
  },
}
