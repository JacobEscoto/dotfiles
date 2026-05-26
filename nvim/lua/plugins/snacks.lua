return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
     ██╗ █████╗  ██████╗ ██████╗ ██████╗ 
     ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
     ██║███████║██║     ██║   ██║██████╔╝
██   ██║██╔══██║██║     ██║   ██║██╔══██╗
╚█████╔╝██║  ██║╚██████╗╚██████╔╝██████╔╝
 ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ]],

          keys = {
            { icon = " ", key = "n", desc = "New File",            action = ":ene | startinsert" },
            { icon = "󱉭 ", key = "p", desc = "Recent Projects",    action = ":Telescope oldfiles" },
            { icon = "󰈞 ", key = "f", desc = "Search File",        action = ":Telescope find_files" },
            { icon = "󱓞 ", key = "m", desc = "Open Mason (LSP)",   action = ":Mason" },
            { icon = "󰒲 ", key = "l", desc = "Lazy Status",        action = ":Lazy" },
            { icon = "󰅚 ", key = "q", desc = "Exit",               action = ":qa" },
          },
        },

        sections = {
          { section = "header" },
          { section = "keys",    gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },

    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        once = false,
        callback = function()

          vim.defer_fn(function()
            vim.cmd("Neotree show")
            vim.cmd("wincmd p")
          end, 60)
        end,
      })
    end,
  },
}
