-- Config/Basic/nvim/lua/config/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

-- Prepend lazy path to runtimepath
vim.opt.rtp:prepend(lazypath)

-- Get plugins from user/plugins.lua
local plugins_spec = require("user.plugins")

-- Setup lazy.nvim
return require("lazy").setup({
  spec = plugins_spec,
  defaults = {
    lazy = false,
    version = nil,
  },
  install = {
    colorscheme = { "habamax" },
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {},
    },
  },
})
