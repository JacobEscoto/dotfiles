# Dotfiles - JacobEscoto

[![WSL2](https://img.shields.io/badge/WSL%20(Debian)-A81D33?style=for-the-badge&logo=debian&logoColor=white)](https://learn.microsoft.com/en-us/windows/wsl/)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Fish](https://img.shields.io/badge/Fish%20Shell-34C534?style=for-the-badge&logo=fishshell&logoColor=white)](https://fishshell.com/)

My personal development environment in WSL using selected CLI tools.

## Folder Structure

```
dotfiles/
├── fish/           # Fish shell configurations + abbreviations
├── git/            # Git configuration with GitHub CLI auth
├── lazygit/        # Lazygit custom scripts and configuration
├── micro/          # Micro keybindings, configuration, and colorschemes
├── nvim/           # Neovim options, keymaps, and custom plugins
├── starship/       # Shell custom prompt
├── wsl/            # WSL personal settings
└── yazi/           # Terminal file manager keymaps and configuration
```

## Installation

### Prerequisites

- WSL2 (Debian Distro)
- Git installed


> [!NOTE]
> For more information on what the `setup` script will execute, see the [Terminal Tools Included](#terminal-tools-included) section.

### Steps

```bash
# 1. Clone the repository
git clone git@github.com:JacobEscoto/dotfiles.git ~/dotfiles

# 2. Change directory to dotfiles and run setup script
cd ~/dotfiles
bash scripts/setup.sh

# 3. Restart WSL (from PowerShell)
wsl --shutdown

# 4. Reopen WSL and authenticate with GitHub
gh auth login
```

## Terminal Tools Included

### Shell foundations

- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs)
- [Zoxide](https://crates.io/crates/zoxide)

### File management and exploration

- [eza](https://eza.rocks/)
- [fd](https://github.com/sharkdp/fd)
- [yazi](https://yazi-rs.github.io/)
- [fzf](https://junegunn.github.io/fzf/)
- [sevenzip](https://7-zip.org/)

### Text processing and visualization

- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/burntsushi/ripgrep)
- [glow](https://github.com/charmbracelet/glow)

### Code development and version control

- [Neovim](https://neovim.io/)
- [Micro](https://micro-editor.github.io/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [gh](https://cli.github.com/)
- [Node.js](https://nodejs.org/en)
- [pnpm](https://pnpm.io/installation)
- [Go](https://go.dev/)
- [Python](https://www.python.org/)

### Extras

- [Gum: glamorous shell scripts](https://github.com/charmbracelet/gum)

## Neovim configuration

For a complete list of plugins, LSP settings, and custom keybindings, please check out the [Neovim configuration documentation](nvim/README.md)

## Scripts

- [setup.sh](scripts/setup.sh): Installs and configures the development environment within the terminal.
- [clean.sh](scripts/clean.sh): Removes and cleans user cache, logs, old packages, and swap files.
- [project.sh](scripts/project.sh): Fast project picker for Neovim/VS Code.

