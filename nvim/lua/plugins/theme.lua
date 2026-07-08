return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
          hide_end_of_buffer = true,
          transparent = false,
          terminal_colors = true,
        },
			})
			vim.cmd("colorscheme github_dark")
		end,
	}
}
