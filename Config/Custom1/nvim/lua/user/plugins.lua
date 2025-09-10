local nvim_plugins = {}

function nvim_plugins.use_plugins(use)
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  })

  use({
    -- requires https://github.com/jesseduffield/lazygit
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
        "nvim-lua/plenary.nvim",
    }
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
    }
  })

  use('nvim-tree/nvim-tree.lua')
  use("petertriho/nvim-scrollbar")


  use("junegunn/fzf")
  use("junegunn/fzf.vim")

  
  use('tpope/vim-fugitive')
  use('folke/tokyonight.nvim')
  use('feline-nvim/feline.nvim')
  use('nvim-tree/nvim-web-devicons')

  use({
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  })
end

return nvim_plugins
