-- Onyx Gold Dark - NvChad Theme
-- Based on the Onyx Gold Dark Ghostty theme by Shawn Lukas

local M = {}

M.base_30 = {
  white = "#eeeeee",
  darker_black = "#0a0a0a",
  black = "#111111", -- nvim bg
  black2 = "#1a1a1a",
  one_bg = "#222222",
  one_bg2 = "#2a2a2a",
  one_bg3 = "#333333",
  grey = "#555555",
  grey_fg = "#777777",
  grey_fg2 = "#666666",
  light_grey = "#999999",
  red = "#eb5757",
  baby_pink = "#f07070",
  pink = "#eb5757",
  line = "#2a2a2a", -- for lines like vertsplit
  green = "#4cc580",
  vibrant_green = "#5dd990",
  nord_blue = "#e5b842",
  blue = "#e5b842",
  yellow = "#e5b842",
  sun = "#f0c850",
  purple = "#eb5757",
  dark_purple = "#c94040",
  teal = "#4cc580",
  orange = "#e5b842",
  cyan = "#4cc580",
  statusline_bg = "#1a1a1a",
  lightbg = "#2a2a2a",
  pmenu_bg = "#e5b842",
  folder_bg = "#e5b842",
}

M.base_16 = {
  base00 = "#111111", -- Default Background
  base01 = "#1a1a1a", -- Lighter Background
  base02 = "#2a2a2a", -- Selection Background
  base03 = "#555555", -- Comments
  base04 = "#999999", -- Dark Foreground
  base05 = "#eeeeee", -- Default Foreground
  base06 = "#dddddd", -- Light Foreground
  base07 = "#eeeeee", -- Light Background
  base08 = "#eb5757", -- Variables, Errors
  base09 = "#e5b842", -- Integers, Constants
  base0A = "#e5b842", -- Classes, Search
  base0B = "#4cc580", -- Strings, Success
  base0C = "#4cc580", -- Regex, Escaped chars
  base0D = "#e5b842", -- Functions, Methods
  base0E = "#e5b842", -- Keywords, Flow control
  base0F = "#eb5757", -- Deprecated, Special
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_16.base05 },
    ["@punctuation.bracket"] = { fg = M.base_30.yellow },
    ["@function.method.call"] = { fg = M.base_30.green },
    ["@function.call"] = { fg = M.base_30.yellow },
    ["@constant"] = { fg = M.base_30.orange },
    ["@variable.parameter"] = { fg = M.base_30.white },
    ["@keyword"] = { fg = M.base_30.yellow },
    ["@string"] = { fg = M.base_30.green },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "onyx-dark")

return M
