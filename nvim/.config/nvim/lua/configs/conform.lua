local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier", "biome" },
    html = { "prettier", "biome" },
    typescript = { "prettier", "prettierd", "biome" },
    javascript = { "prettier", "prettierd", "biome" },
    typescriptreact = { "prettier", "prettierd", "biome" },
    javascriptreact = { "prettier", "prettierd", "biome" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
