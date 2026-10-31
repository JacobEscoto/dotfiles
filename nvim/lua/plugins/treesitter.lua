return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()
    ts.install({
      "bash",
      "lua",
      "go",
      "vim",
      "vimdoc",
      "json",
      "markdown",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "python",
      "rust",
      "svelte",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "bash",
        "sh",
        "lua",
        "go",
        "vim",
        "vimdoc",
        "json",
        "markdown",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "css",
        "python",
        "svelte",
        "rust",
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
