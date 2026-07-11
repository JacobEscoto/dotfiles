return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "shfmt",
        "goimports",
        "gofumpt",

        -- Linters
        "luacheck",
        "shellcheck",
        "golangci-lint",
      },

      run_on_start = true,
      auto_update = false,
      debounce_hours = 24,
    },
  },
}
