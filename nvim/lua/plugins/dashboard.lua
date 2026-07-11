return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "  ▄▄▄██▀▀▀▄▄▄       ▄████▄   ▒█████   ▄▄▄▄       ",
            "    ▒██  ▒████▄    ▒██▀ ▀█  ▒██▒  ██▒▓█████▄     ",
            "    ░██  ▒██  ▀█▄  ▒▓█    ▄ ▒██░  ██▒▒██▒ ▄██    ",
            " ▓██▄██▓ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▒██   ██░▒██░█▀      ",
            "  ▓███▒   ▓█   ▓██▒▒ ▓███▀ ░░ ████▓▒░░▓█  ▀█▓    ",
            "  ▒▓▒▒░   ▒▒   ▓▒█░░ ░▒ ▒  ░░ ▒░▒░▒░ ░▒▓███▀▒    ",
            "  ▒ ░▒░    ▒   ▒▒ ░  ░  ▒     ░ ▒ ▒░ ▒░▒   ░     ",
            "  ░ ░ ░    ░   ▒   ░        ░ ░ ░ ▒   ░    ░     ",
            "  ░   ░        ░  ░░ ░          ░ ░   ░          ",
            "                     ░                       ░   ",
            "                                                 ",
            "                                                 ",
          },

          center = {
            {
              icon = "󰱼 ",
              icon_hl = "Title",
              desc = "Find files            ",
              desc_hl = "String",
              key = "f",
              key_hl = "Number",
              key_format = "%s",
              action = "lua Snacks.picker.files()",
            },
          },
          footer = {},
          vertical_center = true,
        },
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("DashboardDirArg", { clear = true }),
        nested = true,
        callback = function()
          if vim.fn.argc() == 1 then
            local arg = vim.fn.argv(0)
            if vim.fn.isdirectory(arg) == 1 then
              vim.cmd.cd(arg)
              vim.cmd("bnext")
              vim.cmd("%bwipeout")
              vim.cmd("Dashboard")
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("DashboardFix", { clear = true }),
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          if filetype == "NvimTree" or filetype == "toggleterm" then
            local dashboard_win = vim.fn.win_findbuf(vim.fn.bufnr("dashboard"))

            for _, win in ipairs(dashboard_win) do
              if vim.api.nvim_win_is_valid(win) and win ~= vim.api.nvim_get_current_win() then
                pcall(vim.api.nvim_win_close, win, false)
              end
            end
          end
        end,
      })
    end,

    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
      },
    },
  },
}
