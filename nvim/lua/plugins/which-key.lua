return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,

    config = function()
      local wkey = require("which-key")

      wkey.setup({
        preset = "helix",
        delay = 0,
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "▸",
        },
      })

      wkey.add({
        {
          "<C-s>",
          desc = "Save file",
          mode = { "n", "i", "v" },
        },
        {
          "<C-a>",
          desc = "Select all",
        },
        {
          "<leader><leader>",
          desc = "Smart picker",
        },
        {
          "<leader>lg",
          desc = "Opens LazyGit",
          icon = "",
        },

        -- Search Group (Grep, Buffers)
        {
          "<leader>s",
          group = "Search",
          icon = "",
        },
        {
          "<leader>sg",
          desc = "Grep",
        },
        {
          "<leader>sb",
          desc = "Buffers",
        },

        {
          "<leader>f",
          group = "Files",
          icon = "",
        },
        {
          "<leader>f",
          desc = "Find files",
        },

        -- Diagnostics Group
        {
          "<leader>x",
          group = "Diagnostics",
          icon = "",
        },
        {
          "<leader>xx",
          desc = "All diagnostics",
        },
        {
          "<leader>xX",
          desc = "Buffer diagnostics",
        },
        {
          "<leader>xL",
          desc = "Location list",
        },
        {
          "<leader>xQ",
          desc = "Quickfix list",
        },

        {
          "<leader>c",
          group = "Code",
          icon = "",
        },
        {
          "<leader>cf",
          desc = "Format buffer",
        },
        {
          "<leader>cl",
          desc = "LSP references",
        },

        {
          "<leader>t",
          desc = "Terminal",
          icon = "",
        },
        {
          "<leader>N",
          desc = "Notifications",
          icon = "󱅫",
        },

        {
          "<leader>?",
          desc = "Which-key",
          icon = "",
        },
      })
    end,
  },
}
