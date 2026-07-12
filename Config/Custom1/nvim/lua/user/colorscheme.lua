-- /root/.config/nvim/lua/user/colorscheme.lua
-- Color scheme setup

-- Use pcall to avoid errors if tokyonight is not yet installed
local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not ok then
  vim.cmd("colorscheme habamax") -- fallback
end

