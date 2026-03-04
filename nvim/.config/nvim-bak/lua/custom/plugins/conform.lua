return {
  {
    'stevearc/conform.nvim',
    config = function()
      local function get_js_formatter()
        local cwd = vim.fn.getcwd()
        if vim.fn.filereadable(cwd .. '/biome.json') == 1 then
          return { 'biome' }
        else
          return { 'prettier' }
        end
      end

      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          rust = { 'rustfmt' },
          javascript = get_js_formatter,
          javascriptreact = get_js_formatter,
          typescript = get_js_formatter,
          typescriptreact = get_js_formatter,
          json = get_js_formatter,
          jsonc = get_js_formatter,
          markdown = get_js_formatter,
          css = get_js_formatter,
          html = get_js_formatter,
          yaml = get_js_formatter,
          scss = get_js_formatter,
        },
        format_on_save = nil,
      }
      vim.keymap.set('n', '<leader>fm', function()
        require('conform').format { async = true, lsp_fallback = true }
      end, { desc = 'Format file with Conform' })
    end,
  },
}
