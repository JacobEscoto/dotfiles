return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function()
      local wk = require("which-key")

      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 9,
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        popup_margins = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        win = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2},
          winblend = 0,
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        show_help = true,
        triggers = { "<leader>" },
      })

      wk.add({
        { "<leader>c", group = "code" },
        { "<leader>d", group = "diagnostics" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "gitsigns" },
        { "<leader>l", group = "lsp" },
        { "<leader>r", group = "rename" },
      })
    end,
  },
}
