-- /root/.config/nvim/lua/user/plugins.lua
-- Plugin specification for lazy.nvim

return {

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- NO config field here!
  },

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "LazyGit",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  -- Nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        update_cwd = true,
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
        actions = { change_dir = { global = true } },
      })
    end
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },

  -- FZF
  "junegunn/fzf",
  "junegunn/fzf.vim",

  -- Git
  "tpope/vim-fugitive",

  -- Colorscheme
  "folke/tokyonight.nvim",

  -- Statusline (Feline)
  "feline-nvim/feline.nvim",

  -- Icons
  "nvim-tree/nvim-web-devicons",

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 22,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = "bash",
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable('clangd')
    end
  },
}
