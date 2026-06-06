#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "      DOTFILES setup - JacobEscoto      "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Symlinks
echo "▶ Creating symlinks..."

ln -sfv "$DOTFILES_DIR/fish"           ~/.config/fish
ln -sfv "$DOTFILES_DIR/nvim"           ~/.config/nvim
ln -sfv "$DOTFILES_DIR/tmux"           ~/.config/tmux
ln -sfv "$DOTFILES_DIR/yazi"           ~/.config/yazi
ln -sfv "$DOTFILES_DIR/starship.toml"  ~/.config/starship.toml
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig

echo ""

# Homebrew
if ! command -v brew &> /dev/null; then
  echo "▶ Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "▶ Homebrew already installed, skipping."
fi

echo ""

# Packages
echo "▶ Installing packages with brew..."

brew update
brew install \
  fish neovim tmux yazi starship \
  node@24 pnpm eza bat fd fzf ripgrep glow zoxide gh \
  micro sevenzip

echo ""

# WSL Config
echo "▶ Applying wsl.conf..."

sudo cp "$DOTFILES_DIR/wsl/wsl.conf" /etc/wsl.conf
echo "  wsl.conf copied. Run 'wsl --shutdown' from Powershell to apply changes."

echo ""

# Default Shell
if [[ "$SHELL" != "$(which fish)" ]]; then
  echo "▶ Changing default shell to fish..."
  chsh -s "$(which fish)"
else
  echo "▶ Fish already set as default shell, skipping."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "            Setup complete!             "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Next steps:"
echo "  1. Run 'wsl --shutdown' from Powershell"
echo "  2. Reopen WSL"
echo "  3. Run 'gh auth login' to activate GitHub credentials"
echo ""
