vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file (normal mode)" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (insert mode)" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file (visual mode)" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all (normal mode)" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Exit Neovim" })

-- Set keymaps for telescope	
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope find files with interactive search" })

