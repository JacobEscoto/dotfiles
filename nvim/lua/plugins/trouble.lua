return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    opts = {
      win = {
        border = "rounded",
        position = "bottom",
        height = 10,
      },

      modes = {
        diagnostics = {
          filter = {
            any = {
              buf = 0,
            },
          },
        },
      },
      auto_close = true
    },
  },
}
