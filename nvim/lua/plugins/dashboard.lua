return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      local function get_footer()
        return os.date("%d %B %Y • %H:%M:%S")
      end

      require("dashboard").setup({
        theme = "hyper",
        config = {
          header = {
            "                                         ",
            "                                         ",
            "     ██╗ █████╗  ██████╗ ██████╗ ██████╗ ",
            "     ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗",
            "     ██║███████║██║     ██║   ██║██████╔╝",
            "██   ██║██╔══██║██║     ██║   ██║██╔══██╗",
            "╚█████╔╝██║  ██║╚██████╗╚██████╔╝██████╔╝",
            " ╚════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ",
            "                                         ",
          },
          project = {
            enable = false,
            limit = 5,
            icon = "󰉋 ",
            label = "Projects",
            action = "lua Snacks.picker.files(cwd='{path}')",
          },
          mru = { enable = false },
          packages = { enable = false },
          footer = {
            get_footer(),
          },
        },
      })
    end,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
      },
    },
  },
}
