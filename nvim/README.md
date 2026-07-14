# Neovim Configuration

My personal configuration for the [Neovim editor](https://github.com/neovim/neovim) with custom plugins and keymaps.

## Plugins

The list of plugins is separated by category for better organization in the documentation.


The plugin manager I use is: **[lazy.nvim](https://github.com/folke/lazy.nvim)**

### UI Plugins

| File | Description | Repository |
|------|-------------|------------|
| [theme.lua](lua/plugins/theme.lua) | Colorschemes applied for visual style in editor (GitHub Themes) | [projekt0n/github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) |
| [lualine.lua](lua/plugins/lualine.lua) | Fully customizable and modern status line | [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| [dashboard.lua](lua/plugins/dashboard.lua) | Home screen with quick access keys | [nvimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) |
| [nvim-tree.lua](lua/plugins/nvim-tree.lua)| File explorer | [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) |
| [colorizer.lua](lua/plugins/colorizer.lua) | Color highlighter (hex, rgb, hsl, etc...) | [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)|
| [gitsigns.lua](lua/plugins/gitsigns.lua) | Add symbols to the margin to indicate modifications to the file | [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) |

### Code Edition Plugins

| File | Description | Repository |
|------|-------------|------------|
| [autopairs.lua](lua/plugins/autopairs.lua) | Automatically inserts and closes delimiters | [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) |
| [comment.lua](lua/plugins/comment.lua) | Comment and uncomment lines or blocks of code | [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) |
| [completion.lua](lua/plugins/completion.lua) | Contextual autocompletion using LSP, snippets, and buffer words | [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) |
| [treesitter.lua](lua/plugins/treesitter.lua) | Improves syntax highlighting and structural analysis of code | [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| [conform.lua](lua/plugins/conform.lua) | Format the code automatically when saving | [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) |

### Diagnostics and Linting Plugins

| File | Description | Repository |
|------|-------------|------------|
| [trouble.lua](lua/plugins/trouble.lua) | Groups and displays diagnostics (errors, warnings) in a floating panel | [folke/trouble.nvim](https://github.com/folke/trouble.nvim) |
| [lint.lua](lua/plugins/lint.lua) | It runs linters and flags errors or warnings in the code | [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) |

### Utility Plugins

| File | Description | Repository |
|------|-------------|------------|
| [mason.lua](lua/plugins/mason.lua) | Easily manage LSPs, linters, and formatters | [mason-org/mason.nvim](https://github.com/mason-org/mason.nvim) |
| [toggleterm.lua](lua/plugins/toggleterm.lua) | Open and close a floating terminal | [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) |
| [lazygit.lua](lua/plugins/lazygit.lua) | Lazygit TUI interface to manage commits, branches, etc... | [kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) |
| [which-key.lua](lua/plugins/which-key.lua) | Pop-up menu with all available key combinations | [folke/which-key.nvim](https://github.com/folke/which-key.nvim) |
| [persisted.lua](lua/plugins/persisted.lua) | Automatically saves and restores work sessions | [olimorris/persisted.nvim](https://github.com/olimorris/persisted.nvim) |
| [snacks.lua](lua/plugins/snacks.lua) | A set of lightweight utilities such as notifications, file picker, etc... | [folke/snacks.nvim](https://github.com/folke/snacks.nvim) |
| [markdown.lua](lua/plugins/markdown.lua) | Markdown file previewer in the buffer | [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) |


## Keymaps

> [!NOTE]
> `<leader>` refers to the **SPACE** key defined in [options.lua](lua/config/options.lua)

| Keymap           | Description                          | Mode                            |
|------------------|--------------------------------------|---------------------------------|
|`Ctrl + s`        | Saves the current file               | Normal, insert, and visual mode |
|`Ctrl + a`        | Selects all the text                 | Normal mode                     |
|`<leader>e`       | Toggle file explorer                 | Normal mode                     |
|`<leader><leader>`| Smart picker                         | Normal mode                     |
| `<leader>f`      | Find files                           | Normal mode                     |
|`<leader>.`       | Find files in the current directory  | Normal mode                     |
|`<leader>sg`      | Grep search                          | Normal mode                     |
|`<leader>sb`      | Search buffers                       | Normal mode                     |
|`<leader>N`       | Pop-up notifications history         | Normal mode                     |
|`<leader>cf`      | Format code                          | Normal mode                     |
|`<leader>lg`      | Opens Lazygit TUI                    | Normal mode                     |
|`<leader>rs`      | Restore a session (persisted)        | Normal mode                     |
|`<leader>ws`      | Writes/saves a session manually      | Normal mode                     |
|`Ctrl + t`        | Opens/close a floating terminal      | Normal mode                     |
|`<leader>xx`      | Opens a global diagnostics tab       | Normal mode                     |
|`<leader>xX`      | Opens a local buffer diagnostics tab | Normal mode                     |
|`<leader>xQ`      | Shows a Quickfix list                | Normal mode                     |

