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

  use("junegunn/fzf.vim")
end

return nvim_plugins
