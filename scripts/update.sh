#!/usr/bin/env bash

# Update the entire environment in a single command.
# Run periodically to keep everything up to date.

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     DOTFILES Update - JacobEscoto      "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Homebrew
echo "▶ Updating Homebrew packages..."
brew update && brew upgrade
brew autoremove
brew cleanup
echo ""

# Neovim plugins (lazy.nvim)
echo "▶ Updating Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null && echo "  Plugins updated" || echo "  Neovim update skipped or failed"
echo ""

# Fisher
echo "▶ Updating Fish plugins..."
fish -c "fisher update" 2>/dev/null && echo "  Fisher plugins updated" || echo "  Fisher update skipped or failed"
echo ""

# pnpm
echo "▶ Updating pnpm..."
pnpm self-update 2>/dev/null && echo "  pnpm updated" || echo "  pnpm update skipped"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Update complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

