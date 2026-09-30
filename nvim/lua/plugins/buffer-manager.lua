return {
  "j-morano/buffer_manager.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  config = function()
    require("buffer_manager").setup({
      line_keys = "1234567890",
      width = 0.5,
      height = 0.5,
      short_file_names = true,
    })

    vim.keymap.set("n", "<leader>b", function()
      require("buffer_manager.ui").toggle_quick_menu()
    end, { desc = "Buffer menu" })
  end,
}
