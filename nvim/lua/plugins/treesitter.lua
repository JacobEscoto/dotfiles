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
      "java",
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
        "java",
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
