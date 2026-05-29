return {
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "LspAttach",
    config = function ()
      local navic = require("nvim-navic")

      navic.setup({
        lsp = {
          auto_attach = true,
        },
        highlight = true,
        separator = " ➜ ",
      })
    end,
  },
}
