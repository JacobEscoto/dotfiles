return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
	build = "make",
      }
    }
  }
}
