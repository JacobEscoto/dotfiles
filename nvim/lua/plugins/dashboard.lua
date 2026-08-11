return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  opts = function()
    local logo = {
      "",
      "",
      "",
      "     ██╗ █████╗  ██████╗ ██████╗ ██████╗  ",
      "     ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗ ",
      "     ██║███████║██║     ██║   ██║██████╔╝ ",
      "██   ██║██╔══██║██║     ██║   ██║██╔══██╗ ",
      "╚█████╔╝██║  ██║╚██████╗╚██████╔╝██████╔╝ ",
      " ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝  ",
      "",
      "",
      "",
    }

    local opts = {
      theme = "doom",
      hide = {
        statusline = false,
      },

      config = {
        header = logo,

        center = {
          {
            action = "Snacks.picker.files()",
            desc = " Find file",
            icon = "󰱼 ",
            key = "f",
          },
          {
            action = "Snacks.picker.grep()",
            desc = " Find text",
            icon = "󱩾 ",
            key = "g",
          },
          {
            action = function()
              if _G.PersistedSnacksPicker then
                _G.PersistedSnacksPicker()
              end
            end,
            desc = " Restore session",
            icon = "󰦛 ",
            key = "s",
          },
          {
            action = "Lazy",
            desc = " Lazy",
            icon = "󰒲 ",
            key = "L",
          },
          {
            action = function()
              vim.api.nvim_input("<cmd>qa<cr>")
            end,
            desc = " Quit",
            icon = " ",
            key = "q",
          },
        },

        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { " Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 35 - #button.desc)
      button.key_format = "  %s"
    end

    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
