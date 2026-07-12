-- /root/.config/nvim/lua/system/options.lua
-- System infrastructure options for X11/terminal interaction
-- User preferences belong in /root/.config/nvim/lua/user/options.lua

-- Clipboard: enable copy/paste with host system clipboard (X11/Wayland)
vim.opt.clipboard = "unnamedplus"

-- Mouse: enable mouse support in terminal
vim.opt.mouse = "a"
