-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true

-- UI / movement
vim.opt.cursorline = true
vim.opt.hidden = true

-- System
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.updatetime = 250

-- Native Neovim explorer
vim.g.loadeed_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
