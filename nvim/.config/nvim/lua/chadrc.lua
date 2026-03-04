---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    enabled = false
  },
  telescope = {
    style = "bordered"
  },
  statusline = {
    separator_style = "round",
    theme = "minimal"
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    [[                                                     ]],
    [[ __      __       .__                                ]],
    [[/  \    /  \ ____ |  |   ____  ____   _____   ____   ]],
    [[\   \/\/   // __ \|  | _/ ___\/  _ \ /     \_/ __ \  ]],
    [[ \        /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/  ]],
    [[  \__/\  /  \___  >____/\___  >____/|__|_|  /\___  > ]],
    [[       \/       \/          \/            \/     \/  ]],
    [[                                                      ]],
  },
  buttons = {
    { txt = "  Find File", keys = "SPC f f", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "SPC f o", cmd = "Telescope oldfiles" },
    { txt = "  Find Word", keys = "SPC f w", cmd = "Telescope live_grep" },
    { txt = "  File Explorer", keys = "SPC e", cmd = "NvimTreeToggle" },
    { txt = "  Config", keys = "SPC c n", cmd = "edit $MYVIMRC" },
    { txt = "  Update Plugins", keys = "SPC p u", cmd = "Lazy sync" },
    { txt = "  Mason Tools", keys = "SPC m", cmd = "Mason" },
    { txt = "󰊳  Restore Session", keys = "SPC s r", cmd = "SessionRestore" },
  }
}

return M
