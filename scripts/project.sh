#!/usr/bin/env bash

# project.sh: Fast project picker for Neovim/VS Code

PROJECTS_DIR="$HOME/projects"

if [ ! -d "$PROJECTS_DIR" ]; then
  gum style --foreground "#FF3131" --border "none" \
    --align "left" --bold "[ERROR] Projects directory not found at $PROJECTS_DIR"
  exit 1
fi

SELECTED=$(find "$PROJECTS_DIR" -maxdepth 2 -type d | sed "s|$PROJECTS_DIR/||" | gum filter --placeholder "Search project...")

if [ -n "$SELECTED" ]; then
  TARGET="$PROJECTS_DIR/$SELECTED"
  cd "$TARGET" || exit

  EDITOR_CHOICE=$(gum choose "Neovim" "VS Code" "Only go to the folder (Terminal)")

  case "$EDITOR_CHOICE" in
  "Neovim")
    nvim .
    ;;
  "VS Code")
    code .
    ;;
  *)
    $SHELL
    ;;
  esac
fi
