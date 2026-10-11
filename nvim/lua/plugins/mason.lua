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
        --Languages
        "gopls",
        "lua_ls",
        "bashls",
        "typescript-language-server",
        "rust-analyzer",
        "css-lsp",
        "html-lsp",
        "emmet-language-server",

        -- Formatters
        "stylua",
        "shfmt",
        "goimports",
        "gofumpt",
        "prettier",

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
