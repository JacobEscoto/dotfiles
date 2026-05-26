return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({

        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        direction = "float",
        close_on_exit = true,
        float_opts = {
          border = "rounded",
          winblend = 15,
        },
      })
    end,
  },
}
