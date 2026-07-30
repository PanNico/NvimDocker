-- Feline statusline configuration (TokyoNight colors)

local line_ok, feline = pcall(require, "feline")
if not line_ok then
  return
end

local tokyonight = {
  fg = "#c0caf5",
  bg = "#1a1b26",
  green = "#9ece6a",
  yellow = "#e0af68",
  purple = "#9d7cd8",
  orange = "#ff9e64",
  peanut = "#e0af68",
  red = "#f7768e",
  aqua = "#7dcfff",
  darkblue = "#414868",
  dark_red = "#f7768e",
}

local vi_mode_colors = {
  NORMAL = "green",
  OP = "green",
  INSERT = "yellow",
  VISUAL = "purple",
  LINES = "orange",
  BLOCK = "dark_red",
  REPLACE = "red",
  COMMAND = "aqua",
}

-- Helper: conta diff del file corrente
local function get_file_diff(stat_index)
  local path = vim.fn.expand('%:p')
  if path == "" or vim.bo.filetype == "NvimTree" then return 0 end
  local output = vim.fn.system('git diff --numstat -- "' .. path .. '" 2>/dev/null')
  local total = 0
  for line in output:gmatch("[^\n]+") do
    local n = line:match("^(%d+)")  -- stat_index 1=added, 2=removed
    if stat_index == 2 then
      n = line:match("^%d+\t(%d+)")
    end
    if n then total = total + tonumber(n) end
  end
  return total
end

local c = {
  vim_mode = {
    provider = {
      name = "vi_mode",
      opts = { show_mode_name = true },
    },
    hl = function()
      return {
        fg = require("feline.providers.vi_mode").get_mode_color(),
        bg = "darkblue",
        style = "bold",
        name = "NeovimModeHLColor",
      }
    end,
    left_sep = "block",
    right_sep = "block",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  gitBranch = {
    provider = function()
      local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub("\n", "")
      if branch == "" or vim.bo.filetype == "NvimTree" then return "" end
      return " " .. branch .. " "
    end,
    hl = { fg = "peanut", bg = "darkblue", style = "bold" },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffAdded = {
    provider = function()
      local added = get_file_diff(1)
      if added == 0 then return "" end
      return "+" .. tostring(added) .. " "
    end,
    hl = { fg = "green", bg = "darkblue" },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffRemoved = {
    provider = function()
      local removed = get_file_diff(2)
      if removed == 0 then return "" end
      return "-" .. tostring(removed) .. " "
    end,
    hl = { fg = "red", bg = "darkblue" },
    left_sep = "block",
    right_sep = "block",
  },
  gitDiffChanged = {
    provider = "",
    hl = { fg = "fg", bg = "darkblue" },
    left_sep = "block",
    right_sep = "right_filled",
  },
  separator = {
    provider = "",
  },
  fileinfo = {
    provider = {
      name = "file_info",
      opts = { type = "relative-short" },
    },
    hl = { style = "bold" },
    left_sep = " ",
    right_sep = " ",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  nvim_tree_fullpath = {
    provider = function()
      if vim.bo.filetype == "NvimTree" then
        return " " .. vim.fn.getcwd() .. " "
      end
      return ""
    end,
    hl = { fg = "aqua", bg = "darkblue", style = "bold" },
  },
  diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = { fg = "red" },
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = { fg = "yellow" },
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = { fg = "aqua" },
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  diagnostic_info = {
    provider = "diagnostic_info",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  lsp_client_names = {
    provider = "lsp_client_names",
    hl = { fg = "purple", bg = "darkblue", style = "bold" },
    left_sep = "left_filled",
    right_sep = "block",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  file_type = {
    provider = {
      name = "file_type",
      opts = { filetype_icon = true, case = "titlecase" },
    },
    hl = { fg = "red", bg = "darkblue", style = "bold" },
    left_sep = "block",
    right_sep = "block",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  position = {
    provider = "position",
    hl = { fg = "green", bg = "darkblue", style = "bold" },
    left_sep = "block",
    right_sep = "block",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  line_percentage = {
    provider = "line_percentage",
    hl = { fg = "aqua", bg = "darkblue", style = "bold" },
    left_sep = "block",
    right_sep = "block",
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  scroll_bar = {
    provider = "scroll_bar",
    hl = { fg = "yellow", style = "bold" },
    enabled = function() return vim.bo.filetype ~= "NvimTree" end,
  },
  nvim_tree_label = {
    provider = function()
      if vim.bo.filetype == "NvimTree" then
        return " NvimTree "
      end
      return ""
    end,
    hl = { fg = "aqua", bg = "darkblue", style = "bold" },
  },
}

local right = {
  c.gitBranch,
  c.gitDiffAdded,
  c.gitDiffRemoved,
  c.gitDiffChanged,
  c.position,
  c.file_type,
}

local middle = {
  c.nvim_tree_fullpath,
  c.fileinfo,
  c.diagnostic_errors,
  c.diagnostic_warnings,
  c.diagnostic_info,
  c.diagnostic_hints,
}

local left = {
  c.vim_mode,
  c.nvim_tree_label,
}

local components = {
  active = { left, middle, right },
  inactive = { left, middle, right },
}

feline.setup({
  components = components,
  theme = tokyonight,
  vi_mode_colors = vi_mode_colors,
})
