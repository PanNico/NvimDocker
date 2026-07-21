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

-- Configure treesitter after plugins are loaded
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if treesitter_ok then
  treesitter.setup({
    ensure_installed = {
      "c", "cpp", "json", "html", "bash", "cmake", "python",
      "make", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
  })
else
  vim.notify("Treesitter not loaded yet, will retry...", vim.log.levels.WARN)
end

-- LSP clangd
local lsp_ok, _ = pcall(vim.lsp.enable, 'clangd')
