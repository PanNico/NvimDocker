-- Plugin specification for lazy.nvim

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", 
    event = { "BufReadPost", "BufNewFile" },  -- Carica quando apri file
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
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
    end,
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
    tag = "*",
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
      vim.lsp.enable('vimtex_ls')  -- LSP per LaTeX
    end
  },

  -- Vimtex
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 2  -- apri quickfix su errori
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "out",
        options = {
          '-interaction=nonstopmode',
          '-pdf',
          '-shell-escape',
        },
      }
    end
  },
}
