return {
  {
    "olimorris/persisted.nvim",
    event = "BufReadPre",
    opts = {
      auto_start = true,
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      follow_cwd = true,
      use_git_branch = false,
      autoload = false, -- Automatically load the session for the cwd on Neovim startup?

      should_autoload = function()
        return vim.bo.filetype ~= "dashboard" and vim.bo.filetype ~= "NvimTree"
      end,

      allowed_dirs = {
        "~/dotfiles",
        "~/projects",
      },

      ignored_dirs = {
        "~/.config",
        "~/.local",
      },

      telescope = {
        mappings = {
          copy_session = "<C-c>",
          delete_session = "<C-d>",
        },
        icons = {
          selected = " ",
          dir = "  ",
          branch = " ",
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      require("telescope").setup({})
    end,
  },
}
