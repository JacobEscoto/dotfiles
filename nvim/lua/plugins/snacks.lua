return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        indent = {
          char = "¦",
        },
        scope = {
          char = "¦",
        },
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      picker = {
        prompt = " ",
        sources = {},
        focus = "input",
        jump = {
          jumplist = true,
          tagstack = false,
          reuse_win = false,
          close = true,
        },
        layout = {
          cycle = true,
          preset = function()
            return vim.o.columns >= 120 and "default" or "vertical"
          end,
        },
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = true,
          sort_empty = false,
        },
        sort = {
          fields = { "score:desc", "#text", "idx" },
        },
        ui_select = true,
      },
      words = { enabled = false },
      image = { enabled = false },
      scroll = { enabled = false },
      zen = { enabled = false },
    },
  },
}
