-- Custom initialization sequence

require("user.keymaps")
require("user.options")
require("user.colorscheme")
require("user.bottomline")

-- Telescope is already loaded as plugin, just configure it after loading
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    pcall(telescope.load_extension, "fzf")
end
