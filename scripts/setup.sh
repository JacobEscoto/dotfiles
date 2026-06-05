#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

echo "Creating links..."

ln -sfv "$DOTFILES_DIR/fish" ~/.config/fish
ln -sfv "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sfv "$DOTFILES_DIR/tmux" ~/.config/tmux
ln -sfv "$DOTFILES_DIR/yazi" ~/.config/yazi
ln -sfv "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "Installing packages with brew..."
brew update
brew install \
  fish neovim tmux yazi starship \
  node@24 pnpm eza bat fd fzf ripgrep glow zoxide gh \
  micro sevenzip

echo "Setting up WSL"
sudo tee /etc/wsl.conf > /dev/null <<EOF
[user]
default=$USER
[interop]
appendWindowsPath=false
[automount]
enabled=true
options=metadata,umask=22,fmask=11
EOF


if [[ "$SHELL" != "$(which fish)" ]]; then
  chsh -s "$(which fish)"
fi

echo "Restart WSL for applying changes."
