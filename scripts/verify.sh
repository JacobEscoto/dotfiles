#!/usr/bin/env bash

# Verifies the environment is properly configured.
# Utility to validate after setup.sh or any new PC.

PASS="✔"
FAIL="✖"
WARN="⚠"
OK=0
ERRORS=0

check_cmd() {
  local name="$1"
  local cmd="${2:-$1}"
  if command -v "$cmd" &> /dev/null; then
    echo "  $PASS $name"
  else
    echo "  $FAIL $name <- NOT FOUND"
    ERRORS=$((ERRORS + 1))
  fi
}

check_link() {
  local label="$1"
  local path="$2"
  if [ -L "$path" ]; then
    echo "  $PASS $label -> $(readlink "$path")"]
  elif [ -e "$path" ]; then
    echo "  $WARN $label exists but is NOT a symlink"
    ERRORS=$((ERRORS + 1))
  else
    echo "  $FAIL $label <- MISSING"
    ERRORS=$((ERRORS + 1))
  fi
}

check_file() {
  local label="$1"
  local path="$2"
  if [ -f "$path" ]; then
    echo "  $PASS $label"
  else
    echo "  $FAIL $label <- MISSING"
    ERRORS=$((ERRORS + 1))
  fi
}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   DOTFILES Verification - JacobEscoto  "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# CLI Tools
echo "▶ CLI Tools:"
check_cmd "fish"
check_cmd "nvim"
check_cmd "tmux"
check_cmd "yazi"
check_cmd "starship"
check_cmd "eza"
check_cmd "bat"
check_cmd "fzf"
check_cmd "fd"
check_cmd "ripgrep"  "rg"
check_cmd "zoxide"
check_cmd "lazygit"
check_cmd "glow"
check_cmd "gh"
check_cmd "micro"
check_cmd "node"
check_cmd "pnpm"

echo ""

# Symlinks
echo "▶ Symlinks:"
check_link ".gitconfig" "$HOME/.gitconfig"
check_link "fish config" "$HOME/.config/fish"
check_link "nvim config" "$HOME/.config/nvim"
check_link "yazi config" "$HOME/.config/yazi"
check_link "starship" "$HOME/.config/starship.toml"

echo ""

# System Files
echo "▶ System Files:"
check_file "wsl.conf" "/etc/wsl.conf"

echo ""

# Git Auth
echo "▶ Git / GitHub:"
if gh auth status &> /dev/null; then
  echo "  $PASS gh auth activate ($(gh auth status 2>&1 | grep 'Logged in' | xargs))"
else
  echo "  $WARN gh auth not configured; run: gh auth login"
fi

echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$ERRORS" -eq 0 ]; then
  echo "  Everything looks good!"
else
  echo "  $ERRORS issue(s) found. Fix them and re-run verify.sh"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

