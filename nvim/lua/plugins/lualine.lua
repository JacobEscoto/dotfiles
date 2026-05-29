return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "neo-tree", "TelescopePrompt" },
          },
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "", right = "" } } },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", file_status = true, path = 1 },
            {
              "navic",
              color_correction = "nil",

              cond = function() return require("nvim-navic").is_available() end
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { left = "", right = "" } } },
        },
      })
    end
  },
}
