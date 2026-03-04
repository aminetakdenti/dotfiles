return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      'echasnovski/mini.icons',
    },
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()

      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = { padding = 1 },
          icon = { folder_closed = "", folder_open = "", default = "" },
        },
        window = {
          position = "left",
          width = 30,
          mapping_options = { noremap = true, nowait = true },
        },
        filesystem = {
          follow_current_file = true, -- <-- THIS ENABLES AUTO-FOCUS
          group_empty_dirs = true,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
      })


      vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
    end,
    lazy = false, -- neo-tree will lazily load itself
  }
}
