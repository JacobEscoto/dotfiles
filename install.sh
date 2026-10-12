#!/usr/bin/env bash
set -e

DOTFILES_DIR="${HOME}/dotfiles"
REPO_URL="https://github.com/JacobEscoto/dotfiles.git"
RELEASE_URL="https://github.com/JacobEscoto/dotfiles/releases/latest/download/installer-linux-amd64"

# 1. Ensure minimal prerequisites (curl and git)
MISSING_PREREQS=()
if ! command -v curl >/dev/null 2>&1; then
  MISSING_PREREQS+=("curl")
fi
if ! command -v git >/dev/null 2>&1; then
  MISSING_PREREQS+=("git")
fi

if [ ${#MISSING_PREREQS[@]} -gt 0 ]; then
  echo "==> Installing missing prerequisites (${MISSING_PREREQS[*]})..."
  if command -v sudo >/dev/null 2>&1; then
    sudo apt-get update -y && sudo apt-get install -y "${MISSING_PREREQS[@]}"
  else
    apt-get update -y && apt-get install -y "${MISSING_PREREQS[@]}"
  fi
fi

# 2. Clone repository if not already cloned
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "==> Cloning dotfiles repository to $DOTFILES_DIR..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# 3. Obtain prebuilt binary if local binary does not exist or if called directly
BINARY_PATH="./installer/installer"

if [ ! -f "$BINARY_PATH" ]; then
  echo "==> Downloading prebuilt installer from GitHub Releases..."
  mkdir -p ./installer
  if curl -fsSL "$RELEASE_URL" -o "$BINARY_PATH"; then
    chmod +x "$BINARY_PATH"
  else
    echo "==> [WARN] Could not download release binary. Falling back to local Go build if available..."
    if command -v go >/dev/null 2>&1; then
      (cd ./installer && go build -o installer .)
    else
      echo "==> [ERROR] Failed to download prebuilt binary and 'go' is not installed."
      exit 1
    fi
  fi
fi

# 4. Execute installer with any passed arguments (e.g. --dry-run, --symlinks-only)
exec "$BINARY_PATH" "$@"
