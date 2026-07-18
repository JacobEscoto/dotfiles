return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      require("nvim-tree").setup({
        view = {
          side = "right",
          width = 30,
        },
        git = {
          enable = true,
        },
        renderer = {
          icons = {
            git_placement = "before",
            glyphs = {
              git = {
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "",
                untracked = "",
                deleted = "",
                ignored = "",
              },
            },
          },
        },
        filters = {
          -- Show all dotfiles, except .git and node_modules directories
          dotfiles = false,

          custom = {
            "^\\.git$",
            "^node_modules$",
          },
        },
      })
    end,
  },
}
