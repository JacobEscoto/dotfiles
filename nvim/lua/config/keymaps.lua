vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file (normal mode)" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (insert mode)" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (visual mode)" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all (normal mode)" })

-- Exit Neovim
vim.keymap.set({ "n", "t" }, "<leader>q", function()
  vim.cmd("qa")
end, { desc = "Quit Neovim" })

-- Force exit
vim.keymap.set({ "n", "t" }, "<leader>Q", function()
  vim.cmd("qa!")
end, { desc = "Force Quit Neovim" })

-- Snacks keymaps
local Snacks = require("snacks")

vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.files()
end, { desc = "Explorer" })

vim.keymap.set("n", "<leader>.", function()
  Snacks.terminal()
end, { desc = "Terminal" })

vim.keymap.set("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notifications" })
