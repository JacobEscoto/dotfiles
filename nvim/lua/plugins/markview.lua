return {
  "OXY2DEV/markview.nvim",
  lazy = false,

  config = function()
    require("markview").setup({
      preview = { enable = true },
    })

    -- Toggle preview
    vim.api.nvim_set_keymap("n", "<leader>md", "<CMD>Markview<CR>", { desc = "Toggles `markview` previews globally" })

    -- Toggle Splitview
    vim.api.nvim_set_keymap(
      "n",
      "<leader>ms",
      "<CMD>Markview splitToggle<CR>",
      { desc = "Toggles `splitview` for current buffer." }
    )
  end,
}
