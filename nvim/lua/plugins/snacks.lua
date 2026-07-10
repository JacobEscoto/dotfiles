return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        row = nil,
        col = nil,
        pane_gap = 4,
        preset = {
          header = [[
 ▄▄▄██▀▀▀▄▄▄       ▄████▄   ▒█████   ▄▄▄▄   
   ▒██  ▒████▄    ▒██▀ ▀█  ▒██▒  ██▒▓█████▄ 
   ░██  ▒██  ▀█▄  ▒▓█    ▄ ▒██░  ██▒▒██▒ ▄██
▓██▄██▓ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▒██   ██░▒██░█▀  
 ▓███▒   ▓█   ▓██▒▒ ▓███▀ ░░ ████▓▒░░▓█  ▀█▓
 ▒▓▒▒░   ▒▒   ▓▒█░░ ░▒ ▒  ░░ ▒░▒░▒░ ░▒▓███▀▒
 ▒ ░▒░    ▒   ▒▒ ░  ░  ▒     ░ ▒ ▒░ ▒░▒   ░ 
 ░ ░ ░    ░   ▒   ░        ░ ░ ░ ▒   ░    ░ 
 ░   ░        ░  ░░ ░          ░ ░   ░      
                  ░                       ░]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, paddin = 1 },
          { section = "startup" },
        },
      },
      indent = {
        priority = 1,
        enabled = true,
        char = "│",
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      terminal = {
        win = {
          style = "terminal",
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      picker = {
        prompt = " ",
        sources = {},
        focus = "input",
        show_delay = 5000,
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
