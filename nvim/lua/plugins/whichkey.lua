return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",

      win = {
        border = "rounded",
        padding = { 1, 2 },
        wo = {
          winblend = 0,
        },
      },

      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true },
      },

      spec = {
        { "<C-\\>", group = "Terminal", icon = "  " },
        { "<leader>f", group = "Search", icon = "󰍉 " },
        { "<leader>e", group = "Explorer" },
        { "<leader>q", group = "Exit" },
        { "<leader>l", group = "Lazy" },
        { "<leader>m", group = "Mason" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Show keymaps for current buffer",
      },
    },
  },
}
