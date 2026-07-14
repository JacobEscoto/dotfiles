#!/usr/bin/env bash

# setup.sh installs the essential tools and configurations for the environment within the terminal.

set -e

DOTFILES_DIR="$HOME/dotfiles"
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# Colors
SUCCESS_COLOR="#50C878"
WARN_COLOR="#FCF55F"
ERR_COLOR="#FF3131"
INFO_COLOR="#0096FF"

echo ""
echo "❏ DOTFILES setup - JacobEscoto"
echo ""

# Internet connection verification
echo "▶ Checking internet connection..."

if ! ping -c 1 -W 3 1.1.1.1 &>/dev/null; then
  echo ""
  echo "[ERROR] No internet connection detected."
  echo "▶ Please check your network and try again."
  echo ""
  exit 1
fi
echo "▶ Internet connection detected."
echo ""

# Gum Installation - Debian/Ubuntu (https://github.com/charmbracelet/gum#installation)
if ! command -v gum &>/dev/null; then
  echo "===> Installing gum..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt update && sudo apt install -y gum

  if command -v gum &>/dev/null; then
    echo "▶ Gum installed successfully..."
  else
    echo "▶ Gum was not installed correctly."
    echo "▶ Please visit: https://github.com/charmbracelet/gum#installation for manual installation."
    exit 1
  fi
else
  echo "▶ Gum already installed, SKIPPING..."
fi

echo ""

# Symbolic Links configuration
gum style \
  --foreground "$INFO_COLOR" --border "none" \
  --align "left" "ⓘ Creating symlinks..."

mkdir -p ~/.config

# For folders delete first, then link
rm -rf ~/.config/fish
ln -sfv "$DOTFILES_DIR/fish" ~/.config/fish

rm -rf ~/.config/nvim
ln -sfv "$DOTFILES_DIR/nvim" ~/.config/nvim

ln -sfv "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig

echo ""

# Homebrew
if ! command -v brew &>/dev/null; then
  gum style \
    --foreground "$INFO_COLOR" --border "none" --align "left" \
    "ⓘ Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Configure Homebrew env for both Bash and Fish
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.profile
  mkdir -p ~/.config/fish

  echo '/home/linuxbrew/.linuxbrew/bin/brew shellenv | source' >>~/.config/fish/config.fish
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  gum style \
    --foreground "$SUCCESS_COLOR" --border "none" --align "left" \
    "⦿ Homebrew already installed, SKIPPING..."
fi

echo ""

# Packages installation via Homebrew
REQUIRED_PKGS=("fish" "starship" "zoxide" "micro" "neovim" "gh" "go" "python@3.14" "node@24" "pnpm")
OPTIONAL_PKGS=("yazi" "eza" "bat" "fd" "fzf" "ripgrep" "glow" "lazygit" "sevenzip")

# Asks user for installing optional packages & tools
mapfile -t selected_pkgs < <(gum choose --no-limit "${OPTIONAL_PKGS[@]}" || true)
selected_pkgs+=("${REQUIRED_PKGS[@]}")

for package in "${selected_pkgs[@]}"; do

  # Ignores empty elements to avoid executing a "brew install ''" command
  [[ -z "$package" ]] && continue

  if brew list --formula "$package" &>/dev/null; then
    gum style --foreground "$WARN_COLOR" \
      --border "none" --align "left" "⦿ $package is already installed, SKIPPING..."
    continue
  fi

  if gum spin --spinner dot --title "Installing $package..." -- bash -c "NONINTERACTIVE=1 brew install -q '$package' >/dev/null 2>&1"; then
    gum style --foreground "$SUCCESS_COLOR" \
      --border "none" --align "left" "⦿ Successfully installed $package"
  else
    gum style --foreground "$ERR_COLOR" \
      --border "none" --align "left" "[ERROR] Failed to install $package"
  fi
done

# Setup Fish as default shell
if [[ "$SHELL" != "$(command -v fish)" ]]; then
  if gum confirm "Do you want to change your shell to Fish as the default?"; then

    gum style \
      --foreground "$INFO_COLOR" --border "none" \
      --align "left" "ⓘ Changing default shell to Fish..."
    sudo chsh -s "$(command -v fish)" "$USER"
  else
    gum style \
      --foreground "$WARN_COLOR" --border "none" --align "left" \
      "[WARNING] Shell change skipped."
  fi
else
  gum style \
    --foreground "$SUCCESS_COLOR" --border "none" --align "left" \
    "⦿ Fish already set as default shell, SKIPPING..."
fi

# WSL configuration
if gum confirm "Do you want to apply a custom WSL configuration?"; then
  sudo cp "$DOTFILES_DIR/wsl/wsl.conf" /etc/wsl.conf
  gum style \
    --foreground "$SUCCESS_COLOR" --border "none" --align "left" \
    "⦿ WSL Configuration copied." "Restart WSL by running 'wsl --shutdown' from Powershell to apply changes."
else
  gum style \
    --foreground "$WARN_COLOR" --border "none" --align "left" \
    "[WARNING] WSL configuration skipped."
fi

echo ""
gum style --foreground "$SUCCESS_COLOR" --border "none" \
  --align "left" "⦿ Setup Complete!"
echo ""

gum style --foreground "$INFO_COLOR" --border "none" \
  --align "left" "Next steps:" "  1. Run 'wsl --shutdown' from Powershell" \
  "  2. Reopen WSL" "  3. Run 'gh auth login' to activate GitHub credentials"
echo ""
