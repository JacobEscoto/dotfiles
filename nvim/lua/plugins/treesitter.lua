return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install({ "bash", "lua", "go", "vim", "vimdoc", "json", "markdown" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bash", "sh", "lua", "go", "vim", "vimdoc", "json", "markdown" },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
