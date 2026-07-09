return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "lua", "sh" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  }
}
