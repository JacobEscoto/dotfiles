local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Escape
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file and exit insert" })
map("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })

-- Selection & edition
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("v", "<C-c>", '"+y', { desc = "Copy selection to clipboard" })

-- Move lines with Alt+j/k
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate line with Alt+d
map("n", "<A-d>", "yyp", { desc = "Duplicate line" })

-- Scroll
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Undo / Redo
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Neotree (File Explorer)
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep (text)" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "List buffers" })

-- ToggleTerm
map("n", "<C-\\>", ":ToggleTerm<CR>", { desc = "Open floating terminal" })
map("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Exit terminal mode and close" })
map("t", "<C-c>", "<C-\\><C-n>", { desc = "Exit terminal insert mode" })

-- Move between windows/panes (including terminal)
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-Up>", "<C-w>k")
map("n", "<C-Right>", "<C-w>l")

map("t", "<C-Left>", [[<C-\><C-n><C-w>h]])
map("t", "<C-Down>", [[<C-\><C-n><C-w>j]])
map("t", "<C-Up>", [[<C-\><C-n><C-w>k]])
map("t", "<C-Right>", [[<C-\><C-n><C-w>l]])

-- Buffers
map("n", "<leader>c", function()
  local current_buf = vim.api.nvim_get_current_buf()

  if vim.bo[current_buf].modified then
    vim.notify("Save your files first", vim.log.levels.ERROR)
    return
  end

  Snacks.bufdelete()
end, { desc = "Close the current file and show Dashboard" })

-- Exit
map("n", "<leader>q", ":qa!<CR>", { silent = true, desc = "Force Exit Neovim" })
map("i", "<leader>q", "<Esc>:qa!<CR>", { silent = true, desc = "Force Exit Neovim"})
