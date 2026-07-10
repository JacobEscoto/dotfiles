return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
    },

    -- load the session for the current directory
    vim.keymap.set("n", "<leader>qs", function()
      require("persistence").load()
    end),
  },
}
