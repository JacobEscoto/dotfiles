# dotfiles - JacobEscoto

My personal development environment for WSL2(Debian), centered around Fish and curated set of CLI tools.

## What's included

| Config     | Tool                              |
|:-----------|:----------------------------------|
|`fish/`     | Fish shell + abbreviations        |
|`yazi/`     | Terminal file manager             |
|`git/`      | *.gitconfig* with GitHub CLI auth |
|`wsl/`      | *wsl.conf* for WSL2 settings      |
|`starship/` | Shell prompt                      |
|`scripts/`  | Setup, verify and update scripts  |

## CLI Tools installed

| Tool                           | Description                                  |
|:-------------------------------|:---------------------------------------------|
|**fish**                        | Shell                                        |
|**yazi**                        | File manager                                 |
|**starship**                    | Shell prompt                                 |
|**eza**                         | Modern `ls` replacement                      |
|**bat**                         | Modern `cat` + syntax highlighting           |
|**fd**                          | Fast `find` replacement                      |
|**fzf**                         | Fuzzy finder                                 |
|**ripgrep**                     | Fast `grep` replacement                      |
|**zoxide**                      | Smart `cd` replacement                       |
|**lazygit**                     | TUI for Git                                  |
|**glow**                        | Markdown viewer in terminal                  |
|**gh**                          | GitHub CLI                                   |
|**micro**                       | Simple terminal editor                       |
|**node@24** + **pnpm**          | JavaScript runtime + package manager         |
|**sevenzip**                    | Tool for compressing/decompressing files     |
|**go**, **openjdk**, **python** | Set of frequently used language technologies |

## Install

### Prerequisites
- WSL2 with Debian
- Git available

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/JacobEscoto/dotfiles ~/dotfiles

# 2. Run setup
cd ~/dotfiles
bash scripts/setup.sh

# 3. Restart WSL (from PowerShell)
wsl --shutdown

# 4. Reopen WSL and authenticate GitHub
gh auth login
```

## Verify the setup

```bash
bash ~/dotfiles/scripts/verify.sh
```
Checks that all tools are installed, symlinks exist, and GitHub auth is active.

## Update everything

```bash
bash ~/dotfiles/scripts/update.sh
```
Updates Homebrew packages, Fish plugins, and pnpm in one command.