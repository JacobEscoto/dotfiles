local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Neotree (File Explorer)
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "List buffers" })

-- ToggleTerm
map("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Open floating terminal" })
map("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Exit terminal mode and close" })

map("n", "<C-a>", "ggVG")                       -- Select all text (Ctrl + A)
map("v", "<C-c>", '"+y')                        -- Copy text in visual mode (Ctrl + C)
map("n", "<C-z>", "u")                          -- Undo in normal mode (Ctrl + Z)
map("n", "<C-y>", "<C-r>")                       -- Redo in normal mode (Ctrl + Y)

map("n", "<leader>tn", ":tabnew<CR>")           -- New tab (Space + t + n)
map("n", "<leader>tc", ":tabclose<CR>")         -- Close current tab (Space + t + c)
map("n", "<leader>tl", ":tabnext<CR>")          -- Next tab (Space + t + l)
map("n", "<leader>th", ":tabprevious<CR>")      -- Previous tab (Space + t + h)

map("n", "<leader>st", ":botright split | terminal<CR>i")   -- Open terminal (Space + s + t)
map("t", "<Esc>", [[<C-\><C-n>]])                           -- Exit terminal mode (Esc)

-- Move between windows/panes (including terminal) with Ctrl + arrows
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-Up>", "<C-w>k")
map("n", "<C-Right>", "<C-w>l")

map('t', '<C-Left>', [[<C-\><C-n><C-w>h]])
map('t', '<C-Down>', [[<C-\><C-n><C-w>j]])
map('t', '<C-Up>', [[<C-\><C-n><C-w>k]])
map('t', '<C-Right>', [[<C-\><C-n><C-w>l]])

map("n", "<leader>c", function()
  local current_buf = vim.api.nvim_get_current_buf()

  if vim.bo[current_buf].modified then
    vim.notify("Save your files first", vim.log.levels.ERROR)
    return
  end

  Snacks.bufdelete()
end, { desc = "Close the current file and show Dashboard" })

map("n", "<leader>q", ":qa!<CR>", { silent = true, desc = "Force Exit Neovim" })
map("i", "<leader>q", "<Esc>:qa!<CR>", { silent = true, desc = "Force Exit Neovim"})
