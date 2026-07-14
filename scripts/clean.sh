#!/usr/bin/env bash

# clean.sh: remove and clean temporary files (caches, logs, old packages, and swap files)

set -euo pipefail

if command -v apt >/dev/null 2>&1 && ! sudo -n true 2>/dev/null; then
  if command -v gum >/dev/null 2>&1; then
    PASSWORD=$(gum input --password --placeholder "Introduce a password for sudo...")

    if ! echo "$PASSWORD" | sudo -S -v >/dev/null 2>&1; then
      gum style --foreground "#FF3131" --bold --border "none" --align "left" \
        "[ERROR] Incorrect password or sudo error!"
      exit 1
    fi
  else
    printf "[INFO] Admin privileges are required for APT.\n"
    if ! sudo -v; then
      printf "[ERROR] Sudo privileges could not be obtained.\n" >&2
      exit 1
    fi
  fi
fi
run_cmd_spinner() {
  local label="$1"
  local cmd="$2"

  if command -v gum >/dev/null 2>&1; then
    gum spin --spinner dot --title "  Cleaning $label..." -- bash -c "$cmd"
  else
    printf "  Cleaning %s...\n" "$label"
    eval "$cmd"
  fi
}

if command -v gum >/dev/null 2>&1; then
  gum style --foreground "#89CFF0" --bold --border "none" \
    --align "left" " Starting System Cleanup"
  echo ""
else
  echo " Cleaning caches..."
fi

# APT
if command -v apt >/dev/null 2>&1; then
  run_cmd_spinner "APT" "sudo apt autoremove -y && sudo apt autoclean -y"
fi

# Homebrew
if command -v brew >/dev/null 2>&1; then
  run_cmd_spinner "Homebrew" "brew autoremove && brew cleanup"
fi

# pnpm
if command -v pnpm >/dev/null 2>&1; then
  run_cmd_spinner "pnpm" "pnpm store prune"
fi

# npm
if command -v npm >/dev/null 2>&1; then
  run_cmd_spinner "npm" "npm cache clean --force"
fi

# Go
if command -v go >/dev/null 2>&1; then
  run_cmd_spinner "Go" "go clean -cache -testcache -modcache"
fi

# Python
if command -v pip >/dev/null 2>&1; then
  run_cmd_spinner "pip" "pip cache purge 2>/dev/null || true"
fi

# Neovim
run_cmd_spinner "Neovim" "rm -rf ~/.local/state/nvim/swap 2>/dev/null || true; rm -f ~/.local/state/nvim/shada/main.shada.tmp 2>/dev/null || true"

# User cache
run_cmd_spinner "user cache" "rm -rf ~/.cache/* 2>/dev/null || true"

echo ""
if command -v gum >/dev/null 2>&1; then
  gum style --foreground "#89CFF0" --bold --border "none" \
    --align "left" "ⓘ Cleanup complete!"
else
  echo "ⓘ Cleanup complete!"
fi
