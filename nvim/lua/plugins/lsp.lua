return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local signs = { Error = " ", Warn = " ", Hint = " 󰌵", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●", severity_sort = true },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      require("mason").setup({
        ui = { border = "rounded" }
      })

      local servers = { "html", "cssls", "ts_ls", "astro", "tailwindcss", "lua_ls" }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      for _, server in ipairs(servers) do
        local config = { capabilities = capabilities }

        if server == "lua_ls" then
          config.settings = {
            Lua = {
              runtime = {
                version= "LuaJIT"
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
        }
      end

      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
  },
}
