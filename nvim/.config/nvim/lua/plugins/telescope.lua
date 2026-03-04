return {
  "nvim-telescope/telescope.nvim",

  config = function()
    local builtin = require("telescope.builtin")

    -- Basic searches
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search Current Word" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume Search" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })

    -- Fuzzy search in buffer
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Fuzzy Search Buffer" })

    -- Live grep open files
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep Open Files",
      })
    end, { desc = "Search Open Files" })

    -- Search Neovim config
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search Neovim Config" })

    -- Search Lazy packages
    vim.keymap.set("n", "<leader>ep", function()
      builtin.find_files({
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      })
    end, { desc = "Search Packages" })

    -- Search TODO/FIXME
    vim.keymap.set("n", "<leader>st", function()
      builtin.live_grep({
        prompt_title = "TODOs & FIXMEs",
        grep_open_files = true,
        search = [[\b(TODO|FIXME|NOTE|OPTIMIZE|HACK|BUG)\b]],
      })
    end, { desc = "Search TODOs" })
  end,
}
