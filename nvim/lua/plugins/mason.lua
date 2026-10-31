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
        "clangd",
        "css-lsp",
        "html-lsp",
        "emmet-language-server",
        "astro-language-server",
        "svelte-language-server",
        "tailwindcss-language-server",
        "pyright",

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
        "ruff",
      },

      run_on_start = true,
      auto_update = false,
      debounce_hours = 24,
    },
  },
}
