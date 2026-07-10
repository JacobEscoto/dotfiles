return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      notify_on_error = true,

      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },

      formatters_by_ft = {
        go = { "goimports", "gofumpt" },

        lua = { "stylua" },

        sh = { "shfmt" },

        bash = { "shfmt" },
      },
    },

    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        desc = "Format Buffer",
      },
    },
  },
}
