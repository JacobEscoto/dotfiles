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
        { "<leader>f", group = "Search", icon = "󰍉 " },
        { "<leader>e", group = "Explorer" },
        { "<leader>q", group = "Exit" },
        { "<leader>l", group = "Lazy" },

        { "<leader>x", group = "Errors (Trouble)" },
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "View File Errors" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Viw Quickfix List" },
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
