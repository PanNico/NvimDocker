-- /root/.config/nvim/init.lua
-- Main entry point — coordinator

-- Load system infrastructure options (always)
require("system.options")

-- Bootstrap lazy.nvim and load plugins
require("system.lazy")

-- Load user init if it exists (post-plugin customization)
local user_init_path = vim.fn.stdpath("config") .. "/lua/user/init.lua"
if vim.fn.filereadable(user_init_path) == 1 then
  require("user")
end
