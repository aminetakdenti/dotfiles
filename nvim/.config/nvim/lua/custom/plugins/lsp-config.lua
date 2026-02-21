return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'saghen/blink.cmp', opts = {} }, -- Blink completion
    },
    config = function()
      -- LSP capabilities for nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- On attach function for keymaps
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', vim.lsp.buf.references, 'References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('K', vim.lsp.buf.hover, 'Hover')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
      end

      -- Configure diagnostics
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = true,
        virtual_text = { spacing = 2, source = 'if_many' },
      }

      -- LSP servers list
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        ts_ls = {}, -- modern name for tsserver
        -- gopls = {},
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  '^containerClassName\\s*=\\s*{?\\s*[`"]([^"\'`]+)["\'`]\\s*}?$',
                },
              },
            },
          },
        },
      }

      -- Mason setup
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      require 'lspconfig'

      for name, config in pairs(servers) do
        vim.lsp.config(name, {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = config.settings,
        })
      end

      -- Setup Blink completion UI
      local blink_ok, blink = pcall(require, 'blink.cmp')
      if blink_ok then
        blink.setup {
          highlight_current_item = true,
          show_hover = true,
          show_diagnostics = true,
        }
      end
    end,
  },
}
