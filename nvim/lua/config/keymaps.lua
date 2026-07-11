-- Save file (normal, insert, and visual mode)
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file (normal mode)" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (insert mode)" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (visual mode)" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all (normal mode)" })

-- Explorer
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })

-- Snacks keymaps
local Snacks = require("snacks")

-- Smart picker
vim.keymap.set("n", "<leader><leader>", function()
  Snacks.picker.smart({ cwd = vim.fn.getcwd() })
end, { desc = "Smart Picker" })

-- Find files
vim.keymap.set("n", "<leader>f", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

-- Find files in current directory
vim.keymap.set("n", "<leader>.", function()
  Snacks.picker.files({ cwd = vim.fn.getcwd() })
end, { desc = "Find Files (Current Dir)" })

-- Grep search
vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep Search" })

-- Buffers
vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.buffers()
end, { desc = "Search Buffers" })

-- Notifications
vim.keymap.set("n", "<leader>N", function()
  Snacks.notifier.show_history()
end, { desc = "Notifications" })

-- Help
vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Which-key" })
