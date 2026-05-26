return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      local transparent = require("transparent")

      transparent.setup({
        extra_groups = {
          "NormalFloat",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "NeoTreeWinSeparator"
        },

        exclude_groups = {},
      })
      transparent.clear_prefix("NeoTree")
      vim.cmd("TransparentEnable")

      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

      vim.api.nvim_create_autocmd("WinNew", {
        group = vim.api.nvim_create_augroup("CleanFloatsOpacity", { clear = true }),
        callback = function()
          vim.schedule(function()
            local win = vim.api.nvim_get_current_win()
            if vim.api.nvim_win_get_config(win).relative ~= "" then
              vim.wo[win].winblend = 0
            end
          end)
        end,
      })
    end,
  },
}
